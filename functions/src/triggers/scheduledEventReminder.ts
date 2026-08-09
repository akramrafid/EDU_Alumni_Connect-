/**
 * BG-04: scheduledEventReminder
 *
 * Trigger: Cloud Scheduler — runs every hour
 *
 * Sends FCM push + in-app notification to RSVP'd users
 * for events happening within the next 24 hours.
 */
import { onSchedule } from "firebase-functions/v2/scheduler";
import * as admin from "firebase-admin";
import { db, createNotification, sendPushNotification } from "../utils";

export const scheduledEventReminder = onSchedule(
  {
    schedule: "every 60 minutes",
    timeZone: "Asia/Dhaka",
    maxInstances: 1,
  },
  async () => {
    const now = admin.firestore.Timestamp.now();
    const twentyFourHoursLater = admin.firestore.Timestamp.fromDate(
      new Date(now.toDate().getTime() + 24 * 60 * 60 * 1000)
    );

    // Query events in the next 24 hours that haven't been reminded
    const eventsQuery = await db
      .collection("events")
      .where("dateTime", ">=", now)
      .where("dateTime", "<=", twentyFourHoursLater)
      .where("reminderSent", "==", false)
      .get();

    if (eventsQuery.empty) {
      console.log("No events needing reminders.");
      return;
    }

    console.log(`Found ${eventsQuery.size} events to send reminders for.`);

    for (const eventDoc of eventsQuery.docs) {
      const eventData = eventDoc.data();
      const rsvpUserIds: string[] = eventData.rsvpUserIds || [];

      if (rsvpUserIds.length === 0) {
        // Mark as reminded even if no RSVPs
        await eventDoc.ref.update({ reminderSent: true });
        continue;
      }

      const title = "Event Reminder 📅";
      const body = `"${eventData.title}" is happening ${eventData.date} at ${eventData.time}. See you there!`;

      // Send notifications to all RSVP'd users
      for (const uid of rsvpUserIds) {
        try {
          await createNotification(uid, {
            type: "event_reminder",
            title,
            body,
            route: `/events/${eventDoc.id}`,
            entityId: eventDoc.id,
          });

          await sendPushNotification(uid, title, body);
        } catch (error) {
          console.warn(`Failed to notify ${uid} for event ${eventDoc.id}:`, error);
        }
      }

      // Mark as reminded
      await eventDoc.ref.update({ reminderSent: true });
      console.log(
        `Sent reminders for "${eventData.title}" to ${rsvpUserIds.length} users.`
      );
    }
  }
);
