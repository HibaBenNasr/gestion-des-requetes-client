import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exemple2/widgets/Methodes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListUsers extends StatefulWidget {
  final String type;
  const ListUsers({Key? key, required this.type}) : super(key: key);
  @override
  _ListUsersState createState() => _ListUsersState();
}

class _ListUsersState extends State<ListUsers> {
  TextEditingController usernameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController userPostController = new TextEditingController();
  TextEditingController companyController = new TextEditingController();

  String userType= ".. ";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> users=FirebaseFirestore.instance.collection("utilisateurs").where("userType", isEqualTo: widget.type).snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: users ,
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
                  title: Text(widget.type=="client"?data.docs[index]['companyName']:data.docs[index]['userPost']),
                  subtitle: Text(data.docs[index]['username']),
                  leading: CircleAvatar(
                    child: Icon(Icons.account_circle_rounded),
                  ),
                  onTap: (){
                    usernameController.text=data.docs[index]['username'];
                    emailController.text=data.docs[index]['email'];
                    phoneController.text=data.docs[index]['phone'];
                    userPostController.text=data.docs[index]['userPost'];
                    if(widget.type=="client")
                      companyController.text=data.docs[index]['companyName'];
                    showDialogFunc(context,data.docs[index]['username'],data.docs[index]['userPost'],widget.type=="client"?data.docs[index]['companyName']:"",data.docs[index]['email'],data.docs[index]["phone"],data.docs[index]["userType"],data.docs[index].id);
                  },
                ),
              );
              //return Text(data.docs[index]['username']);
            }
        );
      },
    );
  }

  showDialogFunc(context,username,userPost,companyName,email,phone,userType,userId){
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
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 12),
                      Text(userType=="client"?companyName:userType=="employe"?"Employé":"Chef", style: TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold,
                      ),),
                      SizedBox(height: 20),
                      Text(username,textAlign: TextAlign.left,),
                      SizedBox(height: 20),
                      Text(userPost,textAlign: TextAlign.left,),
                      SizedBox(height: 20),
                      Text(email,textAlign: TextAlign.left,),
                      SizedBox(height: 20),
                      Text(phone,textAlign: TextAlign.left,),
                      SizedBox(height: 20),
                      if (userType!="client") MaterialButton(onPressed: (){
                        setUserType(userType,userId);
                        Navigator.of(context).pop();
                      },
                        child: Text(
                            userType=="employe"?"Promu Chef":"Rétrograder à Employé",style: TextStyle(color: Colors.white)),
                        color:  Colors.blue,
                      ) ,
                      Row(
                        children: [
                          MaterialButton(onPressed: (){
                            Navigator.of(context).pop();
                            showDialog(context: context, builder: (context){
                              return Center(
                                child: modifyUser(context,userId,userType),
                              );
                            });
                          },
                            child: Text("Modifier",style: TextStyle(color: Colors.white)),
                            color:  Colors.green,
                          ),
                          SizedBox(width: 5,),
                          MaterialButton(onPressed: (){
                            Navigator.of(context).pop();
                            showDialog(context: context,
                                builder: (BuildContext context)=>CupertinoAlertDialog(
                                    title: Text("Confirmer"),
                                    content: Text("Supprimer ce compte ?"),
                                    actions: [
                                      CupertinoDialogAction(child: Text("Confirmer"),
                                        onPressed: (){
                                          Navigator.of(context).pop();
                                        },),
                                      CupertinoDialogAction(child: Text("Annuler"),
                                        onPressed: (){
                                          Navigator.of(context).pop();
                                        },)
                                    ]
                                ));
                          },
                            child: Text("Supprimer",style: TextStyle(color: Colors.white)),
                            color:  Colors.red,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        }
    );
  }



  Widget modifyUser(context,userId,userType){
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
                  userType=="client"?
                  TextFormField(
                    style: TextStyle(color: Colors.black),
                    decoration: inputDecoration("Societé"),
                    controller: companyController,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Nom de la société obligatoire';
                      }
                      return null;
                    },
                  ):SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    style: TextStyle(color: Colors.black),
                    decoration: inputDecoration("Email"),
                    controller: emailController,
                    readOnly: true,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    style: TextStyle(color: Colors.black),
                    decoration: inputDecoration("Nom d'utilisateur"),
                    controller: usernameController,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "Nom d'utilisateur obligatoire";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    style: TextStyle(color: Colors.black),
                    decoration: inputDecoration("Tél"),
                    controller: phoneController,
                    keyboardType: TextInputType.phone,

                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Num Tél obligatoire';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    style: TextStyle(color: Colors.black),
                    decoration: inputDecoration("Poste"),
                    controller: userPostController,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Poste obligatoire';
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
                        print(phoneController.text);
                        updateUser(usernameController.text,
                            phoneController.text,
                            userPostController.text,
                            companyController.text, userId, userType);
                        Navigator.of(context).pop();                      },
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
