import 'package:casting_manager/UI/login.dart';
import 'package:casting_manager/UI/reusable_components/tap_button.dart';
import 'package:casting_manager/data/actor.dart';
import 'package:casting_manager/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../user.dart';
import 'available_actors.dart';

class HomeScreen extends StatelessWidget {
  final db = DatabaseService();
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

    return SafeArea(
      child: Scaffold(
        appBar: !isLoggedIn(user.user)
            ? AppBar(
                title: Text('Casting Manager'),
              )
            : AppBar(
                title: Text('Casting Manager'),
                actions: <Widget>[
                  TransparentButton(
                      label: 'Roster',
                      onPressed: () => Navigator.pushNamed(context, '/roster')),
                  TransparentButton(
                      label: 'Logout', onPressed: () => user.logout()),
                ],
              ),
        body: !isLoggedIn(user.user)
            ? SignupPage()
            : StreamProvider<List<Actor>>.value(
                initialData: <Actor>[],
                value: db.availableActors,
                child: AvailableActors(),
              ),
      ),
    );
  }

  bool isLoggedIn(String user) {
    return user != '' && user != null;
  }
}
