import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prueba/components/product_card.dart';
import 'package:prueba/models/producto.dart';
import 'package:prueba/provider/productos.dart';
import 'package:uuid/uuid.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // * Form + controllers (UI state)
  final _form = GlobalKey<FormState>();

  final _nombreCtrl = TextEditingController();
  final _marcaCtrl = TextEditingController();
  final _categoriaCtrl = TextEditingController();
  final _precioCtrl = TextEditingController();

  final _uuid = const Uuid();
  @override
  void dispose() {
    _nombreCtrl.dispose();
    _marcaCtrl.dispose();
    _categoriaCtrl.dispose();
    _precioCtrl.dispose();
    super.dispose();
  }

  // ===== Helpers UI =====

  void _limpiarCampos() {
    _nombreCtrl.clear();
    _marcaCtrl.clear();
    _categoriaCtrl.clear();
    _precioCtrl.clear();
  }

  void _abrirDialogAgregarProducto() {
    _limpiarCampos();

    showDialog<void>(
      context: context,
      builder: (dialogContext) => _buildAgregarProductoDialog(dialogContext),
    );
  }

  // ! Agregar para subir fotos
  //* ===== Formulario Agregar Producto =====
  AlertDialog _buildAgregarProductoDialog(BuildContext dialogContext) {
    return AlertDialog(
      title: const Text('Agregar Producto'),
      content: Form(
        key: _form,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildNombreField(),
            _buildMarcaField(),
            _buildCategoriaField(),
            _buildPrecioField(),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('Cancelar'),
        ),
        const SizedBox(width: 100),
        TextButton(
          onPressed: () => _submitForm(dialogContext),
          child: const Text('Aceptar'),
        ),
      ],
    );
  }

  TextFormField _buildNombreField() {
    return TextFormField(
      controller: _nombreCtrl,
      decoration: const InputDecoration(labelText: 'Nombre del producto'),
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

        final existe = context.read<Productos>().nombreExiste(Nombre);
        if (existe) {
          return 'Ya existe we';
        }

        return null;
      },
    );
  }

  TextFormField _buildMarcaField() {
    return TextFormField(
      controller: _marcaCtrl,
      decoration: const InputDecoration(labelText: 'Marca'),
      validator: (Marca) {
        if (Marca == null ||
            Marca.trim().isEmpty ||
            Marca.length < 3 ||
            Marca.length > 20) {
          return 'No mames we';
        }
        return null;
      },
    );
  }

  TextFormField _buildCategoriaField() {
    return TextFormField(
      controller: _categoriaCtrl,
      decoration: const InputDecoration(labelText: 'Categoría'),
      validator: (Categoria) {
        if (Categoria == null || Categoria.trim().isEmpty) {
          return 'No mames we';
        }
        return null;
      },
    );
  }

  TextFormField _buildPrecioField() {
    return TextFormField(
      controller: _precioCtrl,
      decoration: const InputDecoration(labelText: 'Precio'),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
    );
  }

  //* ===== Submit =====

  void _submitForm(BuildContext dialogContext) {
    if (_form.currentState!.validate() == false) return;

    final prov = context.read<Productos>();

    final id = _uuid.v4();
    final nombre = _nombreCtrl.text.trim();
    final marca = _marcaCtrl.text.trim();
    final categoriaFinal = prov.obtenerCategoriaFinal(_categoriaCtrl.text);
    final precio = double.parse(_precioCtrl.text.trim().replaceAll(',', '.'));
    final producto = Producto(
      id: id,
      sku: 'SKU-${id.substring(0, 6)}',
      nombre: nombre,
      marca: marca,
      categoria: categoriaFinal,
      precioBase: precio,
      stock: 0,
      rating: 0,
      imagen: '',
    );

    prov.agregar(producto);

    Navigator.pop(dialogContext);
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
                  onPressed: _abrirDialogAgregarProducto,
                ),
              ),
            ),
          ),
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
                        ),
                    itemBuilder: (context, i) {
                      final p = productos[i];
                      return ProductCard(p: p, onTap: () {}, onAdd: () {});
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
