import 'package:chat/pages/login_page.dart';
import 'package:chat/pages/users_page.dart';
import 'package:chat/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoadingPage extends StatelessWidget {

  static final routeName = 'Loading';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Center();
        },
      ),
    );
  }

  Future checkLoginState(BuildContext context) async{
    final authService = Provider.of<AuthService>(context,listen: false);
    final auth = await authService.logged();
    if(auth){
      //TODO: conectar al socketserver
      Navigator.pushReplacementNamed(context, UsersPage.routeName);
    }else{
      Navigator.pushReplacementNamed(context, LoginPage.routeName);
    }
  }

}