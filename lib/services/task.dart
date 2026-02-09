import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/task.dart';
import '../models/taskListing.dart';

class TaskServices {
  String baseURL = "https://todo-nu-plum-19.vercel.app";

  ///Create Task
  Future<TaskModel> createTask(
      {required String token, required String description}) async {
    try {
      http.Response response = await http.post(Uri.parse('$baseURL/todos/add'),
          headers: {'Content-Type': 'application/json', 'Authorization': token},
          body: jsonEncode({"description": description}));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return TaskModel.fromJson(jsonDecode(response.body));
      } else {
        throw response.reasonPhrase.toString();
      }
    } catch (e) {
      throw e.toString();
    }
  }

  ///Get All Task
  Future<TaskListingModel> getAllTask(String token) async {
    try {
      http.Response response = await http.get(Uri.parse('$baseURL/todos/get'),
          headers: {'Authorization': token});

      if (response.statusCode == 200 || response.statusCode == 201) {
        return TaskListingModel.fromJson(jsonDecode(response.body));
      } else {
        throw response.reasonPhrase.toString();
      }
    } catch (e) {
      throw e.toString();
    }
  }

  ///Get Completed Task
  Future<TaskListingModel> getCompletedTask(String token) async {
    try {
      http.Response response = await http.get(
          Uri.parse('$baseURL/todos/completed'),
          headers: {'Authorization': token});

      if (response.statusCode == 200 || response.statusCode == 201) {
        return TaskListingModel.fromJson(jsonDecode(response.body));
      } else {
        throw response.reasonPhrase.toString();
      }
    } catch (e) {
      throw e.toString();
    }
  }

  ///Get InCompleted Task

  Future<TaskListingModel> getInCompletedTask(String token) async {
    try {
      http.Response response = await http.get(
          Uri.parse('$baseURL/todos/incomplete'),
          headers: {'Authorization': token});

      if (response.statusCode == 200 || response.statusCode == 201) {
        return TaskListingModel.fromJson(jsonDecode(response.body));
      } else {
        throw response.reasonPhrase.toString();
      }
    } catch (e) {
      throw e.toString();
    }
  }

  ///Search Task
  Future<TaskListingModel> searchTask(
      {required String token, required String searchTask}) async {
    try {
      http.Response response = await http.get(
          Uri.parse('$baseURL/todos/search?keywords=$searchTask'),
          headers: {'Authorization': token});

      if (response.statusCode == 200 || response.statusCode == 201) {
        return TaskListingModel.fromJson(jsonDecode(response.body));
      } else {
        throw response.reasonPhrase.toString();
      }
    } catch (e) {
      throw e.toString();
    }
  }

  ///Filter Task
  Future<TaskListingModel> filterTask(
      {required String token,
        required String startDate,
        required String endDate}) async {
    try {
      http.Response response = await http.get(
          Uri.parse(
              '$baseURL/todos/filter?startDate=$startDate&endDate=$endDate'),
          headers: {'Authorization': token});

      if (response.statusCode == 200 || response.statusCode == 201) {
        return TaskListingModel.fromJson(jsonDecode(response.body));
      } else {
        throw response.reasonPhrase.toString();
      }
    } catch (e) {
      throw e.toString();
    }
  }


  ///Delete Task
  Future<bool> deleteTask(
      {required String token, required String taskID}) async {
    try {
      http.Response response = await http.delete(
          Uri.parse('$baseURL/todos/delete/$taskID'),
          headers: {'Authorization': token});

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        throw response.reasonPhrase.toString();
      }
    } catch (e) {
      throw e.toString();
    }
  }


  ///Update Task
  Future<bool> updateTask(
      {required String token,
        required String taskID,
        required String description}) async {
    try {
      http.Response response = await http.patch(
          Uri.parse('$baseURL/todos/update/$taskID'),
          headers: {'Authorization': token, 'Content-Type': 'application/json'},
          body: jsonEncode({'description': description}));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        throw response.reasonPhrase.toString();
      }
    } catch (e) {
      throw e.toString();
    }
  }
  ///Mark Task as Completed
  Future<bool> markTaskAsCompleted({
    required String token,
    required String taskID,
  }) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseURL/todos/complete/$taskID'),
        headers: {
          'Authorization': token,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "complete": true,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw response.body; // show backend error
      }
    } catch (e) {
      throw e.toString();
    }
  }


}