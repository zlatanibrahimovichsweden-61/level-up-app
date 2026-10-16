import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// Application title
  ///
  /// In en, this message translates to:
  /// **'Level Up'**
  String get appTitle;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'You are offline'**
  String get offline;

  /// No description provided for @genericError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get genericError;

  /// 429 `rate_limited` on the unauthenticated /reference/* pickers. Shown in the picker's EXISTING error slot with its existing Retry button — no countdown, no gating, no auto-retry.
  ///
  /// In en, this message translates to:
  /// **'Too many requests. Please try again shortly.'**
  String get rateLimited;

  /// The same message when the server sent a usable Retry-After. Interpolated only; still no countdown.
  ///
  /// In en, this message translates to:
  /// **'Too many requests. Please try again in {seconds} seconds.'**
  String rateLimitedIn(int seconds);

  /// Language-toggle pill label. Shows the OTHER language's endonym: in English it offers Arabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get switchLanguage;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number to continue'**
  String get loginSubtitle;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneLabel;

  /// No description provided for @phoneHint.
  ///
  /// In en, this message translates to:
  /// **'01X XXXX XXXX'**
  String get phoneHint;

  /// No description provided for @sendOtp.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sendOtp;

  /// No description provided for @orDivider.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get orDivider;

  /// No description provided for @createNewAccount.
  ///
  /// In en, this message translates to:
  /// **'Create New Account'**
  String get createNewAccount;

  /// No description provided for @legalPrefix.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to our'**
  String get legalPrefix;

  /// No description provided for @userAgreement.
  ///
  /// In en, this message translates to:
  /// **'User Agreement'**
  String get userAgreement;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @cookiePolicy.
  ///
  /// In en, this message translates to:
  /// **'Cookie Policy'**
  String get cookiePolicy;

  /// No description provided for @legalAnd.
  ///
  /// In en, this message translates to:
  /// **'and'**
  String get legalAnd;

  /// Punctuation between the first two legal links on Login. It IS locale-specific: Arabic uses U+060C ARABIC COMMA, not U+002C. It was previously hardcoded as the Arabic comma in both locales, so the English line read 'User Agreement، Privacy Policy'. Trailing space is intentional — the Wrap has no gap of its own.
  ///
  /// In en, this message translates to:
  /// **', '**
  String get legalSeparator;

  /// No description provided for @checkOtpTitle.
  ///
  /// In en, this message translates to:
  /// **'Check OTP code'**
  String get checkOtpTitle;

  /// No description provided for @otpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We have sent a verification code to your phone. Enter the 6-digit code.'**
  String get otpSubtitle;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @resendOtp.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get resendOtp;

  /// Countdown until the resend action becomes available. Since the timer pill landed this is the pill's SEMANTICS label (what a screen reader says), not visible text.
  ///
  /// In en, this message translates to:
  /// **'Resend in {seconds}s'**
  String resendIn(int seconds);

  /// The visible countdown inside the OTP resend-timer pill, as mm.ss. The separator is a DOT because Figma 82:1328 draws '00.21' — see docs/DESIGN_ISSUES.md #49; do not 'fix' it to a colon here. Both placeholders arrive already zero-padded to two digits.
  ///
  /// In en, this message translates to:
  /// **'{minutes}.{seconds}'**
  String resendTimer(String minutes, String seconds);

  /// No description provided for @onboardingTitle.
  ///
  /// In en, this message translates to:
  /// **'Level Up'**
  String get onboardingTitle;

  /// Figma 459:43876 — the ACCENTED span of 'Your Learning Journey'. Rendered in ext.accentSoft. Split from onboardingTaglineRest so the translator decides which word is accented AND in what order; the widget renders accent-then-rest, so a translation that needs the accent last must put it last by rewording. Do not concatenate these at the call site in a fixed order.
  ///
  /// In en, this message translates to:
  /// **'Your'**
  String get onboardingTaglineAccent;

  /// Figma 459:43876 — the plain span, in ext.textPrimary.
  ///
  /// In en, this message translates to:
  /// **'Learning Journey'**
  String get onboardingTaglineRest;

  /// Figma 459:43887. The line break is deliberate — keep the \n. NOTE: the design misspells this as 'Achive' in BOTH frames (DESIGN_ISSUES #26); we ship the correct spelling.
  ///
  /// In en, this message translates to:
  /// **'Study. Compete. Achieve.\nAll in one place.'**
  String get onboardingSubtitle;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get logIn;

  /// No description provided for @otpSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Successful'**
  String get otpSuccessTitle;

  /// Figma 82:1578 — the full sentence. The shipped copy was truncated to 'You have been authenticated' when the screen was built from a screenshot.
  ///
  /// In en, this message translates to:
  /// **'Congratulations! You have been successfully authenticated'**
  String get otpSuccessSubtitle;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @sessionEndedSuperseded.
  ///
  /// In en, this message translates to:
  /// **'You\'ve been signed out — your account was used on another device.'**
  String get sessionEndedSuperseded;

  /// No description provided for @sessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Your session expired. Please sign in again.'**
  String get sessionExpired;

  /// No description provided for @createAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccountTitle;

  /// No description provided for @createAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Join thousands of students leveling up'**
  String get createAccountSubtitle;

  /// No description provided for @fullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullNameLabel;

  /// No description provided for @fullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Your full name'**
  String get fullNameHint;

  /// No description provided for @parentNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Parent\'s Number'**
  String get parentNumberLabel;

  /// No description provided for @referralCodeOptional.
  ///
  /// In en, this message translates to:
  /// **'Referral Code (Optional)'**
  String get referralCodeOptional;

  /// No description provided for @referralCodeHint.
  ///
  /// In en, this message translates to:
  /// **'Enter code'**
  String get referralCodeHint;

  /// No description provided for @chooseTrackTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Track'**
  String get chooseTrackTitle;

  /// No description provided for @chooseTrackSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This determines your content and quizzes'**
  String get chooseTrackSubtitle;

  /// No description provided for @trackSchool.
  ///
  /// In en, this message translates to:
  /// **'School Student'**
  String get trackSchool;

  /// No description provided for @trackUniversity.
  ///
  /// In en, this message translates to:
  /// **'University Student'**
  String get trackUniversity;

  /// No description provided for @registrationExpired.
  ///
  /// In en, this message translates to:
  /// **'Your registration session expired. Please start again.'**
  String get registrationExpired;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to login'**
  String get backToLogin;

  /// No description provided for @invalidName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get invalidName;

  /// No description provided for @invalidPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get invalidPhone;

  /// No description provided for @errorOtpInvalid.
  ///
  /// In en, this message translates to:
  /// **'This is an incorrect code, try again'**
  String get errorOtpInvalid;

  /// No description provided for @errorOtpExpired.
  ///
  /// In en, this message translates to:
  /// **'This code has expired. Request a new one.'**
  String get errorOtpExpired;

  /// No description provided for @errorOtpThrottled.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please wait a moment and try again.'**
  String get errorOtpThrottled;

  /// 403 account_banned on verifyOtp: the contract-suggested copy (contract/error-codes.md account_banned row, pin eddb6ac), shown inline on the OTP screen until the designer's banned frame exists (CW02).
  ///
  /// In en, this message translates to:
  /// **'Account banned — contact Support'**
  String get errorAccountBanned;

  /// No description provided for @errorValidationFailed.
  ///
  /// In en, this message translates to:
  /// **'Please check your input and try again.'**
  String get errorValidationFailed;

  /// No description provided for @schoolRegistrationTitle.
  ///
  /// In en, this message translates to:
  /// **'School Registration'**
  String get schoolRegistrationTitle;

  /// No description provided for @schoolRegistrationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Complete your profile to get started'**
  String get schoolRegistrationSubtitle;

  /// No description provided for @universityRegistrationTitle.
  ///
  /// In en, this message translates to:
  /// **'University Registration'**
  String get universityRegistrationTitle;

  /// No description provided for @universityRegistrationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Egypt University students'**
  String get universityRegistrationSubtitle;

  /// No description provided for @startLearning.
  ///
  /// In en, this message translates to:
  /// **'Start learning'**
  String get startLearning;

  /// No description provided for @dobLabel.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dobLabel;

  /// No description provided for @dobHint.
  ///
  /// In en, this message translates to:
  /// **'Select your date of birth'**
  String get dobHint;

  /// No description provided for @countryLabel.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get countryLabel;

  /// No description provided for @governorateLabel.
  ///
  /// In en, this message translates to:
  /// **'Governorate'**
  String get governorateLabel;

  /// No description provided for @cityLabel.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get cityLabel;

  /// No description provided for @educationSystemLabel.
  ///
  /// In en, this message translates to:
  /// **'Education System'**
  String get educationSystemLabel;

  /// The design labels this field 'Grade'; the contract field is `stage`.
  ///
  /// In en, this message translates to:
  /// **'Grade'**
  String get stageLabel;

  /// No description provided for @schoolLabel.
  ///
  /// In en, this message translates to:
  /// **'School Name'**
  String get schoolLabel;

  /// adr-028 §1 — the escape link under the city picker that swaps it for a free-text field. Deliberately low visual weight: the coded list stays the primary path.
  ///
  /// In en, this message translates to:
  /// **'My city isn\'t listed'**
  String get cityNotListed;

  /// adr-028 §1 — returns the free-text city field to the coded picker.
  ///
  /// In en, this message translates to:
  /// **'Choose from the list'**
  String get chooseFromList;

  /// adr-028 §1 — the free-text city field's caption (contract `cityName`, maxLength 100).
  ///
  /// In en, this message translates to:
  /// **'City name'**
  String get cityNameLabel;

  /// adr-028 §2 — skips the optional school step. Blameless framing over a bare 'Skip', and it mirrors the city escape one field above.
  ///
  /// In en, this message translates to:
  /// **'I can\'t find my school'**
  String get schoolNotFound;

  /// Shown in the school field after the student skips it, so the field reads as resolved rather than unfinished.
  ///
  /// In en, this message translates to:
  /// **'No school selected'**
  String get schoolSkipped;

  /// No description provided for @universityLabel.
  ///
  /// In en, this message translates to:
  /// **'University Name'**
  String get universityLabel;

  /// No description provided for @facultyLabel.
  ///
  /// In en, this message translates to:
  /// **'Faculty'**
  String get facultyLabel;

  /// No description provided for @studyYearLabel.
  ///
  /// In en, this message translates to:
  /// **'Academic Year'**
  String get studyYearLabel;

  /// A data-driven study year from /reference/universities.
  ///
  /// In en, this message translates to:
  /// **'Year {number}'**
  String studyYearNumber(int number);

  /// No description provided for @stagePrep1.
  ///
  /// In en, this message translates to:
  /// **'Prep 1'**
  String get stagePrep1;

  /// No description provided for @stagePrep2.
  ///
  /// In en, this message translates to:
  /// **'Prep 2'**
  String get stagePrep2;

  /// No description provided for @stagePrep3.
  ///
  /// In en, this message translates to:
  /// **'Prep 3'**
  String get stagePrep3;

  /// No description provided for @stageSecondary1.
  ///
  /// In en, this message translates to:
  /// **'Secondary 1'**
  String get stageSecondary1;

  /// No description provided for @stageSecondary2.
  ///
  /// In en, this message translates to:
  /// **'Secondary 2'**
  String get stageSecondary2;

  /// No description provided for @stageSecondary3.
  ///
  /// In en, this message translates to:
  /// **'Secondary 3'**
  String get stageSecondary3;

  /// No description provided for @selectHint.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get selectHint;

  /// No description provided for @noOptions.
  ///
  /// In en, this message translates to:
  /// **'Nothing to show here'**
  String get noOptions;

  /// No description provided for @searchSchoolsHint.
  ///
  /// In en, this message translates to:
  /// **'Search for your school'**
  String get searchSchoolsHint;

  /// No description provided for @noSchoolsFound.
  ///
  /// In en, this message translates to:
  /// **'No schools match your search'**
  String get noSchoolsFound;

  /// No description provided for @loadMore.
  ///
  /// In en, this message translates to:
  /// **'Load more'**
  String get loadMore;

  /// No description provided for @selectCountryFirst.
  ///
  /// In en, this message translates to:
  /// **'Choose a country first'**
  String get selectCountryFirst;

  /// No description provided for @selectGovernorateFirst.
  ///
  /// In en, this message translates to:
  /// **'Choose a governorate first'**
  String get selectGovernorateFirst;

  /// No description provided for @selectUniversityFirst.
  ///
  /// In en, this message translates to:
  /// **'Choose a university first'**
  String get selectUniversityFirst;

  /// No description provided for @selectFacultyFirst.
  ///
  /// In en, this message translates to:
  /// **'Choose a faculty first'**
  String get selectFacultyFirst;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get fieldRequired;

  /// No description provided for @fieldNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'This doesn\'t apply to your selection'**
  String get fieldNotAllowed;

  /// No description provided for @fieldRejected.
  ///
  /// In en, this message translates to:
  /// **'Please check this field'**
  String get fieldRejected;

  /// No description provided for @phoneAlreadyRegistered.
  ///
  /// In en, this message translates to:
  /// **'This number already has an account. Please sign in.'**
  String get phoneAlreadyRegistered;

  /// No description provided for @registrationTokenInvalid.
  ///
  /// In en, this message translates to:
  /// **'Your registration session expired. Please start again.'**
  String get registrationTokenInvalid;

  /// Trailing mark on a School grade or education-system row the server has not opened (status soon). Figma 1409:26374 / 1409:26436 (light, English) draw it at the row's end edge; the app draws the text only, not the frame's pill (DESIGN_ISSUES #133). Arabic «قريبًا» per the owner, 2026-10-15.
  ///
  /// In en, this message translates to:
  /// **'Soon'**
  String get registrationSoonMark;

  /// 422 school_stage_not_available on completeRegistration (School body): the contract-suggested copy, contract/error-codes.md row `school_stage_not_available` (spec-081 / adr-230, vendored 3.52.0-m1), verbatim. Shown in the School form's failure banner; the same registrationToken is resubmitted after the student picks an open grade.
  ///
  /// In en, this message translates to:
  /// **'Level Up isn\'t open for this grade yet. Coming soon!'**
  String get registrationSchoolStageNotAvailable;

  /// 422 education_system_not_available on completeRegistration (School body): the contract-suggested copy, contract/error-codes.md row `education_system_not_available` (spec-081 / adr-230, vendored 3.52.0-m1), verbatim. Shown in the School form's failure banner; the same registrationToken is resubmitted after the student picks an open education system.
  ///
  /// In en, this message translates to:
  /// **'This education system isn\'t available yet. Coming soon!'**
  String get registrationEducationSystemNotAvailable;

  /// No description provided for @homeWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome back,'**
  String get homeWelcome;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @currentLevel.
  ///
  /// In en, this message translates to:
  /// **'current level'**
  String get currentLevel;

  /// No description provided for @levelLabel.
  ///
  /// In en, this message translates to:
  /// **'LEVEL {level}'**
  String levelLabel(int level);

  /// No description provided for @pointsBalance.
  ///
  /// In en, this message translates to:
  /// **'Pts Balance'**
  String get pointsBalance;

  /// No description provided for @levelProgress.
  ///
  /// In en, this message translates to:
  /// **'Level {level}'**
  String levelProgress(int level);

  /// Points earned toward the next level. The target comes from a CLIENT constant — see DESIGN_ISSUES #13.
  ///
  /// In en, this message translates to:
  /// **'{points} / {target}'**
  String levelProgressPoints(int points, int target);

  /// A points figure on its own, locale-grouped (2,450 / ٢٬٤٥٠).
  ///
  /// In en, this message translates to:
  /// **'{points}'**
  String pointsValue(int points);

  /// No description provided for @dailyTasks.
  ///
  /// In en, this message translates to:
  /// **'Daily Tasks'**
  String get dailyTasks;

  /// University Home only (Figma 125:2373) — quiz-type and flashcard shortcuts. Stubbed: none of them has an endpoint in M1.
  ///
  /// In en, this message translates to:
  /// **'Learning Tools'**
  String get learningTools;

  /// No description provided for @continueLearning.
  ///
  /// In en, this message translates to:
  /// **'Continue Learning'**
  String get continueLearning;

  /// No description provided for @topStudent.
  ///
  /// In en, this message translates to:
  /// **'Top Student'**
  String get topStudent;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;

  /// No description provided for @learnTodayLeadTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Learn Today, Lead Tomorrow'**
  String get learnTodayLeadTomorrow;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navLeaderboard.
  ///
  /// In en, this message translates to:
  /// **'Leaderboard'**
  String get navLeaderboard;

  /// No description provided for @navLearn.
  ///
  /// In en, this message translates to:
  /// **'Learn'**
  String get navLearn;

  /// No description provided for @navMessage.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get navMessage;

  /// No description provided for @navAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get navAccount;

  /// No description provided for @subjectsTitle.
  ///
  /// In en, this message translates to:
  /// **'Subjects'**
  String get subjectsTitle;

  /// No description provided for @searchSubjects.
  ///
  /// In en, this message translates to:
  /// **'Search Subjects'**
  String get searchSubjects;

  /// The module picker's first pill (DG-26). The view name is the contract's and Seif's; the Arabic was confirmed by the owner on 2026-10-15.
  ///
  /// In en, this message translates to:
  /// **'All subjects'**
  String get allSubjects;

  /// No description provided for @mistakes.
  ///
  /// In en, this message translates to:
  /// **'Mistakes'**
  String get mistakes;

  /// The contract's questionCounter. DISPLAY ONLY — it never gates or hides content.
  ///
  /// In en, this message translates to:
  /// **'{answered} / {total} questions'**
  String questionsCount(int answered, int total);

  /// No description provided for @unitsTitle.
  ///
  /// In en, this message translates to:
  /// **'Units'**
  String get unitsTitle;

  /// No description provided for @chaptersTitle.
  ///
  /// In en, this message translates to:
  /// **'Chapters'**
  String get chaptersTitle;

  /// No description provided for @lessonsTitle.
  ///
  /// In en, this message translates to:
  /// **'Lessons'**
  String get lessonsTitle;

  /// Drill-down title carrying the parent's name, per Figma 337:5894 ("Biology Units"). The bare unitsTitle is the fallback before the name is known.
  ///
  /// In en, this message translates to:
  /// **'{subject} Units'**
  String unitsTitleFor(String subject);

  /// Figma 337:6047 draws the singular "Chapter"; built plural — this is a list. Confirm with the designer.
  ///
  /// In en, this message translates to:
  /// **'{unit} Chapters'**
  String chaptersTitleFor(String unit);

  /// No description provided for @lessonsTitleFor.
  ///
  /// In en, this message translates to:
  /// **'{chapter} Lessons'**
  String lessonsTitleFor(String chapter);

  /// No description provided for @lecturesTitle.
  ///
  /// In en, this message translates to:
  /// **'Lectures'**
  String get lecturesTitle;

  /// University drill-down title, per Figma 180:5208 ("Biology Lectures"). The subject name is NOT in the tree payload — it comes from the cached subjects list, and the bare lecturesTitle is the cold-deep-link fallback.
  ///
  /// In en, this message translates to:
  /// **'{subject} Lectures'**
  String lecturesTitleFor(String subject);

  /// No description provided for @quizTypeNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get quizTypeNormal;

  /// No description provided for @quizTypeMidterm.
  ///
  /// In en, this message translates to:
  /// **'Midterm'**
  String get quizTypeMidterm;

  /// No description provided for @quizTypeFinal.
  ///
  /// In en, this message translates to:
  /// **'Final'**
  String get quizTypeFinal;

  /// Contract value practicalRevision. The frame labels it "Practice", but the wire word is "practical" (lab/practical exam) — confirm with the designer, see DESIGN_ISSUES #18.
  ///
  /// In en, this message translates to:
  /// **'Practice'**
  String get quizTypePractice;

  /// Header of the Mistakes overview, Figma 404:6292 / 404:7110 — ONE screen for both tracks. Kept separate from the `mistakes` button label on the Subjects header even though the two strings match today: one is an action, the other a page name.
  ///
  /// In en, this message translates to:
  /// **'Mistakes'**
  String get mistakesTitle;

  /// The contract's mistakeCount, on the overview card and every tree row. 🔴 The frames caption this "20 questions", which is FALSE — it is how many questions the student currently has WRONG, not how many the subject contains. On a 400-question subject with 20 mistakes the frame's copy inverts the meaning of the one number this whole flow exists to show. Built as mistakes; see DESIGN_ISSUES #59. The frames also do not pluralise ("1 questions") — ICU plural here, and Arabic carries all six categories. Arabic wording needs the designer's confirmation: the existing `mistakes` key is أخطائي ("my mistakes"), right for a button and wrong for a count caption.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 mistake} other{{count} mistakes}}'**
  String mistakeCount(int count);

  /// GET /me/mistakes returning 200 [] is a NORMAL response — the record of a student with nothing outstanding — and the contract forbids rendering it as an error. No frame draws this state (DESIGN_ISSUES #60); the neutral register of noSubjects/noLectures/nothingHere ships until the designer supplies a warmer one. Owner ruling 2026-09-12.
  ///
  /// In en, this message translates to:
  /// **'No mistakes yet'**
  String get noMistakes;

  /// 403 insufficient_scope on the OVERVIEW route only, where it means the caller has no active enrolment to scope a history against — reachable in ordinary use, because a track transfer closes the old enrolment before the new one opens (adr-032). It is NOT subjectUnavailable: no subject was refused, this operation takes no id, and retry is legitimate. The SAME code on the subject route keeps subjectUnavailable. Do not collapse the two — DESIGN_ISSUES #61.
  ///
  /// In en, this message translates to:
  /// **'Your enrolment is being updated. Try again in a moment.'**
  String get mistakesEnrolmentPending;

  /// No description provided for @noSubjects.
  ///
  /// In en, this message translates to:
  /// **'No subjects yet'**
  String get noSubjects;

  /// No description provided for @noSubjectsMatch.
  ///
  /// In en, this message translates to:
  /// **'No subjects match your search'**
  String get noSubjectsMatch;

  /// No description provided for @noLectures.
  ///
  /// In en, this message translates to:
  /// **'No lectures yet'**
  String get noLectures;

  /// No description provided for @nothingHere.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get nothingHere;

  /// 403 insufficient_scope — the subject is outside the student's server-derived scope.
  ///
  /// In en, this message translates to:
  /// **'This subject isn\'t part of your course.'**
  String get subjectUnavailable;

  /// No description provided for @quizSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Quiz Setup'**
  String get quizSetupTitle;

  /// No description provided for @selectQuizSize.
  ///
  /// In en, this message translates to:
  /// **'Select Quiz Size'**
  String get selectQuizSize;

  /// Length picker chip, Figma 146:2315. The three values are the contract's own enum (10/30/50) — never other numbers.
  ///
  /// In en, this message translates to:
  /// **'{count} Questions'**
  String quizSizeOption(int count);

  /// No description provided for @quizTitle.
  ///
  /// In en, this message translates to:
  /// **'Quiz'**
  String get quizTitle;

  /// The n/total counter, Figma 308:5261. `total` is the questions DELIVERED, not the length requested — a short pool reads 1/7.
  ///
  /// In en, this message translates to:
  /// **'{position}/{total}'**
  String quizProgress(int position, int total);

  /// No description provided for @questionLabel.
  ///
  /// In en, this message translates to:
  /// **'QUESTION {position}'**
  String questionLabel(int position);

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @finishQuiz.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finishQuiz;

  /// No description provided for @answerCorrect.
  ///
  /// In en, this message translates to:
  /// **'Correct answer'**
  String get answerCorrect;

  /// No description provided for @answerWrong.
  ///
  /// In en, this message translates to:
  /// **'Your answer, incorrect'**
  String get answerWrong;

  /// Screen-reader label on the revealed correct option when the student got it wrong.
  ///
  /// In en, this message translates to:
  /// **'The correct answer'**
  String get correctAnswerRevealed;

  /// No description provided for @questionImage.
  ///
  /// In en, this message translates to:
  /// **'Question image'**
  String get questionImage;

  /// No description provided for @aiExplanation.
  ///
  /// In en, this message translates to:
  /// **'AI EXPLANATION'**
  String get aiExplanation;

  /// No description provided for @showExplanation.
  ///
  /// In en, this message translates to:
  /// **'Show explanation'**
  String get showExplanation;

  /// No description provided for @explanationGenerating.
  ///
  /// In en, this message translates to:
  /// **'Generating your explanation…'**
  String get explanationGenerating;

  /// Covers every failure of GET /questions/{id}/explanation, including the contract's expected 403 before answering. An explanation is an extra — losing it must never read as a broken quiz.
  ///
  /// In en, this message translates to:
  /// **'No explanation is available for this question.'**
  String get explanationUnavailable;

  /// No description provided for @exitQuizTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave this quiz?'**
  String get exitQuizTitle;

  /// Confirm-on-exit. Truthful on both counts: submitted answers are committed server-side, and the session cannot be rebuilt because GET /quizzes/{id} is draft (seif_fight S2).
  ///
  /// In en, this message translates to:
  /// **'Your answers so far are saved, but this quiz cannot be reopened.'**
  String get exitQuizBody;

  /// No description provided for @exitQuizStay.
  ///
  /// In en, this message translates to:
  /// **'Keep going'**
  String get exitQuizStay;

  /// No description provided for @exitQuizLeave.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get exitQuizLeave;

  /// No description provided for @quizCompleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Quiz Complete!'**
  String get quizCompleteTitle;

  /// No description provided for @resultCorrect.
  ///
  /// In en, this message translates to:
  /// **'Correct'**
  String get resultCorrect;

  /// No description provided for @resultWrong.
  ///
  /// In en, this message translates to:
  /// **'Wrong'**
  String get resultWrong;

  /// The third bucket the design has no room for. Rendered only when answeredCount < totalQuestions; wrong is answeredCount - score, NOT totalQuestions - score.
  ///
  /// In en, this message translates to:
  /// **'Skipped'**
  String get resultSkipped;

  /// No description provided for @rewardsEarned.
  ///
  /// In en, this message translates to:
  /// **'REWARDS EARNED'**
  String get rewardsEarned;

  /// QuizSummary.pointsAwarded, rendered verbatim. The app never computes or previews a points figure (seif_fight S12). Since API→UI Wave 13 this whole phrase is the rewards line's accessibility label; the line itself paints pointsAwardedValue and pointsAwardedUnit as the frame's two runs.
  ///
  /// In en, this message translates to:
  /// **'+{points} Points'**
  String pointsAwarded(int points);

  /// The rewards line's first run, Figma 159:2335 (bold, lavender). QuizSummary.pointsAwarded verbatim. Painted left-to-right in every locale so Arabic keeps the sign on the left (KNOWN_BUGS BUG-003).
  ///
  /// In en, this message translates to:
  /// **'+{points}'**
  String pointsAwardedValue(int points);

  /// The rewards line's second run, Figma 159:2337 (regular). The same word pointsAwarded ends with.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get pointsAwardedUnit;

  /// The result header's second line, Figma 159:2250 'Biology — Cell Structure'. Both names are server copy (adr-018); only the separator is ours. When the subject is unknown the scope is shown alone.
  ///
  /// In en, this message translates to:
  /// **'{subject} — {scope}'**
  String quizResultSubtitle(String subject, String scope);

  /// No description provided for @reviewQuestions.
  ///
  /// In en, this message translates to:
  /// **'Review Questions'**
  String get reviewQuestions;

  /// No description provided for @backToLearn.
  ///
  /// In en, this message translates to:
  /// **'Back to Learn'**
  String get backToLearn;

  /// Header of /quiz/:quizId/result/review — Figma 162:2411. Distinct from reviewQuestions, which is the CTA that opens it.
  ///
  /// In en, this message translates to:
  /// **'Quiz Review'**
  String get quizReviewTitle;

  /// Selected-by-default filter chip. The count is the number of questions delivered in the quiz. Only this chip carries a count — Correct and Wrong are bare labels (Figma 162:2780). Plain substitution, not a plural: the project has no ICU plural anywhere.
  ///
  /// In en, this message translates to:
  /// **'All ({count})'**
  String quizReviewFilterAll(int count);

  /// Small label above each review row — Figma 162:2577. Uppercase in English is baked into the value rather than applied with toUpperCase(), which has no meaning in Arabic. `number` is the question's position in the whole quiz, so filtering never renumbers the rows.
  ///
  /// In en, this message translates to:
  /// **'QUESTION {number}'**
  String quizReviewQuestionLabel(int number);

  /// The review screen's only reachable non-content state: the chosen filter selects no rows (e.g. Correct on a quiz answered entirely wrong). Nothing is fetched on this screen, so it has no loading, error or offline state.
  ///
  /// In en, this message translates to:
  /// **'No questions to show here.'**
  String get quizReviewEmpty;

  /// Screen-reader label for the AI glyph on wrong review rows (Figma tdesign:ai-education). The glyph is a non-interactive indicator this day — no destination frame exists for a tap.
  ///
  /// In en, this message translates to:
  /// **'AI explanation available'**
  String get quizReviewAiAvailable;

  /// No description provided for @freeUsageReachedTitle.
  ///
  /// In en, this message translates to:
  /// **'Free Usage Reached'**
  String get freeUsageReachedTitle;

  /// WEEKLY, not daily — the contract says "Free plan: 50 questions/WEEK" and the code is weekly_question_limit_reached. The frame's wording is flagged in DESIGN_ISSUES (seif_fight S16). Purchase-silent (adr-049 §3): no upgrade, price or where-to-buy — provisional wording pending the designer (D-007, DESIGN_ISSUES #51).
  ///
  /// In en, this message translates to:
  /// **'You\'ve used all your questions for this week.'**
  String get weeklyLimitBody;

  /// No description provided for @subscriptionRequiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Subscription Required'**
  String get subscriptionRequiredTitle;

  /// Provisional engineering copy (D-007): names the entitlement the 403 reports, with no price, link or destination (adr-049 §3). "plan", "premium" and "pro" are glossary-forbidden for base_subscription. Pending the designer — DESIGN_ISSUES #51.
  ///
  /// In en, this message translates to:
  /// **'This lesson needs an active subscription.'**
  String get subscriptionRequiredBody;

  /// The getExplanation 403 subscription_required popup. VERBATIM the contract's approved copy (openapi.yaml, GET /questions/{questionId}/explanation, 403) — do not reword. Shown on the limit card under subscriptionRequiredTitle, with no price, link or buy button (adr-049 §3). Owner ruling 2026-09-26, API→UI Wave 12.
  ///
  /// In en, this message translates to:
  /// **'AI explanations are available with a Level Up subscription. Subscribe to get step-by-step explanations and more learning features.'**
  String get explanationSubscriptionRequired;

  /// No description provided for @notNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get notNow;

  /// 422 not_enough_questions. Never silently retried with a smaller length — the student chooses.
  ///
  /// In en, this message translates to:
  /// **'This lesson doesn\'t have enough questions for that quiz size. Try a shorter quiz.'**
  String get errorNotEnoughQuestions;

  /// No description provided for @errorWeeklyQuestionLimitReached.
  ///
  /// In en, this message translates to:
  /// **'You\'ve reached your free weekly question limit.'**
  String get errorWeeklyQuestionLimitReached;

  /// No description provided for @errorSubscriptionRequired.
  ///
  /// In en, this message translates to:
  /// **'This content needs an active subscription.'**
  String get errorSubscriptionRequired;

  /// No description provided for @errorQuizAlreadyFinished.
  ///
  /// In en, this message translates to:
  /// **'This quiz has already been submitted.'**
  String get errorQuizAlreadyFinished;

  /// No description provided for @errorInsufficientScope.
  ///
  /// In en, this message translates to:
  /// **'This content isn\'t part of your course.'**
  String get errorInsufficientScope;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// The stat card's label. Figma 661:8572 says "Points" — distinct from Home's "Pts Balance" (pointsBalance), which is the level card's caption for the same server field.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get profilePointsLabel;

  /// No description provided for @profileSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get profileSettings;

  /// No description provided for @profileFavoriteQuestions.
  ///
  /// In en, this message translates to:
  /// **'Favorite questions'**
  String get profileFavoriteQuestions;

  /// No description provided for @profileYourProgress.
  ///
  /// In en, this message translates to:
  /// **'Your progress'**
  String get profileYourProgress;

  /// No description provided for @profileReferAFriend.
  ///
  /// In en, this message translates to:
  /// **'Refer a Friend'**
  String get profileReferAFriend;

  /// No description provided for @profileCustomerSupport.
  ///
  /// In en, this message translates to:
  /// **'Customer Support'**
  String get profileCustomerSupport;

  /// The Profile menu row (Figma 170:4905). Deliberately NOT the `privacyPolicy` key, which is the Login screen's legal LINK — the two can be reworded independently.
  ///
  /// In en, this message translates to:
  /// **'Privacy & policy'**
  String get profilePrivacyPolicy;

  /// No description provided for @profileTermsConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get profileTermsConditions;

  /// No description provided for @profileGoToUniversity.
  ///
  /// In en, this message translates to:
  /// **'Go to University'**
  String get profileGoToUniversity;

  /// No description provided for @profileLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get profileLogout;

  /// Screen-reader hint on every DISABLED Profile menu row, so a student using TalkBack/VoiceOver is told why the row does nothing instead of being left to guess. Never rendered visually — the reduced opacity carries it on screen.
  ///
  /// In en, this message translates to:
  /// **'Not available yet'**
  String get profileRowUnavailable;

  /// Semantic label for the ✕ that dismisses the Profile dialogs (Figma 180:4539). It is the NEUTRAL dismiss — the only way out of the Logout dialog that does not log you out.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get dialogClose;

  /// No description provided for @logoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutTitle;

  /// No description provided for @logoutBody.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get logoutBody;

  /// No description provided for @logoutNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get logoutNo;

  /// No description provided for @logoutYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get logoutYes;

  /// No description provided for @goToUniTitle.
  ///
  /// In en, this message translates to:
  /// **'Go to Uni'**
  String get goToUniTitle;

  /// No description provided for @goToUniBody.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to convert to the University track?'**
  String get goToUniBody;

  /// No description provided for @goToUniWarning.
  ///
  /// In en, this message translates to:
  /// **'You can\'t go back again.'**
  String get goToUniWarning;

  /// No description provided for @goToUniConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get goToUniConfirm;

  /// Why the Go-to-Uni confirm is disabled. There is no track-switch endpoint, and adr-003's dual point pools make it a data-model question, not a UI one (seif_fight S31).
  ///
  /// In en, this message translates to:
  /// **'Switching tracks isn\'t available yet.'**
  String get goToUniUnavailable;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'E-Mail'**
  String get emailLabel;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'you@example.com'**
  String get emailHint;

  /// Emptying the field sends an explicit `"email": null`, which the contract defines as 'clears it'. Said out loud because a blank box that DELETES something is not a safe thing to leave students to discover.
  ///
  /// In en, this message translates to:
  /// **'Leave this empty to remove your email.'**
  String get emailClearHelp;

  /// Figma 180:4082 reads "Save Change". Corrected to the grammatical plural — the frame's copy is a mock, not a term of art (the same call was made for the Upgrade CTA before adr-049 removed it).
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// Screen-reader hint on every read-only Edit Profile row. Sighted students get the padlock; everyone else is told rather than left wondering why the field won't focus.
  ///
  /// In en, this message translates to:
  /// **'Set when you registered — this can\'t be changed.'**
  String get fieldLockedHint;

  /// One line above the read-only block. `PATCH /me` accepts five fields; the rest of what the frame draws is immutable in v1.1 (seif_fight S20).
  ///
  /// In en, this message translates to:
  /// **'These were set when you registered and can\'t be changed here.'**
  String get fixedAfterRegistration;

  /// No description provided for @changeAvatarTitle.
  ///
  /// In en, this message translates to:
  /// **'Change your picture'**
  String get changeAvatarTitle;

  /// Figma 180:4249 — the default-avatar picker sheet, fed by GET /reference/avatars.
  ///
  /// In en, this message translates to:
  /// **'Choose Avatar'**
  String get chooseAvatarTitle;

  /// No description provided for @useAvatar.
  ///
  /// In en, this message translates to:
  /// **'Use Avatar'**
  String get useAvatar;

  /// No description provided for @uploadPhoto.
  ///
  /// In en, this message translates to:
  /// **'Upload photo'**
  String get uploadPhoto;

  /// Why the frame's Upload photo option is disabled: `PUT /me/avatar` is draft AND moderated (adr-021), so there is no endpoint and no defined outcome for a rejected image (seif_fight S29).
  ///
  /// In en, this message translates to:
  /// **'Uploading your own photo isn\'t available yet.'**
  String get uploadPhotoUnavailable;

  /// No description provided for @discardChangesTitle.
  ///
  /// In en, this message translates to:
  /// **'Discard changes?'**
  String get discardChangesTitle;

  /// No description provided for @discardChangesBody.
  ///
  /// In en, this message translates to:
  /// **'Your edits haven\'t been saved.'**
  String get discardChangesBody;

  /// No description provided for @discardChangesStay.
  ///
  /// In en, this message translates to:
  /// **'Keep editing'**
  String get discardChangesStay;

  /// No description provided for @discardChangesLeave.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discardChangesLeave;

  /// No description provided for @settingsLanguages.
  ///
  /// In en, this message translates to:
  /// **'Languages'**
  String get settingsLanguages;

  /// No description provided for @settingsMode.
  ///
  /// In en, this message translates to:
  /// **'Mode'**
  String get settingsMode;

  /// No description provided for @settingsRank.
  ///
  /// In en, this message translates to:
  /// **'Rank'**
  String get settingsRank;

  /// No description provided for @settingsNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notification Preferences'**
  String get settingsNotifications;

  /// Written in Arabic in BOTH ARB files, on purpose. A student who has ended up in a script they can't read has to be able to recognise the row that gets them out; 'Arabic' in Latin script is no help to someone looking for العربية.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get languageArabicName;

  /// Written in English in BOTH ARB files — see languageArabicName.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglishName;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// The Settings Mode section offers TWO canvases. The frame draws three colour circles; AppColors has two palettes and the third has nothing behind it (seif_fight.md S26).
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @settingsLeaderboardVisible.
  ///
  /// In en, this message translates to:
  /// **'Show me on the leaderboard'**
  String get settingsLeaderboardVisible;

  /// No description provided for @settingsLeaderboardVisibleHelp.
  ///
  /// In en, this message translates to:
  /// **'Turn this off and you won\'t be listed at all.'**
  String get settingsLeaderboardVisibleHelp;

  /// No description provided for @settingsScoreHidden.
  ///
  /// In en, this message translates to:
  /// **'Hide my points'**
  String get settingsScoreHidden;

  /// The frame draws ONE 'Show Rank' switch; the contract has two independent booleans with different adr-023 defaults (seif_fight.md S27). These two help lines are what makes the difference between them legible.
  ///
  /// In en, this message translates to:
  /// **'You\'ll still be listed — without your score.'**
  String get settingsScoreHiddenHelp;

  /// No description provided for @notifAnnouncements.
  ///
  /// In en, this message translates to:
  /// **'Announcements'**
  String get notifAnnouncements;

  /// No description provided for @notifPromotions.
  ///
  /// In en, this message translates to:
  /// **'Promotions'**
  String get notifPromotions;

  /// No description provided for @notifSupport.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get notifSupport;

  /// No description provided for @notifSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get notifSystem;

  /// Why all four notification toggles are disabled: nothing in the contract stores a notification preference (seif_fight.md S28).
  ///
  /// In en, this message translates to:
  /// **'Notification settings aren\'t available yet.'**
  String get settingsNotificationsUnavailable;

  /// No description provided for @friendsTitle.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get friendsTitle;

  /// No description provided for @friendsUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Friends aren\'t available yet.'**
  String get friendsUnavailable;

  /// No description provided for @referUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Inviting friends isn\'t available yet.'**
  String get referUnavailable;

  /// No description provided for @shareInvite.
  ///
  /// In en, this message translates to:
  /// **'Share invite'**
  String get shareInvite;

  /// No description provided for @supportUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Support isn\'t available yet.'**
  String get supportUnavailable;

  /// No description provided for @createTicket.
  ///
  /// In en, this message translates to:
  /// **'Create Ticket'**
  String get createTicket;

  /// Privacy & policy and Terms & Conditions need no endpoint — they need TEXT, and none has been supplied (seif_fight.md S30). Deliberately says the document is missing rather than inventing legal copy.
  ///
  /// In en, this message translates to:
  /// **'This document hasn\'t been published yet.'**
  String get legalNotPublished;

  /// The board screen's own heading (Figma 134:3512). Deliberately NOT the same key as navLeaderboard: the design uses different words for the nav label and the screen title, and the Arabic frame (549:18878) makes that explicit — the tab reads المتصدرون while the heading reads لوحة الصدارة. Reusing one key collapsed the two and shipped the wrong Arabic heading.
  ///
  /// In en, this message translates to:
  /// **'Leaderboard'**
  String get leaderboardTitle;

  /// A student's score on a board row and under the podium. The frame's podium subtitle reads 'level 7,3000Pts', but GET /leaderboard carries no level — only points — so only points are shown.
  ///
  /// In en, this message translates to:
  /// **'{points} pts'**
  String leaderboardPoints(int points);

  /// Labels the caller's own board row, which the server marks with isMe. The frame writes 'You' rather than repeating the student's own name back at them.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get leaderboardYou;

  /// School-track board scope: the student's own education system and country.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get leaderboardScopeSystem;

  /// School-track board scope, Egypt-only sub-scope. Hidden for students registered outside Egypt, where the server would answer 400.
  ///
  /// In en, this message translates to:
  /// **'Governorate'**
  String get leaderboardScopeGovernorate;

  /// University-track board scope — الدفعة: university + faculty + year.
  ///
  /// In en, this message translates to:
  /// **'Cohort'**
  String get leaderboardScopeCohort;

  /// University-track board scope: all university students.
  ///
  /// In en, this message translates to:
  /// **'Global'**
  String get leaderboardScopeGlobal;

  /// Empty state. Only shown once the server says hasMore is false — a page with no rows while hasMore is true is a short page, not an empty board.
  ///
  /// In en, this message translates to:
  /// **'This board doesn\'t have anyone on it yet.'**
  String get leaderboardEmpty;

  /// Footer once hasMore is false. Deliberately neutral: hasMore:false means either the end of the board or the 200-row display bound, and the client cannot tell which.
  ///
  /// In en, this message translates to:
  /// **'That\'s the end of the board.'**
  String get leaderboardEndOfBoard;

  /// The header's share affordance. Rendered disabled: no sharing surface exists in the contract, and a board carries other students' names and scores.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get leaderboardShare;

  /// 403 account_pending_deletion (adr-114). Returned by every authenticated endpoint except four during the 30-day grace window. The contract says do not log out and do not retry — route to the cancel screen, which does not exist yet.
  ///
  /// In en, this message translates to:
  /// **'Your account is scheduled for deletion. Cancel the request to use Level Up again.'**
  String get accountPendingDeletion;

  /// The Lectures tab that opens flashcards (Figma 180:5208, 349:15962; owner ruling 2026-09-29: the entry point). Not a quiz type: the contract's quizTypes enum has no flashcard value. Arabic from the owner (2026-09-29).
  ///
  /// In en, this message translates to:
  /// **'Flashcard'**
  String get flashcardsTab;

  /// The study screen's title (Figma 225:5582). Arabic from the owner (2026-09-29).
  ///
  /// In en, this message translates to:
  /// **'Flash cards'**
  String get flashcardsTitle;

  /// The Setup screen's title (Figma 1234:8797). Arabic from the owner (2026-09-29).
  ///
  /// In en, this message translates to:
  /// **'Flash Card Setup'**
  String get flashcardSetupTitle;

  /// The Setup pill: the lecture's flashcardCount (contract 3.27.0-m1; Figma 1234:8797 draws "10 Flash Cards"). Informational only — not a round size or an allowance. ARABIC IS PROVISIONAL: the owner's term plus the number, pending the owner's confirmation (DESIGN_ISSUES).
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 Flash Card} other{{count} Flash Cards}}'**
  String flashcardSetupCount(int count);

  /// Figma 1234:8797, verbatim (the frame's capitalisation and grammar; logged for the designer). ARABIC IS PROVISIONAL, pending the owner's confirmation (DESIGN_ISSUES).
  ///
  /// In en, this message translates to:
  /// **'this is available Flash cards for this quiz'**
  String get flashcardSetupHelper;

  /// Grades the card gotIt and moves on (Figma 225:5626; owner ruling 2026-09-29). Arabic from the owner.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get flashcardGotIt;

  /// Screen-reader label of the restart button (Figma 1229:8739), which grades the card again and moves on (owner ruling 2026-09-29; the contract's FlashcardSelfGrade `again`). Arabic from the owner.
  ///
  /// In en, this message translates to:
  /// **'Again'**
  String get flashcardAgain;

  /// 403 flashcard_subscription_required: the free weekly preview is used up (not the quiz weekly limit). Owner wording 2026-09-29. Purchase-silent: no price, no upgrade, no button, no Retry (it would 403 again).
  ///
  /// In en, this message translates to:
  /// **'You\'ve used this week\'s free flashcards.'**
  String get flashcardPreviewUsedUp;

  /// The Notifications inbox's first filter chip: the absence of the contract's `category` filter, i.e. every category. EN is Figma 180:8556 without its '(6)' count (no such total exists in the contract); AR is the word already shipped in quizReviewFilterAll. DERIVED, not designer-written: flagged for the owner's confirmation (CW07a, docs/DESIGN_ISSUES.md).
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get notifFilterAll;

  /// Title of a kind=moderation_warning inbox item. Copied character for character from contract/openapi.yaml (the listMyNotifications description, pin eddb6ac), where it is the client-approved copy (approved in writing 2026-10-07). Do not reword, re-punctuate or normalise it; change it only when the contract does. The Arabic text is in app_ar.arb.
  ///
  /// In en, this message translates to:
  /// **'A message about your account'**
  String get notifModerationWarningTitle;

  /// Body of a kind=moderation_warning inbox item. Copied character for character from contract/openapi.yaml (the listMyNotifications description, pin eddb6ac), where it is the client-approved copy (approved in writing 2026-10-07). Do not reword, re-punctuate or normalise it; change it only when the contract does. It tells the student to contact Support from the app while Support is still a shell (CW12 should follow).
  ///
  /// In en, this message translates to:
  /// **'We received a report about content from your account that does not follow the Level Up community rules. This is a warning. Please keep your messages and photos respectful. If this happens again, your account may be banned. If you think this is a mistake, contact Support from the app.'**
  String get notifModerationWarningBody;

  /// Support list: the title of the create-ticket card (Figma 178:3061), and the action label on a closed ticket's thread (the same key, so both read alike). EN is Figma design copy, verbatim. Arabic approved by the owner 2026-10-10 (O-14): the shorter form, identical to createTicket's Arabic, on purpose; keep the two the same. Tracked by test/features/support/support_copy_status_test.dart (tracking only, not a release gate).
  ///
  /// In en, this message translates to:
  /// **'Create a New Ticket'**
  String get supportCreateNewTicket;

  /// Support list: the subtitle of the create-ticket card (Figma 178:3065). EN is Figma design copy, verbatim. Arabic approved by the owner 2026-10-10 (O-14).
  ///
  /// In en, this message translates to:
  /// **'Describe your issue'**
  String get supportDescribeYourIssue;

  /// Support list: the heading above the student's tickets (Figma 178:3079). EN is Figma design copy, verbatim. Arabic approved by the owner 2026-10-10 (O-14).
  ///
  /// In en, this message translates to:
  /// **'Recent Tickets'**
  String get supportRecentTickets;

  /// Create-ticket screen: the title in the top bar (Figma 178:3250). The screen's heading below it reuses the approved createTicket. EN is Figma design copy, verbatim. Arabic approved by the owner 2026-10-10 (O-14).
  ///
  /// In en, this message translates to:
  /// **'New Ticket'**
  String get supportNewTicketTitle;

  /// Create-ticket screen: the subtitle under the heading (Figma 178:3343). EN is Figma design copy, verbatim. Arabic approved by the owner 2026-10-10 (O-14).
  ///
  /// In en, this message translates to:
  /// **'Describe your issue and we\'ll help you'**
  String get supportCreateTicketSubtitle;

  /// Create-ticket screen: the label of the subject field, 1 to 120 characters (Figma 178:3334). EN is Figma design copy, verbatim. Arabic approved by the owner 2026-10-10 (O-14).
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get supportSubjectLabel;

  /// Create-ticket screen: the label of the details field, 1 to 4000 characters (Figma 178:3346). EN is Figma design copy, verbatim. Arabic approved by the owner 2026-10-10 (O-14).
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get supportDetailsLabel;

  /// Create-ticket screen: the hint inside the empty details field (Figma 178:3352). EN is Figma design copy, verbatim, three full stops included. Arabic approved by the owner 2026-10-10 (O-14).
  ///
  /// In en, this message translates to:
  /// **'Describe the issue in detail...'**
  String get supportDetailsHint;

  /// Create-ticket screen: the submit button (Figma 178:3375). EN is Figma design copy, verbatim. Arabic approved by the owner 2026-10-10 (O-14).
  ///
  /// In en, this message translates to:
  /// **'Submit Ticket'**
  String get supportSubmitTicket;

  /// The status pill of a closed ticket, on its row and on a closed thread's bar (Figma 178:3131, the only drawn pill; supportStatusOpen and supportStatusInProgress reuse its look). Pending has no approved label (SQ-32) and gets no pill. EN is Figma design copy, verbatim. Arabic approved by the owner 2026-10-10 (O-14).
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get supportStatusClosed;

  /// The status pill of an open ticket, on its row in the support list. Not drawn in Figma: it reuses the Closed pill's look (178:3131) until the designer draws per-status pills (DG-63). EN and AR approved by the owner 2026-10-10 (O-14).
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get supportStatusOpen;

  /// The status pill of a ticket Customer Service is working on (in_progress), on its row in the support list. It also labels any status this app does not know, because the contract says to treat an unknown value as in progress, not closed. Never used for pending (SQ-32). Not drawn in Figma: it reuses the Closed pill's look (178:3131) until the designer draws per-status pills (DG-63). EN and AR approved by the owner 2026-10-10 (O-14).
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get supportStatusInProgress;

  /// Ticket thread: the hint inside the empty reply field (Figma 178:3469), and the field's accessible name (it is restated once the hint is gone). EN is Figma design copy, verbatim. Arabic approved by the owner 2026-10-10 (O-14).
  ///
  /// In en, this message translates to:
  /// **'Write your message'**
  String get supportComposerHint;

  /// Ticket thread: the accessible name of the reply composer's send button (the paper-plane icon). Screen readers only; nothing draws it as text. EN and AR approved by the owner 2026-10-10 (O-14).
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get supportSend;

  /// A ticket row's meta line: the ticket reference (a display label such as TK-12, never an id) and the created date as yyyy-MM-dd, joined by a middle dot (Figma 178:3110 without its leading '#', DESIGN_ISSUES DG-53). Format only, no words, so it is identical in app_ar.arb and needs no Arabic.
  ///
  /// In en, this message translates to:
  /// **'{reference} · {date}'**
  String supportTicketMeta(String reference, String date);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
