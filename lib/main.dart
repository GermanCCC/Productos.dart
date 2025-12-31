import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prueba/provider/productos.dart';
import 'package:prueba/views/home.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => Productos()..cargarDemo(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Productos App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
