import 'package:flutter/material.dart';

class Input extends StatelessWidget {

  final String placeholder;
  final IconData icon;
  final bool hidden;
  final TextEditingController controller;

  const Input({this.placeholder, this.icon,this.controller, this.hidden = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right:20,left:5,top:5,bottom:5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: Offset(0,5),
            blurRadius: 5
          )
        ]
      ),
      child: TextField(
        controller: this.controller,
        autocorrect: false,
        obscureText: hidden,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          prefixIcon: Icon(this.icon),
          hintText: this.placeholder,
          focusedBorder: InputBorder.none,
          border: InputBorder.none
        ),
      ),
    );
  }
}