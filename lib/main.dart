import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_note_291/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
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
      home: HomePage(),
    );
  }
}


class HomePage extends StatelessWidget {
  FirebaseFirestore firestore = FirebaseFirestore.instance;


  @override
  Widget build(BuildContext context) {

    var collectionRef = firestore.collection("notes");

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
