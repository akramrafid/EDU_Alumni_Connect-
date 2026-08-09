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
exports.onMessageCreated = void 0;
/**
 * BG-01: onMessageCreated
 *
 * Trigger: conversations/{conversationId}/messages/{messageId} — onCreate
 *
 * Updates parent conversation (lastMessage, unreadCount),
 * sends FCM push, and creates in-app notifications for non-sender participants.
 */
const firestore_1 = require("firebase-functions/v2/firestore");
const admin = __importStar(require("firebase-admin"));
const utils_1 = require("../utils");
exports.onMessageCreated = (0, firestore_1.onDocumentCreated)("conversations/{conversationId}/messages/{messageId}", async (event) => {
    var _a, _b, _c, _d, _e;
    const snapshot = event.data;
    if (!snapshot)
        return;
    const messageData = snapshot.data();
    const conversationId = event.params.conversationId;
    const senderId = messageData.senderId;
    // 1. Update parent conversation document
    const convRef = utils_1.db.collection("conversations").doc(conversationId);
    const convDoc = await convRef.get();
    if (!convDoc.exists)
        return;
    const convData = convDoc.data();
    const participantIds = convData.participantIds || [];
    // Idempotency: check if this message is newer than lastMessageAt
    const lastMessageAt = ((_b = (_a = convData.lastMessageAt) === null || _a === void 0 ? void 0 : _a.toDate) === null || _b === void 0 ? void 0 : _b.call(_a)) || new Date(0);
    const sentAt = ((_d = (_c = messageData.sentAt) === null || _c === void 0 ? void 0 : _c.toDate) === null || _d === void 0 ? void 0 : _d.call(_c)) || new Date();
    if (sentAt < lastMessageAt) {
        console.log("Message older than lastMessageAt, skipping update.");
        return;
    }
    // Build unreadCount updates
    const unreadCount = convData.unreadCount || {};
    for (const uid of participantIds) {
        if (uid !== senderId) {
            unreadCount[uid] = (unreadCount[uid] || 0) + 1;
        }
    }
    // Determine display text for lastMessage
    let lastMessageText = messageData.text || "";
    if (messageData.type === "image")
        lastMessageText = "📷 Photo";
    if (messageData.type === "document") {
        lastMessageText = `📄 ${messageData.fileName || "Document"}`;
    }
    if (messageData.type === "voice")
        lastMessageText = "🎤 Voice message";
    await convRef.update({
        lastMessage: lastMessageText,
        lastMessageAt: messageData.sentAt || admin.firestore.FieldValue.serverTimestamp(),
        lastMessageSenderId: senderId,
        unreadCount,
    });
    // 2. Get sender name for notifications
    const senderDoc = await utils_1.db.collection("users").doc(senderId).get();
    const senderName = ((_e = senderDoc.data()) === null || _e === void 0 ? void 0 : _e.fullName) || "Someone";
    // 3. Notify non-sender participants
    for (const uid of participantIds) {
        if (uid === senderId)
            continue;
        await (0, utils_1.createNotification)(uid, {
            type: "new_message",
            title: senderName,
            body: lastMessageText,
            route: `/chat/${conversationId}`,
            entityId: conversationId,
        });
        await (0, utils_1.sendPushNotification)(uid, senderName, lastMessageText);
    }
});
//# sourceMappingURL=onMessageCreated.js.map