import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'state.dart';
import 'memo.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';


//todoアプリの流れとしては、入力した情報(state.dart)をmain.dartにてmarkdown方式で
//羅列する。データはfirebaseかsharedpr

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //  final wordPair = WordPair.random();
    return MaterialApp(
      title :'To do Application',
//      home: RandomWords(),
        home:Todo(),
      // child:Text(wordPair.asPascalCase),
    );
  }
}

class Todo extends StatefulWidget {
  Todo({Key key}) : super(key: key);

  @override
  TodoSentence createState() => new TodoSentence();
}

class TodoSentence extends State<Todo>{
  //List<Memo> memos = new List<Memo>();

  List<String> todoitem = new List<String>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text('To do Application'),
      ),
      body: _list(),
      //todoにいくボタン
      floatingActionButton: new FloatingActionButton.extended(
          icon: Icon(Icons.add_circle_outline),
          label: Text("To do"),
          onPressed: () {
            Memo newMemo = new Memo('');
            //pathをテキスト入力画面
            Navigator.push(context,
                new MaterialPageRoute<Null>(
                    settings: const RouteSettings(name: "/state"),
                    builder: (BuildContext context) =>
                    new MyTextFormViewState(newMemo)
                ));
          }
      ),
    );
  }


  @override
  Widget _list(){
    //for文でなく、listviewを用いてすべての要素を表現する
    return StreamBuilder<QuerySnapshot>(

      //firebaseを用いたlist

      stream: Firestore.instance.collection('message').snapshots(),
      builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
        if(snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch(snapshot.connectionState){
    case ConnectionState.waiting : return new Text("Loading,,,");
    default:
    final int mcount = snapshot.data.documents.length;
    return ListView.builder(
    itemCount: mcount,
    itemBuilder: (context,i){
    final DocumentSnapshot document = snapshot.data.documents[i];
      todoitem.add(document["message"]);//firebaseの値をmemoに代入

    return ListTile(
      title: Text(todoitem[i] ??'<No meddage retrieved>'),
      leading: const Icon(Icons.delete),
      onTap: ()=> _promptRemoveTodoItem(i,todoitem),
      // leading: new IconButton(icon: Icon(Icons.delete), onPressed:_delete(i)),
    );

    }
    );
        }
    }
    );
    }

    //削除機能を追加
    //i番目を削除
  void _promptRemoveTodoItem(int i, List<String> todoitem,){
    showDialog(context: context,
    builder: (BuildContext context){
      return new AlertDialog(
        title :Text("Mark" +todoitem[i] + "as done"),
        actions: <Widget>[
          new FlatButton(
              child: new Text("cancel"),
            onPressed: ()=>Navigator.of(context).pop,
          ),
          new FlatButton(
              onPressed:(){
          _removeItem(i,todoitem);
          Navigator.of(context).pop();
          },
              child: new Text("Delete")
          )
        ],
      );
    }
    );
  }

  //削除画面がうまくできない
  void _removeItem(int i , List<String> todoitem){
    Firestore.instance.collection("message").document(todoitem[i]).delete();
    setState(() =>
      todoitem.removeAt(i)
    );
  }



  }

  //memoを削除する
//        padding: const EdgeInsets.all(16.0),
//        itemCount: memos.length,
//        itemBuilder: (context,i){
//          final item = memos[i];
//
//          //memoを削除する
//          return new Dismissible(
//            onDismissed: (direction){
//              memos.removeAt(i);
//
//              Scaffold.of(context).showSnackBar(
//                new SnackBar(content: new Text("Memo dismissed"))
//              );
//            },
//          );




//class RandomWords extends StatefulWidget{
//  @override
//  RandomWordsState createState() =>new RandomWordsState();
//}
//
//class RandomWordsState extends State<RandomWords>{
//
//  final _suggestions = <WordPair>[];
//  final _biggerFont = const TextStyle(fontSize: 18.0);
//  final _saved = new Set<WordPair>();
//
//  //♡をした後の関数
//  void _pushSaved(){
//    Navigator.of(context).push( //ページ遷移
//        new MaterialPageRoute(
//            builder:(context){
//              final tiles = _saved.map(
//                      (pair){
//                    return new ListTile(
//                      title:new Text(
//                        pair.asPascalCase,
//                        style:_biggerFont,
//                      ),
//                    );
//                  }
//              );
//              final divided = ListTile.divideTiles(
//                  tiles: tiles,
//                  context: context
//              ).toList();
//
//              return new Scaffold(
//                  appBar: AppBar(
//                    title :new Text('saved Suggestions'),
//                  ),
//                  body: new ListView (children:divided)
//              );
//
//            }
//        )
//
//    );
//  }
//
//  Widget _buildSuggestions() {
//    return ListView.builder(
//        padding: const EdgeInsets.all(16.0),
//        itemBuilder: /*1*/ (context, i) {
//          if (i.isOdd) return Divider(); /*2*/
//
//          final index = i ~/ 2; /*3*/
//          if (index >= _suggestions.length) {
//            _suggestions.addAll(generateWordPairs().take(10)); /*4*/
//          }
//          return _buildRow(_suggestions[index]);
//        });
//  }
//
//  Widget _buildRow(WordPair pair) {
//    final alreadySaved = _saved.contains(pair);
//    return ListTile(
//      title: Text(
//        pair.asPascalCase,
//        style: _biggerFont,
//      ),
//      trailing: new Icon(
//        alreadySaved ?Icons.favorite:Icons.favorite_border,
//        color: alreadySaved?Colors.red:null,
//      ),
//      onTap: (){
//        setState(() {
//          if(alreadySaved){
//            _saved.remove(pair);
//          }else{
//            _saved.add(pair);
//          }
//        });
//      },
//    );
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text('Startup Name Generator'),
//        actions: <Widget>[
//          new IconButton(icon: Icon(Icons.list), onPressed:_pushSaved)
//        ],
//      ),
//      body: _buildSuggestions(),
//    );
//  }
//}
