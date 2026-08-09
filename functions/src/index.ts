/**
 * EDU Alumni Connect — Cloud Functions Entry Point
 *
 * Exports all HTTPS Callable functions and Firestore/Auth background triggers.
 */
import * as admin from "firebase-admin";

admin.initializeApp();

// ─── HTTPS Callable Functions ────────────────────────────────────────────────
export { approveAlumni } from "./callable/approveAlumni";
export { rejectAlumni } from "./callable/rejectAlumni";
export { sendMentorshipRequest } from "./callable/sendMentorshipRequest";
export { respondToMentorshipRequest } from "./callable/respondToMentorshipRequest";
export { rsvpEvent } from "./callable/rsvpEvent";
export { postJob } from "./callable/postJob";
export { createEvent } from "./callable/createEvent";
export { getOrCreateConversation } from "./callable/getOrCreateConversation";

// ─── Background Triggers ─────────────────────────────────────────────────────
export { onMessageCreated } from "./triggers/onMessageCreated";
export { onUserProfileUpdated } from "./triggers/onUserProfileUpdated";
export { onNewUserCreated } from "./triggers/onNewUserCreated";
export { scheduledEventReminder } from "./triggers/scheduledEventReminder";
