"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.respondToMentorshipRequest = void 0;
/**
 * CF-04: respondToMentorshipRequest
 *
 * Alumni-only callable. Accepts or declines a mentorship request.
 * On accept, creates a conversation between student and alumni.
 */
const https_1 = require("firebase-functions/v2/https");
const admin = __importStar(require("firebase-admin"));
const utils_1 = require("../utils");
exports.respondToMentorshipRequest = (0, https_1.onCall)({ maxInstances: 10 }, async (request) => {
    const callerUid = (0, utils_1.requireAuth)(request.auth);
    await (0, utils_1.requireRole)(callerUid, "alumni");
    const { requestId, action, reason } = request.data;
    if (!requestId || typeof requestId !== "string") {
        throw new https_1.HttpsError("invalid-argument", "requestId is required.");
    }
    if (!action || !["accept", "decline"].includes(action)) {
        throw new https_1.HttpsError("invalid-argument", "action must be 'accept' or 'decline'.");
    }
    if (action === "decline" && (!reason || typeof reason !== "string")) {
        throw new https_1.HttpsError("invalid-argument", "reason is required when declining.");
    }
    const requestRef = utils_1.db.collection("mentorshipRequests").doc(requestId);
    const requestDoc = await requestRef.get();
    if (!requestDoc.exists) {
        throw new https_1.HttpsError("not-found", "Mentorship request not found.");
    }
    const requestData = requestDoc.data();
    // Verify caller is the alumni on this request
    if (requestData.alumniId !== callerUid) {
        throw new https_1.HttpsError("permission-denied", "You are not the alumni on this request.");
    }
    // Idempotency: if already in target state, return success
    const targetStatus = action === "accept" ? "accepted" : "declined";
    if (requestData.status === targetStatus) {
        return { success: true };
    }
    // Must be pending to change
    if (requestData.status !== "pending") {
        throw new https_1.HttpsError("failed-precondition", `Request is already '${requestData.status}'. Cannot ${action}.`);
    }
    // Update the request
    const updateData = {
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
        const convRef = utils_1.db.collection("conversations").doc(conversationId);
        const convDoc = await convRef.get();
        if (!convDoc.exists) {
            // Get both users' info
            const alumniDoc = await utils_1.db.collection("users").doc(callerUid).get();
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
    const notifType = action === "accept" ? "mentorship_accepted" : "mentorship_declined";
    const notifTitle = action === "accept"
        ? "Mentorship Accepted! 🎉"
        : "Mentorship Update";
    const notifBody = action === "accept"
        ? `${requestData.alumniName} has accepted your mentorship request!`
        : `${requestData.alumniName} has declined your request: ${reason}`;
    await (0, utils_1.createNotification)(requestData.studentId, {
        type: notifType,
        title: notifTitle,
        body: notifBody,
        route: `/mentorship/${requestId}`,
        entityId: requestId,
    });
    await (0, utils_1.sendPushNotification)(requestData.studentId, notifTitle, notifBody);
    return { success: true };
});
//# sourceMappingURL=respondToMentorshipRequest.js.map