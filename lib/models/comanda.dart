import 'package:prueba/models/producto.dart';

enum EstatusComanda { abierta, pagada, cancelada }

class ComandaItem {
  final String productoId;
  final String nombre;
  final String sku;
  final String? varianteId; // si se eligió variante
  final String? varianteNombre;
  final int cantidad;

  /// Precio unitario (en el momento de compra)
  final double precioUnitario;
  final String moneda;

  /// Impuestos aplicados a este item (snapshot)
  final List<Impuesto> impuestos;
  final bool precioIncluyeImpuestos;

  const ComandaItem({
    required this.productoId,
    required this.nombre,
    required this.sku,
    this.varianteId,
    this.varianteNombre,
    required this.cantidad,
    required this.precioUnitario,
    this.moneda = 'MXN',
    this.impuestos = const [],
    this.precioIncluyeImpuestos = false,
  });

  double get subtotal => precioUnitario * cantidad;

  double get totalImpuestos {
    if (precioIncluyeImpuestos || impuestos.isEmpty) return 0;
    final tasa = impuestos.fold<double>(0, (acc, i) => acc + i.tasa);
    return subtotal * tasa;
  }

  double get total {
    if (precioIncluyeImpuestos || impuestos.isEmpty) return subtotal;
    return subtotal + totalImpuestos;
  }

  ComandaItem copyWith({
    String? productoId,
    String? nombre,
    String? sku,
    String? varianteId,
    String? varianteNombre,
    int? cantidad,
    double? precioUnitario,
    String? moneda,
    List<Impuesto>? impuestos,
    bool? precioIncluyeImpuestos,
  }) {
    return ComandaItem(
      productoId: productoId ?? this.productoId,
      nombre: nombre ?? this.nombre,
      sku: sku ?? this.sku,
      varianteId: varianteId ?? this.varianteId,
      varianteNombre: varianteNombre ?? this.varianteNombre,
      cantidad: cantidad ?? this.cantidad,
      precioUnitario: precioUnitario ?? this.precioUnitario,
      moneda: moneda ?? this.moneda,
      impuestos: impuestos ?? this.impuestos,
      precioIncluyeImpuestos:
          precioIncluyeImpuestos ?? this.precioIncluyeImpuestos,
    );
  }

  Map<String, dynamic> toJson() => {
    'productoId': productoId,
    'nombre': nombre,
    'sku': sku,
    'varianteId': varianteId,
    'varianteNombre': varianteNombre,
    'cantidad': cantidad,
    'precioUnitario': precioUnitario,
    'moneda': moneda,
    'impuestos': impuestos.map((e) => e.toJson()).toList(),
    'precioIncluyeImpuestos': precioIncluyeImpuestos,
  };

  factory ComandaItem.fromJson(Map<String, dynamic> json) {
    final impuestosRaw = json['impuestos'];
    final impuestos = <Impuesto>[];
    if (impuestosRaw is List) {
      for (final it in impuestosRaw) {
        if (it is Map)
          impuestos.add(Impuesto.fromJson(it.cast<String, dynamic>()));
      }
    }

    return ComandaItem(
      productoId: (json['productoId'] ?? '').toString(),
      nombre: (json['nombre'] ?? '').toString(),
      sku: (json['sku'] ?? '').toString(),
      varianteId: json['varianteId']?.toString(),
      varianteNombre: json['varianteNombre']?.toString(),
      cantidad: _asInt(json['cantidad']),
      precioUnitario: _asDouble(json['precioUnitario']),
      moneda: (json['moneda'] ?? 'MXN').toString(),
      impuestos: impuestos,
      precioIncluyeImpuestos: (json['precioIncluyeImpuestos'] ?? false) == true,
    );
  }

  @override
  String toString() =>
      'ComandaItem(productoId: $productoId, nombre: $nombre, cantidad: $cantidad, total: $total)';
}

class Comanda {
  final String id;
  final EstatusComanda estatus;

  /// Si es tienda física, puedes guardar mesa/caja, si es online, referencia.
  final String? referencia; // "Caja 1", "Mesa 3", "Online"
  final String moneda;

  final List<ComandaItem> items;

  /// Descuentos globales de comanda (monto fijo)
  final double descuento; // ej. 50.00

  /// Envío (si aplica)
  final double envio;

  final DateTime createdAt;
  final DateTime updatedAt;

  Comanda({
    required this.id,
    this.estatus = EstatusComanda.abierta,
    this.referencia,
    this.moneda = 'MXN',
    this.items = const [],
    this.descuento = 0.0,
    this.envio = 0.0,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  double get subtotal => items.fold<double>(0, (acc, it) => acc + it.subtotal);

  double get impuestos =>
      items.fold<double>(0, (acc, it) => acc + it.totalImpuestos);

  double get total =>
      (items.fold<double>(0, (acc, it) => acc + it.total) - descuento) + envio;

  Comanda copyWith({
    String? id,
    EstatusComanda? estatus,
    String? referencia,
    String? moneda,
    List<ComandaItem>? items,
    double? descuento,
    double? envio,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Comanda(
      id: id ?? this.id,
      estatus: estatus ?? this.estatus,
      referencia: referencia ?? this.referencia,
      moneda: moneda ?? this.moneda,
      items: items ?? this.items,
      descuento: descuento ?? this.descuento,
      envio: envio ?? this.envio,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'estatus': estatus.name,
    'referencia': referencia,
    'moneda': moneda,
    'items': items.map((e) => e.toJson()).toList(),
    'descuento': descuento,
    'envio': envio,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory Comanda.fromJson(Map<String, dynamic> json) {
    final itemsRaw = json['items'];
    final items = <ComandaItem>[];
    if (itemsRaw is List) {
      for (final it in itemsRaw) {
        if (it is Map) {
          items.add(ComandaItem.fromJson(it.cast<String, dynamic>()));
        }
      }
    }

    return Comanda(
      id: (json['id'] ?? '').toString(),
      estatus: EstatusComanda.values.byName(
        (json['estatus'] ?? 'abierta').toString(),
      ),
      referencia: json['referencia']?.toString(),
      moneda: (json['moneda'] ?? 'MXN').toString(),
      items: items,
      descuento: _asDouble(json['descuento']),
      envio: _asDouble(json['envio']),
      createdAt: _asDate(json['createdAt']),
      updatedAt: _asDate(json['updatedAt']),
    );
  }

  @override
  String toString() =>
      'Comanda(id: $id, estatus: ${estatus.name}, items: ${items.length}, total: $total)';
}

/// Helpers (duplicados a propósito si no quieres compartir archivo)
double _asDouble(dynamic v, {double fallback = 0.0}) {
  if (v == null) return fallback;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString()) ?? fallback;
}

int _asInt(dynamic v, {int fallback = 0}) {
  if (v == null) return fallback;
  if (v is num) return v.toInt();
  return int.tryParse(v.toString()) ?? fallback;
}

DateTime _asDate(dynamic v) {
  if (v is DateTime) return v;
  if (v is String) return DateTime.tryParse(v) ?? DateTime.now();
  return DateTime.now();
}
