Hi Mostafa,

Thanks for pulling all of this together. The answers below come from our recorded decisions and the code on `main`. Each item is tagged:
- **[IMPLEMENTED]**: built, in the contract, on staging.
- **[CONFIGURED, NOT ENABLED]**: built but switched off.
- **[NEW IN 3.47.0-m1]**: built and reviewed, and valid from contract version **3.47.0-m1** (see the note below). No response shape you use changes. Four behaviour changes need your acknowledgment; they are listed in item 8.
- **[COMING IN 3.48.0-m1]**: built and reviewed, released right after 3.47. The operations start as `draft`; we tell you when they are `stable`.
- **[PLANNED]**: decided, not built yet.
- **[NOT AVAILABLE]**: not built and not planned for Release 1.

No credentials appear in this message.

> **Important — check the contract version first.** Everything marked **[NEW IN 3.47.0-m1]** (and the four behaviour changes in item 8) is valid only once the published contract in `level-up-contract` shows `info.version: 3.47.0-m1` in `openapi.yaml`. Until then, staging still serves `3.46.0-m1` and those items are not there yet. Everything else in this message is true today. We will also message you when 3.47.0-m1 is published.

## Section 1: your facts
Confirmed. The app IDs, display names, iOS 15.0, the staging URL, purchase silence and the Release 1 scope all match our record. **Text-only chat is correct**: there are no chat photos, voice messages or group chat. Noted: no app registrations in Firebase, Apple or Google until the owner authorises them.

## Section 2: Firebase and push
- **F1. Two separate Firebase projects?** Yes, one for staging and one for production. **[IMPLEMENTED as a rule]** The backend refuses to start with a key from the wrong project.
- **F2. Project IDs and sender status:** **[PLANNED, not created yet]**
  - Neither Firebase project exists yet, so no project ID exists.
  - Each environment's backend sender needs:
    - a server key (held by Seif only);
    - the expected project ID;
    - an on switch.
  - That isn't configured anywhere yet, so push is off in every environment today.
- **F3. Must the app's Firebase config come from the same project as that environment's sender?** Yes: the `.stg` apps use the staging project and the production apps use the production project. A token from the wrong project is refused by Firebase (`SENDER_ID_MISMATCH`) and nothing is delivered.
- **F4. Who creates and owns what:**
  - Seif creates both Firebase projects, and Ahmed Abdullah (the client) pays.
  - After the owner authorises it, Seif registers the four apps and sends you each app's `google-services.json` / `GoogleService-Info.plist` privately.
  - You never receive the server key.
- **F5. iOS and APNs:**
  - The Apple Developer account belongs to Ahmed and is being set up.
  - Once it exists, **Seif or you, through Admin access on that Apple team**, will create the APNs key. Seif then uploads it to both Firebase projects.

### Token lifecycle: decision **[NEW IN 3.47.0-m1]**
You were right: today the token is never detached. We are fixing it **on the server**, with no new endpoint and no change to the request or response.
- **Logout:** the server deletes the student's token.
- **A new sign-in (the session is superseded):** the server deletes the student's token at sign-in, so the old phone stops receiving at once. The new phone registers its own token.
- **Ban:** deleted.
- **Deletion requested:** deleted at the request. It was already deleted when the deletion executes.
- **A different student signs in on the same phone:** registering a token removes it from any other student. One token belongs to one student only.

What the app should do:
- **Register:** `PUT /me/fcm-token` after **every** sign-in and every Firebase token refresh.
- **Sign-out and account switch:** call `FirebaseMessaging.deleteToken()` on logout and on account switch.
- **During deletion grace:** expect `403 account_pending_deletion` from that `PUT`. The contract will list it in 3.47.

### Delivery and testing **[CONFIGURED, NOT ENABLED]**
- **Enabling staging push needs:**
  - Seif: the staging Firebase project, the `.stg` apps, the APNs key, and the server key on staging;
  - your `.stg` build with the Firebase files, the 8 AR/EN strings and the token `PUT`;
  - us: we then add your test students' IDs to the staging allowlist.
- **No date yet.** It depends on the Firebase and Apple setup. Owner: Seif.
- **Triggering a test push:** there is no "test push" button. Pushes come only from real events:
  - a staff reply on a ticket;
  - a friend request;
  - a chat message while the recipient's app isn't connected;
  - an academic-year opening, which is irreversible per track and year, so we fire it on staging once.
- **One test per kind:** yes. We'll run one of each and send you the results.
- **Production:** production push stays **off** until the staging proof is recorded (adr-221).

