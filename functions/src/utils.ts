/**
 * Shared utility functions and constants for Cloud Functions.
 */
import * as admin from "firebase-admin";
import { HttpsError } from "firebase-functions/v2/https";

export const db = admin.firestore();
export const auth = admin.auth();
export const messaging = admin.messaging();

export type UserRole = "student" | "alumni" | "admin";
export type VerificationStatus = "pending" | "verified" | "rejected";

/**
 * Validates that the caller is authenticated. Throws HttpsError if not.
 */
export function requireAuth(authContext: { uid: string } | undefined): string {
  if (!authContext?.uid) {
    throw new HttpsError("unauthenticated", "Authentication required.");
  }
  return authContext.uid;
}

/**
 * Validates that the caller has the specified role via custom claims.
 */
export async function requireRole(
  uid: string,
  requiredRole: UserRole
): Promise<void> {
  const user = await auth.getUser(uid);
  const claims = user.customClaims || {};
  if (claims.role !== requiredRole) {
    throw new HttpsError(
      "permission-denied",
      `This action requires the '${requiredRole}' role.`
    );
  }
}

/**
 * Validates that the caller has one of the specified roles.
 */
export async function requireAnyRole(
  uid: string,
  roles: UserRole[]
): Promise<UserRole> {
  const user = await auth.getUser(uid);
  const claims = user.customClaims || {};
  const userRole = claims.role as UserRole;
  if (!roles.includes(userRole)) {
    throw new HttpsError(
      "permission-denied",
      `This action requires one of these roles: ${roles.join(", ")}.`
    );
  }
  return userRole;
}

/**
 * Creates an in-app notification document for a user.
 */
export async function createNotification(
  recipientUid: string,
  notification: {
    type: string;
    title: string;
    body: string;
    route?: string;
    entityId?: string;
  }
): Promise<void> {
  await db
    .collection("notifications")
    .doc(recipientUid)
    .collection("items")
    .add({
      type: notification.type,
      title: notification.title,
      body: notification.body,
      read: false,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      payload: {
        route: notification.route || "",
        entityId: notification.entityId || "",
      },
    });
}

/**
 * Sends an FCM push notification to a user if they have an fcmToken.
 */
export async function sendPushNotification(
  recipientUid: string,
  title: string,
  body: string
): Promise<void> {
  try {
    const userDoc = await db.collection("users").doc(recipientUid).get();
    const fcmToken = userDoc.data()?.fcmToken;
    if (!fcmToken) return;

    await messaging.send({
      token: fcmToken,
      notification: { title, body },
      android: {
        notification: { channelId: "default" },
      },
    });
  } catch (error) {
    // FCM failures are non-critical; log but don't throw
    console.warn(`FCM send failed for ${recipientUid}:`, error);
  }
}
