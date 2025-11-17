import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jobnexus/features/auth/repository/auth_local_repository.dart';
import 'package:jobnexus/features/auth/view/pages/login_page.dart';
import 'package:jobnexus/features/auth/viewmodal/auth_view_model.dart';
import 'package:jobnexus/main_page.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer();
  // await container.read(authViewModelProvider.notifier).initSharePreferences();

  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: LoginPage());
  }
}
