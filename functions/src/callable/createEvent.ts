/**
 * CF-07: createEvent
 *
 * Admin-only callable. Creates a new event.
 */
import { onCall, HttpsError } from "firebase-functions/v2/https";
import * as admin from "firebase-admin";
import { db, requireAuth, requireRole } from "../utils";

export const createEvent = onCall(
  { maxInstances: 10 },
  async (request) => {
    const callerUid = requireAuth(request.auth);
    await requireRole(callerUid, "admin");

    const {
      title, description, tag, dateTime,
      location, isOnline, maxAttendees, bannerUrl,
    } = request.data;

    // Input validation
    if (!title || typeof title !== "string") {
      throw new HttpsError("invalid-argument", "title is required.");
    }
    if (!description || typeof description !== "string") {
      throw new HttpsError("invalid-argument", "description is required.");
    }
    if (!tag || typeof tag !== "string") {
      throw new HttpsError("invalid-argument", "tag is required.");
    }
    if (!dateTime || typeof dateTime !== "string") {
      throw new HttpsError("invalid-argument", "dateTime (ISO string) is required.");
    }
    if (!location || typeof location !== "string") {
      throw new HttpsError("invalid-argument", "location is required.");
    }
    if (typeof maxAttendees !== "number" || maxAttendees < 1) {
      throw new HttpsError("invalid-argument", "maxAttendees must be a positive number.");
    }

    const parsedDate = new Date(dateTime);
    if (isNaN(parsedDate.getTime())) {
      throw new HttpsError("invalid-argument", "dateTime must be a valid ISO date string.");
    }

    // Format display strings
    const months = [
      "JAN", "FEB", "MAR", "APR", "MAY", "JUN",
      "JUL", "AUG", "SEP", "OCT", "NOV", "DEC",
    ];
    const displayDate = `${months[parsedDate.getMonth()]} ${parsedDate.getDate()}`;
    const hours = parsedDate.getHours();
    const minutes = parsedDate.getMinutes().toString().padStart(2, "0");
    const amPm = hours >= 12 ? "PM" : "AM";
    const displayTime = `${hours > 12 ? hours - 12 : hours || 12}:${minutes} ${amPm}`;

    const eventRef = db.collection("events").doc();
    await eventRef.set({
      eventId: eventRef.id,
      title,
      description,
      tag: tag.toUpperCase(),
      dateTime: admin.firestore.Timestamp.fromDate(parsedDate),
      date: displayDate,
      time: displayTime,
      location,
      bannerUrl: bannerUrl || null,
      isOnline: isOnline || false,
      maxAttendees,
      rsvpCount: 0,
      rsvpUserIds: [],
      postedByAdminId: callerUid,
      reminderSent: false,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    return { success: true, eventId: eventRef.id };
  }
);
