import 'package:exemple2/screens/AddUser.dart';
import 'package:exemple2/widgets/ListUsers.dart';
import 'package:exemple2/widgets/Drawer.dart';
import 'package:flutter/material.dart';

class Accounts extends StatefulWidget {
  const Accounts({Key? key}) : super(key: key);
  @override
  _AccountsState createState() => _AccountsState();
}

class _AccountsState extends State<Accounts> {
  int _selectedIndex = 0;
  final tabs= [
  ListUsers(type: "client"),
    ListUsers(type: "employe"),
    ListUsers(type: "chef"),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comptes"),
        centerTitle: true,
      ),
      drawer: MainDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) =>
          _selectedIndex==0? AddUser(type: "client"):
          _selectedIndex==1?AddUser(type: "employe"):
          AddUser(type: "chef")));
        },
        child: Icon(Icons.add),
      ),
      body: tabs.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Clients',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_mail),
            label: 'Employés',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_rounded),
            label: 'Chefs',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }

}
