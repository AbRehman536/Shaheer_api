import 'package:flutter/material.dart';
import 'package:shaheer_apis/provider/user_token_provider.dart';
import 'package:shaheer_apis/services/auth.dart';
import 'package:shaheer_apis/views/get_all_task.dart';
import 'package:shaheer_apis/views/register.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  get Provider => null;

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Column(
        children: [
          TextField(controller: emailController,),
          TextField(controller: passwordController,),
          isLoading ? Center(child: CircularProgressIndicator(),)
              :ElevatedButton(onPressed: ()async{
                try{
                  isLoading = true;
                setState(() {});
                  await AuthServices().loginUser(
                      email: emailController.text,
                      password: passwordController.text)
                      .then((value)async{
                        userProvider.setToken(value.token!);
                        await AuthServices().getProfile(value.token!)
                            .then((val){
                          userProvider.setUser(val);
                          isLoading = false;
                          setState(() {});
                          showDialog(context: context, builder: (BuildContext context) {
                            return AlertDialog(
                              content: Text("Login Successfully"),
                              actions: [
                                TextButton(onPressed: (){
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> GetAllTaskView()));
                                }, child: Text("Okay"))
                              ],
                            );
                          }, );
                  });
                  });
                }catch(e){
                  isLoading = false;
                  setState(() {});
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(e.toString())));

                }
          }, child: Text("Login")),
          ElevatedButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> Register()));
          }, child: Text("Register"))
        ],
      ),
    );
  }
}
