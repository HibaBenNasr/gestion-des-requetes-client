import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exemple2/screens/ConfirmDeleteUser.dart';
import 'package:exemple2/widgets/profile_menu_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/Constants.dart';
import '../widgets/Drawer.dart';
import '../widgets/Info.dart';
import 'modifyUserAccount.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String username= "...";
  String email= "...";
  void getData() async {
    User? user =  FirebaseAuth.instance.currentUser;
    var data;
    data = await FirebaseFirestore.instance
        .collection("utilisateurs")
        .doc(user!.uid)
        .get();
    setState(() {
      username=data.data()!['username'];
      email=data.data()!['email'];
    });
  }
  void initState(){
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text("Paramètre Compte"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Info(
              image: "assets/images/user.png",
              name: username,
              email: email,
            ),
            SizedBox(height: 10), //20
            ProfileMenuItem(
              i: Icon(
                Icons.account_circle,
                size: 20,
                color: kTextLigntColor,
              ),
              title: "Profile",
              press: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context)=> ModifyUserAccount()));
              },
            ),
            ProfileMenuItem(
              i: Icon(
                Icons.lock_clock,
                size: 20,
                color: kTextLigntColor,
              ),
              title: "Réinitialiser le mot de passe",
              press: () {},
            ),
            ProfileMenuItem(
              i: Icon(
                Icons.delete_forever,
                size: 20,
                color: kTextLigntColor,
              ),
              title: "Supprimer compte",
              press: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => ConfirmDeleteUser()));
              },
            ),
          ],
        ),
      ),
    );
  }
}


