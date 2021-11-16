import 'package:cloud_firestore/cloud_firestore.dart';

class Stats{

  String tempo="";
  String qtdMsg="";
  String qtdCaracteres="";
  DateTime dt=DateTime.now();
  String tipo="";

  Stats();

  Map<String, dynamic> toJson() =>{
    'tempo': tempo,
    'qtdMsg':qtdMsg,
    'qtdCaracteres': qtdCaracteres,
    'dt': dt,
    'tipo':tipo
  };

  Stats.fromSnapshot(DocumentSnapshot snapshot):
        tempo = snapshot['tempo'],
        qtdMsg = snapshot['qtdMsg'],
        qtdCaracteres = snapshot['qtdCaracteres'],
        tipo = snapshot['tipo'],
        dt = snapshot['dt'].toDate();
}