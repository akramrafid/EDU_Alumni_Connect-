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
exports.getOrCreateConversation = void 0;
/**
 * CF-08: getOrCreateConversation
 *
 * Authenticated callable. Returns an existing 1:1 conversation
 * or creates one using a deterministic ID (sorted uids).
 */
const https_1 = require("firebase-functions/v2/https");
const admin = __importStar(require("firebase-admin"));
const utils_1 = require("../utils");
exports.getOrCreateConversation = (0, https_1.onCall)({ maxInstances: 10 }, async (request) => {
    const callerUid = (0, utils_1.requireAuth)(request.auth);
    const { otherUserId } = request.data;
    if (!otherUserId || typeof otherUserId !== "string") {
        throw new https_1.HttpsError("invalid-argument", "otherUserId is required.");
    }
    if (otherUserId === callerUid) {
        throw new https_1.HttpsError("invalid-argument", "Cannot create a conversation with yourself.");
    }
    // Verify other user exists
    const otherUserDoc = await utils_1.db.collection("users").doc(otherUserId).get();
    if (!otherUserDoc.exists) {
        throw new https_1.HttpsError("not-found", "User not found.");
    }
    const otherUserData = otherUserDoc.data();
    // Get caller info
    const callerDoc = await utils_1.db.collection("users").doc(callerUid).get();
    const callerData = callerDoc.data() || {};
    // Deterministic conversation ID
    const sortedIds = [callerUid, otherUserId].sort();
    const conversationId = `${sortedIds[0]}_${sortedIds[1]}`;
    const convRef = utils_1.db.collection("conversations").doc(conversationId);
    const convDoc = await convRef.get();
    if (convDoc.exists) {
        return {
            conversationId,
            conversation: convDoc.data(),
            created: false,
        };
    }
    // Create new conversation
    const conversationData = {
        conversationId,
        participantIds: sortedIds,
        participantDetails: {
            [callerUid]: {
                fullName: callerData.fullName || "",
                photoUrl: callerData.photoUrl || null,
            },
            [otherUserId]: {
                fullName: otherUserData.fullName || "",
                photoUrl: otherUserData.photoUrl || null,
            },
        },
        lastMessage: "",
        lastMessageAt: admin.firestore.FieldValue.serverTimestamp(),
        lastMessageSenderId: "",
        unreadCount: {
            [callerUid]: 0,
            [otherUserId]: 0,
        },
        isGroup: false,
        groupName: null,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
    };
    await convRef.set(conversationData);
    return {
        conversationId,
        conversation: conversationData,
        created: true,
    };
});
//# sourceMappingURL=getOrCreateConversation.js.map