import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({Key key, @required this.onPressed, @required this.label})
      : super(key: key);

  final Function onPressed;
  final String label;
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(18.0),
      ),
      disabledColor: Colors.lightGreen,
      color: Colors.green,
      onPressed: onPressed,
      child: Center(
        child: Text(
          label,
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat'),
        ),
      ),
    );
  }
}
