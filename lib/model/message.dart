import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class Message{
  String idConversa="";
  String user="";
  String friend="";
  String msg="";
  DateTime dt=DateTime.now();


  Message();

  Map<String, dynamic> toJson() =>{
    'idConversa': idConversa,
    'user': user,
    'friend':friend,
    'msg': msg,
    'dt': dt
  };

Message.fromSnapshot(DocumentSnapshot snapshot):
      idConversa = snapshot['idConversa'],
      user = snapshot['user'],
      friend = snapshot['friend'],
      msg = snapshot['msg'],
      dt = snapshot['dt'].toDate();
}



