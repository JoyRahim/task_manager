//verify_email_otp_provider
//RecoverVerifyEmail, RecoverVerifyOtp, RecoverResetPassword

import 'package:flutter/foundation.dart';
import 'package:task_manager/data/services/api_caller.dart';
import 'package:task_manager/data/utils/urls.dart';

class VerifyEmailOtpProvider extends ChangeNotifier {
  bool _verifyEmailOtpInProgress = false;
  bool _recoverVerifyEmailInProgress = false;
  bool _recoverVerifyOtpInProgress = false;
  bool _recoverResetPasswordInProgress = false;
  String? _errorMessage;

  bool get verifyEmailOtpInProgress => _verifyEmailOtpInProgress;
  bool get recoverVerifyEmailInProgress => _recoverVerifyEmailInProgress;
  bool get recoverVerifyOtpInProgress => _recoverVerifyOtpInProgress;
  bool get recoverResetPasswordInProgress => _recoverResetPasswordInProgress;
  String? get errorMessage => _errorMessage;

  Future<bool> recoverVerifyEmail(String email) async {
    bool isSuccess = false;
    _recoverVerifyEmailInProgress = true;
    notifyListeners();
    final ApiResponse response = await ApiCaller.getRequest(url: Urls.recoverVerifyEmailUrl(email));

    if (response.isSuccess && response.responseData['status'] == 'success') {
      _errorMessage = null;
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }
    _recoverVerifyEmailInProgress = false;
    notifyListeners();

    return isSuccess;
  }

  Future<bool> recoverVerifyOtp(String email, String otp) async {
    bool isSuccess = false;
    _recoverVerifyOtpInProgress = true;
    notifyListeners();
    final ApiResponse response = await ApiCaller.getRequest(url: Urls.recoverVerifyOtpUrl(email, otp));

    if (response.isSuccess && response.responseData['status'] == 'success') {
      _errorMessage = null;
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }
    _recoverVerifyOtpInProgress = false;
    notifyListeners();

    return isSuccess;
  }

  Future<bool> recoverResetPassword(String email, String otp, String password) async {
    bool isSuccess = false;
    _recoverResetPasswordInProgress = true;
    notifyListeners();

    Map<String, dynamic> requestBody = {
      "email": email,
      "OTP": otp,
      "password": password,
    };
    final ApiResponse response = await ApiCaller.postRequest(
      url: Urls.recoverResetPasswordUrl,
      body: requestBody,
    );

    if (response.isSuccess && response.responseData['status'] == 'success') {
      _errorMessage = null;
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }
    _recoverResetPasswordInProgress = false;
    notifyListeners();

    return isSuccess;
  }
}
