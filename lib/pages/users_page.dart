import 'package:chat/pages/login_page.dart';
import 'package:chat/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:chat/models/user_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


class UsersPage extends StatefulWidget {

  static final routeName = 'Users';

  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  final users = [
    User(uid: '1',name: 'Rodri',email: 'rodrigo@rodrigo.com',online: true),
    User(uid: '2',name: 'Leonel',email: 'leonel@rodrigo.com',online: false),
    User(uid: '3',name: 'Abel',email: 'abel@rodrigo.com',online: true),
    User(uid: '4',name: 'Otto',email: 'otto@rodrigo.com',online: true),
  ];

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthService>(context).user;
    return Scaffold(
      appBar: AppBar(
        title: Text(user.name,style: TextStyle(color: Colors.black),),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.exit_to_app_outlined,color: Colors.black),
          onPressed: (){
            //TODO: desconectarnos del socket server
            AuthService.deleteToken();
            Navigator.pushReplacementNamed(context, LoginPage.routeName);
          },
        ),
        actions: [
          Container(
            alignment: Alignment.center,
            margin:EdgeInsets.only(right:20),
            child: FaIcon(FontAwesomeIcons.plug, color: Colors.green),
          ),
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        header: WaterDropHeader(
          waterDropColor: Colors.blue,
          complete: Icon(FontAwesomeIcons.check,color: Colors.green,),
        ),
        onRefresh: _loadingUsers,
        child: ListView.separated(
          physics:BouncingScrollPhysics(),
          itemCount: users.length,
          separatorBuilder: (BuildContext context, int index) => Divider(),
          itemBuilder: (BuildContext context, int index) => UserItem(users[index]), 
        ),
      ),
    );
  }

  void _loadingUsers() async {
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }
}

class UserItem extends StatelessWidget {
  final User user;
  UserItem(this.user);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(user.name),
      subtitle: Text(user.email),
      leading: CircleAvatar(
        child: Text(user.name.substring(0,2)),
      ),
      trailing: Icon(Icons.online_prediction, color: (user.online)?Colors.green:Colors.red,),
    );
  }
}