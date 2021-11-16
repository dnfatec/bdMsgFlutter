import 'dart:io';
import 'dart:io' as io;
import 'dart:convert' show Utf8Codec, utf8;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';

import 'dart:async';
import 'package:flutter_app_bdm/model/message.dart';


Widget buildMessageCard(BuildContext context, DocumentSnapshot document, String friend ) {
  final messages = Message.fromSnapshot(document);

  return new Container(
      child: Card(
        child: InkWell(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: <Widget>[
                Padding(

                  padding: const EdgeInsets.only(top: 1.0, bottom: 1.0),
                  child: Wrap(
                    //Vertical || Horizontal
                      children: <Widget>[
                        Text(
                          "Enviado por: "+  messages.user + " Data: " + messages.dt.day.toString() +"/"+ messages.dt.month.toString()+"/"+messages.dt.year.toString()+" " + messages.dt.hour.toString() + ":" + messages.dt.minute.toString() + ":" + messages.dt.second.toString()+":"+ messages.dt.millisecond.toString() ,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: new TextStyle(
                              backgroundColor: Colors.black12,
                              fontSize: 9.0,
                              fontWeight: FontWeight.bold,
                              decorationStyle: TextDecorationStyle.wavy
                          ),
                        )
                      ]
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 1.0, bottom: 1.0),
                  child: Wrap(
                    runAlignment: WrapAlignment.start,
                    alignment: WrapAlignment.spaceAround,
                    children: [
                        Text(
                          messages.msg,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 14,

                        )
                      ],
                  )
                ),

              ],
            ),
          ),
          onTap: (){
            //_abreOutraTela(context, Pedido_Usuario(listUser: [], card: cardapio,));
            //_abreOutraTela(context, PedidoRestaurante(pedido: pedido));
          },
          onDoubleTap: (){
            print("Double tap");

          },
          onTapCancel: (){

          },
          onLongPress: (){
            print("Segurar");
          },

        ),
      ));


}


