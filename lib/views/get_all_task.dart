import 'package:flutter/material.dart';

import '../models/taskListing.dart';
import '../provider/user_token_provider.dart';
import '../services/task.dart';

class GetAllTaskView extends StatefulWidget {
  const GetAllTaskView({super.key});

  @override
  State<GetAllTaskView> createState() => _GetAllTaskViewState();
}

class _GetAllTaskViewState extends State<GetAllTaskView> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Get All Task"),

      ),
      body:FutureProvider.value(
          value: TaskServices().getAllTask(userProvider.getToken().toString()),
          initialData: TaskListingModel(),
          builder: (context, child) {
            TaskListingModel taskListingModel = context.watch<TaskListingModel>(context);
            return taskListingModel.tasks == null
                ? Center(
              child: CircularProgressIndicator(),
            )
                : ListView.builder(
              itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: Icon(Icons.task),
                title: Text(taskListingModel.tasks![index].description.toString()),
              );
            },);

          },
        ),

    );
  }
}