Hi Mostafa,

One launch rule from Ahmed Abdullah that changes the **School registration** screen:

**At launch, only 2nd and 3rd secondary (الصف الثاني والثالث الثانوي), in the National systems (عربي / لغات), are open.** Every other grade and system is **"Soon"** (قريباً).

**Contract 3.51.0-m1** (I'll confirm when it's published):
- **New `GET /reference/school-stages` (`listSchoolStages`):** all six stages with `status: active | soon`. Keep using your own stage labels (AR/EN).
- **`listEducationSystems`:** each item now has `status: active | soon`.
- **Registration refuses closed choices**, with `422 school_stage_not_available` or `422 education_system_not_available`. The suggested copy is in `error-codes.md`.

**What to change:**
1. In the stage and education-system pickers, show "Soon" items **visibly but not selectable**, with a small "Soon / قريباً" label. This works the same as University "soon" years.
2. Read the status from the server every time. **Don't hard-code it:** grades will open later without an app update.
3. If registration still returns one of the two codes (for example, the screen was open while we changed the setting), show the message and send the student back to the picker.

**Staging:** everything stays open on staging for your test accounts. We'll switch staging to the launch rules briefly to prove it, and tell you when.

Thanks,
Seif
