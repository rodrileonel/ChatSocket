import 'package:chat/helpers/show_alert.dart';
import 'package:chat/pages/register_page.dart';
import 'package:chat/pages/users_page.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/socket.dart';
import 'package:chat/widgets/input.dart';
import 'package:chat/widgets/login_register_button.dart';
import 'package:chat/widgets/logo.dart';
import 'package:chat/widgets/button_sign.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {

  static final routeName = 'Login';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height*0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:[
                Logo(),
                _Form(),
                LoginRegisterButton(
                  routeName: RegisterPage.routeName, 
                  label: '¿No tienes una cuenta?',
                  textButton: 'Crea una ahora!',
                ),
                SizedBox(height:50),
                Text('Términos y condiciones'),
              ]
            ),
          ),
        ),
      )
   );
  }
}

class _Form extends StatelessWidget {

  final emailController = TextEditingController();
  final passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal:40),
        child: Column(
          children:[
            Input(icon: Icons.email_outlined, placeholder: 'Email',controller: emailController,),
            SizedBox(height: 20,),
            Input(icon: Icons.lock_outlined, placeholder: 'Contraseña', controller: passController, hidden: true,),
            SizedBox(height: 30,),
            SignButton(
              label: 'Ingresar',
              press: authService.logeando ? null: () async {
                FocusScope.of(context).unfocus();
                final loginOK = await authService.login(emailController.text.trim(), passController.text);
                if(loginOK){
                  //conectar a socketserver
                  socketService.connect();
                  //navegar a la pantalla de usuarios
                  Navigator.pushReplacementNamed(context, UsersPage.routeName);
                }else{
                  showAlert(context, 'Login Incorrecto', 'Revisa tus credenciales ya vuelta');
                }
              },
            ),
          ]
        ),
      ),
    );
  }
}





