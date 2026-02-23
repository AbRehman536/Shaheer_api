import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shaheer_apis/views/create_task.dart';
import 'package:shaheer_apis/views/filter_task.dart';
import 'package:shaheer_apis/views/get_completed.dart';
import 'package:shaheer_apis/views/get_incompleted.dart';
import 'package:shaheer_apis/views/search_task.dart';
import 'package:shaheer_apis/views/update_task.dart';

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
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> GetCompletedTaskView()));
          }, icon: Icon(Icons.circle)),
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> GetInCompletedTaskView()));
          }, icon: Icon(Icons.incomplete_circle)),
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> SearchTask()));
          }, icon: Icon(Icons.search)),
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> FilterTask()));
          }, icon: Icon(Icons.filter)),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> CreateTaskView()));
        
      },child: Icon(Icons.add),),
      body:FutureProvider.value(
          value: TaskServices().getAllTask(userProvider.getToken().toString()),
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
                  Checkbox(
                      value: taskListingModel.tasks![index].complete,
                      onChanged: taskListingModel.tasks![index].complete == true 
                          ? null 
                          :(value)async{
                        try{
                          setState(() {
                            isLoading = true;
                          });
                          await TaskServices().markTaskAsCompleted(
                              token: userProvider.getToken().toString(),
                              taskID: taskListingModel.tasks![index].id.toString())
                          .then((val){
                            setState(() {
                              isLoading = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Task Completed"))
                            );
                          });
                        }catch(e){
                          setState(() {
                            isLoading= false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString()))
                          );
                        }
                      }
                  ),
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
                  }, icon: Icon(Icons.edit)),
                ],),
              );
            },);

          },
        ),

    );
  }
}