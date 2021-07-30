import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exemple2/screens/AddNews.dart';
import 'package:exemple2/screens/Declaration.dart';
import 'package:exemple2/screens/HomeScreen.dart';
import 'package:exemple2/screens/ManageTasks.dart';
import 'package:exemple2/screens/MyTasks.dart';
import 'package:exemple2/screens/UserProfile.dart';
import 'package:exemple2/screens/accounts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Methodes.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  @override
  String userType="..";
  String username="..";
  Future getData() async {
    User? user = await FirebaseAuth.instance.currentUser;
    var data;
      data = await FirebaseFirestore.instance
          .collection("utilisateurs")
          .doc(user!.uid)
          .get();
    setState(() {
      userType=data.data()!['userType'];
      username=data.data()!['username'];
    });
  }
  void initState(){
    getData();
    super.initState();
  }

  Widget build(BuildContext context) {
    final safeArea = EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top);

    return Container(
      child: Drawer(
        child: userType=="admin"? DrawerAdmin():
            userType=="client"? DrawerClient():
                userType=="employe"? DrawerEmployee():
                userType=="chef"? DrawerChef():
            Column(
            children: <Widget>[
                Container(
                    width: double.infinity,
                    color: Theme.of(context).primaryColor,
                    child: Center(
                        child: Container(
                            padding: EdgeInsets.symmetric(vertical: 24).add(safeArea),
                            child: buildHeader(),
                    ),
                    ),
                ),
                const SizedBox(height: 24),
                ListTile(
                    leading: Icon(Icons.home, color: Colors.black,),
                    title: Text('Accueil', style: TextStyle(
                    fontSize: 18,),),
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => HomeScreen())),
                    ),
                ListTile(
                    leading: Icon(Icons.settings,color: Colors.black,),
                    title: Text('Paramètre Compte', style: TextStyle(
                    fontSize: 18,),),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => UserProfile())),
                    ),
                Divider(color: Colors.black38),
                ListTile(
                    leading: Icon(Icons.logout, color: Colors.black,),
                    title: Text('Déconnecter', style: TextStyle(
                    fontSize: 18,),),
                    onTap: () => logOut(context),
                    ),
            ],
            ),
      ),
    );
  }

  Widget buildHeader() => Row(
    children: [
      const SizedBox(width: 24),
      Icon(Icons.account_circle, size: 56,color: Colors.white,),
      const SizedBox(width: 16),
      Expanded(
        child:Text(username, style: TextStyle(fontSize: 32, color: Colors.white),)
      ),
    ],
  );

  Widget DrawerAdmin(){
    final safeArea = EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top);
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          color: Theme.of(context).primaryColor,
          child: Center(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 24).add(safeArea),
              child: buildHeader(),
            ),
          ),
        ),
        const SizedBox(height: 24),
        ListTile(
          leading: Icon(Icons.home, color: Colors.black,),
          title: Text('Accueil', style: TextStyle(
            fontSize: 18,
          ),
          ),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => HomeScreen())),
        ),
        ListTile(
          leading: Icon(Icons.settings,color: Colors.black,),
          title: Text('Paramètre Compte', style: TextStyle(
            fontSize: 18,
          ),
          ),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => UserProfile())),
        ),
        ListTile(
          leading: Icon(Icons.switch_account, color: Colors.black,),
          title: Text('Gérer les compte', style: TextStyle(
            fontSize: 18,
          ),
          ),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Accounts())),
        ),
        Divider(color: Colors.black38),
        ListTile(
          leading: Icon(Icons.logout, color: Colors.black,),
          title: Text('Déconnecter', style: TextStyle(
            fontSize: 18,
          ),
          ),
          onTap: () => logOut(context),
        ),
      ],
    );
  }

  Widget DrawerChef(){
    final safeArea = EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top);
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          color: Theme.of(context).primaryColor,
          child: Center(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 24).add(safeArea),
              child: buildHeader(),
            ),
          ),
        ),
        const SizedBox(height: 24),
        ListTile(
          leading: Icon(Icons.home, color: Colors.black,),
          title: Text('Accueil', style: TextStyle(
            fontSize: 18,
          ),
          ),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => HomeScreen())),
        ),
        ListTile(
          leading: Icon(Icons.settings,color: Colors.black,),
          title: Text('Paramètre Compte', style: TextStyle(
            fontSize: 18,
          ),
          ),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => UserProfile())),
        ),
        ListTile(
          leading: Icon(Icons.task, color: Colors.black,),
          title: Text('Gérer tâches', style: TextStyle(
            fontSize: 18,
          ),
          ),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ManageTasks())),
        ),
        ListTile(
          leading: Icon(Icons.file_present, color: Colors.black,),
          title: Text('Mes tâches', style: TextStyle(
            fontSize: 18,
          ),
          ),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MyTasks())),
        ),
        ListTile(
          leading: Icon(Icons.new_label_sharp, color: Colors.black,),
          title: Text('Ajouter news', style: TextStyle(
            fontSize: 18,
          ),
          ),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddNews())),
        ),

        Divider(color: Colors.black38),
        ListTile(
          leading: Icon(Icons.logout, color: Colors.black,),
          title: Text('Déconnecter', style: TextStyle(
            fontSize: 18,
          ),
          ),
          onTap: () => logOut(context),
        ),
      ],
    );
  }

  Widget DrawerClient(){
    final safeArea = EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top);
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          color: Theme.of(context).primaryColor,
          child: Center(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 24).add(safeArea),
              child: buildHeader(),
            ),
          ),
        ),
        const SizedBox(height: 24),
        ListTile(
          leading: Icon(Icons.home, color: Colors.black,),
          title: Text('Accueil', style: TextStyle(
            fontSize: 18,
          ),
          ),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => HomeScreen())),
        ),
        ListTile(
          leading: Icon(Icons.settings,color: Colors.black,),
          title: Text('Paramètre Compte', style: TextStyle(
            fontSize: 18,
          ),
          ),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => UserProfile())),
        ),
        ListTile(
          leading: Icon(Icons.report_problem, color: Colors.black,),
          title: Text('Déclarer Un Problème', style: TextStyle(
            fontSize: 18,
          ),
          ),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Declaration())),
        ),
        Divider(color: Colors.black38),
        ListTile(
          leading: Icon(Icons.logout, color: Colors.black,),
          title: Text('Déconnecter', style: TextStyle(
            fontSize: 18,
          ),
          ),
          onTap: () => logOut(context),
        ),
      ],
    );
  }
  Widget DrawerEmployee(){
    final safeArea = EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top);
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          color: Theme.of(context).primaryColor,
          child: Center(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 24).add(safeArea),
              child: buildHeader(),
            ),
          ),
        ),
        const SizedBox(height: 24),
        ListTile(
          leading: Icon(Icons.home, color: Colors.black,),
          title: Text('Accueil', style: TextStyle(
            fontSize: 18,
          ),
          ),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => HomeScreen())),
        ),
        ListTile(
          leading: Icon(Icons.settings,color: Colors.black,),
          title: Text('Paramètre Compte', style: TextStyle(
            fontSize: 18,
          ),
          ),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => UserProfile())),
        ),
        ListTile(
          leading: Icon(Icons.file_present, color: Colors.black,),
          title: Text('Mes tâches', style: TextStyle(
            fontSize: 18,
          ),
          ),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MyTasks())),
        ),
        Divider(color: Colors.black38),
        ListTile(
          leading: Icon(Icons.logout, color: Colors.black,),
          title: Text('Déconnecter', style: TextStyle(
            fontSize: 18,
          ),
          ),
          onTap: () => logOut(context),
        ),
      ],
    );
  }
}
