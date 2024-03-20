import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:text_copypaster/providers/equipments.dart';
import 'package:text_copypaster/screens/home.dart';
import 'package:window_size/window_size.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // DatabaseHelper data = DatabaseHelper();
  // await data.resetDatabase();
  // await data.clearDatabase();

  if (Platform.isWindows) {
    setWindowTitle('OS text-copypaster');
    setWindowMaxSize(const Size(2000, 2000));
    setWindowMinSize(const Size(1000, 1000));
  }

  runApp(ChangeNotifierProvider(
    create: (context) => EquipmentsRepository(),
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeData _currentTheme = ThemeData.light();

  void _toggleTheme() {
    setState(() {
      _currentTheme = _currentTheme == ThemeData.light()
          ? ThemeData.dark()
          : ThemeData.light();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tema Claro/Escurso',
      theme: _currentTheme,
      home: Home(toggleTheme: _toggleTheme),
    );
  }
}
