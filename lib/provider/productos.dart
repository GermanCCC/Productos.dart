import 'package:flutter/material.dart';

class Productos extends ChangeNotifier {
  final List<String> _productos = [];

  List<String> get productos => List.unmodifiable(_productos);

  void agregarProducto(String producto) {
    _productos.add(producto);
    notifyListeners();
  }

  void eliminarProducto(String producto) {
    _productos.remove(producto);
    notifyListeners();
  }
}
