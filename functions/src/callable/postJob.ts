/**
 * CF-06: postJob
 *
 * Alumni or admin callable. Creates a job posting with denormalized poster info.
 */
import { onCall, HttpsError } from "firebase-functions/v2/https";
import * as admin from "firebase-admin";
import { db, requireAuth, requireAnyRole } from "../utils";

const VALID_JOB_TYPES = [
  "full-time", "part-time", "internship", "remote", "contract",
];

export const postJob = onCall(
  { maxInstances: 10 },
  async (request) => {
    const callerUid = requireAuth(request.auth);
    await requireAnyRole(callerUid, ["alumni", "admin"]);

    const { title, company, location, jobType, description, applyLink } =
      request.data;

    // Input validation
    if (!title || typeof title !== "string" || title.length > 200) {
      throw new HttpsError("invalid-argument", "Valid title is required (max 200 chars).");
    }
    if (!company || typeof company !== "string") {
      throw new HttpsError("invalid-argument", "company is required.");
    }
    if (!location || typeof location !== "string") {
      throw new HttpsError("invalid-argument", "location is required.");
    }
    if (!jobType || !VALID_JOB_TYPES.includes(jobType)) {
      throw new HttpsError(
        "invalid-argument",
        `jobType must be one of: ${VALID_JOB_TYPES.join(", ")}`
      );
    }
    if (!description || typeof description !== "string") {
      throw new HttpsError("invalid-argument", "description is required.");
    }
    if (!applyLink || typeof applyLink !== "string") {
      throw new HttpsError("invalid-argument", "applyLink is required.");
    }

    // Get poster info for denormalization
    const userDoc = await db.collection("users").doc(callerUid).get();
    const userData = userDoc.data() || {};

    const jobRef = db.collection("jobPostings").doc();
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
  }
);
