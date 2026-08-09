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
exports.scheduledEventReminder = void 0;
/**
 * BG-04: scheduledEventReminder
 *
 * Trigger: Cloud Scheduler — runs every hour
 *
 * Sends FCM push + in-app notification to RSVP'd users
 * for events happening within the next 24 hours.
 */
const scheduler_1 = require("firebase-functions/v2/scheduler");
const admin = __importStar(require("firebase-admin"));
const utils_1 = require("../utils");
exports.scheduledEventReminder = (0, scheduler_1.onSchedule)({
    schedule: "every 60 minutes",
    timeZone: "Asia/Dhaka",
    maxInstances: 1,
}, async () => {
    const now = admin.firestore.Timestamp.now();
    const twentyFourHoursLater = admin.firestore.Timestamp.fromDate(new Date(now.toDate().getTime() + 24 * 60 * 60 * 1000));
    // Query events in the next 24 hours that haven't been reminded
    const eventsQuery = await utils_1.db
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
        const rsvpUserIds = eventData.rsvpUserIds || [];
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
                await (0, utils_1.createNotification)(uid, {
                    type: "event_reminder",
                    title,
                    body,
                    route: `/events/${eventDoc.id}`,
                    entityId: eventDoc.id,
                });
                await (0, utils_1.sendPushNotification)(uid, title, body);
            }
            catch (error) {
                console.warn(`Failed to notify ${uid} for event ${eventDoc.id}:`, error);
            }
        }
        // Mark as reminded
        await eventDoc.ref.update({ reminderSent: true });
        console.log(`Sent reminders for "${eventData.title}" to ${rsvpUserIds.length} users.`);
    }
});
//# sourceMappingURL=scheduledEventReminder.js.map