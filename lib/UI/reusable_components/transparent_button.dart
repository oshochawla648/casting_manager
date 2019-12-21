import 'package:flutter/material.dart';

class TransparentButton extends StatelessWidget {
  final Function onPressed;
  final String label;

  const TransparentButton({Key key, this.onPressed, this.label})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      textColor: Colors.white,
      onPressed: this.onPressed,
      child: Text(this.label),
      shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
    );
  }
}
