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
exports.scheduledEventReminder = exports.onNewUserCreated = exports.onUserProfileUpdated = exports.onMessageCreated = exports.getOrCreateConversation = exports.createEvent = exports.postJob = exports.rsvpEvent = exports.respondToMentorshipRequest = exports.sendMentorshipRequest = exports.rejectAlumni = exports.approveAlumni = void 0;
/**
 * EDU Alumni Connect — Cloud Functions Entry Point
 *
 * Exports all HTTPS Callable functions and Firestore/Auth background triggers.
 */
const admin = __importStar(require("firebase-admin"));
admin.initializeApp();
// ─── HTTPS Callable Functions ────────────────────────────────────────────────
var approveAlumni_1 = require("./callable/approveAlumni");
Object.defineProperty(exports, "approveAlumni", { enumerable: true, get: function () { return approveAlumni_1.approveAlumni; } });
var rejectAlumni_1 = require("./callable/rejectAlumni");
Object.defineProperty(exports, "rejectAlumni", { enumerable: true, get: function () { return rejectAlumni_1.rejectAlumni; } });
var sendMentorshipRequest_1 = require("./callable/sendMentorshipRequest");
Object.defineProperty(exports, "sendMentorshipRequest", { enumerable: true, get: function () { return sendMentorshipRequest_1.sendMentorshipRequest; } });
var respondToMentorshipRequest_1 = require("./callable/respondToMentorshipRequest");
Object.defineProperty(exports, "respondToMentorshipRequest", { enumerable: true, get: function () { return respondToMentorshipRequest_1.respondToMentorshipRequest; } });
var rsvpEvent_1 = require("./callable/rsvpEvent");
Object.defineProperty(exports, "rsvpEvent", { enumerable: true, get: function () { return rsvpEvent_1.rsvpEvent; } });
var postJob_1 = require("./callable/postJob");
Object.defineProperty(exports, "postJob", { enumerable: true, get: function () { return postJob_1.postJob; } });
var createEvent_1 = require("./callable/createEvent");
Object.defineProperty(exports, "createEvent", { enumerable: true, get: function () { return createEvent_1.createEvent; } });
var getOrCreateConversation_1 = require("./callable/getOrCreateConversation");
Object.defineProperty(exports, "getOrCreateConversation", { enumerable: true, get: function () { return getOrCreateConversation_1.getOrCreateConversation; } });
// ─── Background Triggers ─────────────────────────────────────────────────────
var onMessageCreated_1 = require("./triggers/onMessageCreated");
Object.defineProperty(exports, "onMessageCreated", { enumerable: true, get: function () { return onMessageCreated_1.onMessageCreated; } });
var onUserProfileUpdated_1 = require("./triggers/onUserProfileUpdated");
Object.defineProperty(exports, "onUserProfileUpdated", { enumerable: true, get: function () { return onUserProfileUpdated_1.onUserProfileUpdated; } });
var onNewUserCreated_1 = require("./triggers/onNewUserCreated");
Object.defineProperty(exports, "onNewUserCreated", { enumerable: true, get: function () { return onNewUserCreated_1.onNewUserCreated; } });
var scheduledEventReminder_1 = require("./triggers/scheduledEventReminder");
Object.defineProperty(exports, "scheduledEventReminder", { enumerable: true, get: function () { return scheduledEventReminder_1.scheduledEventReminder; } });
//# sourceMappingURL=index.js.map