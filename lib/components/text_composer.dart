import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TextComposer extends StatefulWidget {
  @override
  _TextComposerState createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {

  final TextEditingController _msgCtrl = TextEditingController();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _disableButton = false;

  bool isiOS(){
    return Theme.of(context).platform == TargetPlatform.iOS;
  }

  Future ensureLoggedIn() async {
    GoogleSignInAccount user = _googleSignIn.currentUser;
    if(user == null)
      user = await _googleSignIn.signInSilently();
    if(user  == null)
      user = await _googleSignIn.signIn();
    if(await _auth.currentUser() == null){
      GoogleSignInAuthentication credential = await _googleSignIn.currentUser.authentication;
      await _auth.signInWithGoogle(idToken: credential.idToken, accessToken: credential.accessToken);
    }
  }

  _handleSubmitted(String text) async {
    await ensureLoggedIn();
    this._sendMessage(text: text);
  }

  void _sendMessage({String text, String imgUrl}) async {
    await Firestore.instance.collection('messages').add({
      'text': text,
      'imgUrl': imgUrl,
      'from': _googleSignIn.currentUser.displayName,
      'from_photo_url': _googleSignIn.currentUser.photoUrl
    });
    this._msgCtrl.clear();
    setState(() {
      this._disableButton = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: this.isiOS() ? this.buildBorder() : null,
        child: Row(
          children: <Widget>[
            Container(
              child: IconButton(
                icon: Icon(Icons.photo_camera),
                onPressed: (){},
              ),
            ),
            Expanded(
              child: TextField(
                controller: this._msgCtrl,
                decoration: InputDecoration(hintText: "Enviar uma mensagem"),
                onChanged: (value){
                  setState(() {
                    this._disableButton = value.length > 0;
                  });
                },
                onSubmitted: (value){
                  this._handleSubmitted(value);
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: buildButtonSend(), 
            )
          ],
        ),
      ),
    );
  }

  Widget buildButtonSend(){
    if(this.isiOS()){
      return CupertinoButton(
        child: Text('Enviar'),
        onPressed: this._disableButton ? (){this._handleSubmitted(this._msgCtrl.text);} : null,
      );
    }else{
      return IconButton(
        icon: Icon(Icons.send),
        onPressed: this._disableButton ? (){this._handleSubmitted(this._msgCtrl.text);} : null,
      );
    }
  }

  Decoration buildBorder(){
    return BoxDecoration(
      border: Border(top: BorderSide(color: Colors.grey[200]))
    );
  }
}
