import 'package:flutter/material.dart';

void showSnackbar(String content, context) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(content)));
}
