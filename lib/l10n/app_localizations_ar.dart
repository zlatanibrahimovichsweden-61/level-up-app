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
  String get otpSuccessTitle => 'تم بنجاح';

  @override
  String get otpSuccessSubtitle => 'تم تسجيل دخولك بنجاح';

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
}
