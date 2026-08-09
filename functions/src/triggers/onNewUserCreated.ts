/**
 * BG-03: onNewUserCreated
 *
 * Trigger: Firebase Auth — user.onCreate
 *
 * Sets default custom claims based on email domain.
 * @eastdelta.edu.bd → student (auto-verified)
 * other → alumni (pending verification)
 */
import { beforeUserCreated } from "firebase-functions/v2/identity";
import { auth } from "../utils";

const UNIVERSITY_DOMAIN = "@eastdelta.edu.bd";

export const onNewUserCreated = beforeUserCreated(
  async (event) => {
    const user = event.data;
    const email = user.email || "";

    let role: string;
    let verificationStatus: string;

    if (email.endsWith(UNIVERSITY_DOMAIN)) {
      role = "student";
      verificationStatus = "verified";
    } else {
      role = "alumni";
      verificationStatus = "pending";
    }

    // Set custom claims
    // Note: beforeUserCreated runs before the user record is fully committed,
    // so we use the customClaims return value approach
    await auth.setCustomUserClaims(user.uid, {
      role,
      verificationStatus,
    });

    console.log(
      `New user ${user.uid} (${email}): role=${role}, status=${verificationStatus}`
    );
  }
);
