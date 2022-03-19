import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../main.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  GoogleSignIn googleSignIn = GoogleSignIn();
  FirebaseFirestore firestore =FirebaseFirestore.instance;

  Future sigInFunction()async {
    GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if(googleUser ==null){
      return;
    }
    final googleAuth =await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    DocumentSnapshot userExist = await firestore.collection('users').doc(userCredential.user!.uid).get();
    if (userExist.exists){
      print("User Already Exists in Database");
    }else{
      await firestore.collection('users').doc(userCredential.user!.uid).set({
        'email':userCredential.user!.email,
        'name':userCredential.user!.displayName,
        'image':userCredential.user!.photoURL,
        'uid':userCredential.user!.uid,
        'date':DateTime.now(),
      });
    }
    Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context)=> MyApp()), (route) => false);
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT2VjlDZ3ZSuRlGegcW1AvoBF2D9USwn4YtiA&usqp=CAU"),
                  ),
                ),
              ),
            ),
            const Text(
              "flutter chat app",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
              child: ElevatedButton(
                onPressed: ()async {
                  await sigInFunction();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      'https://blog.hubspot.com/hubfs/image8-2.jpg',
                      height: 36,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text('Sign in with Google',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    ),
                  ],
                ),style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.black),
                padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 12,),),
              ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
