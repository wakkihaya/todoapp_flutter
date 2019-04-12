import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'state.dart';
import 'memo.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';


//todoアプリの流れとしては、入力した情報(state.dart)をmain.dartにてmarkdown方式で
//羅列する。データはstreamかfirebase

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //  final wordPair = WordPair.random();
    return MaterialApp(
      title :'Todo',
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
  List<Memo> memos = new List<Memo>();


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title:Text('Todo'),
      ),
    body: _list(),
      //todoにいくボタン
      floatingActionButton: new FloatingActionButton(
          child:new Text('To do をかく'),
          onPressed: (){

            Memo newMemo = new Memo('');

            //pathをテキスト入力画面
            Navigator.push(context,
           new MaterialPageRoute<Null>(
              settings: const RouteSettings(name: "/state"),
              builder:(BuildContext context) => new MyTextFormViewState(newMemo)
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
    return ListTile(
      title: Text(document["message"]??'<No meddage retrieved>'),
    );
    }

    //コンパイルが通りません！


    //memoを削除する
//    return new Dismissible(
////    onDismissed: (direction){
////    document.removeAt(i);
////
////    Scaffold.of(context).showSnackBar(
////    new SnackBar(content: new Text("Memo dismissed"))
////    );
////    },
////    );
    );

    }

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
        }

    );

  }



}




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
