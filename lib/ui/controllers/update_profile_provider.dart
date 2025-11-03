//update_profile_provider
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager/data/models/user_model.dart';
import 'package:task_manager/data/services/api_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/controllers/auth_controller.dart';

class UpdateProfileProvider extends ChangeNotifier {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _selectedImage;
  bool _updateProfileInProgress = false;
  bool _getProfileDetailsInProgress = false;
  String? _errorMessage;

  bool get updateProfileInProgress => _updateProfileInProgress;
  bool get getProfileDetailsInProgress => _getProfileDetailsInProgress;
  XFile? get selectedImage => _selectedImage;
  String? get errorMessage => _errorMessage;

  Future<bool> updateProfile(
    String email,
    String firstName,
    String lastName,
    String mobile,
    String password,
    //XFile? selectedImage,
  ) async {
    bool isSuccess = false;
    _updateProfileInProgress = true;
    notifyListeners();

    final Map<String, dynamic> requestBody = {"email": email, "firstName": firstName, "lastName": lastName, "mobile": mobile};

    if (password.isNotEmpty) {
      requestBody['password'] = password;
    }

    String? encodedPhoto;
    if (_selectedImage != null) {
      List<int> bytes = await _selectedImage!.readAsBytes();
      encodedPhoto = jsonEncode(bytes);
      requestBody['photo'] = encodedPhoto;
    }

    final ApiResponse response = await ApiCaller.postRequest(url: Urls.updateProfileUrl, body: requestBody);

    if (response.isSuccess && response.responseData['status'] == 'success') {

      UserModel model = UserModel(
        id: AuthController.userModel!.id,
        email: email,
        firstName: firstName,
        lastName: lastName,
        mobile: mobile,
        photo: encodedPhoto ?? AuthController.userModel!.photo,
      );
      await AuthController.updateUserData(model);
      _errorMessage = null;
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }
    _updateProfileInProgress = false;
    notifyListeners();

    return isSuccess;
  }

  Future<void> profilePickImage() async {
    XFile? pickedImage = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      _selectedImage = pickedImage;
      notifyListeners();
    }
  }

  Future<void> getUserProfileDetails() async {
    _getProfileDetailsInProgress = true;
    notifyListeners();
    final ApiResponse response = await ApiCaller.getRequest(
      url: Urls.profileDetailsUrl,
    );
    if (response.isSuccess && response.responseData['status'] == 'success') {
      List<UserModel> userModelList = [];
      for (Map<String, dynamic> jsonData in response.responseData['data']) {
        userModelList.add(UserModel.fromJson(jsonData));
      }
      await AuthController.updateUserData(userModelList[0]);
      _errorMessage = null;
    } else {
      _errorMessage = response.errorMessage;
    }
    _getProfileDetailsInProgress = false;
    notifyListeners();
  }

}
