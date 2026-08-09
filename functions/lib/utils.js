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
exports.sendPushNotification = exports.createNotification = exports.requireAnyRole = exports.requireRole = exports.requireAuth = exports.messaging = exports.auth = exports.db = void 0;
/**
 * Shared utility functions and constants for Cloud Functions.
 */
const admin = __importStar(require("firebase-admin"));
const https_1 = require("firebase-functions/v2/https");
exports.db = admin.firestore();
exports.auth = admin.auth();
exports.messaging = admin.messaging();
/**
 * Validates that the caller is authenticated. Throws HttpsError if not.
 */
function requireAuth(authContext) {
    if (!(authContext === null || authContext === void 0 ? void 0 : authContext.uid)) {
        throw new https_1.HttpsError("unauthenticated", "Authentication required.");
    }
    return authContext.uid;
}
exports.requireAuth = requireAuth;
/**
 * Validates that the caller has the specified role via custom claims.
 */
async function requireRole(uid, requiredRole) {
    const user = await exports.auth.getUser(uid);
    const claims = user.customClaims || {};
    if (claims.role !== requiredRole) {
        throw new https_1.HttpsError("permission-denied", `This action requires the '${requiredRole}' role.`);
    }
}
exports.requireRole = requireRole;
/**
 * Validates that the caller has one of the specified roles.
 */
async function requireAnyRole(uid, roles) {
    const user = await exports.auth.getUser(uid);
    const claims = user.customClaims || {};
    const userRole = claims.role;
    if (!roles.includes(userRole)) {
        throw new https_1.HttpsError("permission-denied", `This action requires one of these roles: ${roles.join(", ")}.`);
    }
    return userRole;
}
exports.requireAnyRole = requireAnyRole;
/**
 * Creates an in-app notification document for a user.
 */
async function createNotification(recipientUid, notification) {
    await exports.db
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
exports.createNotification = createNotification;
/**
 * Sends an FCM push notification to a user if they have an fcmToken.
 */
async function sendPushNotification(recipientUid, title, body) {
    var _a;
    try {
        const userDoc = await exports.db.collection("users").doc(recipientUid).get();
        const fcmToken = (_a = userDoc.data()) === null || _a === void 0 ? void 0 : _a.fcmToken;
        if (!fcmToken)
            return;
        await exports.messaging.send({
            token: fcmToken,
            notification: { title, body },
            android: {
                notification: { channelId: "default" },
            },
        });
    }
    catch (error) {
        // FCM failures are non-critical; log but don't throw
        console.warn(`FCM send failed for ${recipientUid}:`, error);
    }
}
exports.sendPushNotification = sendPushNotification;
//# sourceMappingURL=utils.js.map