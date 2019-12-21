import 'package:casting_manager/UI/reusable_components/submit_button.dart';
import 'package:casting_manager/data/actor.dart';
import 'package:casting_manager/services/database_service.dart';
import 'package:casting_manager/shared_state/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AvailableActors extends StatelessWidget {
  final db = DatabaseService();
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    List<Actor> actors = Provider.of<List<Actor>>(context);
    return actors == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Padding(
            padding: EdgeInsets.all(15.0),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: actors.length == 0
                      ? Center(child: Text('No available actors'))
                      : ListView(
                          children: actors.map(
                          (Actor actor) {
                            return Column(
                              children: <Widget>[
                                ListTile(
                                  title: Text(actor.name),
                                  trailing: Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.red),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.add,
                                      ),
                                      color: Colors.white,
                                      onPressed: () async {
                                        db.addToRoster(actor.id, user.user);
                                      },
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(actor.cost),
                                      Text(actor.description)
                                    ],
                                  ),
                                ),
                                Divider(
                                  thickness: 2.0,
                                )
                              ],
                            );
                          },
                        ).toList()),
                ),
                SubmitButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/newActor');
                    },
                    label: 'New Actor'),
              ],
            ),
          );
  }
}
