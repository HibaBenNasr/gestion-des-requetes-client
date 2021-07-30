import 'package:exemple2/screens/HomeScreen.dart';
import 'package:exemple2/screens/SignUp.dart';
import 'package:flutter/material.dart';
import '../widgets/Methodes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: isLoading ? Center(
        child: Container(
          width: size.width /10,
          height: size.height /20,
          child: CircularProgressIndicator(),
        ),
      ) :SingleChildScrollView(
        reverse: true,
        child: Column(
          children: [
            SizedBox(
              height: size.height/10,
            ),
            Container(
              width: size.width/1.3,
              child: Text(
                "Bienvenue",
                style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            Container(
              width: size.width/1.3,
              child: Text(
                  "Connectez-vous pour continuer",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 25,
                fontWeight: FontWeight.w500,
              ),
              ),
            ),
            SizedBox(
              height: size.height/10,
            ),
            Container(
              width: size.width,
                alignment: Alignment.center,
                child: field(size,"Email",Icons.drafts,_email,false),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18.0),
              child: Container(
                width: size.width,
                alignment: Alignment.center,
                child: field(size, "Mot de passe", Icons.lock,_password,true),
              ),
            ),
            SizedBox(
              height: size.height/10,
            ),
            button(size),
            SizedBox(
              height: size.height/40,
            ),
            GestureDetector(
              onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (_) => SignUp())),
              child: Text(
                "S'inscrire",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget button(Size size){
    return GestureDetector(
      onTap: (){
        if(_email.text.isNotEmpty && _password.text.isNotEmpty){
          setState(() {
            isLoading =true;
          });
          logIn(context,_email.text,_password.text).then((user){
            if(user != null){
              print("login sucessful");
              setState(() {
                isLoading =false;
              });
            //  Navigator.push(context, MaterialPageRoute(builder: (_) => HomeScreen()));
            }
            else{
              print("login failed");
              setState(() {
                isLoading =false;
              });
            }
          });
        }
        else{
          print("les champs ne doit pas etre vide");
        }
      },
      child: Container(
        height: size.height/14,
        width: size.width/1.2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.blue,
        ),
        alignment: Alignment.center,
        child: Text(
          "Connexion",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget field(Size size, String hintText, IconData icon,TextEditingController cont, bool pwd){
    return Container(
      height: size.height/11,
      width: size.width/1.1,
      child: TextField(
        controller: cont,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey,
          ),
            border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
        ),
        ),
        obscureText: pwd,
      ),
    );
  }
}
