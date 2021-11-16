import 'package:flutter/material.dart';
class BotoesCustom extends StatelessWidget {
  final String texto;
  final void Function() onPressed;
  BotoesCustom (this.texto, {required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(20),
            side: BorderSide(color: Colors.white)
        ),
        color:Colors.redAccent,
        child: Text(
          texto,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        onPressed: onPressed);
  }
}
