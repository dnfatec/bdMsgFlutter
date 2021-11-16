import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_bdm/nossowidget/widget_button_custom.dart';
import 'package:flutter_app_bdm/nossowidget/widget_text_custom.dart';
import 'package:flutter_app_bdm/store/menuFirestore.dart';
import 'package:flutter_app_bdm/store/messagesFirestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Menu extends StatefulWidget {

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  String tempo="";
  late DateTime _initialTime;
  // 1. declare a Timer
  late final Timer _timer;
  String _user = "";
  String _friend = "";
  Duration _elapsed = Duration.zero;
  @override
  Widget build(BuildContext context) {
    _loadUserSmartphone();
    _loadLastFriendSmartphone();
    return Scaffold(
      appBar: AppBar(
        title: Text("Escolha o banco"),
      ),
      body: _menu(context),
    );
  }

  _menu(ctx) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BotoesCustom("Firestore", onPressed: (){
            _bdFirestore(ctx, MenuFirestore(_user, _friend));
          }),
          BotoesCustom("Realtime", onPressed: _bdRealtime),
          //BotoesCustom("Iniciar", onPressed: _testeIniciar),
          //BotoesCustom("Fechar", onPressed: _testeFechar),
          //TextosCustom(tempo, 18, Colors.redAccent)
        ],
      ),
    );
  }

  void _bdFirestore(BuildContext ctx, MenuFirestore page) {
    Navigator.push(ctx, MaterialPageRoute(builder: (BuildContext context)
    {
      return page;
    }));
  }

  void _bdRealtime() {
  }

  void _testeIniciar() {
    _initialTime = DateTime.now();
  }

  void _testeFechar() {
     final now = DateTime.now();
    _elapsed = now.difference(_initialTime);
    setState(() {
      tempo=_elapsed.toString();
    });

  }



  void _loadUserSmartphone() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    _user = prefs.getString('UserSmartphone')!;
    //print("usuario"+ _user.toString());

  }

  void _loadLastFriendSmartphone() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    _friend = prefs.getString('FriendSmartphone')!;
    //print("usuario"+ _user.toString());

  }



}
