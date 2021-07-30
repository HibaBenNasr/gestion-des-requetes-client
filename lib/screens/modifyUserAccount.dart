import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exemple2/screens/UserProfile.dart';
import 'package:exemple2/widgets/Methodes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ModifyUserAccount extends StatefulWidget {
  const ModifyUserAccount({Key? key}) : super(key: key);

  @override
  _ModifyUserAccountState createState() => _ModifyUserAccountState();
}

class _ModifyUserAccountState extends State<ModifyUserAccount> {
  TextEditingController usernameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController userPostController = new TextEditingController();
  TextEditingController companyController = new TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String userType= ".. ";
  void getData() async {
    User? user =  FirebaseAuth.instance.currentUser;
    var data;
    data = await FirebaseFirestore.instance
        .collection("utilisateurs")
        .doc(user!.uid)
        .get();
    setState(() {
      userType=data.data()!['userType'];
      usernameController.text=data.data()!['username'];
      emailController.text=data.data()!['email'];
      phoneController.text=data.data()!['phone'];
      userPostController.text=data.data()!['userPost'];
      if(userType=="client")
      companyController.text=data.data()!['companyName'];
    });
  }
  void initState(){
    getData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Modifier info"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Form(
            key:  _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
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
                          companyController.text, FirebaseAuth.instance.currentUser!.uid, userType);
                      Navigator.push(context,MaterialPageRoute(builder: (context)=> UserProfile()));
                    },
                    child: Text(
                      "Enregistrer",
                      style: TextStyle(color: Colors.white),
                    )),
              ],
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
