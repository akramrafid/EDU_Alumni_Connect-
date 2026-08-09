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
exports.rejectAlumni = void 0;
/**
 * CF-02: rejectAlumni
 *
 * Admin-only callable. Rejects a pending alumni verification.
 */
const https_1 = require("firebase-functions/v2/https");
const admin = __importStar(require("firebase-admin"));
const utils_1 = require("../utils");
exports.rejectAlumni = (0, https_1.onCall)({ maxInstances: 10 }, async (request) => {
    const callerUid = (0, utils_1.requireAuth)(request.auth);
    await (0, utils_1.requireRole)(callerUid, "admin");
    const { uid, reason } = request.data;
    if (!uid || typeof uid !== "string") {
        throw new https_1.HttpsError("invalid-argument", "uid is required.");
    }
    if (!reason || typeof reason !== "string") {
        throw new https_1.HttpsError("invalid-argument", "reason is required.");
    }
    const userRef = utils_1.db.collection("users").doc(uid);
    const userDoc = await userRef.get();
    if (!userDoc.exists) {
        throw new https_1.HttpsError("not-found", "User not found.");
    }
    // Update custom claims
    await utils_1.auth.setCustomUserClaims(uid, {
        role: "alumni",
        verificationStatus: "rejected",
    });
    // Update user document
    await userRef.update({
        verificationStatus: "rejected",
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });
    // Notify the user
    await (0, utils_1.createNotification)(uid, {
        type: "system",
        title: "Verification Update",
        body: `Your alumni verification was declined: ${reason}`,
        route: "/home",
    });
    await (0, utils_1.sendPushNotification)(uid, "Verification Update", `Your alumni verification was declined: ${reason}`);
    return { success: true };
});
//# sourceMappingURL=rejectAlumni.js.map