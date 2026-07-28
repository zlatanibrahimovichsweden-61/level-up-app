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
  /// **'01021871999'**
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

  /// Countdown until the resend action becomes available.
  ///
  /// In en, this message translates to:
  /// **'Resend in {seconds}s'**
  String resendIn(int seconds);

  /// No description provided for @otpSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Successful'**
  String get otpSuccessTitle;

  /// No description provided for @otpSuccessSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You have been authenticated'**
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

  /// Non-Egypt only — free text, never blocks registration (adr-010).
  ///
  /// In en, this message translates to:
  /// **'School Name (Optional)'**
  String get schoolNameOptional;

  /// No description provided for @schoolNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your school name'**
  String get schoolNameHint;

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
