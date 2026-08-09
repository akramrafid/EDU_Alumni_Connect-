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
exports.createEvent = void 0;
/**
 * CF-07: createEvent
 *
 * Admin-only callable. Creates a new event.
 */
const https_1 = require("firebase-functions/v2/https");
const admin = __importStar(require("firebase-admin"));
const utils_1 = require("../utils");
exports.createEvent = (0, https_1.onCall)({ maxInstances: 10 }, async (request) => {
    const callerUid = (0, utils_1.requireAuth)(request.auth);
    await (0, utils_1.requireRole)(callerUid, "admin");
    const { title, description, tag, dateTime, location, isOnline, maxAttendees, bannerUrl, } = request.data;
    // Input validation
    if (!title || typeof title !== "string") {
        throw new https_1.HttpsError("invalid-argument", "title is required.");
    }
    if (!description || typeof description !== "string") {
        throw new https_1.HttpsError("invalid-argument", "description is required.");
    }
    if (!tag || typeof tag !== "string") {
        throw new https_1.HttpsError("invalid-argument", "tag is required.");
    }
    if (!dateTime || typeof dateTime !== "string") {
        throw new https_1.HttpsError("invalid-argument", "dateTime (ISO string) is required.");
    }
    if (!location || typeof location !== "string") {
        throw new https_1.HttpsError("invalid-argument", "location is required.");
    }
    if (typeof maxAttendees !== "number" || maxAttendees < 1) {
        throw new https_1.HttpsError("invalid-argument", "maxAttendees must be a positive number.");
    }
    const parsedDate = new Date(dateTime);
    if (isNaN(parsedDate.getTime())) {
        throw new https_1.HttpsError("invalid-argument", "dateTime must be a valid ISO date string.");
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
    const eventRef = utils_1.db.collection("events").doc();
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
});
//# sourceMappingURL=createEvent.js.map