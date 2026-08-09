/**
 * BG-01: onMessageCreated
 *
 * Trigger: conversations/{conversationId}/messages/{messageId} — onCreate
 *
 * Updates parent conversation (lastMessage, unreadCount),
 * sends FCM push, and creates in-app notifications for non-sender participants.
 */
import {
  onDocumentCreated,
} from "firebase-functions/v2/firestore";
import * as admin from "firebase-admin";
import { db, createNotification, sendPushNotification } from "../utils";

export const onMessageCreated = onDocumentCreated(
  "conversations/{conversationId}/messages/{messageId}",
  async (event) => {
    const snapshot = event.data;
    if (!snapshot) return;

    const messageData = snapshot.data();
    const conversationId = event.params.conversationId;
    const senderId = messageData.senderId;

    // 1. Update parent conversation document
    const convRef = db.collection("conversations").doc(conversationId);
    const convDoc = await convRef.get();
    if (!convDoc.exists) return;

    const convData = convDoc.data()!;
    const participantIds: string[] = convData.participantIds || [];

    // Idempotency: check if this message is newer than lastMessageAt
    const lastMessageAt = convData.lastMessageAt?.toDate?.() || new Date(0);
    const sentAt = messageData.sentAt?.toDate?.() || new Date();
    if (sentAt < lastMessageAt) {
      console.log("Message older than lastMessageAt, skipping update.");
      return;
    }

    // Build unreadCount updates
    const unreadCount: Record<string, number> = convData.unreadCount || {};
    for (const uid of participantIds) {
      if (uid !== senderId) {
        unreadCount[uid] = (unreadCount[uid] || 0) + 1;
      }
    }

    // Determine display text for lastMessage
    let lastMessageText = messageData.text || "";
    if (messageData.type === "image") lastMessageText = "📷 Photo";
    if (messageData.type === "document") {
      lastMessageText = `📄 ${messageData.fileName || "Document"}`;
    }
    if (messageData.type === "voice") lastMessageText = "🎤 Voice message";

    await convRef.update({
      lastMessage: lastMessageText,
      lastMessageAt: messageData.sentAt || admin.firestore.FieldValue.serverTimestamp(),
      lastMessageSenderId: senderId,
      unreadCount,
    });

    // 2. Get sender name for notifications
    const senderDoc = await db.collection("users").doc(senderId).get();
    const senderName = senderDoc.data()?.fullName || "Someone";

    // 3. Notify non-sender participants
    for (const uid of participantIds) {
      if (uid === senderId) continue;

      await createNotification(uid, {
        type: "new_message",
        title: senderName,
        body: lastMessageText,
        route: `/chat/${conversationId}`,
        entityId: conversationId,
      });

      await sendPushNotification(uid, senderName, lastMessageText);
    }
  }
);
