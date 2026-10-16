Hi Mostafa,

**Mobile contract 3.52.0-m1: `listSchoolStages` is now `stable`**, together with the `status` field on `listEducationSystems` and the two registration codes (`school_stage_not_available`, `education_system_not_available`).

Build the School registration "Soon" stages and systems against it, as in my earlier note. We tested it live on staging today with the launch setting:
- prep1–secondary1 and IG / American / IB came back `soon`, and were refused at registration;
- secondary2/3 with a national system registered fine.

**Staging stays all-open** for your test accounts. Production applies the launch rule (2nd and 3rd secondary, national systems) from its next deploy.

**One question for the website's Account Deletion page:** what is the exact in-app path to delete an account, in English and Arabic, with the labels exactly as they appear in the current build? For example: Profile → Settings → Delete account / الملف الشخصي ← الإعدادات ← حذف الحساب. The web developer puts it on the page as written, so the labels must match the app.

Thanks,
Seif