Kinds and data are as you listed. Unknown kinds open the notifications screen.

## P0
**1. Production API.** **[PLANNED: today]**
- The hosts are final:
  - API: `https://api.level-upworld.com/api/v1`
  - Chat hub: `wss://api.level-upworld.com/hubs/chat`, on the same host, outside `/api/v1`. It uses WebSockets only with `skipNegotiation: true`, because production runs 2 API servers.
- Seif is provisioning production today (9 Oct), aiming to be live by 10 Oct.
- The production URL goes into the contract's `servers:` only **after** the deploy is verified. We'll tell you when it's there.

**2. Store reviewer access.** **[NEW IN 3.47.0-m1]**
- **The mechanism:**
  - Production has no fixed test codes, so we are adding a narrow reviewer path.
  - A short list of reviewer phone numbers, set in production config, signs in with a secret code. No SMS is sent, and all normal limits still apply.
  - Seif will create **one School and one University reviewer account**, each with active access. The same two accounts can serve both stores, or we can make separate ones per store if you prefer, up to 4.
- **Delivery:**
  - Seif enters the number and code directly into App Store Connect ("Sign-in information") and Play Console ("App access").
  - If you submit the builds, he shares them through a private password-manager share, never in chat.
- **Validity:** the accounts stay valid, and Seif can rotate the code after each review.

