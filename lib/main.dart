// import 'package:casting_manager/data/actor.dart';
import 'package:casting_manager/UI/login.dart';
import 'package:casting_manager/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:provider/provider.dart';

import 'UI/home_screen.dart';
import 'UI/add_new_actor_screen.dart';
import 'UI/roster_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<User>(
      create: (context) => User(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => HomeScreen(),
          '/roster': (context) => RosterScreen(),
          '/newActor': (context) => AddNewActorScreen(),
          '/login': (context) => SignupPage(),
        },
      ),
    );
  }
}
