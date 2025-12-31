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

  // ===== METODOS DE CATALOGO (CRUD) =====
  bool nombreExiste(String nombre) {
    // ⭐
    final n = nombre.trim().toLowerCase();
    return _catalogo.any((p) => p.nombre.trim().toLowerCase() == n);
  }

  void cargarDemo() {
    if (_catalogo.isNotEmpty) return;
    /*           
'https://static.nike.com/a/images/t_web_pdp_936_v2/f_auto/2a3b1721-2428-498b-ab17-f962ff6294d1/NIKE+COURT+LEGACY+%28PSV%29.png',
          'https://static.nike.com/a/images/t_web_pdp_936_v2/f_auto/73bfd1aa-6841-421f-9d4f-e0253cd1da0e/WMNS+NIKE+DUNK+LOW.png',
          'https://b2cimpulsmx.vtexassets.com/arquivos/ids/376024-800-800?v=638716165441400000&width=800&height=800&aspect=true', */
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
