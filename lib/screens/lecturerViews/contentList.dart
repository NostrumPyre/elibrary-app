import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elibrary_app/screens/lecturerViews/searchContentScreen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class contentList extends StatefulWidget {
  contentList({Key? key}) : super(key: key);

  @override
  State<contentList> createState() => _contentListState();
}

class _contentListState extends State<contentList> {
  final db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Content Manager"),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: db.collection('contents').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            
            return Container(
              child: ListView(
              
              children: snapshot.data!.docs.map((doc) {
                return ListTile(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.white, width: 0.5),
                    ),
                  //show the cover image
                  leading: Image.network(doc['cover']),
                  title: Text(doc['title']),
                  subtitle: Text(doc['author']),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    color: Colors.pink,
                    onPressed: () {
                      db.collection('contents').doc(doc.id).delete();
                      db.collection('contents').doc(doc.id).collection('files').get().then((value) {
                        for (var file in value.docs) {
                          db.collection('contents').doc(doc.id).collection('files').doc(file.id).delete();
                          FirebaseStorage.instance.ref().child(file.data()['path']).delete();
                        }
                      });
                    },
                  ),
                );
              }).toList(),
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => searchContentScreen()),
          );
        },
        child: const Icon(Icons.search),
        backgroundColor: Colors.green,
      ),
    );
  }
}
