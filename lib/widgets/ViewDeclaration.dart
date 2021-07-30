import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exemple2/widgets/Methodes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ViewDelaration extends StatefulWidget {
  const ViewDelaration({Key? key}) : super(key: key);

  @override
  _ViewDelarationState createState() => _ViewDelarationState();
}

class _ViewDelarationState extends State<ViewDelaration> {
  final Stream<QuerySnapshot> rec=FirebaseFirestore.instance.collection("reclamation").snapshots();
  String userId=".";
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
                child: ListTile(
                  title: Text(data.docs[index]['object']),
                  subtitle: Text(data.docs[index]['date']),
                  leading: Icon(
                    Icons.article_outlined,
                  ),
                  onTap: (){
                    showDialogFunc(context,data.docs[index]['object'],data.docs[index]['date'],data.docs[index]['content'],data.docs[index]['userId'],data.docs[index].id);
                  },
                ),
              );
              //return Text(data.docs[index]['username']);
            }
        );
      },
    );
  }
}

showDialogFunc(context,object,date,content,userId,recId){
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
                  SizedBox(height: 20),
                  Text("date: $date"),
                  SizedBox(height: 20),
                  MaterialButton(onPressed: (){
                    deleteRec(recId);
                    Navigator.of(context).pop();
                  },
                    child: Text("Supprimer",style: TextStyle(color: Colors.white)),
                    color:  Colors.red,
                  ),
                ],
              ),
            ),
          ),
        );
      }
  );
}