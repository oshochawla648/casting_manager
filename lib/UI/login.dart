import 'package:casting_manager/UI/reusable_components/submit_button.dart';
import 'package:casting_manager/core/helper.dart';
import 'package:casting_manager/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/database_service.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final db = DatabaseService();
  String username;
  String error;
  bool loading = false;
  @override
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    // print(user.user);
    return Container(
      padding: EdgeInsets.all(20.0),
      child: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: <Widget>[
                TextField(
                  onChanged: (value) {
                    this.setState(() {
                      username = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'USERNAME',
                    labelStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                  ),
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SubmitButton(
                      label: 'SIGNIN',
                      onPressed: !isValidUsername(username)
                          ? null
                          : () async {
                              setState(() {
                                loading = true;
                              });
                              if (await db.login(username) == 'Error') {
                                this.setState(() {
                                  error = 'User is not registered';
                                });
                              } else {
                                user.updateUser(username);
                              }

                              setState(() {
                                loading = false;
                              });
                            },
                    ),
                    SizedBox(width: 20.0),
                    SubmitButton(
                      label: 'SIGNUP',
                      onPressed: !isValidUsername(username)
                          ? null
                          : () async {
                              setState(() {
                                loading = true;
                              });
                              if (await db.register(username) == 'Error') {
                                this.setState(() {
                                  error = 'User is already registered';
                                });
                              } else {
                                user.updateUser(username);
                              }

                              setState(() {
                                loading = false;
                              });
                            },
                    )
                  ],
                ),
                error != null ? Text(error) : Container()
              ],
            ),
    );
  }
}
