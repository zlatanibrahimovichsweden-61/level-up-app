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
  String get rateLimited => 'Too many requests. Please try again shortly.';

  @override
  String rateLimitedIn(int seconds) {
    return 'Too many requests. Please try again in $seconds seconds.';
  }

  @override
  String get switchLanguage => 'العربية';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get loginSubtitle => 'Enter your phone number to continue';

  @override
  String get phoneLabel => 'Phone Number';

  @override
  String get phoneHint => '01X XXXX XXXX';

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
  String get legalSeparator => ', ';

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
  String resendTimer(String minutes, String seconds) {
    return '$minutes.$seconds';
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
  String get errorAccountBanned => 'Account banned — contact Support';

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
  String get cityNotListed => 'My city isn\'t listed';

  @override
  String get chooseFromList => 'Choose from the list';

  @override
  String get cityNameLabel => 'City name';

  @override
  String get schoolNotFound => 'I can\'t find my school';

  @override
  String get schoolSkipped => 'No school selected';

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
  String get mistakesTitle => 'Mistakes';

  @override
  String mistakeCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString mistakes',
      one: '1 mistake',
    );
    return '$_temp0';
  }

  @override
  String get noMistakes => 'No mistakes yet';

  @override
  String get mistakesEnrolmentPending =>
      'Your enrolment is being updated. Try again in a moment.';

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
  String get quizSetupTitle => 'Quiz Setup';

  @override
  String get selectQuizSize => 'Select Quiz Size';

  @override
  String quizSizeOption(int count) {
    return '$count Questions';
  }

  @override
  String get quizTitle => 'Quiz';

  @override
  String quizProgress(int position, int total) {
    return '$position/$total';
  }

  @override
  String questionLabel(int position) {
    return 'QUESTION $position';
  }

  @override
  String get confirm => 'Confirm';

  @override
  String get next => 'Next';

  @override
  String get finishQuiz => 'Finish';

  @override
  String get answerCorrect => 'Correct answer';

  @override
  String get answerWrong => 'Your answer, incorrect';

  @override
  String get correctAnswerRevealed => 'The correct answer';

  @override
  String get questionImage => 'Question image';

  @override
  String get aiExplanation => 'AI EXPLANATION';

  @override
  String get showExplanation => 'Show explanation';

  @override
  String get explanationGenerating => 'Generating your explanation…';

  @override
  String get explanationUnavailable =>
      'No explanation is available for this question.';

  @override
  String get exitQuizTitle => 'Leave this quiz?';

  @override
  String get exitQuizBody =>
      'Your answers so far are saved, but this quiz cannot be reopened.';

  @override
  String get exitQuizStay => 'Keep going';

  @override
  String get exitQuizLeave => 'Leave';

  @override
  String get quizCompleteTitle => 'Quiz Complete!';

  @override
  String get resultCorrect => 'Correct';

  @override
  String get resultWrong => 'Wrong';

  @override
  String get resultSkipped => 'Skipped';

  @override
  String get rewardsEarned => 'REWARDS EARNED';

  @override
  String pointsAwarded(int points) {
    return '+$points Points';
  }

  @override
  String pointsAwardedValue(int points) {
    return '+$points';
  }

  @override
  String get pointsAwardedUnit => 'Points';

  @override
  String quizResultSubtitle(String subject, String scope) {
    return '$subject — $scope';
  }

  @override
  String get reviewQuestions => 'Review Questions';

  @override
  String get backToLearn => 'Back to Learn';

  @override
  String get quizReviewTitle => 'Quiz Review';

  @override
  String quizReviewFilterAll(int count) {
    return 'All ($count)';
  }

  @override
  String quizReviewQuestionLabel(int number) {
    return 'QUESTION $number';
  }

  @override
  String get quizReviewEmpty => 'No questions to show here.';

  @override
  String get quizReviewAiAvailable => 'AI explanation available';

  @override
  String get freeUsageReachedTitle => 'Free Usage Reached';

  @override
  String get weeklyLimitBody =>
      'You\'ve used all your questions for this week.';

  @override
  String get subscriptionRequiredTitle => 'Subscription Required';

  @override
  String get subscriptionRequiredBody =>
      'This lesson needs an active subscription.';

  @override
  String get explanationSubscriptionRequired =>
      'AI explanations are available with a Level Up subscription. Subscribe to get step-by-step explanations and more learning features.';

  @override
  String get notNow => 'Not now';

  @override
  String get errorNotEnoughQuestions =>
      'This lesson doesn\'t have enough questions for that quiz size. Try a shorter quiz.';

  @override
  String get errorWeeklyQuestionLimitReached =>
      'You\'ve reached your free weekly question limit.';

  @override
  String get errorSubscriptionRequired =>
      'This content needs an active subscription.';

  @override
  String get errorQuizAlreadyFinished =>
      'This quiz has already been submitted.';

  @override
  String get errorInsufficientScope =>
      'This content isn\'t part of your course.';

  @override
  String get profileTitle => 'Profile';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get profilePointsLabel => 'Points';

  @override
  String get profileSettings => 'Settings';

  @override
  String get profileFavoriteQuestions => 'Favorite questions';

  @override
  String get profileYourProgress => 'Your progress';

  @override
  String get profileReferAFriend => 'Refer a Friend';

  @override
  String get profileCustomerSupport => 'Customer Support';

  @override
  String get profilePrivacyPolicy => 'Privacy & policy';

  @override
  String get profileTermsConditions => 'Terms & Conditions';

  @override
  String get profileGoToUniversity => 'Go to University';

  @override
  String get profileLogout => 'Logout';

  @override
  String get profileRowUnavailable => 'Not available yet';

  @override
  String get dialogClose => 'Close';

  @override
  String get logoutTitle => 'Logout';

  @override
  String get logoutBody => 'Are you sure you want to log out?';

  @override
  String get logoutNo => 'No';

  @override
  String get logoutYes => 'Yes';

  @override
  String get goToUniTitle => 'Go to Uni';

  @override
  String get goToUniBody =>
      'Are you sure you want to convert to the University track?';

  @override
  String get goToUniWarning => 'You can\'t go back again.';

  @override
  String get goToUniConfirm => 'Confirm';

  @override
  String get goToUniUnavailable => 'Switching tracks isn\'t available yet.';

  @override
  String get emailLabel => 'E-Mail';

  @override
  String get emailHint => 'you@example.com';

  @override
  String get emailClearHelp => 'Leave this empty to remove your email.';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get fieldLockedHint =>
      'Set when you registered — this can\'t be changed.';

  @override
  String get fixedAfterRegistration =>
      'These were set when you registered and can\'t be changed here.';

  @override
  String get changeAvatarTitle => 'Change your picture';

  @override
  String get chooseAvatarTitle => 'Choose Avatar';

  @override
  String get useAvatar => 'Use Avatar';

  @override
  String get uploadPhoto => 'Upload photo';

  @override
  String get uploadPhotoUnavailable =>
      'Uploading your own photo isn\'t available yet.';

  @override
  String get discardChangesTitle => 'Discard changes?';

  @override
  String get discardChangesBody => 'Your edits haven\'t been saved.';

  @override
  String get discardChangesStay => 'Keep editing';

  @override
  String get discardChangesLeave => 'Discard';

  @override
  String get settingsLanguages => 'Languages';

  @override
  String get settingsMode => 'Mode';

  @override
  String get settingsRank => 'Rank';

  @override
  String get settingsNotifications => 'Notification Preferences';

  @override
  String get languageArabicName => 'العربية';

  @override
  String get languageEnglishName => 'English';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get settingsLeaderboardVisible => 'Show me on the leaderboard';

  @override
  String get settingsLeaderboardVisibleHelp =>
      'Turn this off and you won\'t be listed at all.';

  @override
  String get settingsScoreHidden => 'Hide my points';

  @override
  String get settingsScoreHiddenHelp =>
      'You\'ll still be listed — without your score.';

  @override
  String get notifAnnouncements => 'Announcements';

  @override
  String get notifPromotions => 'Promotions';

  @override
  String get notifSupport => 'Support';

  @override
  String get notifSystem => 'System';

  @override
  String get settingsNotificationsUnavailable =>
      'Notification settings aren\'t available yet.';

  @override
  String get friendsTitle => 'Friends';

  @override
  String get friendsUnavailable => 'Friends aren\'t available yet.';

  @override
  String get referUnavailable => 'Inviting friends isn\'t available yet.';

  @override
  String get shareInvite => 'Share invite';

  @override
  String get supportUnavailable => 'Support isn\'t available yet.';

  @override
  String get createTicket => 'Create Ticket';

  @override
  String get legalNotPublished => 'This document hasn\'t been published yet.';

  @override
  String get leaderboardTitle => 'Leaderboard';

  @override
  String leaderboardPoints(int points) {
    final intl.NumberFormat pointsNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String pointsString = pointsNumberFormat.format(points);

    return '$pointsString pts';
  }

  @override
  String get leaderboardYou => 'You';

  @override
  String get leaderboardScopeSystem => 'System';

  @override
  String get leaderboardScopeGovernorate => 'Governorate';

  @override
  String get leaderboardScopeCohort => 'Cohort';

  @override
  String get leaderboardScopeGlobal => 'Global';

  @override
  String get leaderboardEmpty => 'This board doesn\'t have anyone on it yet.';

  @override
  String get leaderboardEndOfBoard => 'That\'s the end of the board.';

  @override
  String get leaderboardShare => 'Share';

  @override
  String get accountPendingDeletion =>
      'Your account is scheduled for deletion. Cancel the request to use Level Up again.';

  @override
  String get flashcardsTab => 'Flashcard';

  @override
  String get flashcardsTitle => 'Flash cards';

  @override
  String get flashcardSetupTitle => 'Flash Card Setup';

  @override
  String flashcardSetupCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString Flash Cards',
      one: '1 Flash Card',
    );
    return '$_temp0';
  }

  @override
  String get flashcardSetupHelper =>
      'this is available Flash cards for this quiz';

  @override
  String get flashcardGotIt => 'Got it';

  @override
  String get flashcardAgain => 'Again';

  @override
  String get flashcardPreviewUsedUp =>
      'You\'ve used this week\'s free flashcards.';

  @override
  String get notifFilterAll => 'All';

  @override
  String get notifModerationWarningTitle => 'A message about your account';

  @override
  String get notifModerationWarningBody =>
      'We received a report about content from your account that does not follow the Level Up community rules. This is a warning. Please keep your messages and photos respectful. If this happens again, your account may be banned. If you think this is a mistake, contact Support from the app.';

  @override
  String get supportCreateNewTicket => 'Create a New Ticket';

  @override
  String get supportDescribeYourIssue => 'Describe your issue';

  @override
  String get supportRecentTickets => 'Recent Tickets';

  @override
  String get supportNewTicketTitle => 'New Ticket';

  @override
  String get supportCreateTicketSubtitle =>
      'Describe your issue and we\'ll help you';

  @override
  String get supportSubjectLabel => 'Subject';

  @override
  String get supportDetailsLabel => 'Details';

  @override
  String get supportDetailsHint => 'Describe the issue in detail...';

  @override
  String get supportSubmitTicket => 'Submit Ticket';

  @override
  String get supportStatusClosed => 'Closed';

  @override
  String get supportComposerHint => 'Write your message';

  @override
  String supportTicketMeta(String reference, String date) {
    return '$reference · $date';
  }
}
