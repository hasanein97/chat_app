import 'package:chat_app/models/user_models.dart';
import 'package:chat_app/screens/auth_screen.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
Future<Widget>userSignIn()async{
  User? user = FirebaseAuth.instance.currentUser;
  if(user !=null){
    DocumentSnapshot userData = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    UserModel userModel = UserModel.fromjson(userData);
    return HomeScreen(userModel);
  }else{
    return AuthScreen();
  }
}
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: userSignIn(),
        builder:(context,AsyncSnapshot<Widget>snapshot){
          if(snapshot.hasData){
            return snapshot.data!;
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } ,
      ),



    );
  }
}
