// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'ليفل أب';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get offline => 'أنت غير متصل بالإنترنت';

  @override
  String get genericError => 'حدث خطأ ما';

  @override
  String get rateLimited => 'طلبات كثيرة. حاول مرة أخرى بعد قليل.';

  @override
  String rateLimitedIn(int seconds) {
    return 'طلبات كثيرة. حاول مرة أخرى بعد $seconds ثانية.';
  }

  @override
  String get switchLanguage => 'English';

  @override
  String get welcomeBack => 'مرحبًا بعودتك';

  @override
  String get loginSubtitle => 'أدخل رقم هاتفك للمتابعة';

  @override
  String get phoneLabel => 'رقم الهاتف';

  @override
  String get phoneHint => '01021871999';

  @override
  String get sendOtp => 'إرسال رمز التحقق';

  @override
  String get orDivider => 'أو';

  @override
  String get createNewAccount => 'إنشاء حساب جديد';

  @override
  String get legalPrefix => 'بالمتابعة، فإنك توافق على';

  @override
  String get userAgreement => 'اتفاقية المستخدم';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get cookiePolicy => 'سياسة ملفات تعريف الارتباط';

  @override
  String get legalAnd => 'و';

  @override
  String get checkOtpTitle => 'التحقق من الرمز';

  @override
  String get otpSubtitle =>
      'لقد أرسلنا رمز التحقق إلى هاتفك. أدخل الرمز المكوّن من 6 أرقام.';

  @override
  String get verify => 'تحقّق';

  @override
  String get resendOtp => 'إعادة إرسال الرمز';

  @override
  String resendIn(int seconds) {
    return 'إعادة الإرسال خلال $seconds ث';
  }

  @override
  String get onboardingTitle => 'ليفل أب';

  @override
  String get onboardingTaglineAccent => 'رحلتك';

  @override
  String get onboardingTaglineRest => 'التعليمية';

  @override
  String get onboardingSubtitle =>
      'ذاكر. نافس. حقّق أهدافك.\nكل ذلك في مكان واحد.';

  @override
  String get getStarted => 'ابدأ الآن';

  @override
  String get logIn => 'تسجيل الدخول';

  @override
  String get otpSuccessTitle => 'تم بنجاح';

  @override
  String get otpSuccessSubtitle => 'تهانينا! تم تسجيل دخولك بنجاح';

  @override
  String get continueLabel => 'متابعة';

  @override
  String get sessionEndedSuperseded =>
      'تم تسجيل خروجك — تم استخدام حسابك على جهاز آخر.';

  @override
  String get sessionExpired =>
      'انتهت صلاحية جلستك. من فضلك سجّل الدخول مرة أخرى.';

  @override
  String get createAccountTitle => 'إنشاء حساب';

  @override
  String get createAccountSubtitle =>
      'انضم إلى آلاف الطلاب الذين يرتقون بمستواهم';

  @override
  String get fullNameLabel => 'الاسم الكامل';

  @override
  String get fullNameHint => 'اسمك الكامل';

  @override
  String get parentNumberLabel => 'رقم ولي الأمر';

  @override
  String get referralCodeOptional => 'رمز الإحالة (اختياري)';

  @override
  String get referralCodeHint => 'أدخل الرمز';

  @override
  String get chooseTrackTitle => 'اختر مسارك';

  @override
  String get chooseTrackSubtitle => 'هذا يحدّد المحتوى والاختبارات الخاصة بك';

  @override
  String get trackSchool => 'طالب مدرسة';

  @override
  String get trackUniversity => 'طالب جامعة';

  @override
  String get registrationExpired =>
      'انتهت صلاحية جلسة التسجيل. من فضلك ابدأ من جديد.';

  @override
  String get backToLogin => 'العودة لتسجيل الدخول';

  @override
  String get invalidName => 'من فضلك أدخل اسمك';

  @override
  String get invalidPhone => 'من فضلك أدخل رقم هاتف صحيح';

  @override
  String get errorOtpInvalid => 'الرمز غير صحيح، حاول مرة أخرى';

  @override
  String get errorOtpExpired => 'انتهت صلاحية هذا الرمز. اطلب رمزًا جديدًا.';

  @override
  String get errorOtpThrottled =>
      'محاولات كثيرة جدًا. انتظر لحظة ثم حاول مرة أخرى.';

  @override
  String get errorValidationFailed => 'من فضلك تحقق من بياناتك وحاول مرة أخرى.';

  @override
  String get schoolRegistrationTitle => 'تسجيل طلاب المدارس';

  @override
  String get schoolRegistrationSubtitle => 'أكمل بياناتك لتبدأ';

  @override
  String get universityRegistrationTitle => 'تسجيل طلاب الجامعات';

  @override
  String get universityRegistrationSubtitle => 'طلاب الجامعات في مصر';

  @override
  String get startLearning => 'ابدأ التعلّم';

  @override
  String get dobLabel => 'تاريخ الميلاد';

  @override
  String get dobHint => 'اختر تاريخ ميلادك';

  @override
  String get countryLabel => 'الدولة';

  @override
  String get governorateLabel => 'المحافظة';

  @override
  String get cityLabel => 'المدينة';

  @override
  String get educationSystemLabel => 'النظام التعليمي';

  @override
  String get stageLabel => 'الصف الدراسي';

  @override
  String get schoolLabel => 'اسم المدرسة';

  @override
  String get cityNotListed => 'مدينتي غير موجودة';

  @override
  String get chooseFromList => 'اختر من القائمة';

  @override
  String get cityNameLabel => 'اسم المدينة';

  @override
  String get schoolNotFound => 'لم أجد مدرستي';

  @override
  String get schoolSkipped => 'لم يتم اختيار مدرسة';

  @override
  String get universityLabel => 'اسم الجامعة';

  @override
  String get facultyLabel => 'الكلية';

  @override
  String get studyYearLabel => 'السنة الدراسية';

  @override
  String studyYearNumber(int number) {
    return 'السنة $number';
  }

  @override
  String get stagePrep1 => 'الصف الأول الإعدادي';

  @override
  String get stagePrep2 => 'الصف الثاني الإعدادي';

  @override
  String get stagePrep3 => 'الصف الثالث الإعدادي';

  @override
  String get stageSecondary1 => 'الصف الأول الثانوي';

  @override
  String get stageSecondary2 => 'الصف الثاني الثانوي';

  @override
  String get stageSecondary3 => 'الصف الثالث الثانوي';

  @override
  String get selectHint => 'اختر';

  @override
  String get noOptions => 'لا يوجد ما يمكن عرضه';

  @override
  String get searchSchoolsHint => 'ابحث عن مدرستك';

  @override
  String get noSchoolsFound => 'لا توجد مدارس مطابقة لبحثك';

  @override
  String get loadMore => 'عرض المزيد';

  @override
  String get selectCountryFirst => 'اختر الدولة أولًا';

  @override
  String get selectGovernorateFirst => 'اختر المحافظة أولًا';

  @override
  String get selectUniversityFirst => 'اختر الجامعة أولًا';

  @override
  String get selectFacultyFirst => 'اختر الكلية أولًا';

  @override
  String get fieldRequired => 'هذا الحقل مطلوب';

  @override
  String get fieldNotAllowed => 'هذا الحقل لا ينطبق على اختيارك';

  @override
  String get fieldRejected => 'من فضلك تحقق من هذا الحقل';

  @override
  String get phoneAlreadyRegistered =>
      'هذا الرقم لديه حساب بالفعل. من فضلك سجّل الدخول.';

  @override
  String get registrationTokenInvalid =>
      'انتهت صلاحية جلسة التسجيل. من فضلك ابدأ من جديد.';

  @override
  String get homeWelcome => 'أهلًا بعودتك،';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get currentLevel => 'المستوى الحالي';

  @override
  String levelLabel(int level) {
    return 'المستوى $level';
  }

  @override
  String get pointsBalance => 'رصيد النقاط';

  @override
  String levelProgress(int level) {
    return 'المستوى $level';
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
  String get dailyTasks => 'المهام اليومية';

  @override
  String get learningTools => 'أدوات التعلّم';

  @override
  String get continueLearning => 'أكمل التعلم';

  @override
  String get topStudent => 'الأوائل';

  @override
  String get seeAll => 'عرض الكل';

  @override
  String get comingSoon => 'قريبًا';

  @override
  String get learnTodayLeadTomorrow => 'تعلّم اليوم، تصدّر غدًا';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navLeaderboard => 'المتصدرون';

  @override
  String get navLearn => 'تعلّم';

  @override
  String get navMessage => 'الرسائل';

  @override
  String get navAccount => 'حسابي';

  @override
  String get subjectsTitle => 'المواد';

  @override
  String get searchSubjects => 'ابحث عن مادة';

  @override
  String get mistakes => 'أخطائي';

  @override
  String questionsCount(int answered, int total) {
    final intl.NumberFormat answeredNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String answeredString = answeredNumberFormat.format(answered);
    final intl.NumberFormat totalNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return '$answeredString / $totalString سؤال';
  }

  @override
  String get unitsTitle => 'الوحدات';

  @override
  String get chaptersTitle => 'الفصول';

  @override
  String get lessonsTitle => 'الدروس';

  @override
  String unitsTitleFor(String subject) {
    return 'وحدات $subject';
  }

  @override
  String chaptersTitleFor(String unit) {
    return 'فصول $unit';
  }

  @override
  String lessonsTitleFor(String chapter) {
    return 'دروس $chapter';
  }

  @override
  String get lecturesTitle => 'المحاضرات';

  @override
  String lecturesTitleFor(String subject) {
    return 'محاضرات $subject';
  }

  @override
  String get quizTypeNormal => 'عادي';

  @override
  String get quizTypeMidterm => 'منتصف الترم';

  @override
  String get quizTypeFinal => 'نهائي';

  @override
  String get quizTypePractice => 'عملي';

  @override
  String get noSubjects => 'لا توجد مواد بعد';

  @override
  String get noSubjectsMatch => 'لا توجد مواد مطابقة لبحثك';

  @override
  String get noLectures => 'لا توجد محاضرات بعد';

  @override
  String get nothingHere => 'لا يوجد شيء هنا بعد';

  @override
  String get subjectUnavailable => 'هذه المادة ليست ضمن مقررك.';

  @override
  String get quizSetupTitle => 'إعداد الاختبار';

  @override
  String get selectQuizSize => 'اختر عدد الأسئلة';

  @override
  String quizSizeOption(int count) {
    return '$count سؤال';
  }

  @override
  String get quizTitle => 'الاختبار';

  @override
  String quizProgress(int position, int total) {
    return '$position/$total';
  }

  @override
  String questionLabel(int position) {
    return 'السؤال $position';
  }

  @override
  String get confirm => 'تأكيد';

  @override
  String get next => 'التالي';

  @override
  String get finishQuiz => 'إنهاء';

  @override
  String get answerCorrect => 'إجابة صحيحة';

  @override
  String get answerWrong => 'إجابتك، غير صحيحة';

  @override
  String get correctAnswerRevealed => 'الإجابة الصحيحة';

  @override
  String get questionImage => 'صورة السؤال';

  @override
  String get aiExplanation => 'شرح الذكاء الاصطناعي';

  @override
  String get showExplanation => 'اعرض الشرح';

  @override
  String get explanationGenerating => 'جارٍ تجهيز الشرح…';

  @override
  String get explanationUnavailable => 'لا يوجد شرح متاح لهذا السؤال.';

  @override
  String get exitQuizTitle => 'هل تريد الخروج من الاختبار؟';

  @override
  String get exitQuizBody =>
      'إجاباتك حتى الآن محفوظة، لكن لا يمكن فتح هذا الاختبار مرة أخرى.';

  @override
  String get exitQuizStay => 'أكمل الاختبار';

  @override
  String get exitQuizLeave => 'خروج';

  @override
  String get quizCompleteTitle => 'أنهيت الاختبار!';

  @override
  String get resultCorrect => 'صحيحة';

  @override
  String get resultWrong => 'خاطئة';

  @override
  String get resultSkipped => 'متروكة';

  @override
  String get rewardsEarned => 'النقاط المكتسبة';

  @override
  String pointsAwarded(int points) {
    return '+$points نقطة';
  }

  @override
  String get resultLevelProgress => 'تقدّم المستوى';

  @override
  String levelAndPoints(int level, int points) {
    return 'المستوى $level · $points نقطة';
  }

  @override
  String get reviewQuestions => 'مراجعة الأسئلة';

  @override
  String get reviewQuestionsComingSoon => 'مراجعة إجاباتك قريبًا.';

  @override
  String get backToLearn => 'العودة إلى التعلّم';

  @override
  String get freeUsageReachedTitle => 'انتهت أسئلتك المجانية';

  @override
  String get weeklyLimitBody =>
      'استخدمت كل أسئلتك المجانية لهذا الأسبوع. اشترك للحصول على تدريب بلا حدود.';

  @override
  String get subscriptionRequiredTitle => 'الاشتراك مطلوب';

  @override
  String get subscriptionRequiredBody =>
      'هذا الدرس ضمن الخطة المدفوعة. اشترك لتبدأ التدريب.';

  @override
  String get benefitUnlimitedQuestions => 'أسئلة بلا حدود';

  @override
  String get benefitAiExplanations => 'شرح بالذكاء الاصطناعي';

  @override
  String get benefitPrioritySupport => 'دعم ذو أولوية';

  @override
  String get benefitNoAds => 'إزالة كل الإعلانات';

  @override
  String get upgradeCta => 'اشترك الآن';

  @override
  String get notNow => 'ليس الآن';

  @override
  String get errorNotEnoughQuestions =>
      'لا يحتوي هذا الدرس على أسئلة كافية لهذا العدد. جرّب اختبارًا أقصر.';

  @override
  String get errorWeeklyQuestionLimitReached =>
      'وصلت إلى حدّ الأسئلة المجانية الأسبوعي.';

  @override
  String get errorSubscriptionRequired => 'هذا المحتوى يحتاج إلى اشتراك فعّال.';

  @override
  String get errorQuizAlreadyFinished => 'تم تسليم هذا الاختبار بالفعل.';

  @override
  String get errorInsufficientScope => 'هذا المحتوى ليس ضمن مقررك.';

  @override
  String get profileTitle => 'الملف الشخصي';

  @override
  String get editProfile => 'تعديل الملف الشخصي';

  @override
  String get profilePointsLabel => 'النقاط';

  @override
  String get profileSettings => 'الإعدادات';

  @override
  String get profileFavoriteQuestions => 'الأسئلة المفضّلة';

  @override
  String get profileYourProgress => 'تقدّمك';

  @override
  String get profileReferAFriend => 'دعوة صديق';

  @override
  String get profileCustomerSupport => 'دعم العملاء';

  @override
  String get profileSubscription => 'الاشتراك';

  @override
  String get profilePrivacyPolicy => 'سياسة الخصوصية';

  @override
  String get profileTermsConditions => 'الشروط والأحكام';

  @override
  String get profileGoToUniversity => 'التحويل إلى الجامعة';

  @override
  String get profileLogout => 'تسجيل الخروج';

  @override
  String get profileRowUnavailable => 'غير متاح بعد';

  @override
  String get dialogClose => 'إغلاق';

  @override
  String get logoutTitle => 'تسجيل الخروج';

  @override
  String get logoutBody => 'هل أنت متأكد أنك تريد تسجيل الخروج؟';

  @override
  String get logoutConfirm => 'تسجيل الخروج';

  @override
  String get goToUniTitle => 'التحويل إلى الجامعة';

  @override
  String get goToUniBody => 'هل أنت متأكد أنك تريد التحويل إلى مسار الجامعة؟';

  @override
  String get goToUniWarning => 'لا يمكنك الرجوع مرة أخرى.';

  @override
  String get goToUniConfirm => 'تأكيد';

  @override
  String get goToUniUnavailable => 'تغيير المسار غير متاح بعد.';

  @override
  String get emailLabel => 'البريد الإلكتروني';

  @override
  String get emailHint => 'you@example.com';

  @override
  String get emailClearHelp => 'اترك هذا الحقل فارغًا لحذف بريدك الإلكتروني.';

  @override
  String get saveChanges => 'حفظ التغييرات';

  @override
  String get fieldLockedHint => 'تم تحديده عند التسجيل ولا يمكن تغييره.';

  @override
  String get fixedAfterRegistration =>
      'تم تحديد هذه البيانات عند التسجيل ولا يمكن تغييرها من هنا.';

  @override
  String get changeAvatarTitle => 'تغيير صورتك';

  @override
  String get chooseAvatarTitle => 'اختر صورة رمزية';

  @override
  String get useAvatar => 'اختيار صورة رمزية';

  @override
  String get uploadPhoto => 'رفع صورة';

  @override
  String get uploadPhotoUnavailable => 'رفع صورتك الشخصية غير متاح بعد.';

  @override
  String get discardChangesTitle => 'تجاهل التغييرات؟';

  @override
  String get discardChangesBody => 'لم يتم حفظ تعديلاتك.';

  @override
  String get discardChangesStay => 'متابعة التعديل';

  @override
  String get discardChangesLeave => 'تجاهل';
}
