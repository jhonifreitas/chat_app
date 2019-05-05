import 'package:flutter/material.dart';
import 'package:chat_app/components/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_app/components/text_composer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool isiOS(){
    return Theme.of(context).platform == TargetPlatform.iOS;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Grupo'),
          centerTitle: true,
          elevation: this.isiOS() ? 0 : 4,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: StreamBuilder(
                stream: Firestore.instance.collection('messages').snapshots(),
                builder: (context, snapshot) {
                  switch(snapshot.connectionState){
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Center(child: CircularProgressIndicator());
                    default:
                      List reverse = snapshot.data.documents.reversed.toList();
                      return ListView.builder(
                        reverse: true,
                        itemCount: reverse.length,
                        itemBuilder: (context, index) {
                          return MessageComponent(reverse[index].data);
                        },
                      );
                  }
                },
              ),
            ),
            Divider(height: 1,),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
              ),
              child: TextComposer(),
            )
          ],
        ),
      ),
    );
  }
}
