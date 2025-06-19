import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/home_page.dart';

import 'package:todo_list/sign_in.dart';

class LoginPage extends StatefulWidget {
  static route() => MaterialPageRoute(
    builder: (context) => const LoginPage(),
  );
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();

  Future<void> getUserLogedIn() async{
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailcontroller.text.trim(), 
        password: passwordcontroller.text.trim());
      if(context.mounted){
        Navigator.pushAndRemoveUntil(
          context,
          HomePage.route(),
          (route) => false,
        
        );
      }
    }
    on FirebaseAuthException catch(e){
      
      if(context.mounted){
        showAdaptiveDialog(context: context,
       builder: (context){
          return AlertDialog.adaptive(
            icon: const Icon(Icons.warning),
            title: Text(e.message.toString()),
            actions: [
              TextButton(onPressed: (){
                  Navigator.of(context).pop();
              }, child: const Text("ok"))
            ],
          );
       }
       );
      }
    }
  }

  @override
  Widget build(BuildContext context) {

  
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
          
            children: [
              const Spacer(),
               Center(
                 child: Text("Sign In ",
                 style: Theme.of(context).textTheme.bodyLarge,),
               ),

               const SizedBox(height: 15,),
          
               TextField(
                controller: emailcontroller,
                style: Theme.of(context).textTheme.bodyMedium,
                
                decoration: InputDecoration(
                  focusColor: Colors.black,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 30,vertical: 20),
                  hintText: "Enter your email",
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  )
                )
               ),

              const SizedBox(height: 20),

               TextField(
                controller: passwordcontroller,
                style: Theme.of(context).textTheme.bodyMedium,
                obscureText: true,
                
                decoration: InputDecoration(
                
                  focusColor: Colors.black,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 30,vertical: 20),
                  hintText: "Enter your password",
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  )
                )
               ),

              const SizedBox(height: 20),

              GestureDetector(
                onTap: (){
                  Navigator.push(context, SignInPage.route());
                },
                child: RichText(text:
                TextSpan(text: "Don't have a account ? ",
                style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.normal),
                children: [
                  TextSpan(text: "Sign Up",
                  style: Theme.of(context).textTheme.bodySmall)
                ] ),
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton(onPressed: ()async{
                await getUserLogedIn();
              },
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.primary),
                
              ),
              child: Text("Sign In",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.black),)
              ),

               const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
  }