import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/login_page.dart';
import 'package:todo_list/widgets/add_task.dart';
import 'package:todo_list/widgets/tasks.dart';

class HomePage extends StatefulWidget {
  static route() => MaterialPageRoute(
    builder: (context) => const HomePage(),
  );
  const HomePage({super.key});


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var name = 'to do list';
  final taskController = TextEditingController();
  int selected = 0;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tasks"),
        centerTitle: true,
        leading: const Padding(
          padding:  EdgeInsets.all(8.0),
          child:  CircleAvatar(
            backgroundImage: AssetImage("assets/fonts/images/img1.jpg",
            ),
            
          ),
        ),
        actions: [
          IconButton(onPressed: () {
            showDialog(context: context,
            builder: (context){
              return AlertDialog(
                title: const Text("Are you sure you want to sign out ?"),
                actions: [
                  TextButton(onPressed: () async{
                    await FirebaseAuth.instance.signOut();
                    if (!context.mounted) return;
                    Navigator.pushAndRemoveUntil(context,
                     LoginPage.route(),
                     (route)=>false);
                  },
                  child: const Text("Yes",style: TextStyle(color: Colors.red),)),

                  TextButton(onPressed: (){
                  
                  Navigator.of(context).pop();
                  },
                  child: const Text("No",style: TextStyle(color: Colors.blue),))
                ],
              );
            });
          },
          icon: const Icon(Icons.power_settings_new))
        ],
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height*0.1,
            width: MediaQuery.of(context).size.width*0.9,
            child: Row(
              
              children: [
                Expanded(
                  child: ListView.builder(
                  
                    itemCount: 1,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context,index)
                  
                    {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selected = index;
                            
                          });
                        },
                        child: Chip(
                        label: const Text( "to do list",
                        style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: BorderSide(color: selected == index ? const Color.fromARGB(255, 227, 219, 219)
                          : const Color.fromARGB(255, 42, 41, 41))
                        ),
                        ),
                      ),
                    );
                    }
                  ),
                ),


                IconButton(onPressed: (){
                  showAdaptiveDialog(context: context, 
                  builder: (context){
                    return AlertDialog(
                      title: const Icon(Icons.note_add_sharp),
                      content: TextField(
                        controller: taskController,
                        style:const  TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
                        decoration: const InputDecoration(
                          hintText: 'Enter new list to add',
                          hintStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey
                          )
                        ),
                      ),
                      actions: [
                        TextButton(onPressed: (){
                          setState(() {
                          FirebaseFirestore.instance.collection('task_list').add({
                            'list':taskController.text,
                            'user':FirebaseAuth.instance.currentUser!.uid
                          });
                          Navigator.pop(context);
                          });
                        },
                        style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.primary)),
                        child: const Text("add",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.black)))
                      ],
                    );
                  }
                  );
                },
                style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 71, 70, 70))),
                icon: const Icon(Icons.add))
              ],
            ),
          ),

          StreamBuilder(
            stream: FirebaseFirestore.instance.collection('to_do').snapshots(),
            builder: (context,snapshot){

              if(!snapshot.hasData || snapshot.data!.docs.isEmpty){
                  return Column(
                    
                    children: [
                      Center(child: Image.asset('assets/fonts/images/img2.png')),
                      const SizedBox(height: 10,),
                      const Text("No tasks are added")
                    ],
                  );
              }
              
              return  const Tasks();
            }
            ),

          Padding(
            padding: const EdgeInsets.only(bottom: 20,right: 15),
            child: Align(
              alignment: Alignment.centerRight,
              child:
              
                FloatingActionButton(onPressed: (){
                Navigator.push(context,
                AddTask.route()
                );
                },
                child: const Icon(Icons.add)),
              
            ),
          )
        ]
      ),
    );
  }
}