import 'package:exemple2/screens/HomeScreen.dart';
import 'package:exemple2/screens/LoginScreen.dart';
import 'package:exemple2/screens/UserProfile.dart';
import 'package:exemple2/screens/accounts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:get/get.dart';


Future<User?> createAccount(String companyName,String username,String userPost, String email, String password,String phone,String userType) async{
  FirebaseAuth _auth= FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
    User? user = (await _auth.createUserWithEmailAndPassword(
        email: email, password: password)).user;
    if (user!= null){
      print("sign up sucessfull");
      user.updateDisplayName(username);

      await _firestore.collection('utilisateurs').doc(_auth.currentUser!.uid).set({
        "uid": _auth.currentUser!.uid,
        "username": username,
        "email": email,
        "userType": userType,
        "userPost": userPost,
        "phone": phone
      });
      if(userType=="client"){
        await _firestore.collection('utilisateurs').doc(_auth.currentUser!.uid).update({
          "companyName": companyName,
        });
      }
      return user;
    }
    else{
      print("sign up failed");
      return user;
    }

}


Future createUserAccount( companyName, username, userPost,email,password,phone,userType,adminEmail,adminPassword,context) async{
  FirebaseAuth _auth= FirebaseAuth.instance;
  CollectionReference reference=FirebaseFirestore.instance.collection("utilisateurs");

  try{
    await _auth.createUserWithEmailAndPassword(
        email: email, password: password).then((value){
          reference.add({
            "companyName": companyName,
            "username": username,
            "email": email,
            "userType": userType,
            "userPost": userPost,
            "phone": phone
          }).then((value) => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => Accounts())));
    }).catchError((onError){
      Fluttertoast.showToast(msg: onError.toString());
    });
    User? user = (await _auth.signInWithEmailAndPassword(email: adminEmail, password: adminPassword)).user;
    if(user!=null)  {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => Accounts()));
    }
    else{
      Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen()));
    }
      return user;
   }catch(e){
    Fluttertoast.showToast(msg: e.toString());
     print(e);
   }
}

Future createDeclaration(String object,String content,String date) async{
  FirebaseAuth _auth= FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

        await _firestore.collection('reclamation').add({
        "userId": _auth.currentUser!.uid,
        "object": object,
        "content": content,
          "date": date
      });
    }

Future createNews(String object,String details,String date) async{
  FirebaseAuth _auth= FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  await _firestore.collection('news').add({
    "userId": _auth.currentUser!.uid,
    "object": object,
    "details": details,
    "date": date
  });
}

Future createTask(String object,String details,String date,String empId) async{
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  await _firestore.collection('tasks').add({
    "empId": empId,
    "object": object,
    "details": details,
    "date": date,
    "done": false
  });
}

Future setIsDone(bool done,String taskId) async{
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  await _firestore.collection('tasks').doc(taskId).update(
    {
      "done": !done
    }
  );
}

Future updateUser(username,phone,post,company,userId,userType) async{
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  await _firestore.collection('utilisateurs').doc(userId).update(
      {
        "companyName": company,
        "username": username,
        "userPost": post,
        "phone": phone
      }
  );
  if(userType=="client")
    await _firestore.collection('utilisateurs').doc(userId).update(
        {
          "companyName": company,
        }
    );

}

Future setUserType(String type,String userId) async{
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  if(type=="chef"){
    type="employe";
  }
  else{
    type="chef";
  }
  await _firestore.collection('utilisateurs').doc(userId).update(
      {
        "userType": type
      }
  );
}

Future newsUpdate(object,details,newsId) async{
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  await _firestore.collection('news').doc(newsId).update(
      {
        "details": details,
        "object":object,
        "idEdited":true
      }
  );
}

Future taskUpdate(object,details,taskId) async{
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  await _firestore.collection('tasks').doc(taskId).update(
      {
        "details": details,
        "object":object,
        "idEdited":true
      }
  );
}


Future deleteTask(String taskId) async{
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  await _firestore.collection('tasks').doc(taskId).delete(
  );
}


Future deleteNews(String newsId) async{
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  await _firestore.collection('news').doc(newsId).delete(
  );
}

Future deleteRec(String recId) async{
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  await _firestore.collection('reclamation').doc(recId).delete(
  );
}


Future <User?> logIn(context,String email, String password)async{
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  try{
    User? user = (await _auth.signInWithEmailAndPassword(email: email, password: password)).user;
    if (user != null){
      print ("login sucessfull");
      await FirebaseFirestore.instance
          .collection("utilisateurs")
          .doc(user.uid)
          .get().then((doc) {
            if(!doc.exists){
              print("null");
              String uidToDelete;
               FirebaseFirestore.instance
                  .collection("utilisateurs").where("email", isEqualTo: email)
                  .get().then((value){
                _firestore.collection('utilisateurs').doc(_auth.currentUser!.uid).set({
                  "uid": _auth.currentUser!.uid,
                  "username": value.docs[0]["username"],
                  "email": value.docs[0]["email"],
                  "userType": value.docs[0]["userType"],
                  "userPost": value.docs[0]["userPost"],
                  "phone": value.docs[0]["phone"],
                });
                if(value.docs[0]["userType"]=="client"){
                  _firestore.collection('utilisateurs').doc(_auth.currentUser!.uid).update({
                    "companyName": value.docs[0]["companyName"],
                  });
                }
                uidToDelete=value.docs[0].id;
                 _firestore.collection('utilisateurs').doc(uidToDelete).delete();
              });
            }
      });
      Navigator.push(context, MaterialPageRoute(builder: (_) => HomeScreen()));
      return user;
    }
    else{
      print("login failed");
    }
  }catch(e){
    Fluttertoast.showToast(msg: e.toString());
    print(e);
    return null;
  }
}



Future<User?> logOut(BuildContext context) async{
  FirebaseAuth _auth = FirebaseAuth.instance;
  try{
    await _auth.signOut().then((value){
      Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen()));
    });
  }catch(e){
    Fluttertoast.showToast(msg: e.toString());
    print("error");
  }
}


void resetPassword(context, String email) async{
  FirebaseAuth _auth= FirebaseAuth.instance;
  await _auth.sendPasswordResetEmail(email: email).then((value){
    Navigator.push(context, MaterialPageRoute(builder: (_) => UserProfile()));
  }).catchError((onError){
    Fluttertoast.showToast(msg: onError.toString());
  });
}


Future<User?> deleteAccounte(context,email,password) async{
   FirebaseFirestore _firestore = FirebaseFirestore.instance;
   FirebaseAuth _auth= FirebaseAuth.instance;
  User? user =  _auth.currentUser;
  String userId=user!.uid;
  AuthCredential credential = EmailAuthProvider.credential(email: email, password: password);

  await user.reauthenticateWithCredential(credential).then((value){
    value.user!.delete().then((res) {
       _firestore.collection('utilisateurs').doc(userId).delete();
      Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen()));
    });
  });
}