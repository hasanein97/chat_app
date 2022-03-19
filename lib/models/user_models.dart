import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class UserModel{
  String email;
  String name;
  String image;
  Timestamp date;
  String uid;

  UserModel({
    required this.email,
    required this.uid,
     required this.date,
    required this.image,
    required this.name,
});
factory UserModel.fromjson(DocumentSnapshot snapshot){
  return UserModel(
    email: snapshot['email'],
    name: snapshot['name'],
    image: snapshot['image'],
    date: snapshot['date'],
    uid: snapshot['uid'],
  );
}

}