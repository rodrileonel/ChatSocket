import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  
  final String text;
  final String uid;
  final AnimationController anim;

  const ChatMessage({
    @required this.text, 
    @required this.uid,
    this.anim
  });

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: CurvedAnimation(parent: anim,curve: Curves.easeOut),
      child: Align(
        alignment: (this.uid =='1')?Alignment.topRight:Alignment.topLeft,
        child: Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(top:5,bottom:5,left:(this.uid =='1')?50:10,right: (this.uid =='1')?10:50),
          decoration: BoxDecoration(
            color:(this.uid =='1')?Colors.blueAccent:Colors.green,
            borderRadius: BorderRadius.circular(20)
          ),
          child: Text(this.text,style: TextStyle(color:Colors.white),),
        ),
      ),
    );
  }
}