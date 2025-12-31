import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prueba/components/product_card.dart';
import 'package:prueba/provider/productos.dart';
import 'package:uuid/uuid.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // * Variables y controladores
  final _form = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController(); // ⭐

  // * Funciones
  void _agregarProductos(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Agregar Producto'),
          content: Form(
            key: _form,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nombreCtrl,
                  decoration: InputDecoration(labelText: 'Nombre del producto'),
                  validator: (Nombre) {
                    if (Nombre == null || Nombre.trim().isEmpty) {
                      return 'No mames we';
                    }
                    if (Nombre.length > 50) {
                      return 'Muy largo we';
                    }
                    if (Nombre.length < 3) {
                      return 'Muy corto we';
                    }
                    // ⭐ VALIDACIÓN DE NOMBRE EXISTENTE
                    final existe = context.read<Productos>().nombreExiste(
                      Nombre,
                    );
                    if (existe) {
                      return 'Ya existe we';
                    }

                    return null;
                  },
                ),

                TextFormField(
                  decoration: InputDecoration(labelText: 'Marca'),
                  validator: (Marca) {
                    if (Marca == null ||
                        Marca.trim().isEmpty ||
                        Marca.length < 3 ||
                        Marca.length > 20) {
                      return 'No mames we';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Categoría'),
                  validator: (Categoria) {
                    if (Categoria == null || Categoria.trim().isEmpty) {
                      return 'No mames we';
                    }
                    // ⭐ Normaliza texto de categoría
                    String _normalizarCategoria(String categoria) {
                      final c = categoria.trim().toLowerCase();
                      if (c.isEmpty) return c;

                      // Primera letra en mayúscula (opcional, estética)
                      return c[0].toUpperCase() + c.substring(1);
                    }

                    // ⭐ Verifica si la categoría ya existe (ignora mayúsculas)
                    bool categoriaExiste(String categoria) {
                      final c = categoria.trim().toLowerCase();
                      return _catalogo.any(
                        (p) => p.categoria.trim().toLowerCase() == c,
                      );
                    }

                    // ⭐ Devuelve la categoría correcta (existente o nueva)
                    String obtenerCategoriaFinal(String categoria) {
                      final c = categoria.trim().toLowerCase();

                      for (final p in _catalogo) {
                        if (p.categoria.trim().toLowerCase() == c) {
                          return p.categoria; // ya existe → reutiliza
                        }
                      }

                      // no existe → se crea normalizada
                      return _normalizarCategoria(categoria);
                    }

                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Precio'),
                  validator: (precio) {
                    if (precio == null || precio.trim().isEmpty) {
                      return 'No mames we';
                    }
                    if (precio.contains(RegExp(r'[A-Za-z]'))) {
                      return 'Solo numeros we';
                    }
                    final p = double.tryParse(precio.replaceAll(',', '.'));
                    if (p == null) {
                      return 'Solo numeros we';
                    }
                    if (p <= 0) {
                      return 'no lo regales we';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            SizedBox(width: 100),
            TextButton(onPressed: _submitForm, child: const Text('Aceptar')),
          ],
        );
      },
    );
  }

  void _submitForm() {
    if (_form.currentState!.validate() == false) return;
    final uuid = Uuid();
    print(uuid.v4());

    print('validanding');
    print('que peo we');
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<Productos>();
    final productos = prov.productosFiltrados;
    final categorias = prov.categorias;

    return Scaffold(
      appBar: AppBar(title: const Text('Tienda')),
      body: Column(
        children: [
          // Buscador
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: prov.setBusqueda,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Buscar productos…',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add_box_outlined),
                  onPressed: () => _agregarProductos(context),
                ),
              ),
            ),
          ),

          // Categorías
          SizedBox(
            height: 44,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              scrollDirection: Axis.horizontal,
              itemCount: categorias.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final c = categorias[i];
                return ChoiceChip(
                  label: Text(c),
                  selected: c == prov.categoria,
                  onSelected: (_) => prov.setCategoria(c),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          // Grid
          Expanded(
            child: productos.isEmpty
                ? const Center(
                    child: Text('No hay productos con esos filtros.'),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(2),
                    itemCount: productos.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          // childAspectRatio: 1.5,
                        ),

                    itemBuilder: (context, i) {
                      final p = productos[i];
                      return ProductCard(
                        p: p,
                        onTap: () {}, // detalle lo metemos después
                        onAdd: () {}, // carrito lo metemos después
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
