import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_note_291/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passController = TextEditingController();
  var mobNoController = TextEditingController();
  var ageController = TextEditingController();
  var genderController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nameController,
            ),
            SizedBox(
              height: 11,
            ),
            TextField(
              controller: emailController,
            ),
            SizedBox(
              height: 11,
            ),
            TextField(
              controller: mobNoController,
            ),
            SizedBox(
              height: 11,
            ),
            TextField(
              controller: ageController,
            ),
            SizedBox(
              height: 11,
            ),
            TextField(
              controller: genderController,
            ),
            SizedBox(
              height: 11,
            ),
            TextField(
              controller: passController,
            ),
            SizedBox(
              height: 11,
            ),

            ElevatedButton(onPressed: () async{
              var name = nameController.text.toString();
              var mobNo = mobNoController.text.toString();
              var email = emailController.text.toString();
              var age = int.parse(ageController.text.toString());
              var gender = genderController.text.toString();
              var pass = passController.text.toString();

              var auth = FirebaseAuth.instance;

              try{
                var cred = await auth.createUserWithEmailAndPassword(email: email, password: pass);
                if(cred.user!=null){
                  print('user created!! : ${cred.user!.uid}');

                  /// then add the user details in user collection
                  var firestore = FirebaseFirestore.instance;
                  var collectionRef = firestore.collection("users");

                  var userModel = UserModel(
                      name: name,
                      mobNo: mobNo,
                      email: email,
                      gender: gender,
                      age: age);

                  collectionRef.doc(cred.user!.uid).set(userModel.toDoc());


                } else {
                  print('user not created!!');
                }
              } on FirebaseAuthException catch(e){
                if (e.code == 'weak-password') {
                  print('The password provided is too weak.');
                } else if (e.code == 'email-already-in-use') {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('The account already exists for that email.')));
                  print('The account already exists for that email.');
                }
              } catch(e){
                print("Exception: ${e.toString()}");
              }


            }, child: Text('Sign Up')),

          ],
        ),
      ),
    );
  }
}
