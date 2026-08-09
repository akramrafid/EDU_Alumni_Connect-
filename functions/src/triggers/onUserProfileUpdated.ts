/**
 * BG-02: onUserProfileUpdated
 *
 * Trigger: users/{uid} — onUpdate
 *
 * Syncs verified alumni profile changes to alumniDirectory.
 * Syncs name/photo changes to conversation participantDetails.
 */
import {
  onDocumentUpdated,
} from "firebase-functions/v2/firestore";
import { db } from "../utils";

const SYNCED_ALUMNI_FIELDS = [
  "fullName", "photoUrl", "department", "currentCompany",
  "jobTitle", "skills", "location", "bio", "openToMentorship",
];

export const onUserProfileUpdated = onDocumentUpdated(
  "users/{uid}",
  async (event) => {
    const beforeData = event.data?.before?.data();
    const afterData = event.data?.after?.data();
    if (!beforeData || !afterData) return;

    const uid = event.params.uid;

    // 1. Sync to alumniDirectory if user is a verified alumni
    if (
      afterData.role === "alumni" &&
      afterData.verificationStatus === "verified"
    ) {
      const dirRef = db.collection("alumniDirectory").doc(uid);
      const dirDoc = await dirRef.get();

      if (dirDoc.exists) {
        // Check if any synced field actually changed
        const updates: Record<string, unknown> = {};
        for (const field of SYNCED_ALUMNI_FIELDS) {
          if (
            JSON.stringify(beforeData[field]) !==
            JSON.stringify(afterData[field])
          ) {
            updates[field] = afterData[field] ?? null;
          }
        }

        if (Object.keys(updates).length > 0) {
          await dirRef.update(updates);
          console.log(`Synced ${Object.keys(updates).length} fields to alumniDirectory/${uid}`);
        }
      }
    }

    // 2. Sync fullName/photoUrl changes to conversation participantDetails
    const nameChanged = beforeData.fullName !== afterData.fullName;
    const photoChanged = beforeData.photoUrl !== afterData.photoUrl;

    if (nameChanged || photoChanged) {
      // Find conversations where this user is a participant
      const convQuery = await db
        .collection("conversations")
        .where("participantIds", "array-contains", uid)
        .get();

      if (convQuery.empty) return;

      // Batch update (max 500 per batch)
      const batches: FirebaseFirestore.WriteBatch[] = [db.batch()];
      let opCount = 0;

      for (const doc of convQuery.docs) {
        if (opCount >= 499) {
          batches.push(db.batch());
          opCount = 0;
        }

        const currentBatch = batches[batches.length - 1];
        const updatePayload: Record<string, any> = {};

        if (nameChanged) {
          updatePayload[`participantDetails.${uid}.fullName`] =
            afterData.fullName;
        }
        if (photoChanged) {
          updatePayload[`participantDetails.${uid}.photoUrl`] =
            afterData.photoUrl || null;
        }

        currentBatch.update(doc.ref, updatePayload);
        opCount++;
      }

      // Commit all batches
      for (const batch of batches) {
        await batch.commit();
      }

      console.log(
        `Updated participantDetails in ${convQuery.size} conversations for user ${uid}`
      );
    }
  }
);
