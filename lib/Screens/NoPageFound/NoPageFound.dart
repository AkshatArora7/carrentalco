import 'package:flutter/material.dart';


class NoPageFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page Not Found'),
      ),
      body: Center(
        child: Text('Sorry, the page you requested was not found.'),
      ),
    );
  }
}