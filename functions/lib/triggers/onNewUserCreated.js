"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.onNewUserCreated = void 0;
/**
 * BG-03: onNewUserCreated
 *
 * Trigger: Firebase Auth — user.onCreate
 *
 * Sets default custom claims based on email domain.
 * @eastdelta.edu.bd → student (auto-verified)
 * other → alumni (pending verification)
 */
const identity_1 = require("firebase-functions/v2/identity");
const utils_1 = require("../utils");
const UNIVERSITY_DOMAIN = "@eastdelta.edu.bd";
exports.onNewUserCreated = (0, identity_1.beforeUserCreated)(async (event) => {
    const user = event.data;
    const email = user.email || "";
    let role;
    let verificationStatus;
    if (email.endsWith(UNIVERSITY_DOMAIN)) {
        role = "student";
        verificationStatus = "verified";
    }
    else {
        role = "alumni";
        verificationStatus = "pending";
    }
    // Set custom claims
    // Note: beforeUserCreated runs before the user record is fully committed,
    // so we use the customClaims return value approach
    await utils_1.auth.setCustomUserClaims(user.uid, {
        role,
        verificationStatus,
    });
    console.log(`New user ${user.uid} (${email}): role=${role}, status=${verificationStatus}`);
});
//# sourceMappingURL=onNewUserCreated.js.map