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
exports.rsvpEvent = void 0;
/**
 * CF-05: rsvpEvent
 *
 * Authenticated callable. RSVP or cancel RSVP for an event.
 * Uses Firestore transaction for atomic count management.
 */
const https_1 = require("firebase-functions/v2/https");
const admin = __importStar(require("firebase-admin"));
const utils_1 = require("../utils");
exports.rsvpEvent = (0, https_1.onCall)({ maxInstances: 10 }, async (request) => {
    const callerUid = (0, utils_1.requireAuth)(request.auth);
    const { eventId, action } = request.data;
    if (!eventId || typeof eventId !== "string") {
        throw new https_1.HttpsError("invalid-argument", "eventId is required.");
    }
    if (!action || !["rsvp", "cancel"].includes(action)) {
        throw new https_1.HttpsError("invalid-argument", "action must be 'rsvp' or 'cancel'.");
    }
    const eventRef = utils_1.db.collection("events").doc(eventId);
    const newRsvpCount = await utils_1.db.runTransaction(async (transaction) => {
        const eventDoc = await transaction.get(eventRef);
        if (!eventDoc.exists) {
            throw new https_1.HttpsError("not-found", "Event not found.");
        }
        const eventData = eventDoc.data();
        const rsvpUserIds = eventData.rsvpUserIds || [];
        const isAlreadyRsvped = rsvpUserIds.includes(callerUid);
        if (action === "rsvp") {
            // Idempotency: already RSVP'd
            if (isAlreadyRsvped) {
                return eventData.rsvpCount || rsvpUserIds.length;
            }
            // Check capacity
            const currentCount = eventData.rsvpCount || rsvpUserIds.length;
            if (currentCount >= eventData.maxAttendees) {
                throw new https_1.HttpsError("resource-exhausted", "This event is at full capacity.");
            }
            // Add RSVP
            transaction.update(eventRef, {
                rsvpUserIds: admin.firestore.FieldValue.arrayUnion(callerUid),
                rsvpCount: admin.firestore.FieldValue.increment(1),
            });
            return currentCount + 1;
        }
        else {
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
});
//# sourceMappingURL=rsvpEvent.js.map