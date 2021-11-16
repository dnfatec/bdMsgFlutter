
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_bdm/model/message.dart';
import 'package:flutter_app_bdm/model/stats.dart';
import 'package:flutter_app_bdm/nossowidget/widget_text_custom.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

import 'messageCard.dart';
class MessageList extends StatefulWidget {

  String user;
  String friend;
  MessageList(this.user, this.friend);

  @override
  _MessageListState createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  late FirebaseAuth auth ;
  late UserCredential userCredential;
  List _resultsList = [];
  Message ms = new Message();
  late QuerySnapshot result;


  String tempo="";
  late DateTime _initialTime;
  // 1. declare a Timer
  late final Timer _timer;
  Duration _elapsed = Duration.zero;

  @override
  Future <void> autFirebase() async
  {
    auth = FirebaseAuth.instance;
    //userCredential = await FirebaseAuth.instance.signInAnonymously();
    userCredential = await FirebaseAuth.instance.signInAnonymously();
    print(userCredential.credential.toString());
  }


  Future <void> inicializarFirebase() async {
    await Firebase.initializeApp();
    Firebase.initializeApp().whenComplete(() => print("Conectado firebase"));
  }


  @override
  Widget build(BuildContext context) {
    inicializarFirebase();
    return Scaffold(
    appBar: AppBar(
    title: Text("Lista conversas"),
    actions: [
      IconButton(
        onPressed:() {_buscaRegistro(context);},
        icon: Icon(Icons.one_k),
      ),
      IconButton(
        onPressed:() {_buscaRegistro2(context);},
        icon: Icon(Icons.four_k),
      ),
      IconButton(
          onPressed:() {_buscaRegistro8(context);},
          icon: Icon(Icons.eight_k)
      )
    ],
    ),
    body: _lista(),
    );
  }




  _lista() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _resultsList.length==null?0:_resultsList.length,
      itemBuilder: (BuildContext ctx, int index) =>
          buildMessageCard(ctx, _resultsList[index], widget.friend),
    );
}


ContainerOldMessages()
{
return Container(
        color: Colors.transparent,
        height: 270,
        width: double.maxFinite,
        margin: EdgeInsets.only(left: 3, right: 3, bottom: 0, top: 0),
        child: ListView.builder(
        shrinkWrap: true,
        itemCount: _resultsList.length==null?0:_resultsList.length,
        itemBuilder: (BuildContext ctx, int index) =>
        buildMessageCard(ctx, _resultsList[index], widget.friend),
)
);
}


Future <void> _buscaRegistro(BuildContext ctx) async{
  var banco = FirebaseFirestore.instance.collection("msg");
  var filtronaColecao = banco;
  var consulta;

  _initialTime = DateTime.now();


  consulta = await filtronaColecao
      .where("idConversa", isEqualTo: IdConversa())
      .orderBy("dt", descending: true)
      .limit(int.parse("10000"));

  result = await consulta.get();

  final now = DateTime.now();
  _elapsed = now.difference(_initialTime);
  tempo=_elapsed.toString();
  _saveStats(ctx, "read01");


  setState(() {
    _resultsList = result.docs;
  });
}

  Future <void> _buscaRegistro2(BuildContext ctx) async {
    var banco = FirebaseFirestore.instance.collection("msg");
    var filtronaColecao = banco;
    var consulta;

    _initialTime = DateTime.now();


    consulta = await filtronaColecao
        .where("idConversa", isEqualTo: IdConversa())
        .where("friend", isEqualTo: widget.friend)
        .orderBy("dt", descending: true)
        .limit(int.parse("10000"));

    result = await consulta.get();

    final now = DateTime.now();
    _elapsed = now.difference(_initialTime);
    tempo=_elapsed.toString();
    _saveStats(ctx, "read01");


    setState(() {
      _resultsList = result.docs;
    });
  }

  Future <void>_buscaRegistro8(BuildContext ctx) async {
    var banco = FirebaseFirestore.instance.collection("msg");
    var filtronaColecao = banco;
    var consulta;

    _initialTime = DateTime.now();


    consulta = await filtronaColecao
        .where("idConversa", isEqualTo: IdConversa())
        .where("friend", isEqualTo: widget.friend)
        .where("user", isEqualTo: widget.user)
        .where("dt", isGreaterThan: DateTime.now().day-5)
        .orderBy("dt", descending: true)
        .limit(int.parse("10000"));

    result = await consulta.get();

    final now = DateTime.now();
    _elapsed = now.difference(_initialTime);
    tempo=_elapsed.toString();
    _saveStats(ctx, "read01");


    setState(() {
      _resultsList = result.docs;
    });
  }

  String IdConversa() {
    if (widget.friend.compareTo(widget.user.trim()) < 0){
      return widget.friend.trim()+widget.user.trim() ;
    }
    else
      return widget.user.trim() + widget.friend.trim();

  }


  void _saveStats(BuildContext ctx, String tipo) {
    Stats stats = new Stats();
    stats.tempo= tempo.toString();
    stats.dt = DateTime.now();
    stats.qtdCaracteres = "read";
    stats.qtdMsg = "10000";
    stats.tipo = tipo;
    CollectionReference est = FirebaseFirestore.instance.collection("stats");
    Future<void> addSts(){
      return est
          .doc(stats.dt.toString().trim())
          .set(stats.toJson())
          .then((value) => print("Estatística adicionada"))
          .catchError((onError) => print("Erro ao gravar no banco $onError"));
    }
    addSts();
    toast(ctx, "Tempo: " + tempo.toString() ,StyledToastPosition.center  );
  }

  toast(BuildContext context, String texto,  StyledToastPosition position) {
    showToast(texto,
      context: context,
      animation: StyledToastAnimation.scale,
      reverseAnimation: StyledToastAnimation.fade,
      position: position,
      animDuration: Duration(seconds: 1),
      duration: Duration(seconds: 10),
      curve: Curves.elasticOut,
      backgroundColor: Colors.redAccent,
      reverseCurve: Curves.linear,
    );
  }
}
