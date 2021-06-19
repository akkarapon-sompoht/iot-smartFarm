import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;
  const Background({
    Key key,
    @required this.child,
  }) : super(key: key);

@override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget> [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
            image: AssetImage('assets/images/wpp.jpg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      child,
      ],
    );
  }
}