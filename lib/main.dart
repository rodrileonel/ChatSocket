import 'package:chat/pages/loading_page.dart';
import 'package:chat/routes/routes.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/chat_service.dart';
import 'package:chat/services/socket.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
 
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService(),),
        ChangeNotifierProvider(create: (_) => SocketService(),),
        ChangeNotifierProvider(create: (_) => ChatService(),),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: LoadingPage.routeName,
        routes: routes,
      ),
    );
  }
}