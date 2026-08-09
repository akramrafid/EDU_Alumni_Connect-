/**
 * CF-03: sendMentorshipRequest
 *
 * Student-only callable. Creates a mentorship request and notifies the alumni.
 */
import { onCall, HttpsError } from "firebase-functions/v2/https";
import * as admin from "firebase-admin";
import {
  db, requireAuth, requireRole,
  createNotification, sendPushNotification,
} from "../utils";

export const sendMentorshipRequest = onCall(
  { maxInstances: 10 },
  async (request) => {
    const callerUid = requireAuth(request.auth);
    await requireRole(callerUid, "student");

    const { alumniId, message } = request.data;
    if (!alumniId || typeof alumniId !== "string") {
      throw new HttpsError("invalid-argument", "alumniId is required.");
    }
    if (!message || typeof message !== "string" || message.length < 10) {
      throw new HttpsError(
        "invalid-argument",
        "message is required and must be at least 10 characters."
      );
    }

    // Check alumni exists and is open to mentorship
    const alumniDoc = await db
      .collection("alumniDirectory")
      .doc(alumniId)
      .get();
    if (!alumniDoc.exists) {
      throw new HttpsError("not-found", "Alumni not found in directory.");
    }
    const alumniData = alumniDoc.data()!;
    if (!alumniData.openToMentorship) {
      throw new HttpsError(
        "failed-precondition",
        "This alumni is not currently accepting mentorship requests."
      );
    }

    // Check for duplicate pending/accepted request
    const existingQuery = await db
      .collection("mentorshipRequests")
      .where("studentId", "==", callerUid)
      .where("alumniId", "==", alumniId)
      .where("status", "in", ["pending", "accepted"])
      .limit(1)
      .get();

    if (!existingQuery.empty) {
      throw new HttpsError(
        "already-exists",
        "You already have a pending or active mentorship with this alumni."
      );
    }

    // Get student info for denormalization
    const studentDoc = await db.collection("users").doc(callerUid).get();
    const studentData = studentDoc.data() || {};

    // Create the request
    const requestRef = db.collection("mentorshipRequests").doc();
    await requestRef.set({
      requestId: requestRef.id,
      studentId: callerUid,
      alumniId: alumniId,
      studentName: studentData.fullName || "Student",
      studentPhotoUrl: studentData.photoUrl || null,
      alumniName: alumniData.fullName || "Alumni",
      alumniPhotoUrl: alumniData.photoUrl || null,
      status: "pending",
      message: message,
      declineReason: null,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    // Notify the alumni
    await createNotification(alumniId, {
      type: "mentorship_request",
      title: "New Mentorship Request",
      body: `${studentData.fullName || "A student"} has requested your mentorship.`,
      route: `/mentorship/${requestRef.id}`,
      entityId: requestRef.id,
    });

    await sendPushNotification(
      alumniId,
      "New Mentorship Request",
      `${studentData.fullName || "A student"} would like you as their mentor.`
    );

    return { success: true, requestId: requestRef.id };
  }
);
