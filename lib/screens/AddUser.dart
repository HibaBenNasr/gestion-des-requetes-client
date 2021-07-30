import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/Methodes.dart';

class AddUser extends StatefulWidget {
  final String type;
  const AddUser({Key? key, required this.type}) : super(key: key);

  @override
  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  late String _username,_userPost,_email,_phoneNumber,_password,_passwordAdmin;
  String _companyName="";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String adminEmail,adminPassword;
  Future getData() async {
    User? user = await FirebaseAuth.instance.currentUser;
    var data;
    data = await FirebaseFirestore.instance
        .collection("utilisateurs")
        .doc(user!.uid)
        .get();
    setState(() {
      adminEmail=data.data()!['email'];
      adminPassword=data.data()!['password'];
    });
  }
  void initState(){
    getData();
    super.initState();
  }

  Widget _builCompanyName() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Nom de la société',
          prefixIcon: Icon(Icons.home_work_rounded)),
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Nom de la société obligatoire';
        }
        return null;
      },
      onSaved: (String? value) {
        _companyName = value!;
      },
    );
  }

  Widget _buildName() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Nom d'utilisateur",
          prefixIcon: Icon(Icons.account_circle)
      ),
      // maxLength: 20,
      validator: (String? value) {
        if (value!.isEmpty) {
          return "Nom d'utilisateur obligatoire";
        }
        return null;
      },
      onSaved: (String? value) {
        _username = value!;
      },
    );
  }

  Widget _buildPost() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Poste de l'utilisateur",
          prefixIcon: Icon(Icons.badge)),
      validator: (String? value) {

        if (value!.isEmpty) {
          return "Poste de l'utilisateur obligatoire";
        }

        return null;
      },
      onSaved: (String? value) {
        _userPost = value!;
      },
    );
  }


  Widget _buildEmail() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Email',
          prefixIcon: Icon(Icons.drafts)),
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Email obligatoire';
        }
        if (!RegExp(
            r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
          return 'Please enter a valid email Address';
        }
        return null;
      },
      onSaved: (String? value) {
        _email = value!;
      },
    );
  }


  Widget _buildPhoneNumber() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Num Tel',
          prefixIcon: Icon(Icons.phone)
      ),
      keyboardType: TextInputType.phone,
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Num Tel obligatoire';
        }

        return null;
      },
      onSaved: (String? value) {
        _phoneNumber = value!;
      },
    );
  }

  Widget _buildPassword() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Mot de passe',
          prefixIcon: Icon(Icons.lock_outline)),
      keyboardType: TextInputType.visiblePassword,
      obscureText : true,
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Mot de passe obligatoire';
        }

        return null;
      },
      onSaved: (String? value) {
        _password = value!;
      },
    );
  }

  Widget _buildPasswordAdmin() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Mot de passe admin',
          prefixIcon: Icon(Icons.lock_outline)),
      keyboardType: TextInputType.visiblePassword,
      obscureText : true,
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Mot de passe obligatoire';
        }
        if(value!=adminPassword){
          return "Mot de passe non valide";
        }
        return null;
      },
      onSaved: (String? value) {
        _passwordAdmin = value!;
      },
    );
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
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
              height: 80,
            ),
            Container(
              width: size.width/1.3,
              child: Text(
                widget.type=="client"?"Ajouter Client":
                widget.type=="employe"?"Ajouter Employe":
                "Ajouer Chef",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.only(bottom: 24, right: 24, left: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    widget.type=="client"?_builCompanyName():
                    _buildPost(),
                    _buildName(),
                    _buildEmail(),
                    _buildPhoneNumber(),
                    _buildPassword(),
                    _buildPasswordAdmin(),
                    SizedBox(height: 30),
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
                          "Ajouter",
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
                        showDialog(context: context, builder: (context)=>CupertinoAlertDialog(
                            title: Text("Confirmer"),
                            content: Text("Voulez-vous continuer"),
                            actions: [
                              CupertinoDialogAction(child: Text("Annuler"),
                                onPressed: (){
                                  Navigator.of(context).pop();
                                },),
                              CupertinoDialogAction(child: Text("Continuer"),
                                onPressed: (){
                                  setState(() {
                                    isLoading= true;
                                  });
                                  createUserAccount(
                                      _companyName,
                                      _username,
                                      _userPost,
                                      _email,
                                      _password,
                                      _phoneNumber, widget.type,adminEmail,adminPassword,context);//Send to API
                                },)
                            ]
                        ));
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
