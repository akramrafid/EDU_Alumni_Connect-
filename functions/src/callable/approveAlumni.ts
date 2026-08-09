/**
 * CF-01: approveAlumni
 *
 * Admin-only callable. Sets custom claims to verified alumni,
 * updates user doc, creates alumniDirectory entry, and notifies.
 */
import { onCall, HttpsError } from "firebase-functions/v2/https";
import * as admin from "firebase-admin";
import {
  db, auth, requireAuth, requireRole,
  createNotification, sendPushNotification,
} from "../utils";

export const approveAlumni = onCall(
  { maxInstances: 10 },
  async (request) => {
    const callerUid = requireAuth(request.auth);
    await requireRole(callerUid, "admin");

    const { uid } = request.data;
    if (!uid || typeof uid !== "string") {
      throw new HttpsError("invalid-argument", "uid is required.");
    }

    // Verify user exists and is pending alumni
    const userRef = db.collection("users").doc(uid);
    const userDoc = await userRef.get();
    if (!userDoc.exists) {
      throw new HttpsError("not-found", "User not found.");
    }

    const userData = userDoc.data()!;
    if (userData.role !== "alumni") {
      throw new HttpsError(
        "failed-precondition",
        "User is not an alumni account."
      );
    }

    // 1. Set custom claims
    await auth.setCustomUserClaims(uid, {
      role: "alumni",
      verificationStatus: "verified",
    });

    // 2. Update user document
    await userRef.update({
      verificationStatus: "verified",
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    // 3. Create alumniDirectory entry (denormalized)
    await db.collection("alumniDirectory").doc(uid).set({
      uid,
      fullName: userData.fullName || "",
      department: userData.department || "",
      batchYear: userData.batchYear || 0,
      currentCompany: userData.currentCompany || null,
      jobTitle: userData.jobTitle || null,
      skills: userData.skills || [],
      location: userData.location || null,
      photoUrl: userData.photoUrl || null,
      bio: userData.bio || null,
      openToMentorship: userData.openToMentorship || false,
    });

    // 4. Notify the user
    await createNotification(uid, {
      type: "system",
      title: "Account Verified! 🎉",
      body: "Your alumni account has been verified. Welcome to the network!",
      route: "/home",
    });

    await sendPushNotification(
      uid,
      "Account Verified! 🎉",
      "Your alumni account has been verified. Welcome to EDU Alumni Connect!"
    );

    return { success: true };
  }
);
