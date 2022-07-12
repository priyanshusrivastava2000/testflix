import 'package:flutter/material.dart';

showLoaderDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 15),
    content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const CircularProgressIndicator(
          backgroundColor: Colors.transparent,
          color: Colors.white,
        ),
        Container(margin: EdgeInsets.only(left: 0), child: Text("Loading")),
      ],
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
