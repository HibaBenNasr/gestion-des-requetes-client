import 'package:exemple2/widgets/Drawer.dart';
import 'package:exemple2/widgets/Methodes.dart';
import 'package:flutter/material.dart';

import 'HomeScreen.dart';

class AddNews extends StatefulWidget {
  const AddNews({Key? key}) : super(key: key);

  @override
  _AddNewsState createState() => _AddNewsState();
}

class _AddNewsState extends State<AddNews> {
  late String _object;
  late String _message;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  Widget _builObject() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Objet',
        prefixIcon: Icon(Icons.emoji_objects_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
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

  Widget _builMessage() {
    return TextFormField(
      maxLines: 11,
      decoration: InputDecoration(
        // labelText: 'Message',
        hintText: "Message",
        prefixIcon: Icon(Icons.message_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
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
      appBar: AppBar(
        title: Text("Ajouter News"),
        centerTitle: true,
      ),
      drawer: MainDrawer(),
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
                "Ajouter News",
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
                    _builMessage(),
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
                        createNews(_object, _message,date.add(Duration(days: 5, hours: 5, minutes: 5)).toString());
                        setState(() {
                          isLoading= true;
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => HomeScreen()));
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
}
