import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePicPage extends StatefulWidget {

  @override
  State<ProfilePicPage> createState() => _ProfilePicPageState();
}

class _ProfilePicPageState extends State<ProfilePicPage> {
  File? pickedFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
      ),
      body: Center(
        child: InkWell(
          onTap: () async{
            /// image pick here
           XFile? pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
           if(pickedImage!=null) {
             CroppedFile? cropFile = await ImageCropper().cropImage(sourcePath: pickedImage.path, uiSettings: [
               IOSUiSettings(
                 title: 'Cropper',
               ),
             ]);
             if(cropFile!=null) {
               pickedFile = File(cropFile.path);

               ///upload new image to storage
               var storage = FirebaseStorage.instance;
               var storageRef = storage.ref();

               var profilePicRef = storageRef.child("images/profile_pic/IMG_${DateTime.now().millisecondsSinceEpoch}.jpg");

               await profilePicRef.putFile(pickedFile!);

               var actualUrl = await profilePicRef.getDownloadURL();

               FirebaseFirestore.instance.collection("users").doc("jhvhsbvhdbvjkdsbkvjbds").update({
                 "profilePicUrl" : actualUrl
               });

               print(actualUrl);

               setState(() {

               });


             }
           }

          },
          child: pickedFile!=null ? Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
              image: DecorationImage(
                image: FileImage(pickedFile!)
              )
            ),
          ) : Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
