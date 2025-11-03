import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/data/services/api_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/controllers/verify_email_otp_provider.dart';
import 'package:task_manager/ui/screens/forgot_password_verify_otp_screen.dart';
import 'package:task_manager/ui/screens/sign_up_screen.dart';
import 'package:task_manager/ui/widgets/centered_progress_indicator.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

class ForgotPasswordVerifyEmailScreen extends StatefulWidget {
  const ForgotPasswordVerifyEmailScreen({super.key});

  @override
  State<ForgotPasswordVerifyEmailScreen> createState() =>
      _ForgotPasswordVerifyEmailScreenState();
}

class _ForgotPasswordVerifyEmailScreenState
    extends State<ForgotPasswordVerifyEmailScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final VerifyEmailOtpProvider _verifyEmailOtpProvider = VerifyEmailOtpProvider();
  bool _recoverVerifyInProgress = false;

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
                      'Your Email Address',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'A 6 digits OTP will be sent to your email address',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _emailTEController,
                      decoration: InputDecoration(hintText: 'Email'),
                    ),
                    const SizedBox(height: 16),
                    // FilledButton(
                    //   onPressed: _onTapNextButton,
                    //   child: Icon(Icons.arrow_circle_right_outlined),
                    // ),
                    Consumer<VerifyEmailOtpProvider>(
                      builder: (context, verifyEmailOtpProvider, _) {
                        return Visibility(
                          visible: verifyEmailOtpProvider.recoverVerifyEmailInProgress == false,
                          replacement: CenteredProgressIndicator(),
                          child: FilledButton(
                            onPressed: _onTapNextButton,
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
                                ..onTap = _onTapLoginButton,
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

  Future<void> _recoverVerifyEmail() async {
    final bool isSuccess = await _verifyEmailOtpProvider.recoverVerifyEmail(
      _emailTEController.text.trim(),
    );
    if (isSuccess) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ForgotPasswordVerifyOtpScreen(email:_emailTEController.text)),
      );
    } else {
      showSnackBarMessage(context, _verifyEmailOtpProvider.errorMessage!);
    }

  }

  void _onTapLoginButton() {
    Navigator.pop(context);
  }

  void _onTapNextButton() {
    _recoverVerifyEmail();
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    super.dispose();
  }
}
