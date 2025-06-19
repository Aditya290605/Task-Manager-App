import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';


class AddTask extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context)=>const AddTask());
 
  const AddTask({super.key,
  });

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  DateTime todate = DateTime.now();
  Color? selectedColor;

  final titleController = TextEditingController();
  final descriptioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        
        title: Text("Add Task",
        style: Theme.of(context).textTheme.titleLarge,),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: titleController,
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                  hintText: "Enter title *",
                  hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.normal),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(25))
                ),
              ),

              const SizedBox(height: 10,),
        
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(   
                    maxLines: 5,
                    minLines: 1,
                    controller: descriptioController,
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                    hintText: "Enter description *",
                    hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.normal),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(25))
                                  ),
                                ),
                  ),
              
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 20),
                    child: Column(
                      children: [
                        Text("${todate.day}/${todate.month}/${todate.year}"),
                    
                        TextButton(onPressed: () async{
                          DateTime? current = await showDatePicker(context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2001),
                          lastDate: DateTime(2026)
                          );
        
                          if(current!=null){
                            setState(() {
                              todate = current;
                            });
                          }
                        }, 
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.primary)
                        ),
                        child: Text("Choose date",
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.black),
                        ),
                        )
                      ],
                    ),
                  )       
                ],
              ),
        
               Padding(
                padding:  const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text("Choose color",
                style: Theme.of(context).textTheme.bodyMedium,),
              ),
        
              ColorPicker(
              pickersEnabled: const {
                ColorPickerType.wheel:true
              },
              onColorChanged: (Color? color){
                setState(() {
                  selectedColor = color;
                }
                );
              },
              title: const Text("Choose color",
              style: TextStyle(fontSize: 16),),
              subheading: const Text("Choose shades"
              ,style:TextStyle(fontSize: 16),
              )
              ,
              ),
        
              Center(
                child: TextButton(onPressed: (){
                  try {
                      FirebaseFirestore.instance.collection('to_do').add({
                        'title':titleController.text.trim(),
                        'des':descriptioController.text.trim(),
                        'color':selectedColor!.hexAlpha,
                        'user':FirebaseAuth.instance.currentUser!.uid,
                        'timeSelected':todate,
                        'publishedAt':FieldValue.serverTimestamp(),
                        'isChecked':false
        
                      }
                      );
                      Navigator.pop(context);
                    } on FirebaseException catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(e.message.toString()))
                        );
                    }
                },
                
                style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(
                  Theme.of(context).colorScheme.primary
                ),
                fixedSize: WidgetStatePropertyAll(
                  Size(
                    MediaQuery.of(context).size.width*0.5,
                    MediaQuery.of(context).size.height*0.06 )
                )),
                
                child: const Text("Submit",
                style: TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.bold),),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}