"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.onUserProfileUpdated = void 0;
/**
 * BG-02: onUserProfileUpdated
 *
 * Trigger: users/{uid} — onUpdate
 *
 * Syncs verified alumni profile changes to alumniDirectory.
 * Syncs name/photo changes to conversation participantDetails.
 */
const firestore_1 = require("firebase-functions/v2/firestore");
const utils_1 = require("../utils");
const SYNCED_ALUMNI_FIELDS = [
    "fullName", "photoUrl", "department", "currentCompany",
    "jobTitle", "skills", "location", "bio", "openToMentorship",
];
exports.onUserProfileUpdated = (0, firestore_1.onDocumentUpdated)("users/{uid}", async (event) => {
    var _a, _b, _c, _d, _e;
    const beforeData = (_b = (_a = event.data) === null || _a === void 0 ? void 0 : _a.before) === null || _b === void 0 ? void 0 : _b.data();
    const afterData = (_d = (_c = event.data) === null || _c === void 0 ? void 0 : _c.after) === null || _d === void 0 ? void 0 : _d.data();
    if (!beforeData || !afterData)
        return;
    const uid = event.params.uid;
    // 1. Sync to alumniDirectory if user is a verified alumni
    if (afterData.role === "alumni" &&
        afterData.verificationStatus === "verified") {
        const dirRef = utils_1.db.collection("alumniDirectory").doc(uid);
        const dirDoc = await dirRef.get();
        if (dirDoc.exists) {
            // Check if any synced field actually changed
            const updates = {};
            for (const field of SYNCED_ALUMNI_FIELDS) {
                if (JSON.stringify(beforeData[field]) !==
                    JSON.stringify(afterData[field])) {
                    updates[field] = (_e = afterData[field]) !== null && _e !== void 0 ? _e : null;
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
        const convQuery = await utils_1.db
            .collection("conversations")
            .where("participantIds", "array-contains", uid)
            .get();
        if (convQuery.empty)
            return;
        // Batch update (max 500 per batch)
        const batches = [utils_1.db.batch()];
        let opCount = 0;
        for (const doc of convQuery.docs) {
            if (opCount >= 499) {
                batches.push(utils_1.db.batch());
                opCount = 0;
            }
            const currentBatch = batches[batches.length - 1];
            const updatePayload = {};
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
        console.log(`Updated participantDetails in ${convQuery.size} conversations for user ${uid}`);
    }
});
//# sourceMappingURL=onUserProfileUpdated.js.map