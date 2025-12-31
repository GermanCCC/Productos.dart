import 'package:flutter/material.dart';
import 'package:prueba/models/producto.dart';

class Productos extends ChangeNotifier {
  // Fuente de datos (catálogo completo)
  final List<Producto> _catalogo = [];

  // Estado de UI (filtros)
  String _busqueda = '';
  String _categoria = 'Todo';

  // ===== GETTERS =====

  List<Producto> get catalogo => List.unmodifiable(_catalogo);

  String get busqueda => _busqueda;
  String get categoria => _categoria;

  /// Categorías disponibles (basado en lo que exista en el catálogo)
  List<String> get categorias {
    final set = <String>{'Todo'};
    for (final p in _catalogo) {
      set.add(p.categoria);
    }
    return set.toList();
  }

  /// Lista ya filtrada (la que se pinta en Home)
  List<Producto> get productosFiltrados {
    final q = _busqueda.trim().toLowerCase();

    return _catalogo.where((p) {
      final okCat = _categoria == 'Todo' || p.categoria == _categoria;
      final okQ =
          q.isEmpty ||
          p.nombre.toLowerCase().contains(q) ||
          p.marca.toLowerCase().contains(q) ||
          p.sku.toLowerCase().contains(q);
      return okCat && okQ;
    }).toList();
  }

  // ===== REGLAS / HELPERS =====

  bool nombreExiste(String nombre) {
    final n = nombre.trim().toLowerCase();
    return _catalogo.any((p) => p.nombre.trim().toLowerCase() == n);
  }

  bool categoriaExiste(String categoria) {
    final c = categoria.trim().toLowerCase();
    return _catalogo.any((p) => p.categoria.trim().toLowerCase() == c);
  }

  String obtenerCategoriaFinal(String categoria) {
    final c = categoria.trim().toLowerCase();

    for (final p in _catalogo) {
      if (p.categoria.trim().toLowerCase() == c) {
        return p.categoria; // reutiliza formato existente
      }
    }

    final limpia = categoria.trim();
    if (limpia.isEmpty) return limpia;

    // Normalización simple: primera mayúscula + resto minúscula
    return limpia[0].toUpperCase() + limpia.substring(1).toLowerCase();
  }

  // ===== METODOS DE CATALOGO (CRUD) =====

  void cargarDemo() {
    if (_catalogo.isNotEmpty) return;

    _catalogo.addAll([
      Producto(
        imagen:
            'https://static.nike.com/a/images/t_web_pdp_936_v2/f_auto/63d90bf6-fcb9-46b7-bf62-a22453360218/NIKE+DUNK+LOW+%28PSE%29.png',
        id: '1',
        sku: 'SKU-001',
        nombre: 'Playera Oversize',
        marca: 'Genérica',
        categoria: 'Ropa',
        precioBase: 299,
        stock: 10,
        rating: 4.6,
      ),
      Producto(
        imagen:
            'https://static.nike.com/a/images/t_web_pdp_936_v2/f_auto/63d90bf6-fcb9-46b7-bf62-a22453360218/NIKE+DUNK+LOW+%28PSE%29.png',
        id: '2',
        sku: 'SKU-002',
        nombre: 'Tenis mogolos',
        marca: 'Genérica',
        categoria: 'Tenis',
        precioBase: 299,
        stock: 10,
        rating: 4.6,
      ),
    ]);

    notifyListeners();
  }

  void agregar(Producto producto) {
    _catalogo.add(producto);
    notifyListeners();
  }

  void eliminarPorId(String id) {
    _catalogo.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  void actualizar(Producto productoActualizado) {
    final i = _catalogo.indexWhere((p) => p.id == productoActualizado.id);
    if (i == -1) return;

    _catalogo[i] = productoActualizado;
    notifyListeners();
  }

  Producto? buscarPorId(String id) {
    for (final p in _catalogo) {
      if (p.id == id) return p;
    }
    return null;
  }

  // ===== METODOS DE FILTRO =====

  void setBusqueda(String value) {
    _busqueda = value;
    notifyListeners();
  }

  void setCategoria(String value) {
    _categoria = value;
    notifyListeners();
  }

  void limpiarFiltros() {
    _busqueda = '';
    _categoria = 'Todo';
    notifyListeners();
  }
}
