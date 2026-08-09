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
exports.sendMentorshipRequest = void 0;
/**
 * CF-03: sendMentorshipRequest
 *
 * Student-only callable. Creates a mentorship request and notifies the alumni.
 */
const https_1 = require("firebase-functions/v2/https");
const admin = __importStar(require("firebase-admin"));
const utils_1 = require("../utils");
exports.sendMentorshipRequest = (0, https_1.onCall)({ maxInstances: 10 }, async (request) => {
    const callerUid = (0, utils_1.requireAuth)(request.auth);
    await (0, utils_1.requireRole)(callerUid, "student");
    const { alumniId, message } = request.data;
    if (!alumniId || typeof alumniId !== "string") {
        throw new https_1.HttpsError("invalid-argument", "alumniId is required.");
    }
    if (!message || typeof message !== "string" || message.length < 10) {
        throw new https_1.HttpsError("invalid-argument", "message is required and must be at least 10 characters.");
    }
    // Check alumni exists and is open to mentorship
    const alumniDoc = await utils_1.db
        .collection("alumniDirectory")
        .doc(alumniId)
        .get();
    if (!alumniDoc.exists) {
        throw new https_1.HttpsError("not-found", "Alumni not found in directory.");
    }
    const alumniData = alumniDoc.data();
    if (!alumniData.openToMentorship) {
        throw new https_1.HttpsError("failed-precondition", "This alumni is not currently accepting mentorship requests.");
    }
    // Check for duplicate pending/accepted request
    const existingQuery = await utils_1.db
        .collection("mentorshipRequests")
        .where("studentId", "==", callerUid)
        .where("alumniId", "==", alumniId)
        .where("status", "in", ["pending", "accepted"])
        .limit(1)
        .get();
    if (!existingQuery.empty) {
        throw new https_1.HttpsError("already-exists", "You already have a pending or active mentorship with this alumni.");
    }
    // Get student info for denormalization
    const studentDoc = await utils_1.db.collection("users").doc(callerUid).get();
    const studentData = studentDoc.data() || {};
    // Create the request
    const requestRef = utils_1.db.collection("mentorshipRequests").doc();
    await requestRef.set({
        requestId: requestRef.id,
        studentId: callerUid,
        alumniId: alumniId,
        studentName: studentData.fullName || "Student",
        studentPhotoUrl: studentData.photoUrl || null,
        alumniName: alumniData.fullName || "Alumni",
        alumniPhotoUrl: alumniData.photoUrl || null,
        status: "pending",
        message: message,
        declineReason: null,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });
    // Notify the alumni
    await (0, utils_1.createNotification)(alumniId, {
        type: "mentorship_request",
        title: "New Mentorship Request",
        body: `${studentData.fullName || "A student"} has requested your mentorship.`,
        route: `/mentorship/${requestRef.id}`,
        entityId: requestRef.id,
    });
    await (0, utils_1.sendPushNotification)(alumniId, "New Mentorship Request", `${studentData.fullName || "A student"} would like you as their mentor.`);
    return { success: true, requestId: requestRef.id };
});
//# sourceMappingURL=sendMentorshipRequest.js.map