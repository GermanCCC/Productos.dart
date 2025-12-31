import 'package:flutter/material.dart';
import 'package:prueba/models/producto.dart';

class ProductCard extends StatefulWidget {
  final Producto p;
  final VoidCallback onTap;
  final VoidCallback onAdd;

  const ProductCard({
    super.key,
    required this.p,
    required this.onTap,
    required this.onAdd,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        width: size.width * 0.2,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MouseRegion(
              onHover: (_) => setState(() => _scale = 1.30),
              onExit: (_) => setState(() => _scale = 1),
              child: Image.network(
                widget.p.imagen,
                height: size.height * 0.2 * _scale,
                width: size.width * 0.2 * _scale,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 1),
            Text(
              widget.p.nombre,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text(
              '\$${widget.p.precioBase.toStringAsFixed(2)} ${widget.p.moneda}',
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.onAdd,
                child: const Text('Agregar producto'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
