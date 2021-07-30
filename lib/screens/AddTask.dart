import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exemple2/screens/ManageTasks.dart';
import 'package:exemple2/widgets/Drawer.dart';
import 'package:exemple2/widgets/Methodes.dart';
import 'package:flutter/material.dart';

import 'HomeScreen.dart';

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  late String _object;
  late String _message;
  final Stream<QuerySnapshot> emp=FirebaseFirestore.instance.collection("utilisateurs").where("userType", arrayContainsAny: ['chef','employe']).snapshots();

  var   selectedCurrency, selectedTypes;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  Widget _builObject() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Objet',
        prefixIcon: Icon(Icons.emoji_objects_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2),
        ),),
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Objet obligatoire';
        }
        return null;
      },
      onSaved: (String? value) {
        _object = value!;
      },
    );
  }

  Widget _builDetails() {
    return TextFormField(
      maxLines: 4,
      decoration: InputDecoration(
        hintText: "Détails",
        prefixIcon: Icon(Icons.details),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2),
        ),),
      onSaved: (String? value) {
        _message = value!;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: isLoading? Center(
        child: Container(
          height: size.height/20,
          width: size.width/10,
          child: CircularProgressIndicator(),
        ),
      )
          :SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height/30,
            ),
            Container(
              width: size.width/1.3,
              child: Text(
                "Assigner Tâches",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 24, right: 24, left: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: size.height/20,
                    ),
                    _builObject(),
                    SizedBox(
                      height: size.height/50,
                    ),
                    _builDetails(),
                    SizedBox(
                      height: size.height/30,
                    ),
                    GestureDetector(
                      child: Container(
                        height: size.height/14,
                        width: size.width/1.2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.blue,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "Envoyer",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onTap: () {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }
                        _formKey.currentState!.save();
                        var date=DateTime.now();
                        showEmpFunc(context,_object, _message,date.add(Duration(days: 5, hours: 5, minutes: 5)).toString());
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  showEmpFunc(context,String object,String details,String date){
    final size = MediaQuery.of(context).size;
    int screen=2;
    final Stream<QuerySnapshot> chef=FirebaseFirestore.instance.collection("utilisateurs").where("userType", isEqualTo: "chef").snapshots();
    final Stream<QuerySnapshot> emp=FirebaseFirestore.instance.collection("utilisateurs").where("userType", isEqualTo: "employe").snapshots();
    return showDialog(
        context: context,
        builder: (context){
          return Center(
            child: Material(
              type: MaterialType.transparency,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                ),
                padding: EdgeInsets.all(15),
                width: size.width*0.7,
                height: 280,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Liste Employés",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold)),
                      StreamBuilder<QuerySnapshot>(
                        stream: emp ,
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                          if(snapshot.hasError){
                            return Text("error");
                          }
                          if (snapshot.connectionState==ConnectionState.waiting){
                            return Center(child: CircularProgressIndicator());
                          }
                          final data =snapshot.requireData;
                          return Container(
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: data.size,
                                itemBuilder: (context, index){
                                  return Card(
                                    color: Colors.greenAccent,
                                    child: ListTile(
                                      title: Text(data.docs[index]['username']),
                                      subtitle: Text(data.docs[index]['userPost']),
                                      leading: Icon(
                                        Icons.person,
                                      ),
                                      onTap: (){
                                        createTask(object, details,date,data.docs[index]['userId']);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => ManageTasks()));
                                      },
                                    ),
                                  );
                                }
                            ),
                          );
                        },
                      ),
                      Text("Liste Chefs",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold)),
                      StreamBuilder<QuerySnapshot>(
                        stream: chef ,
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                          if(snapshot.hasError){
                            return Text("error");
                          }
                          if (snapshot.connectionState==ConnectionState.waiting){
                            return Center(child: CircularProgressIndicator());
                          }
                          final data =snapshot.requireData;
                          return Container(
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: data.size,
                                itemBuilder: (context, index){
                                  return Card(
                                    color: Colors.greenAccent,
                                    child: ListTile(
                                      title: Text(data.docs[index]['username']),
                                      subtitle: Text(data.docs[index]['userPost']),
                                      leading: Icon(
                                        Icons.warning_amber_sharp,
                                      ),
                                      onTap: (){
                                        createTask(object, details,date,data.docs[index]['userId']);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => ManageTasks()));
                                      },
                                    ),
                                  );
                                }
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
    );
  }
}

