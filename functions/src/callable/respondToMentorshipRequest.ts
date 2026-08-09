/**
 * CF-04: respondToMentorshipRequest
 *
 * Alumni-only callable. Accepts or declines a mentorship request.
 * On accept, creates a conversation between student and alumni.
 */
import { onCall, HttpsError } from "firebase-functions/v2/https";
import * as admin from "firebase-admin";
import {
  db, requireAuth, requireRole,
  createNotification, sendPushNotification,
} from "../utils";

export const respondToMentorshipRequest = onCall(
  { maxInstances: 10 },
  async (request) => {
    const callerUid = requireAuth(request.auth);
    await requireRole(callerUid, "alumni");

    const { requestId, action, reason } = request.data;
    if (!requestId || typeof requestId !== "string") {
      throw new HttpsError("invalid-argument", "requestId is required.");
    }
    if (!action || !["accept", "decline"].includes(action)) {
      throw new HttpsError(
        "invalid-argument",
        "action must be 'accept' or 'decline'."
      );
    }
    if (action === "decline" && (!reason || typeof reason !== "string")) {
      throw new HttpsError(
        "invalid-argument",
        "reason is required when declining."
      );
    }

    const requestRef = db.collection("mentorshipRequests").doc(requestId);
    const requestDoc = await requestRef.get();
    if (!requestDoc.exists) {
      throw new HttpsError("not-found", "Mentorship request not found.");
    }

    const requestData = requestDoc.data()!;

    // Verify caller is the alumni on this request
    if (requestData.alumniId !== callerUid) {
      throw new HttpsError(
        "permission-denied",
        "You are not the alumni on this request."
      );
    }

    // Idempotency: if already in target state, return success
    const targetStatus = action === "accept" ? "accepted" : "declined";
    if (requestData.status === targetStatus) {
      return { success: true };
    }

    // Must be pending to change
    if (requestData.status !== "pending") {
      throw new HttpsError(
        "failed-precondition",
        `Request is already '${requestData.status}'. Cannot ${action}.`
      );
    }

    // Update the request
    const updateData: Record<string, unknown> = {
      status: targetStatus,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    };
    if (action === "decline") {
      updateData.declineReason = reason;
    }
    await requestRef.update(updateData);

    // If accepted, create a conversation
    if (action === "accept") {
      const sortedIds = [requestData.studentId, callerUid].sort();
      const conversationId = `${sortedIds[0]}_${sortedIds[1]}`;
      const convRef = db.collection("conversations").doc(conversationId);
      const convDoc = await convRef.get();

      if (!convDoc.exists) {
        // Get both users' info
        const alumniDoc = await db.collection("users").doc(callerUid).get();
        const alumniData = alumniDoc.data() || {};

        await convRef.set({
          conversationId,
          participantIds: sortedIds,
          participantDetails: {
            [requestData.studentId]: {
              fullName: requestData.studentName,
              photoUrl: requestData.studentPhotoUrl || null,
            },
            [callerUid]: {
              fullName: alumniData.fullName || requestData.alumniName,
              photoUrl: alumniData.photoUrl || null,
            },
          },
          lastMessage: "Mentorship accepted! Start chatting.",
          lastMessageAt: admin.firestore.FieldValue.serverTimestamp(),
          lastMessageSenderId: callerUid,
          unreadCount: {
            [requestData.studentId]: 1,
            [callerUid]: 0,
          },
          isGroup: false,
          groupName: null,
          createdAt: admin.firestore.FieldValue.serverTimestamp(),
        });
      }
    }

    // Notify the student
    const notifType =
      action === "accept" ? "mentorship_accepted" : "mentorship_declined";
    const notifTitle =
      action === "accept"
        ? "Mentorship Accepted! 🎉"
        : "Mentorship Update";
    const notifBody =
      action === "accept"
        ? `${requestData.alumniName} has accepted your mentorship request!`
        : `${requestData.alumniName} has declined your request: ${reason}`;

    await createNotification(requestData.studentId, {
      type: notifType,
      title: notifTitle,
      body: notifBody,
      route: `/mentorship/${requestId}`,
      entityId: requestId,
    });

    await sendPushNotification(requestData.studentId, notifTitle, notifBody);

    return { success: true };
  }
);
