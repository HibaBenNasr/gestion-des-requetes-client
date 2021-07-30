import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exemple2/widgets/Drawer.dart';
import 'package:exemple2/widgets/Methodes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyTasks extends StatefulWidget {
  const MyTasks({Key? key}) : super(key: key);

  @override
  _MyTasksState createState() => _MyTasksState();
}

class _MyTasksState extends State<MyTasks> {
  FirebaseAuth _auth= FirebaseAuth.instance;

  final Stream<QuerySnapshot> tasks=FirebaseFirestore.instance.collection("tasks").orderBy("date").snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text("Gérer Tâches"),
    centerTitle: true,
    ),
    drawer: MainDrawer(),
       body: StreamBuilder<QuerySnapshot>(
          stream: tasks ,
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
                  return data.docs[index]['empId']== _auth.currentUser!.uid?Card(
                    child: ListTile(
                      title: Text(data.docs[index]['object']),
                      subtitle: Text(data.docs[index]['date']),
                      trailing: Text(data.docs[index]['done']?"terminé": "non terminé"),
                      leading: Icon(
                        Icons.article_outlined,
                      ),
                      onTap: (){
                        showDialogFunc(context,data.docs[index]['object'],data.docs[index]['date'],data.docs[index]['details'],data.docs[index]['done'],data.docs[index].id);
                      },
                    ),
                  ): Center();
                  //return Text(data.docs[index]['username']);
                }
            );
          },
        ),
    );
  }
}
showDialogFunc(context,object,date,content,isDone, String taskId){
  final size = MediaQuery.of(context).size;
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
              width: size.width*0.7,
              height: 280,
              child: SingleChildScrollView(
                child: Column(
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
                         isDone? "Marquer comme non terminé":"Marquer comme terminé" ,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onTap: () {
                        setIsDone(isDone,taskId);
                        Navigator.of(context).pop();
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