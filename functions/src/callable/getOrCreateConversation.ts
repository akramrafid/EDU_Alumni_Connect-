/**
 * CF-08: getOrCreateConversation
 *
 * Authenticated callable. Returns an existing 1:1 conversation
 * or creates one using a deterministic ID (sorted uids).
 */
import { onCall, HttpsError } from "firebase-functions/v2/https";
import * as admin from "firebase-admin";
import { db, requireAuth } from "../utils";

export const getOrCreateConversation = onCall(
  { maxInstances: 10 },
  async (request) => {
    const callerUid = requireAuth(request.auth);

    const { otherUserId } = request.data;
    if (!otherUserId || typeof otherUserId !== "string") {
      throw new HttpsError("invalid-argument", "otherUserId is required.");
    }
    if (otherUserId === callerUid) {
      throw new HttpsError(
        "invalid-argument",
        "Cannot create a conversation with yourself."
      );
    }

    // Verify other user exists
    const otherUserDoc = await db.collection("users").doc(otherUserId).get();
    if (!otherUserDoc.exists) {
      throw new HttpsError("not-found", "User not found.");
    }
    const otherUserData = otherUserDoc.data()!;

    // Get caller info
    const callerDoc = await db.collection("users").doc(callerUid).get();
    const callerData = callerDoc.data() || {};

    // Deterministic conversation ID
    const sortedIds = [callerUid, otherUserId].sort();
    const conversationId = `${sortedIds[0]}_${sortedIds[1]}`;

    const convRef = db.collection("conversations").doc(conversationId);
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
  }
);
