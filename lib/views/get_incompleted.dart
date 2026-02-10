import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shaheer_apis/views/update_task.dart';

import '../models/taskListing.dart';
import '../provider/user_token_provider.dart';
import '../services/task.dart';

class GetInCompletedTaskView extends StatefulWidget {
  const GetInCompletedTaskView({super.key});

  @override
  State<GetInCompletedTaskView> createState() => _GetInCompletedTaskViewState();
}

class _GetInCompletedTaskViewState extends State<GetInCompletedTaskView> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Get InCompleted Task"),

      ),
      body:FutureProvider.value(
        value: TaskServices().getInCompletedTask(userProvider.getToken().toString()),
        initialData: TaskListingModel(),
        builder: (context, child) {
          TaskListingModel taskListingModel = context.watch<TaskListingModel>();
          return taskListingModel.tasks == null
              ? Center(
            child: CircularProgressIndicator(),
          )
              : ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: Icon(Icons.task),
                title: Text(taskListingModel.tasks![index].description.toString()),
                trailing: Row(mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(onPressed: ()async{
                      try{
                        await TaskServices().deleteTask(
                            token: userProvider.getToken().toString(),
                            taskID: taskListingModel.tasks![index].id.toString())
                            .then((val){
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text("Delete Successfully")));
                        });
                      }catch(e){
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(e.toString())));
                      }
                    }, icon: Icon(Icons.delete)),
                    IconButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> UpdateTaskView(model: taskListingModel.tasks![index])));
                    }, icon: Icon(Icons.edit))
                  ],),
              );
            },);

        },
      ),

    );
  }
}