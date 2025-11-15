import 'package:flutter/material.dart';

Route<dynamic> generateRouter(RouteSettings settings) {
  switch (settings.name) {
    default:
      return MaterialPageRoute(
        builder: (context) => Scaffold(body: Text("Invalid Error")),
      );
  }
}
