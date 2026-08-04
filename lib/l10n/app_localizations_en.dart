// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Level Up';

  @override
  String get retry => 'Retry';

  @override
  String get offline => 'You are offline';

  @override
  String get genericError => 'Something went wrong';

  @override
  String get switchLanguage => 'العربية';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get loginSubtitle => 'Enter your phone number to continue';

  @override
  String get phoneLabel => 'Phone Number';

  @override
  String get phoneHint => '01021871999';

  @override
  String get sendOtp => 'Send OTP';

  @override
  String get orDivider => 'OR';

  @override
  String get createNewAccount => 'Create New Account';

  @override
  String get legalPrefix => 'By continuing, you agree to our';

  @override
  String get userAgreement => 'User Agreement';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get cookiePolicy => 'Cookie Policy';

  @override
  String get legalAnd => 'and';

  @override
  String get checkOtpTitle => 'Check OTP code';

  @override
  String get otpSubtitle =>
      'We have sent a verification code to your phone. Enter the 6-digit code.';

  @override
  String get verify => 'Verify';

  @override
  String get resendOtp => 'Resend OTP';

  @override
  String resendIn(int seconds) {
    return 'Resend in ${seconds}s';
  }

  @override
  String get onboardingTitle => 'Level Up';

  @override
  String get onboardingTaglineAccent => 'Your';

  @override
  String get onboardingTaglineRest => 'Learning Journey';

  @override
  String get onboardingSubtitle =>
      'Study. Compete. Achieve.\nAll in one place.';

  @override
  String get getStarted => 'Get Started';

  @override
  String get logIn => 'Log In';

  @override
  String get otpSuccessTitle => 'Successful';

  @override
  String get otpSuccessSubtitle =>
      'Congratulations! You have been successfully authenticated';

  @override
  String get continueLabel => 'Continue';

  @override
  String get sessionEndedSuperseded =>
      'You\'ve been signed out — your account was used on another device.';

  @override
  String get sessionExpired => 'Your session expired. Please sign in again.';

  @override
  String get createAccountTitle => 'Create Account';

  @override
  String get createAccountSubtitle => 'Join thousands of students leveling up';

  @override
  String get fullNameLabel => 'Full Name';

  @override
  String get fullNameHint => 'Your full name';

  @override
  String get parentNumberLabel => 'Parent\'s Number';

  @override
  String get referralCodeOptional => 'Referral Code (Optional)';

  @override
  String get referralCodeHint => 'Enter code';

  @override
  String get chooseTrackTitle => 'Choose Your Track';

  @override
  String get chooseTrackSubtitle => 'This determines your content and quizzes';

  @override
  String get trackSchool => 'School Student';

  @override
  String get trackUniversity => 'University Student';

  @override
  String get registrationExpired =>
      'Your registration session expired. Please start again.';

  @override
  String get backToLogin => 'Back to login';

  @override
  String get invalidName => 'Please enter your name';

  @override
  String get invalidPhone => 'Please enter a valid phone number';

  @override
  String get errorOtpInvalid => 'This is an incorrect code, try again';

  @override
  String get errorOtpExpired => 'This code has expired. Request a new one.';

  @override
  String get errorOtpThrottled =>
      'Too many attempts. Please wait a moment and try again.';

  @override
  String get errorValidationFailed => 'Please check your input and try again.';

  @override
  String get schoolRegistrationTitle => 'School Registration';

  @override
  String get schoolRegistrationSubtitle =>
      'Complete your profile to get started';

  @override
  String get universityRegistrationTitle => 'University Registration';

  @override
  String get universityRegistrationSubtitle => 'Egypt University students';

  @override
  String get startLearning => 'Start learning';

  @override
  String get dobLabel => 'Date of Birth';

  @override
  String get dobHint => 'Select your date of birth';

  @override
  String get countryLabel => 'Country';

  @override
  String get governorateLabel => 'Governorate';

  @override
  String get cityLabel => 'City';

  @override
  String get educationSystemLabel => 'Education System';

  @override
  String get stageLabel => 'Grade';

  @override
  String get schoolLabel => 'School Name';

  @override
  String get schoolNameOptional => 'School Name (Optional)';

  @override
  String get schoolNameHint => 'Enter your school name';

  @override
  String get universityLabel => 'University Name';

  @override
  String get facultyLabel => 'Faculty';

  @override
  String get studyYearLabel => 'Academic Year';

  @override
  String studyYearNumber(int number) {
    return 'Year $number';
  }

  @override
  String get stagePrep1 => 'Prep 1';

  @override
  String get stagePrep2 => 'Prep 2';

  @override
  String get stagePrep3 => 'Prep 3';

  @override
  String get stageSecondary1 => 'Secondary 1';

  @override
  String get stageSecondary2 => 'Secondary 2';

  @override
  String get stageSecondary3 => 'Secondary 3';

  @override
  String get selectHint => 'Select';

  @override
  String get noOptions => 'Nothing to show here';

  @override
  String get searchSchoolsHint => 'Search for your school';

  @override
  String get noSchoolsFound => 'No schools match your search';

  @override
  String get loadMore => 'Load more';

  @override
  String get selectCountryFirst => 'Choose a country first';

  @override
  String get selectGovernorateFirst => 'Choose a governorate first';

  @override
  String get selectUniversityFirst => 'Choose a university first';

  @override
  String get selectFacultyFirst => 'Choose a faculty first';

  @override
  String get fieldRequired => 'This field is required';

  @override
  String get fieldNotAllowed => 'This doesn\'t apply to your selection';

  @override
  String get fieldRejected => 'Please check this field';

  @override
  String get phoneAlreadyRegistered =>
      'This number already has an account. Please sign in.';

  @override
  String get registrationTokenInvalid =>
      'Your registration session expired. Please start again.';

  @override
  String get homeWelcome => 'Welcome back,';

  @override
  String get notifications => 'Notifications';

  @override
  String get currentLevel => 'current level';

  @override
  String levelLabel(int level) {
    return 'LEVEL $level';
  }

  @override
  String get pointsBalance => 'Pts Balance';

  @override
  String levelProgress(int level) {
    return 'Level $level';
  }

  @override
  String levelProgressPoints(int points, int target) {
    final intl.NumberFormat pointsNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String pointsString = pointsNumberFormat.format(points);
    final intl.NumberFormat targetNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String targetString = targetNumberFormat.format(target);

    return '$pointsString / $targetString';
  }

  @override
  String pointsValue(int points) {
    final intl.NumberFormat pointsNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String pointsString = pointsNumberFormat.format(points);

    return '$pointsString';
  }

  @override
  String get dailyTasks => 'Daily Tasks';

  @override
  String get learningTools => 'Learning Tools';

  @override
  String get continueLearning => 'Continue Learning';

  @override
  String get topStudent => 'Top Student';

  @override
  String get seeAll => 'See All';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get learnTodayLeadTomorrow => 'Learn Today, Lead Tomorrow';

  @override
  String get navHome => 'Home';

  @override
  String get navLeaderboard => 'Leaderboard';

  @override
  String get navLearn => 'Learn';

  @override
  String get navMessage => 'Message';

  @override
  String get navAccount => 'Account';

  @override
  String get subjectsTitle => 'Subjects';

  @override
  String get searchSubjects => 'Search Subjects';

  @override
  String get mistakes => 'Mistakes';

  @override
  String questionsCount(int answered, int total) {
    final intl.NumberFormat answeredNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String answeredString = answeredNumberFormat.format(answered);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return '$answeredString / $totalString questions';
  }

  @override
  String get unitsTitle => 'Units';

  @override
  String get chaptersTitle => 'Chapters';

  @override
  String get lessonsTitle => 'Lessons';

  @override
  String unitsTitleFor(String subject) {
    return '$subject Units';
  }

  @override
  String chaptersTitleFor(String unit) {
    return '$unit Chapters';
  }

  @override
  String lessonsTitleFor(String chapter) {
    return '$chapter Lessons';
  }

  @override
  String get lecturesTitle => 'Lectures';

  @override
  String lecturesTitleFor(String subject) {
    return '$subject Lectures';
  }

  @override
  String get quizTypeNormal => 'Normal';

  @override
  String get quizTypeMidterm => 'Midterm';

  @override
  String get quizTypeFinal => 'Final';

  @override
  String get quizTypePractice => 'Practice';

  @override
  String get noSubjects => 'No subjects yet';

  @override
  String get noSubjectsMatch => 'No subjects match your search';

  @override
  String get noLectures => 'No lectures yet';

  @override
  String get nothingHere => 'Nothing here yet';

  @override
  String get subjectUnavailable => 'This subject isn\'t part of your course.';

  @override
  String get quizSetupComingSoon => 'Quiz setup is coming soon';
}
