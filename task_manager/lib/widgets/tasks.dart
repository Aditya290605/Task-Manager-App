import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class Tasks extends StatefulWidget {

 

  const Tasks({super.key,

  });

  @override
  State<Tasks> createState() => _TasksState();
}

class _TasksState extends State<Tasks> {

  @override
  Widget build(BuildContext context) {
    
    return Expanded(

      child: StreamBuilder(
        
        stream: FirebaseFirestore.instance.collection('to_do').where(
          'user',isEqualTo: FirebaseAuth.instance.currentUser!.uid
        ).snapshots(),
        builder: (context, snapshot) {


          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(),);
          }
          

          return ListView.builder(
            
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context,index)
            {
              bool isSelected = snapshot.data!.docs[index].data()['isChecked'];
              Timestamp? timestamp = snapshot.data!.docs[index].data()['timeSelected'];
              Timestamp? timestamp1 =  snapshot.data!.docs[index].data()['publishedAt'];
              DateTime date = timestamp?.toDate() ?? DateTime.now();
              DateTime date1 = timestamp1?.toDate() ?? DateTime.now();
              String lastDate = DateFormat('d/M/yy').format(date);
              String lastTime = DateFormat('hh:mm a').format(date1);
              

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Dismissible(
                  key: ValueKey(index),
                  onDismissed: (direction) {
                    setState(() {
                      if(direction == DismissDirection.endToStart){
                      FirebaseFirestore.instance.collection("to_do").doc(
                        snapshot.data!.docs[index].id
                      ).delete();
                    }
                    });
                  },

                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Color(int.parse(snapshot.data!.docs[index].data()['color'].toString(),radix: 16)),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(20),
                    
                  ),
                  child: ListTile(
                    title: Text(snapshot.data!.docs[index].data()['title'],
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 20,
                      color: Colors.black,
                      decoration: isSelected == true ? TextDecoration.lineThrough : TextDecoration.none,
                      decorationStyle: TextDecorationStyle.solid,
                      decorationThickness: 3),
                    ),
                    leading: Checkbox(
                      checkColor: Colors.green,
                      fillColor: const WidgetStatePropertyAll(Colors.white), 
                      value: isSelected , onChanged: (bool? changed){
                      
                        setState(() {
                          FirebaseFirestore.instance.collection('to_do').doc(
                            snapshot.data!.docs[index].id
                          ).update({"isChecked":changed});
                        }
                        );
                      
                    },
                    ),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                      
                          child: Text(snapshot.data!.docs[index].data()['des'],
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 18,color: Colors.black),
                          maxLines: 3,
                          overflow: TextOverflow.clip,),
                        ),
                            
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 15,
                            right: 0,
                            bottom: 25
                          ),
                          child: Text("$lastTime\n $lastDate",
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 16,color: Colors.black)),
                        )
                      ],
                    ),
                    
                  )
                ),
                ),
              );
            }
          );
        }
      )
      );
      }
}
