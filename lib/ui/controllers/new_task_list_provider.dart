import 'package:flutter/foundation.dart';
import 'package:task_manager/data/models/task_status_count_model.dart';

import '../../data/models/task_model.dart';
import '../../data/services/api_caller.dart';
import '../../data/utils/urls.dart';

class NewTaskListProvider extends ChangeNotifier {
  bool _getNewTasksInProgress = false;
  bool _getTaskStatusCountInProgress = false;
  bool _addNewTaskInProgress = false;
  bool _changeStatusInProgress = false;
  bool _deleteInProgress = false;

  String? _taskId;
  String? _editTaskId;
  String? _errorMessage;

  List<TaskModel> _newTaskList = [];
  List<TaskStatusCountModel> _taskStatusCountList = [];

  bool get getNewTasksProgress => _getNewTasksInProgress;
  bool get getTaskStatusCountInProgress => _getTaskStatusCountInProgress;
  bool get addNewTaskInProgress => _addNewTaskInProgress;
  bool get changeStatusInProgress => _changeStatusInProgress;
  bool get deleteInProgress => _deleteInProgress;
  String? get taskId => _taskId;
  String? get editTaskId => _editTaskId;

  String? get errorMessage => _errorMessage;

  List<TaskModel> get newTaskList => _newTaskList;
  List<TaskStatusCountModel> get taskStatusCountList => _taskStatusCountList;

  Future<bool> getNewTasks() async {
    bool isSuccess = false;

    _getNewTasksInProgress = true;
    notifyListeners();

    final ApiResponse response = await ApiCaller.getRequest(
      url: Urls.newTaskListUrl,
    );
    if (response.isSuccess) {
      List<TaskModel> list = [];
      for (Map<String, dynamic> jsonData in response.responseData['data']) {
        list.add(TaskModel.fromJson(jsonData));
      }
      _newTaskList = list;
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }

    _getNewTasksInProgress = false;
    notifyListeners();

    return isSuccess;
  }

  Future<bool> getAllTaskStatusCount() async {
    bool isSuccess = false;
    _getTaskStatusCountInProgress = true;
    notifyListeners();

    final ApiResponse response = await ApiCaller.getRequest(
      url: Urls.taskStatusCountUrl,
    );
    if (response.isSuccess) {
      List<TaskStatusCountModel> list = [];
      for (Map<String, dynamic> jsonData in response.responseData['data']) {
        list.add(TaskStatusCountModel.fromJson(jsonData));
      }
      _taskStatusCountList = list;
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }
    _getTaskStatusCountInProgress = false;
    notifyListeners();

    return isSuccess;
  }

  Future<bool> addNewTask(String title, String description) async {
    bool isSuccess = false;
    _addNewTaskInProgress = true;
    notifyListeners();

    Map<String, dynamic> requestBody = {
      "title": title,
      "description": description,
      "status": "New",
    };

    final ApiResponse response = await ApiCaller.postRequest(
      url: Urls.createTaskUrl,
      body: requestBody,
    );

    if (response.isSuccess) {
      isSuccess = true;
      _addNewTaskInProgress = false;
      notifyListeners();
      await getAllTaskStatusCount();
      await getNewTasks();
    } else {
      _errorMessage = response.errorMessage;
      _addNewTaskInProgress = false;
      notifyListeners();
    }
    //_addNewTaskInProgress = false;
    //notifyListeners();

    return isSuccess;
  }

  Future<bool> deleteTask(String taskId) async {
    bool isSuccess = false;
    _taskId = taskId;
    _deleteInProgress = true;
    notifyListeners();

    final ApiResponse response = await ApiCaller.getRequest(
      url: Urls.deleteTaskUrl(taskId),
    );

    if (response.isSuccess) {
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }
    _deleteInProgress = false;
    _taskId = null;
    notifyListeners();
    return isSuccess;
  }

  Future<bool> changeStatus(String taskId, String status) async {
    bool isSuccess = false;
    _changeStatusInProgress = true;
    _editTaskId = taskId;
    notifyListeners();

    final ApiResponse response = await ApiCaller.getRequest(
      url: Urls.updateTaskStatusUrl(taskId, status),
    );

    if (response.isSuccess) {
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }
    _changeStatusInProgress = false;
    _editTaskId = null;
    notifyListeners();
    return isSuccess;
  }

}
