import 'package:flutter/material.dart';
import 'package:chat_app/pages/home.dart';

void main() => runApp(MyApp());

final ThemeData iOSTheme = ThemeData(
  primarySwatch: Colors.orange,
  primaryColor: Colors.grey[100],
  primaryColorBrightness: Brightness.light
);

final ThemeData defaultTheme = ThemeData(
  primarySwatch: Colors.purple,
  accentColor: Colors.orangeAccent[400],
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat',
      home: HomePage(),
      theme: Theme.of(context).platform == TargetPlatform.iOS ? iOSTheme : defaultTheme,
      debugShowCheckedModeBanner: false,
    );
  }
}
