//import 'dart:convert';
//import 'dart:typed_data';

import 'package:flutter/material.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/data/models/user_model.dart';
//import 'package:task_manager/data/services/api_caller.dart';
//import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/controllers/auth_controller.dart';
import 'package:task_manager/ui/controllers/update_profile_provider.dart';
import 'package:task_manager/ui/widgets/centered_progress_indicator.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';
import 'package:task_manager/ui/widgets/tm_app_bar.dart';

import '../widgets/photo_picker_field.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  static const String name = '/update-profile';

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final UpdateProfileProvider _updateProfileProvider = UpdateProfileProvider();

  @override
  void initState() {
    super.initState();
    _updateProfileProvider.getUserProfileDetails();
    UserModel user = AuthController.userModel!;

    _emailTEController.text = user.email;
    _firstNameTEController.text = user.firstName;
    _lastNameTEController.text = user.lastName;
    _mobileTEController.text = user.mobile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(fromUpdateProfile: true),
      body: ChangeNotifierProvider(
        create: (_) => _updateProfileProvider,
        child: ScreenBackground(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    Text('Update Profile', style: TextTheme.of(context).titleLarge),
                    const SizedBox(height: 24),
                    Consumer<UpdateProfileProvider>(
                      builder: (context, updateProfileProvider, _) {
                        return PhotoPickerField(onTap: _pickImage, selectedPhoto: updateProfileProvider.selectedImage);
                      },
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _emailTEController,
                      decoration: InputDecoration(hintText: 'Email'),
                      enabled: false,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _firstNameTEController,
                      decoration: InputDecoration(hintText: 'First name'),
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return 'Enter your first name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _lastNameTEController,
                      decoration: InputDecoration(hintText: 'Last name'),
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return 'Enter your last name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _mobileTEController,
                      decoration: InputDecoration(hintText: 'Mobile'),
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return 'Enter your mobile number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _passwordTEController,
                      obscureText: true,
                      decoration: InputDecoration(hintText: 'Password (Optional)'),
                      validator: (String? value) {
                        if ((value != null && value.isNotEmpty) && value.length < 6) {
                          return 'Enter a password more than 6 letters';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Consumer<UpdateProfileProvider>(
                      builder: (context, updateProfileProvider, _) {
                        return Visibility(
                          visible: updateProfileProvider.updateProfileInProgress == false,
                          replacement: CenteredProgressIndicator(),
                          child: FilledButton(onPressed: _onTapUpdateButton, child: Icon(Icons.arrow_circle_right_outlined)),
                        );
                      },
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

  void _onTapUpdateButton() {
    if (_formKey.currentState!.validate()) {
      _updateProfile();
    }
  }

  Future<void> _updateProfile() async {
    final bool isSuccess = await _updateProfileProvider.updateProfile(
      _emailTEController.text.trim(),
      _firstNameTEController.text.trim(),
      _lastNameTEController.text.trim(),
      _mobileTEController.text.trim(),
      _passwordTEController.text,
    );
    if (isSuccess) {
      _passwordTEController.clear();
      showSnackBarMessage(context, 'Profile has been updated.');
    } else {
      showSnackBarMessage(context, _updateProfileProvider.errorMessage!);
    }
  }

  Future<void> _pickImage() async {
    await _updateProfileProvider.profilePickImage();
  }

  // Future<void> _pickImage() async {
  //   XFile? pickedImage = await _imagePicker.pickImage(source: ImageSource.gallery);
  //   if (pickedImage != null) {
  //     _selectedImage = pickedImage;
  //     setState(() {});
  //   }
  // }

  @override
  void dispose() {
    _emailTEController.dispose();
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _mobileTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}
