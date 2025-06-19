import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/firebase_options.dart';
import 'package:todo_list/home_page.dart';

import 'package:todo_list/sign_in.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        datePickerTheme: const DatePickerThemeData(
          dayStyle: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,fontFamily: "Roboto"),
          weekdayStyle: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,fontFamily: "Roboto"),
          yearStyle: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,fontFamily: "Roboto")
        ),
    
        colorScheme: const ColorScheme.dark(),

  
    
        textTheme: const TextTheme(
    
          bodyLarge: TextStyle(
            fontFamily: "Roboto",
            fontSize: 32,
            fontWeight: FontWeight.bold
          ),
    
          bodyMedium: TextStyle(
            fontFamily: "Roboto",
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),
    
          bodySmall: TextStyle(
            fontFamily: "Roboto",
            fontWeight: FontWeight.bold,
            fontSize: 14
          ),
    
           titleLarge: TextStyle(
            fontFamily: "Roboto",
            fontWeight: FontWeight.bold,
            fontSize: 28
          )
    
        ),
    
        useMaterial3: true,
        
      ),
      debugShowCheckedModeBanner: false,
    
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(),);
          }

          if(snapshot.hasData){
            return const HomePage();
          }
          else{
          return const SignInPage();
          }
        }
      ),
    );

    
  }
}