import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exemple2/widgets/Methodes.dart';
import 'package:flutter/material.dart';

class ViewTasks extends StatefulWidget {
  const ViewTasks({Key? key}) : super(key: key);

  @override
  _ViewTasksState createState() => _ViewTasksState();
}

class _ViewTasksState extends State<ViewTasks> {
  TextEditingController delaisController = new TextEditingController();
  TextEditingController objectController = new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Stream<QuerySnapshot> rec=FirebaseFirestore.instance.collection("tasks").orderBy("date").snapshots();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: rec ,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        if(snapshot.hasError){
          return Text("error");
        }
        if (snapshot.connectionState==ConnectionState.waiting){
          return Center(child: CircularProgressIndicator());
        }
        final data =snapshot.requireData;
        return ListView.builder(
            itemCount: data.size,
            itemBuilder: (context, index){
              return Card(
                color: Colors.greenAccent,
                child: ListTile(
                  title: Text(data.docs[index]['object']),
                  subtitle: Text(data.docs[index]['date']),
                  trailing: Text(data.docs[index]['done']?"terminé": "non terminé"),
                  leading: Icon(
                    Icons.warning_amber_sharp,
                  ),
                  onTap: (){
                      delaisController.text = data.docs[index]['details'];
                      objectController.text = data.docs[index]['object'];
                    showDialogFunc(context,data.docs[index]['object'],data.docs[index]['date'],data.docs[index]['details'],data.docs[index]['empId'],data.docs[index].id);
                  },
                ),
              );
              //return Text(data.docs[index]['username']);
            }
        );
      },
    );
  }
  showDialogFunc(context,object,date,content,empId,taskId){
    return showDialog(
        context: context,
        builder: (context){
          return Center(
            child: Material(
              type: MaterialType.transparency,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                padding: EdgeInsets.all(15),
                width: MediaQuery.of(context).size.width*0.7,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 12),
                    Text(object, style: TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold,
                    ),),
                    SizedBox(height: 20),
                    Text(content),
                    SizedBox(height: 30),
                    Text("date: $date"),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        MaterialButton(onPressed: (){
                          Navigator.of(context).pop();
                          showDialog(context: context, builder: (context){
                            return Center(
                              child: modifyTask(context,taskId,object,content),
                            );
                          });
                        },
                          child: Text("Modifier",style: TextStyle(color: Colors.white)),
                          color:  Colors.green,
                        ),
                        SizedBox(width: 5,),
                        MaterialButton(onPressed: (){
                          deleteTask(taskId);
                          Navigator.of(context).pop();
                        },
                          child: Text("Supprimer",style: TextStyle(color: Colors.white)),
                          color:  Colors.red,
                        ),
                      ],
                    ) ,
                  ],
                ),
              ),
            ),
          );
        }
    );
  }
  Widget modifyTask(context,taskId,object,details){
    return Material(
      type: MaterialType.transparency,
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          padding: EdgeInsets.all(15),
          width: MediaQuery.of(context).size.width*0.85,
          child: Container(
            padding: EdgeInsets.all(20),
            child: Form(
              key:  _formKey,
              child: Column(
                children: [
                  TextFormField(
                    style: TextStyle(color: Colors.black),
                    decoration: inputDecoration("Sujet"),
                    controller: objectController,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Sujet obligatoire';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  TextFormField(
                    style: TextStyle(color: Colors.black),
                    decoration: inputDecoration("Détails"),
                    controller: delaisController,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "Détails obligatoire";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20,),
                  MaterialButton(
                      color: Colors.blueGrey,
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }
                        _formKey.currentState!.save();
                        taskUpdate(objectController.text,
                            delaisController.text,
                            taskId);
                        Navigator.of(context).pop();},
                      child: Text(
                        "Enregistrer",
                        style: TextStyle(color: Colors.white),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration inputDecoration(String labelText) {
    return InputDecoration(
      focusColor: Colors.green,
      labelStyle: TextStyle(color: Colors.blueGrey),
      labelText: labelText,
      fillColor: Colors.red,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.0),
        borderSide: BorderSide(color: Colors.blue,width: 2.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.0),
        borderSide: BorderSide(
          color: Colors.blueGrey,
          width: 2.0,
        ),
      ),
    );
  }
}

