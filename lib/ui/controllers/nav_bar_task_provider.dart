//nav_bar_task_provider
import 'package:flutter/foundation.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/data/services/api_caller.dart';
import 'package:task_manager/data/utils/urls.dart';

class NavBarTaskProvider extends ChangeNotifier {
  String? _errorMessage;
  bool _getProgressTaskInProgress = false;
  bool _getCancelledTaskInProgress = false;
  bool _getCompletedTaskInProgress = false;

  List<TaskModel> _progressTaskList = [];
  List<TaskModel> _cancelledTaskList = [];
  List<TaskModel> _completedTaskList = [];

  String? get errorMessage => _errorMessage;
  bool get getProgressTaskInProgress => _getProgressTaskInProgress;
  bool get getCancelledTaskInProgress => _getCancelledTaskInProgress;
  bool get getCompletedTaskInProgress => _getCompletedTaskInProgress;
  List<TaskModel> get progressTaskList => _progressTaskList;
  List<TaskModel> get cancelledTaskList => _cancelledTaskList;
  List<TaskModel> get completedTaskList => _completedTaskList;

  Future<void> getAllProgressTasks() async {
    _getProgressTaskInProgress = true;
    notifyListeners();

    final ApiResponse response = await ApiCaller.getRequest(url: Urls.progressTaskListUrl);
    if (response.isSuccess) {
      List<TaskModel> list = [];
      for (Map<String, dynamic> jsonData in response.responseData['data']) {
        list.add(TaskModel.fromJson(jsonData));
      }
      _progressTaskList = list;

    } else {
      _errorMessage = response.errorMessage;
    }

    _getProgressTaskInProgress = false;
    notifyListeners();
  }

  Future<void> getAllCancelledTasks() async {
    _getCancelledTaskInProgress = true;
    notifyListeners();

    final ApiResponse response = await ApiCaller.getRequest(
      url: Urls.cancelledTaskListUrl,
    );
    if (response.isSuccess) {
      List<TaskModel> list = [];
      for (Map<String, dynamic> jsonData in response.responseData['data']) {
        list.add(TaskModel.fromJson(jsonData));
      }
      _cancelledTaskList = list;
    } else {
      _errorMessage = response.errorMessage;
    }
    _getCancelledTaskInProgress = false;
    notifyListeners();
  }

  Future<void> getAllCompletedTasks() async {
    _getCompletedTaskInProgress = true;
    notifyListeners();

    final ApiResponse response = await ApiCaller.getRequest(
      url: Urls.completedTaskListUrl,
    );
    if (response.isSuccess) {
      List<TaskModel> list = [];
      for (Map<String, dynamic> jsonData in response.responseData['data']) {
        list.add(TaskModel.fromJson(jsonData));
      }
      _completedTaskList = list;
    } else {
      _errorMessage = response.errorMessage;
    }
    _getCompletedTaskInProgress = false;
    notifyListeners();
  }

}
