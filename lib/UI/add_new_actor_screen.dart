import 'package:casting_manager/UI/reusable_components/submit_button.dart';
import 'package:casting_manager/core/helper.dart';
import 'package:casting_manager/data/actor.dart';
import 'package:casting_manager/services/database_service.dart';
import 'package:flutter/material.dart';

class AddNewActorScreen extends StatefulWidget {
  @override
  _AddNewActorScreenState createState() => _AddNewActorScreenState();
}

class _AddNewActorScreenState extends State<AddNewActorScreen> {
  final db = DatabaseService();
  String name;
  String cost;
  String description;
  bool nameError = false;
  bool costError = false;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    bool isAvailable = true;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Casting Manager'),
        ),
        body: loading
            ? Center(child: CircularProgressIndicator())
            : Container(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    Field(
                      label: 'NAME',
                      onChanged: (value) {
                        setState(() {
                          name = value;
                        });
                      },
                    ),
                    Field(
                      label: 'COST',
                      onChanged: (value) {
                        setState(() {
                          cost = value;
                        });
                      },
                    ),
                    Field(
                      label: 'DESCRIPTION',
                      onChanged: (value) {
                        description = value;
                      },
                    ),
                    SubmitButton(
                      onPressed: () async {
                        setState(() {
                          nameError = !isValidName(name);
                          costError = !isValidCost(cost);
                        });

                        if (!nameError && !costError) {
                          setState(() {
                            loading = true;
                          });

                          await db.addNewActor(
                            Actor(
                                name: name,
                                cost: cost,
                                description: description,
                                isAvailable: isAvailable),
                          );
                          setState(() {
                            loading = false;
                          });
                          Navigator.pop(context);
                        }
                      },
                      label: 'Submit',
                    ),
                    Column(
                      children: <Widget>[
                        nameError ? Text('Name is not valid') : Container(),
                        costError ? Text('Cost is not valid') : Container(),
                      ],
                    )
                  ],
                ),
              ),
      ),
    );
  }
}

class Field extends StatelessWidget {
  const Field(
      {Key key, @required this.onChanged, @required this.label, this.error})
      : super(key: key);
  final onChanged;
  final String label;
  final String error;
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        errorText: error,
        labelText: label,
        labelStyle: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            color: Colors.grey),
      ),
      onChanged: this.onChanged,
    );
  }
}
