import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_note_291/firebase_options.dart';
import 'package:fire_note_291/login_google_page.dart';
import 'package:fire_note_291/profile_pic_page.dart';
import 'package:fire_note_291/register_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LoginGooglePage(),
    );
  }
}


class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  FirebaseMessaging msgService = FirebaseMessaging.instance;

  @override
  void initState() async{
    super.initState();
    NotificationSettings settings= await msgService.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  @override
  Widget build(BuildContext context) {

    print("Device Token : ${msgService.getToken()}");



    var collectionRef = firestore.collection("notes");


    ///foreground
    FirebaseMessaging.onMessage.listen((event) {
      print("Notification: ${event.notification!.title}, ${event.notification!.body}");
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('FireNote'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: collectionRef.snapshots(),
        builder: (_, snapshot){
          if(snapshot.hasData){
            return snapshot.data!.docs.isNotEmpty ? ListView.builder(
              itemCount: snapshot.data!.docs.length,
                itemBuilder: (_, index){
              return ListTile(
                title: Text(snapshot.data!.docs[index].data()['title']),
                subtitle: Text(snapshot.data!.docs[index].data()['desc']),
                trailing: SizedBox(
                  width: 100,
                  child: Row(
                    children: [
                      IconButton(onPressed: (){
                        collectionRef.doc(snapshot.data!.docs[index].id).update({
                          "desc" : "My note desc Updated!!"
                        });
                      }, icon: Icon(Icons.edit)),
                      IconButton(onPressed: (){}, icon: Icon(Icons.delete_outline)),
                    ],
                  ),
                ),
              );
            }) : Center(
              child: Text('No Notes yet'),
            );
          }
          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()async{

         var docRef = await collectionRef.add({
            "title" : "New note",
            "desc" : "My note desc"
          });

         print("Doc created : ${docRef.id}");

        },
        child: Icon(Icons.add),
      ),
    );
  }
}
