import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exemple2/screens/AddTask.dart';
import 'package:exemple2/widgets/Drawer.dart';
import 'package:exemple2/widgets/ViewDeclaration.dart';
import 'package:exemple2/widgets/ViewTasks.dart';
import 'package:flutter/material.dart';
class ManageTasks extends StatefulWidget {
  const ManageTasks({Key? key}) : super(key: key);

  @override
  _ManageTasksState createState() => _ManageTasksState();
}

class _ManageTasksState extends State<ManageTasks> {
  int _selectedIndex = 0;
  final tabs= [
    ViewDelaration(),
    ViewTasks(),
    AddTask(),
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
        title: Text("Gérer Tâches"),
        centerTitle: true,
      ),
      drawer: MainDrawer(),
      body: tabs.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.comment),
            label: 'Reclamation',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: 'Tâches',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_task),
            label: 'Assigner Tâche',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
