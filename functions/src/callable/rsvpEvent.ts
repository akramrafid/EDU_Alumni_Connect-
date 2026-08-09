/**
 * CF-05: rsvpEvent
 *
 * Authenticated callable. RSVP or cancel RSVP for an event.
 * Uses Firestore transaction for atomic count management.
 */
import { onCall, HttpsError } from "firebase-functions/v2/https";
import * as admin from "firebase-admin";
import { db, requireAuth } from "../utils";

export const rsvpEvent = onCall(
  { maxInstances: 10 },
  async (request) => {
    const callerUid = requireAuth(request.auth);

    const { eventId, action } = request.data;
    if (!eventId || typeof eventId !== "string") {
      throw new HttpsError("invalid-argument", "eventId is required.");
    }
    if (!action || !["rsvp", "cancel"].includes(action)) {
      throw new HttpsError(
        "invalid-argument",
        "action must be 'rsvp' or 'cancel'."
      );
    }

    const eventRef = db.collection("events").doc(eventId);

    const newRsvpCount = await db.runTransaction(async (transaction) => {
      const eventDoc = await transaction.get(eventRef);
      if (!eventDoc.exists) {
        throw new HttpsError("not-found", "Event not found.");
      }

      const eventData = eventDoc.data()!;
      const rsvpUserIds: string[] = eventData.rsvpUserIds || [];
      const isAlreadyRsvped = rsvpUserIds.includes(callerUid);

      if (action === "rsvp") {
        // Idempotency: already RSVP'd
        if (isAlreadyRsvped) {
          return eventData.rsvpCount || rsvpUserIds.length;
        }

        // Check capacity
        const currentCount = eventData.rsvpCount || rsvpUserIds.length;
        if (currentCount >= eventData.maxAttendees) {
          throw new HttpsError(
            "resource-exhausted",
            "This event is at full capacity."
          );
        }

        // Add RSVP
        transaction.update(eventRef, {
          rsvpUserIds: admin.firestore.FieldValue.arrayUnion(callerUid),
          rsvpCount: admin.firestore.FieldValue.increment(1),
        });

        return currentCount + 1;
      } else {
        // Cancel RSVP
        if (!isAlreadyRsvped) {
          return eventData.rsvpCount || rsvpUserIds.length;
        }

        transaction.update(eventRef, {
          rsvpUserIds: admin.firestore.FieldValue.arrayRemove(callerUid),
          rsvpCount: admin.firestore.FieldValue.increment(-1),
        });

        return (eventData.rsvpCount || rsvpUserIds.length) - 1;
      }
    });

    return { success: true, newRsvpCount };
  }
);
