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
  String get otpSuccessTitle => 'Successful';

  @override
  String get otpSuccessSubtitle => 'You have been authenticated';

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
}
