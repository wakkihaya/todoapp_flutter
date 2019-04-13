import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/memo.dart';
import 'main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';


class MyTextFormViewState extends StatelessWidget {

  final Memo _memo;

  MyTextFormViewState(this._memo);

  final mycontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text('create todo'),
      ),
      body: new ListView(
          children: <Widget>[
            new TextField(
                maxLines: 3,
                decoration: new InputDecoration(
                    hintText: "write here"
                ),
                controller: mycontroller,
                //onChanged: (text) {
//                  Firestore.instance.collection('message').document().setData({
//                    'message': text,
//                  });
                //}

            ),



          Center(
            child: new Container(
              margin: const EdgeInsets.all(10.0),
              height: 75.0,
              width: 150.0,
              child: new FlatButton(
                  child: new Text('save memo'),
                  color: Colors.lightBlue,
                  textColor: Colors.white,
                  onPressed: () {
                    Firestore.instance.collection('message').document().setData({
                      'message': mycontroller.text,
                    });

                    Navigator.pop(context);
                  }),
            ),
          )
        ],
      ),
    );
  }
}