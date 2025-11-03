import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/data/services/api_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/controllers/verify_email_otp_provider.dart';
import 'package:task_manager/ui/screens/login_screen.dart';
import 'package:task_manager/ui/widgets/centered_progress_indicator.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key, required this.email, required this.otp});
  final String email;
  final String otp;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _confirmPasswordTEController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final VerifyEmailOtpProvider _verifyEmailOtpProvider = VerifyEmailOtpProvider();
  bool _recoverResetPasswordInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (_) => _verifyEmailOtpProvider,
        child: ScreenBackground(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 82),
                    Text(
                      'Reset Password',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Password should be more than 6 letters and combination of numbers',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _passwordTEController,
                      decoration: InputDecoration(hintText: 'New Password'),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _confirmPasswordTEController,
                      decoration: InputDecoration(
                        hintText: 'Confirm New Password',
                      ),
                    ),
                    const SizedBox(height: 16),
                    // FilledButton(
                    //   onPressed: _onTapResetPasswordButton,
                    //   child: Icon(Icons.arrow_circle_right_outlined),
                    // ),
                    Consumer<VerifyEmailOtpProvider>(
                      builder: (context, verifyEmailOtpProvider, _) {
                        return Visibility(
                          visible: verifyEmailOtpProvider.recoverResetPasswordInProgress == false,
                          replacement: CenteredProgressIndicator(),
                          child: FilledButton(
                            onPressed: _onTapResetPasswordButton,
                            child: Icon(Icons.arrow_circle_right_outlined),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 36),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                          text: "Already have an account? ",
                          children: [
                            TextSpan(
                              text: 'Login',
                              style: TextStyle(color: Colors.green),
                              recognizer: TapGestureRecognizer()
                                ..onTap = _onTapSignUpButton,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTapSignUpButton() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (predicate) => false,
    );
  }

  Future<void> _recoverResetPassword2() async {
    _recoverResetPasswordInProgress = true;
    setState(() {});
    Map<String, dynamic> requestBody = {
      "email": widget.email.trim(),
      "OTP": widget.otp.trim(),
      "password": _passwordTEController.text,
    };
    final ApiResponse response = await ApiCaller.postRequest(
      url: Urls.recoverResetPasswordUrl,
      body: requestBody,
    );
    _recoverResetPasswordInProgress = false;
    setState(() {});

    if (response.isSuccess) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
            (predicate) => false,
      );
    } else {
      showSnackBarMessage(context, response.errorMessage!);
    }
  }

  Future<void> _recoverResetPassword() async {
    final bool isSuccess = await _verifyEmailOtpProvider.recoverResetPassword(
      widget.email.trim(),
      widget.otp.trim(),
      _passwordTEController.text,
    );
    if (isSuccess) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
            (predicate) => false,
      );
    } else {
      showSnackBarMessage(context, _verifyEmailOtpProvider.errorMessage!);
    }

  }

  void _onTapResetPasswordButton() {
    _recoverResetPassword();
  }

  @override
  void dispose() {
    _passwordTEController.dispose();
    _confirmPasswordTEController.dispose();
    super.dispose();
  }
}
