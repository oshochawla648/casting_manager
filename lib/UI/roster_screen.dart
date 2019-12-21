import 'package:casting_manager/UI/reusable_components/transparent_button.dart';
import 'package:casting_manager/data/actor.dart';
import 'package:casting_manager/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:casting_manager/shared_state/user.dart';

class RosterScreen extends StatelessWidget {
  final db = DatabaseService();
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Roster'),
          actions: <Widget>[
            TransparentButton(
              onPressed: () => Navigator.pop(context),
              label: 'Actor & Actresses',
            )
          ],
        ),
        body: Container(
            child: StreamProvider<List<Actor>>.value(
          initialData: <Actor>[],
          value: db.roster(user.user),
          child: Rosters(),
        )),
      ),
    );
  }
}

class Rosters extends StatelessWidget {
  final db = DatabaseService();
  @override
  Widget build(BuildContext context) {
    List<Actor> actors = Provider.of<List<Actor>>(context);

    return actors == null
        ? Center(child: CircularProgressIndicator())
        : actors.length == 0
            ? Center(child: Text('Roster Empty'))
            : Padding(
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 25),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Name',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18.0),
                        ),
                        Text('Cost',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18.0))
                      ],
                    ),
                    SizedBox(height: 10.0),
                    Expanded(
                      child: ListView(
                        children: actors.map((actor) {
                          return Column(
                            children: <Widget>[
                              ListTile(
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      width: 40.0,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.red),
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.remove,
                                        ),
                                        color: Colors.black,
                                        onPressed: () {
                                          db.removeFromRoster(actor.id);
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Text(actor.name),
                                  ],
                                ),
                                trailing: Text(actor.cost),
                              ),
                              Divider(
                                thickness: 2.0,
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Total',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 20.0),
                          ),
                          Text(totalCost(actors).toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 20.0))
                        ])
                  ],
                ),
              );
  }

  int totalCost(List<Actor> actors) {
    int sum = 0;
    for (Actor actor in actors) {
      if (actor.cost != '' && actor.cost != null) {
        sum += double.parse(actor.cost).round();
      }
    }
    return sum;
  }
}
