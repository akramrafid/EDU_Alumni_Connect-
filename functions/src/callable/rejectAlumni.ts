/**
 * CF-02: rejectAlumni
 *
 * Admin-only callable. Rejects a pending alumni verification.
 */
import { onCall, HttpsError } from "firebase-functions/v2/https";
import * as admin from "firebase-admin";
import {
  db, auth, requireAuth, requireRole,
  createNotification, sendPushNotification,
} from "../utils";

export const rejectAlumni = onCall(
  { maxInstances: 10 },
  async (request) => {
    const callerUid = requireAuth(request.auth);
    await requireRole(callerUid, "admin");

    const { uid, reason } = request.data;
    if (!uid || typeof uid !== "string") {
      throw new HttpsError("invalid-argument", "uid is required.");
    }
    if (!reason || typeof reason !== "string") {
      throw new HttpsError("invalid-argument", "reason is required.");
    }

    const userRef = db.collection("users").doc(uid);
    const userDoc = await userRef.get();
    if (!userDoc.exists) {
      throw new HttpsError("not-found", "User not found.");
    }

    // Update custom claims
    await auth.setCustomUserClaims(uid, {
      role: "alumni",
      verificationStatus: "rejected",
    });

    // Update user document
    await userRef.update({
      verificationStatus: "rejected",
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    // Notify the user
    await createNotification(uid, {
      type: "system",
      title: "Verification Update",
      body: `Your alumni verification was declined: ${reason}`,
      route: "/home",
    });

    await sendPushNotification(
      uid,
      "Verification Update",
      `Your alumni verification was declined: ${reason}`
    );

    return { success: true };
  }
);