**3. Account-deletion copy.** **[NEW IN 3.47.0-m1: the contract is relaxed]**
- You're right about the conflict. The contract will drop the "paid subscription / no partial refund" wording, and the no-refund rule stays in the Terms.
- Use this copy (pending Ahmed's final approval):
  - EN: "Deleting your account is permanent. You will lose access to Level Up, and your points, level, badges and quiz history will be removed. A new account registered later with the same number starts from zero."
  - AR: "حذف الحساب نهائي. ستفقد إمكانية الدخول إلى Level Up، وسيتم حذف نقاطك ومستواك وشاراتك وسجل اختباراتك. أي حساب جديد يُسجَّل لاحقاً بنفس الرقم يبدأ من الصفر."

**4. Public legal URLs.** **[PLANNED]**
- The URLs:
  - `https://level-upworld.com/privacy`
  - `https://level-upworld.com/terms`
  - `https://level-upworld.com/account-deletion` (information only; the real deletion is in-app)
- Badawy owns the website. The pages exist on his preview and go live when the site moves to production with us.
- There is no automatic link to the API version. Both come from the same approved r4 text, and a new version is published to both together.
- In the app, show legal text through `getLegalDocument` rather than opening a browser.

**5. Production Terms.** **[PLANNED: same as staging]**
- Production will serve **`r4-2026-10-07`**, the same as staging.
- New versions are manual: Ahmed approves the text, we publish a new version ID with a deploy, and published texts are never edited.
- Re-accepting isn't forced by the server. `getTermsAcceptance` returns `isCurrent: false`, and the app should then prompt.
- The only server-enforced gates are support photos and custom-avatar upload, which return `403 terms_acceptance_required` until the current version is accepted. Text tickets are never gated.

**6. Privacy and security facts.**
- **Region:** production runs in DigitalOcean **Frankfurt (FRA1)**: servers, database, cache and file storage. Staging runs on Railway EU West, with file storage in Frankfurt.
- **Logs:** kept 30 days. The web proxy keeps no access log.
- **Chat and photo retention:** chat messages are deleted 24 h after being read or 30 days after sending. Support photos are deleted 90 days after the ticket closes.
- **Backups:** the managed database has daily backups kept 7 days, which is the provider standard. Servers have weekly backups. The cache has no backups because it holds only short-lived data.
- **`security.md`:** this is our internal threat register, not a partner document. The contract's reference to it only means that the staging test numbers don't exist in production.

**7. User content moderation.**
- **Display names: [NEW IN 3.47.0-m1]** a blocked-word filter (Arabic and English). An offensive name is refused with `422 name_not_allowed` at registration and profile edit.
- **Chat text: [NOT AVAILABLE] as an automatic filter in Release 1.** Chat is between accepted friends only, and has report message, report student and block.
- **Reports: [IMPLEMENTED]** Reports go to the staff moderation queue in the console. Customer Service and Admin can dismiss, remove content, warn, ban or escalate.
- **Response time:** there is no response-time commitment, so the app should not state one. Use "Our team will review it."

## P1
**8. Contract stability.**
- `3.46.0-m1` (`eddb6ac`) is the baseline for Release 1. **3.47.0-m1** follows today or tomorrow with the additive items marked in this reply.
- No freeze date is recorded. The standing rule: **a breaking or behavioural change to an operation you use needs your acknowledgment before it ships** (adr-026, adr-038). Additive changes are announced in the changelog.
- Since 3.38, these changed behaviour, all in the changelog:
  - 3.41: a new inbox kind;
  - 3.42: `account_banned` on 4 sign-in operations, and the chat tombstone;
  - 3.43: the forwarded-question card in chat;
  - 3.45: the `forwardQuestion` 409 narrowed.
- Three changelog entries kept the version unchanged: cross-track `blockStudent`, the 3-connection hub cap, and `skipNegotiation`.
- We found no undocumented changes. We have not diffed every commit.
- **Behaviour changes in 3.47.0-m1** (no shape change; please acknowledge):
  1. **Push token:** the server now removes the registration on logout, on a new sign-in, on a ban and on a deletion request (see Section 2).
  2. **`leveledUp`** on `finishQuiz` now fires when the level in `GET /me` increases, at 500, 1,000 … 5,500. It used to fire 500 points late.
  3. **`422 name_not_allowed`** is new on `completeRegistration` and `updateMyProfile` (item 7).
  4. **Recovery:** after the 3rd wrong code, `verifyParentOtp` and `confirmRecovery` answer `429 otp_throttled` for every call until the 30-minute lock ends, even with the right code. This enforces the documented 3-failure rule under parallel requests.

**9–11.** See Section 2.

**12. Banned-account support.** **[NEW IN 3.47.0-m1: copy in the contract]**
- There is no anonymous support operation, and none is planned. The channel is external, by email.
- Show:
  - EN: "Your account has been banned. To contact Support, email support@level-upworld.com."
  - AR: "تم حظر حسابك. للتواصل مع الدعم راسلنا على support@level-upworld.com"

**13. Missing product APIs.**
- **Progress/history: [IMPLEMENTED]** through the existing operations:
  - `listQuizHistory`, `getQuizReview`, `getMyQuizSummary`;
  - `getMyMistakes`;
  - the leaderboards and `getMyRank`;
  - `GET /me` for points, level and badges.
- **There is no "XP".** The app uses points.
- **Daily Tasks: [COMING IN 3.48.0-m1]** — in Release 1 (it is in the signed scope and the School Home design). The Admin creates tasks; the app reads today's tasks from `GET /api/v1/me/daily-tasks` (`listMyDailyTasks`): title (AR/EN), type (`answerQuestions`, `answerCorrectly`, `finishQuizzes`), target, live progress, completed, reward points, optional subject, and `endsAt` (next Cairo midnight). At most 5 tasks a day per student; progress resets at Cairo midnight; the reward (1–50 points) is added **instantly** when the target is reached, with no claim button. No push and no inbox item. Everyone sees tasks (free answers still count against the weekly 50). Use it for the Home "Daily Tasks" block and a "See All" list (University Home too, if the design has it).
- **A personal daily streak: [NOT AVAILABLE]**. It was removed by decision. Only the friend-pair streak exists (`listMyFriendStreaks`).

**14–16. Test accounts and data.** **[IMPLEMENTED on staging]**
No credentials need to be sent privately. Every account uses the staging test-number range and the fixed staging test code that the contract publishes in `openapi.yaml`, in the OTP notes near the top. That range and code exist **only on staging**.

**How to sign in:**
1. Point the staging build at `https://level-up-backend-staging.up.railway.app/api/v1`.
2. Enter the phone number from the table below. No SMS is sent for these numbers.
3. Enter the published staging test code.
4. The account opens with the current Terms already accepted.

The normal limits still apply to these numbers: 60 s between code requests, and a 15-minute lock after 5 wrong codes.

| Account | Phone | Track | What it holds |
|---|---|---|---|
| S1 | +2010000000065 | School | Accepted friendship with S2. Pending incoming request from S3. A conversation with S2 with 3 messages and a forwarded-question card (S2 has not answered it). An **open** ticket with a staff reply. A finished quiz (2 wrong, 2 right). |
| S2 | +2010000000061 | School | Friend of S1. A **closed** ticket with a staff reply. A `moderation_warning` inbox item. |
| S3 | +2010000000062 | School | Has sent S1 a friend request, still pending. |
| U1 | +2010000000066 | University | On a released term with a subject, a lecture, 12 questions and 5 lecture flashcards. A finished quiz with wrong answers, so mistakes exist. Flashcard access is active. The cohort (university, faculty and study year) shows on the profile. |
| B1 | +2010000000064 | School | **Banned by Support.** After the correct code, sign-in answers `403 account_banned`. Use it for the banned screen. |

**Inbox coverage:**
- **Every account:** the automatic `enrolment_opened` welcome item.
- **S2 and S3:** an `announcement` item. S1 and U1 were created after it was sent, and announcements reach only students who exist at send time.
- **S1 and S2:** a `support_ticket_replied` item.
- **S2:** `moderation_warning`.
- **`academic_year_opened`:** not seeded yet. It is irreversible per track and year, so we fire it once, together with the push test.

**Notes:**
- **Messages expire.** Chat messages disappear 24 h after being read or 30 days after sending, so the conversation will empty over time. Tell us and we re-run the seed. It is safe to re-run and never duplicates.
- **Testing on these accounts changes their state.** For example, accepting the request from S3 or replying to the ticket. Re-running the seed restores what it can.
- **More accounts:** if you need more, any other number in the same range works for a fresh registration.

**17. Leaderboard names.** These are the same name field, so the new name filter covers them. Students can also hide from the leaderboard (`leaderboardVisible`, `scoreHidden`).

**18. Parent reports.** **[CONFIGURED, NOT ENABLED]**
- They are not part of Release 1. `GET /me` `school.parentReportStatus` will be `inactive`.
- The earliest first send is **1 November 2026**, for October. Ahmed asked for a richer report, which we're building now.
- Before the first send:
  - Meta must approve the WhatsApp template;
  - the Terms/Privacy need a counsel-approved line, which means a new version.

## P2
**20. `enrolment_opened`.** **[IMPLEMENTED]**
- It is still written, once at registration (the welcome item), with category `system`. It is never pushed.
- `data` is `{ "track": "School" | "University" }`. **Note the capital letter**, unlike `academic_year_opened`, which uses lowercase.
- Render it from `kind` and `track`. 3.47 documents this.

**21. Push limits.** All four kinds share the same limits:
- **5 per student per kind per hour.**
- **Chat:** also at most 1 push per conversation per 5 minutes, and none if the message reached a live chat connection.
- **No repeats:** an event is never pushed twice.

**22. OTP throttling.**
- **`429 otp_throttled`:** it has **no** `Retry-After` and no remaining time.
  - Use `resendAfterSeconds` from `requestOtp`'s 202 response (60 s).
  - After 5 failed verifies the account is locked for 15 minutes.
- **Where `Retry-After` does appear:** always in whole seconds, never an HTTP date, on:
  - `rate_limited`;
  - `forward_daily_limit_reached`;
  - the avatar and support-photo throttles.
- So it is **not** on every 429. 3.47 says this explicitly.

**23. Forced update.** **[NEW IN 3.47.0-m1]**
- The operation: `GET /api/v1/app/version-policy` (`getAppVersionPolicy`, **stable**), with no sign-in. It returns `{ android: { minimumVersion, latestVersion }, ios: { … } }`.
- How the app uses it:
  - **Below `minimumVersion`:** a blocking update screen.
  - **Below `latestVersion`:** a nudge the student can dismiss.
  - **`null`:** nothing.
  - **The call fails:** don't block.
- **Please build this into the very first release build.**

**24. Contract corrections.** **[NEW IN 3.47.0-m1: one correction entry]** We confirmed 11 of your 12 points:
- **3.35 is not skipped.** The entry exists, but its text says "3.28 → 3.35".
- **The two leaderboard operations** do carry stamps. What is missing is a re-stamp for the 3.36 block-exclusion change, which we'll add.
- **The FCM `403 account_pending_deletion`** is real. No token is stored in that case.

**25–26. Presigned uploads.**
- **Which flows:** only support photos use a presigned `PUT`. Avatars are a multipart upload through the API.
- **The URL:** it is valid until `expiresAt`, at most 15 minutes. Send exactly the returned headers.
- **When the `PUT` fails:**
  - **Before expiry:** re-sending the **identical bytes and headers** to the same URL is fine.
  - **After expiry, or on a signature error:** call `createSupportAttachmentUpload` again. You get a new attachment ID.
- **`completeSupportAttachment`:** on `503`, retry the complete call. On `413` or `422`, start again.
- **Hostnames:** treat the URL as opaque and don't pin the host. Today it is the Frankfurt Spaces endpoint, with a different bucket per environment. Avatars are served from our CDN host.

**27. Learning edge cases.** **[IMPLEMENTED]**
- **Point credit:**
  - Points are credited **at each `submitAnswer`**: +1 per correct answer, returned immediately in `pointsDelta`.
  - `finishQuiz` awards nothing, and a replayed submit returns `pointsDelta: 0`.
  - The same question in a later quiz earns again.
- **Quiz 403s:** branch on `code`.
  - **`createQuiz`:**
    - `weekly_question_limit_reached`: the free weekly cap would be exceeded. Nothing is created, and the cap resets Monday 00:00 Cairo.
    - `insufficient_scope`: an unknown, other-cohort or unreleased leaf, or no enrolment.
  - **`submitAnswer`:**
    - `insufficient_scope`: a foreign quiz, question or option.
    - `409 quiz_already_finished`: a finished quiz, or one over 24 h old.
  - **`getQuizReview`:** `quiz_not_finished` for your own unfinished quiz.
  - **Any signed-in call:** can also return `account_pending_deletion`.
- **Subject tree:** the only discriminator is `code` (`insufficient_scope`). The 200 body is a `oneOf` on `track`.
- **Mistakes and replays:**
  - A question counts as a mistake only while its latest graded answer is wrong. `retakeWrong` uses the "ever wrong" pool.
  - Replaying a submit returns the original verdict, even with a different option.
  - `newBadge` and `leveledUp` are frozen on the attempt.
- **Weekly allowance:** it is charged **when the quiz is created**. An abandoned quiz refunds nothing, and questions already charged this week cost nothing again.
- **Avatar 400 vs 404:** there is **no 404** (`avatar_not_found` is unused).
  - **`400 validation_failed`:**
    - a bad `avatarId`;
    - an upload that isn't exactly one multipart part named `image`.
  - **422:** bad bytes, size or animation give `image_content_invalid`; a moderation refusal gives `image_rejected_by_moderation`.
  - **Other:** over 2 MiB is 413, and Terms not accepted is 403.
- **Flashcard round two:**
  - The server has no rounds. The list is ordered by card ID ascending, which is creation order.
  - For round two, request again from page 1 and filter `selfGrade == "again"` on the client.
  - Cards already delivered this week come again for free.
- **`termId` / `termNumber`:** the keys are always present but can be `null`. They are always null for School, and `termNumber` is null exactly when `termId` is null. Decode both as nullable.

**28. Profile and Settings.**
- **"HERO":** there is no such tier in the backend. Don't show it; use the numeric `getMyRank` instead.
- **Notification preferences:** not stored on the server. The phone's notification permission is the switch.
- **`parentPhone`:** write-only, sent at registration only. Only a masked form appears, in recovery.
- **The level ladder:**
  - **Level 1 at 0 points, +1 every 500, Level 12 at 5,500.**
  - Badges come every 5,000 points after that, the first at 11,000.
  - We found that `leveledUp` fired one step late (Level 12 at 6,000). This is fixed in 3.47, so it now matches `GET /me`. No shape changes.

**29. Sentry.** **[PLANNED]**
- Yes to the Sentry Flutter SDK in the app, with PII off:
  - `sendDefaultPii: false`;
  - no phone numbers, codes or message text;
  - no screenshots.
- Seif creates the Sentry project and shares the DSN privately. Backend Sentry is planned but not wired yet.

**30. Staging error-path testing.**
- **Short-lived test tokens:** [NOT AVAILABLE]. Use the staging test numbers instead.
- **401 / refresh:** the access token lasts about 15 minutes, so wait it out. Signing in on a second phone gives `session_superseded`.
- **429:** use the real limits. For example, call `requestOtp` twice within 60 s.
- **Forced 5xx:** [NOT AVAILABLE].
- **`explanationAvailable: true`:** [NOT AVAILABLE] on staging. AI explanations stay off until the OpenAI key and evaluation are in place.

## Section 4: not available or not planned for Release 1
| Item | Owner | Target |
|---|---|---|
| XP (the app uses points) | n/a | none |
| Personal daily streak | removed by decision | none |
| Chat text auto-filter | Seif | after Release 1 |
| Moderation response-time commitment | Ahmed | none |
| Anonymous in-app support (we use email instead) | n/a | n/a |
| Test-token / fault injection on staging | n/a | none |
| AI explanations on staging | Seif | after the OpenAI key and evaluation |
| Parent WhatsApp report | Seif and Ahmed | earliest 1 Nov 2026 |
| Firebase projects, APNs, staging push proof | Seif (Ahmed for the Apple account) | after the owner authorises it; no date yet |

Thanks,
Seif
