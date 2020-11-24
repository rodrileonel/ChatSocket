import 'package:chat/helpers/show_alert.dart';
import 'package:chat/pages/login_page.dart';
import 'package:chat/pages/users_page.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/widgets/button_sign.dart';
import 'package:chat/widgets/input.dart';
import 'package:chat/widgets/login_register_button.dart';
import 'package:chat/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatelessWidget {

  static final routeName = 'Register';

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
                  routeName: LoginPage.routeName, 
                  label: '¿Ya tienes una cuenta?',
                  textButton: 'Ingresa ahora!',
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

  final userController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal:40),
        child: Column(
          children:[
            Input(icon: Icons.perm_identity_outlined, placeholder: 'Usuario',controller: userController,),
            SizedBox(height: 20,),
            Input(icon: Icons.email_outlined, placeholder: 'Email',controller: emailController,),
            SizedBox(height: 20,),
            Input(icon: Icons.lock_outlined, placeholder: 'Contraseña', controller: passController, hidden: true,),
            SizedBox(height: 30,),
            SignButton(
              label: 'Registrarse',
              press: authService.logeando ?null:() async {
                final msg = await authService.register(userController.text.trim(), emailController.text.trim(), passController.text);
                if(msg==true){
                  //TODO: conectar al socketserver
                  Navigator.pushReplacementNamed(context, UsersPage.routeName);
                }
                else
                  showAlert(context, 'Registro', msg);
              },
            ),
          ]
        ),
      ),
    );
  }
}

