import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_bdm/model/message.dart';
import 'package:flutter_app_bdm/model/stats.dart';
import 'package:flutter_app_bdm/nossowidget/widget_button_custom.dart';
import 'package:flutter_app_bdm/nossowidget/widget_input.dart';
import 'package:flutter_app_bdm/nossowidget/widget_text_custom.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'messageCard.dart';
class MensagensFirestore extends StatefulWidget {
String user;
String friend;
MensagensFirestore(this.user, this.friend);

  @override
  _MensagensFirestoreState createState() => _MensagensFirestoreState();
}

class _MensagensFirestoreState extends State<MensagensFirestore> {
  final _friend= TextEditingController();
  final _user = TextEditingController();
  final _msg = TextEditingController();
  final _qtdmsg = TextEditingController();
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



  //@override
  Future <void> inicializarFirebase() async {
    //super.initState();

    await Firebase.initializeApp();
    //Firebase.initializeApp().whenComplete(() => print("Conectado firebase"));
    FirebaseFirestore.instance.settings =
        Settings(cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);
  }

  @override
  Widget build(BuildContext context) {
    inicializarFirebase();
    _user.text=widget.user.toString();
    _friend.text=widget.friend.toString();
    //_buscaRegistro();
    //initState();
    //autFirebase();
    return Scaffold(
      appBar: AppBar(
        title: Text("Mensagens"),

      ),
      body: _body(),
    );
  }
  _body(){

    return ListView(
    padding: EdgeInsets.all(9),
    children: [
      TextosCustom("Conversas com seu amigo: "+ _friend.text , 16, Colors.redAccent),
      ContainerOldMessages(),
      TextosCustom(" ", 12, Colors.black),
      ContainerInsere(_msg, "","Digite a mensagem:"),
      ContainerInsere(_qtdmsg, "1","Digite a qtd. de  mensagens: " ),
      BotoesCustom("Enviar", onPressed:() {
        _clickSendFinal(context);
          }
        ),
      BotoesCustom("Receber", onPressed:() {
        _buscaRegistro(context);
      })
    ],
    );


  }


 Future <void> _send() async {
       var rng = new Random();
       var code = rng.nextInt(900000) + 100000;
       CollectionReference message = FirebaseFirestore.instance.collection("msg");
       Future<void> addMsg(){
       return message
           .doc(DateTime.now().toString()+code.toString())
           .set(ms.toJson())
           .then((value) => print("Mensagem adicionada"))
           .catchError((onError) => print("Erro ao gravar no banco $onError"));
       }
       await addMsg();
 }

  Future <void> _clickSendFinal(BuildContext ctx) async{
    await _clicksend(ctx);
    _saveStats(ctx,"insere");

  }

  Future <void> _clicksend(BuildContext ctx) async {
    ms.friend=_friend.text.toString().trim();
    ms.user=_user.text.toString().trim();
    ms.msg=_msg.text.toString().trim();
    ms.dt=DateTime.now();
    ms.idConversa=IdConversa();

    int conta=0;
    int contaAte=int.parse(_qtdmsg.text.trim());


    _initialTime = DateTime.now();
    while(conta < contaAte)
    {
      await _send();
      conta++;
    }
    print("conta envio:" + conta.toString());
    final now = DateTime.now();
    _elapsed = now.difference(_initialTime);
    tempo=_elapsed.toString();


    //_buscaRegistro();
    //_msg.text="";
    //_qtdmsg.text="1";


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


  ContainerInsere(TextEditingController txt, String label, String rotulo)
  {
    return Container(
      color: Colors.transparent,
      margin: EdgeInsets.only(left: 3, right: 3, bottom: 0, top: 0),
      child: InputTextos(rotulo, label,controller: txt,),
      alignment: AlignmentDirectional.topStart,
    );
  }


  Future <void> _buscaRegistro(BuildContext ctx) async{
    //print("user: " + _user.text);
    //print("_friend:"  + _friend.text);
    FirebaseFirestore.instance.settings =
        Settings(cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);

    var banco = FirebaseFirestore.instance.collection("msg");
    var filtronaColecao = banco;
    var consulta;

    FirebaseFirestore.instance.settings =
        Settings(cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);

    _initialTime = DateTime.now();
    consulta = await filtronaColecao
         .where("idConversa", isEqualTo: IdConversa())
         //.where("dt", isEqualTo: DateTime.now().hour - 8)
         .orderBy("dt", descending: true)
        .limit(int.parse(_qtdmsg.text.toString()));
        //.limit(15);

    result = await consulta.get();
    final now = DateTime.now();
    _elapsed = now.difference(_initialTime);
    tempo=_elapsed.toString();
    _saveStats(ctx, "read");


    setState(() {
      _resultsList = result.docs;
    });


    //print("qtd: "+_resultsList.length.toString());
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

  void _saveStats(BuildContext ctx, String tipo) {
    Stats stats = new Stats();
    stats.tempo= tempo.toString();
    stats.dt = DateTime.now();
    stats.qtdCaracteres = _msg.text.toString().trim().length.toString();
    stats.qtdMsg = _qtdmsg.text;
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

  String IdConversa() {
    if (_friend.text.trim().compareTo(_user.text.trim()) < 0){
      return widget.friend.trim()+widget.user.trim() ;
    }
    else
      return widget.user.trim() + widget.friend.trim();

  }
}
