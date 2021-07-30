import 'package:exemple2/screens/SignUpEmployee.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'HomeScreen.dart';
import '../widgets/Methodes.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late String _username,_companyName,_userPost,_email,_phoneNumber,_password;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
              height: size.height/15,
            ),
            Container(
              width: size.width/1.3,
              child: Text(
                "Bienvenue",
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              width: size.width/1.3,
              child: Text(
                "inscrivez-vous pour continuer",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
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
                    _builCompanyName(),
                    _buildPost(),
                    _buildName(),
                    _buildEmail(),
                    _buildPhoneNumber(),
                    _buildPassword(),
                    SizedBox(height: 15),
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
                          "S'inscrire",
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
                                createAccount(
                                        _companyName,
                                        _username,
                                        _userPost,
                                        _email,
                                        _password,
                                        _phoneNumber,
                                        "client")
                                    .then((user) {
                                  if (user != null) {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => HomeScreen()));
                                    print("login sucessful");
                                  } else {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    print("login failed");
                                  }
                                  setState(() {
                                    isLoading = false;
                                  });
                                }).catchError((e){
                                  showDialog(context: context,
                                      builder: (BuildContext context)=>CupertinoAlertDialog(
                                          title: Text("Erreur"),
                                          content: Text(e.message),
                                          actions: [
                                            CupertinoDialogAction(child: Text("ok"),
                                            onPressed: (){
                                              Navigator.of(context).pop();
                                            },)
                                          ]
                                      ));
                                });//Send to API
                      },
                    ),
                    SizedBox(
                      height: size.height/60,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text(
                        "Connexion",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Divider(color: Colors.black38, height: 10, thickness: 2, indent: 20,endIndent: 20),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Employé? ',
                          style: TextStyle(fontSize: 14, color: Colors.black, height: 1.5, fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return SignUpEmployee();
                            }));
                          },
                          child: Text(
                            "Inscrivez-vous",
                            style: TextStyle(fontSize: 17, color: Colors.white, height: 1.5).copyWith(
                                color: Colors.blue, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
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
