import 'dart:io';

import 'package:chat/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ChatPage extends StatefulWidget {

  static final routeName = 'Chat';

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin{

  final _textControler = TextEditingController();
  bool writing = false;
  final focus = FocusNode();

  final _items = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(child: Text('Ro'),),
            SizedBox(width:10),
            Text('Rodrigo',style: TextStyle(color:Colors.black),),
          ]
        ),
        elevation: 1,
        backgroundColor: Colors.white,
      ),
      body: Container(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                reverse: true,
                itemCount: this._items.length,
                itemBuilder: (BuildContext context, int index) {
                  return _items[index];
                },
              ),
            ),
            Divider(height:2),
            _inputChat(),
          ],
        ),
     ),
   );
  }

  Widget _inputChat(){
    return SafeArea(
      child: Container(
        height: 50,
        margin: EdgeInsets.all(8),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textControler,
                decoration: InputDecoration(
                  hintText: 'Enviar Mensaje'
                ),
                focusNode: this.focus,
                onSubmitted: this.writing ? (_)=>_handleSubmit(_,'1') : (_) => this._textControler.clear(),
                onChanged: (text){
                  if(text.trim().length!=0) writing = true;
                  else writing = false;
                  setState(() {});                  
                },
              ),
            ),
            Container(
              child: Platform.isIOS
                ?CupertinoButton(
                  child: Text('Enviar'), 
                  onPressed: this.writing ?()=>_handleSubmit(this._textControler.text,'1'):null,
                )
                :IconButton(
                  splashColor: Colors.transparent, 
                  highlightColor: Colors.transparent, 
                  icon: Icon(Icons.send),
                  onPressed: this.writing ?()=>_handleSubmit(this._textControler.text,'1'):null,
                )
            )
          ],
        ),
      ),
    );
  }

  _handleSubmit(String text,String uid){
    print(text);
    this._textControler.clear();
    this.focus.requestFocus();

    final message = ChatMessage(
      text: text, 
      uid: uid,
      anim: AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 500),
      ),
    );

    this._items.insert(0, message);
    message.anim.forward();
    
    setState(() {writing = false;});
  }

  @override
  void dispose() {
    // TODO: off del socket
    for(ChatMessage message in _items)
      message.anim.dispose();
    _textControler.dispose();
    super.dispose();
  }
}