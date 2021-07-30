import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exemple2/widgets/Drawer.dart';
import 'package:exemple2/widgets/ViewNews.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
   String userType="..";
  Future getData() async {
    User? user =  FirebaseAuth.instance.currentUser;
    var data;
      data = await FirebaseFirestore.instance
          .collection("utilisateurs")
          .doc(user!.uid)
          .get();
    setState(() {
      userType=data.data()!['userType'];
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
          title: Text("Home"),
          centerTitle: true,
        ),
        drawer: MainDrawer(),
        body:
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: ViewNews(userType: userType),
        ),
    );
  }
}
