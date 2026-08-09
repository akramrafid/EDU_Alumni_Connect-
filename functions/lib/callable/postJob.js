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
exports.postJob = void 0;
/**
 * CF-06: postJob
 *
 * Alumni or admin callable. Creates a job posting with denormalized poster info.
 */
const https_1 = require("firebase-functions/v2/https");
const admin = __importStar(require("firebase-admin"));
const utils_1 = require("../utils");
const VALID_JOB_TYPES = [
    "full-time", "part-time", "internship", "remote", "contract",
];
exports.postJob = (0, https_1.onCall)({ maxInstances: 10 }, async (request) => {
    const callerUid = (0, utils_1.requireAuth)(request.auth);
    await (0, utils_1.requireAnyRole)(callerUid, ["alumni", "admin"]);
    const { title, company, location, jobType, description, applyLink } = request.data;
    // Input validation
    if (!title || typeof title !== "string" || title.length > 200) {
        throw new https_1.HttpsError("invalid-argument", "Valid title is required (max 200 chars).");
    }
    if (!company || typeof company !== "string") {
        throw new https_1.HttpsError("invalid-argument", "company is required.");
    }
    if (!location || typeof location !== "string") {
        throw new https_1.HttpsError("invalid-argument", "location is required.");
    }
    if (!jobType || !VALID_JOB_TYPES.includes(jobType)) {
        throw new https_1.HttpsError("invalid-argument", `jobType must be one of: ${VALID_JOB_TYPES.join(", ")}`);
    }
    if (!description || typeof description !== "string") {
        throw new https_1.HttpsError("invalid-argument", "description is required.");
    }
    if (!applyLink || typeof applyLink !== "string") {
        throw new https_1.HttpsError("invalid-argument", "applyLink is required.");
    }
    // Get poster info for denormalization
    const userDoc = await utils_1.db.collection("users").doc(callerUid).get();
    const userData = userDoc.data() || {};
    const jobRef = utils_1.db.collection("jobPostings").doc();
    await jobRef.set({
        jobId: jobRef.id,
        postedByAlumniId: callerUid,
        posterName: userData.fullName || "Alumni",
        posterPhotoUrl: userData.photoUrl || null,
        title,
        company,
        location,
        jobType,
        description,
        applyLink,
        status: "active",
        postedAt: admin.firestore.FieldValue.serverTimestamp(),
    });
    return { success: true, jobId: jobRef.id };
});
//# sourceMappingURL=postJob.js.map