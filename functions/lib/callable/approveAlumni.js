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
exports.approveAlumni = void 0;
/**
 * CF-01: approveAlumni
 *
 * Admin-only callable. Sets custom claims to verified alumni,
 * updates user doc, creates alumniDirectory entry, and notifies.
 */
const https_1 = require("firebase-functions/v2/https");
const admin = __importStar(require("firebase-admin"));
const utils_1 = require("../utils");
exports.approveAlumni = (0, https_1.onCall)({ maxInstances: 10 }, async (request) => {
    const callerUid = (0, utils_1.requireAuth)(request.auth);
    await (0, utils_1.requireRole)(callerUid, "admin");
    const { uid } = request.data;
    if (!uid || typeof uid !== "string") {
        throw new https_1.HttpsError("invalid-argument", "uid is required.");
    }
    // Verify user exists and is pending alumni
    const userRef = utils_1.db.collection("users").doc(uid);
    const userDoc = await userRef.get();
    if (!userDoc.exists) {
        throw new https_1.HttpsError("not-found", "User not found.");
    }
    const userData = userDoc.data();
    if (userData.role !== "alumni") {
        throw new https_1.HttpsError("failed-precondition", "User is not an alumni account.");
    }
    // 1. Set custom claims
    await utils_1.auth.setCustomUserClaims(uid, {
        role: "alumni",
        verificationStatus: "verified",
    });
    // 2. Update user document
    await userRef.update({
        verificationStatus: "verified",
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });
    // 3. Create alumniDirectory entry (denormalized)
    await utils_1.db.collection("alumniDirectory").doc(uid).set({
        uid,
        fullName: userData.fullName || "",
        department: userData.department || "",
        batchYear: userData.batchYear || 0,
        currentCompany: userData.currentCompany || null,
        jobTitle: userData.jobTitle || null,
        skills: userData.skills || [],
        location: userData.location || null,
        photoUrl: userData.photoUrl || null,
        bio: userData.bio || null,
        openToMentorship: userData.openToMentorship || false,
    });
    // 4. Notify the user
    await (0, utils_1.createNotification)(uid, {
        type: "system",
        title: "Account Verified! 🎉",
        body: "Your alumni account has been verified. Welcome to the network!",
        route: "/home",
    });
    await (0, utils_1.sendPushNotification)(uid, "Account Verified! 🎉", "Your alumni account has been verified. Welcome to EDU Alumni Connect!");
    return { success: true };
});
//# sourceMappingURL=approveAlumni.js.map