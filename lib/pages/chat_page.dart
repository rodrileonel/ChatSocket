import 'dart:io';

import 'package:chat/models/message.dart';
import 'package:chat/models/user_model.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/chat_service.dart';
import 'package:chat/services/socket.dart';
import 'package:chat/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ChatPage extends StatefulWidget {

  static final routeName = 'Chat';

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin{

  final _textControler = TextEditingController();
  bool writing = false;
  final _focus = FocusNode();
 
  List<ChatMessage> _items = [];

  User user;
  SocketService socketService;
  AuthService authService;
  ChatService chatService;

  @override
  void initState() {
    super.initState();
    this.socketService = Provider.of<SocketService>(context,listen: false);
    this.authService = Provider.of<AuthService>(context,listen: false);
    this.chatService = Provider.of<ChatService>(context,listen: false);

    user = chatService.userFrom;
    this.socketService.socket.on('message', _listenMessage);
    
    _loadingChat(this.chatService.userFrom.uid);
  }

  void _loadingChat(String uid) async {
    List<Message> chat = await this.chatService.getChat(uid);
    final history = chat.map((m) => ChatMessage(
      text: m.message, 
      uid: m.from,
      anim: AnimationController(vsync: this,duration: Duration(milliseconds:0))..forward(),
    ));
    setState(() {
      _items.insertAll(0, history);
    });
    
  }

  void _listenMessage(dynamic data){
    print(data['message']);
    ChatMessage msj = ChatMessage(
      text: data['message'],
      uid: data['from'],
      anim: AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 500),
      ),
    );
    setState(() {
      _items.insert(0, msj);
    });
    msj.anim.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(child: (user!=null)?Text('${user.name.substring(0,2)}'):Text('')),
            SizedBox(width:10),
            Expanded(child: (user!=null)? Text('${user.name}',style: TextStyle(color:Colors.black),):Text('')),
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
                decoration: InputDecoration.collapsed(
                  hintText: 'Enviar Mensaje'
                ),
                focusNode: _focus,
                onSubmitted: this.writing ? (_)=>_handleSubmit(_) : (_) => this._textControler.clear(),
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
                  onPressed: this.writing ?()=>_handleSubmit(this._textControler.text):null,
                )
                :IconButton(
                  splashColor: Colors.transparent, 
                  highlightColor: Colors.transparent, 
                  icon: Icon(Icons.send),
                  onPressed: this.writing ?()=>_handleSubmit(this._textControler.text):null,
                )
            )
          ],
        ),
      ),
    );
  }

  _handleSubmit(String text){
    this._textControler.clear();
    _focus.requestFocus();

    final message = ChatMessage(
      text: text, 
      uid: authService.user.uid,
      anim: AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 500),
      ),
    );

    this._items.insert(0, message);
    message.anim.forward();
    
    setState(() {writing = false;});

    //enviar mensaje al socket server
    this.socketService.socket.emit('message',{
      'from': authService.user.uid,
      'to': user.uid,
      'message':text
    });

  }

  @override
  void dispose() {
    for(ChatMessage message in _items)
      message.anim.dispose();
    _textControler.dispose();
    this.socketService.socket.off('message');
    super.dispose();
  }
}