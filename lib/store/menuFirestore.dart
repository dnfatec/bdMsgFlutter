import 'package:flutter/material.dart';
import 'package:flutter_app_bdm/nossowidget/widget_button_custom.dart';
import 'package:flutter_app_bdm/nossowidget/widget_input.dart';
import 'package:flutter_app_bdm/nossowidget/widget_text_custom.dart';
import 'package:flutter_app_bdm/store/messageList.dart';
import 'package:flutter_app_bdm/store/messagesFirestore.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuFirestore extends StatefulWidget {
  String user = "";
  String friend = "";
  MenuFirestore (this.user, this.friend);
  @override
  _MenuFirestoreState createState() => _MenuFirestoreState();
}

class _MenuFirestoreState extends State<MenuFirestore> {
  String _friend = "";
  String _user = "";
  final _myuser = TextEditingController();
  final _myFriend  = TextEditingController();
  @override
  Widget build(BuildContext context) {
    _myuser.text = widget.user;
    _myFriend.text = widget.friend;
   // _loadUserSmartphone(context);
   // _loadLastFriendSmartphone(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Escolha a opção"),
        actions: [
          IconButton(
              onPressed: () { _saveUserSmartphone(context); },
                icon: Icon(
                Icons.person
                ),
          ),
          IconButton(
              onPressed: (){ _saveFriendSmartphone(context);},
              icon: Icon(
              Icons.supervised_user_circle
              ),
          )
        ],
      ),
      body: _menu(context),
    );
  }

  _menu(ctx) {

    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          BotoesCustom("Conversar", onPressed: () {
            _bdFirestore(ctx, MensagensFirestore(_myuser.text.toString(), _myFriend.text.toString()));
          }),
          TextosCustom("Seu usuário:", 18, Colors.black),
          ContainerInsere(_myuser, ""),
          TextosCustom("Com quem você quer conversar?", 18, Colors.black),
          ContainerInsere(_myFriend, ""),

          BotoesCustom("Histórico de mensagens", onPressed: () {
            _HistoricoFirestore(ctx, MessageList(_myuser.text.toString(), _myFriend.text.toString()));
          }),

        ],
      ),
    );
  }
//MessageList
  void _bdFirestore(BuildContext ctx, MensagensFirestore page) {
    Navigator.push(ctx, MaterialPageRoute(builder: (BuildContext context) {
      return page;
    }));
  }


  void _saveUserSmartphone(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('UserSmartphone', _myuser.text.toString());
    toast(context, "Usuário registrado", StyledToastPosition.center);
  }

  /*
  void _loadUserSmartphone(BuildContext ctx) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    _user = prefs.getString('UserSmartphone')!;
    //print("usuario"+ _user.toString());
    if (_user==null){
      _saveUserSmartphone(ctx);
    }
    else{
      setState(() {
        if (_myuser!=null)
        _myuser.text=_user;
      });
    }
  }*/


  void _saveFriendSmartphone(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('FriendSmartphone', _myFriend.text.toString());
    toast(context, "Amigo registrado", StyledToastPosition.center);
  }

  void _loadLastFriendSmartphone(BuildContext ctx) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    _friend = prefs.getString('FriendSmartphone')!;
    //print("usuario"+ _user.toString());
    if (_friend==null){
      _saveFriendSmartphone(ctx);
    }
    else{
      setState(() {
        _myFriend.text=_friend;
      });
    }
  }



  ContainerInsere(TextEditingController txt, String label)
  {
    return Container(
      color: Colors.transparent,
      margin: EdgeInsets.only(left: 5, right: 5, bottom: 0, top: 0),
      child: InputTextos("", "your user",controller: txt,),
      alignment: AlignmentDirectional.topStart,
    );
  }

  void _HistoricoFirestore(BuildContext ctx, MessageList page) {
    Navigator.push(ctx, MaterialPageRoute(builder: (BuildContext context) {
      return page;
    }));
  }


  toast(BuildContext context, String texto,  StyledToastPosition position) {
    showToast(texto,
      context: context,
      animation: StyledToastAnimation.scale,
      reverseAnimation: StyledToastAnimation.fade,
      position: position,
      animDuration: Duration(seconds: 1),
      duration: Duration(seconds: 3),
      curve: Curves.elasticOut,
      backgroundColor: Colors.redAccent,
      reverseCurve: Curves.linear,
    );
  }

}
