enum UnidadMedida { pieza, kg, g, litro, ml, paquete }

enum TipoImpuesto { iva, ieps, otro }

class Impuesto {
  final TipoImpuesto tipo;
  final double tasa; // 0.16 = 16%
  final String nombre;

  const Impuesto({
    required this.tipo,
    required this.tasa,
    required this.nombre,
  });
  Impuesto copyWith({TipoImpuesto? tipo, double? tasa, String? nombre}) {
    return Impuesto(
      tipo: tipo ?? this.tipo,
      tasa: tasa ?? this.tasa,
      nombre: nombre ?? this.nombre,
    );
  }

  Map<String, dynamic> toJson() => {
    'tipo': tipo.name,
    'tasa': tasa,
    'nombre': nombre,
  };

  factory Impuesto.fromJson(Map<String, dynamic> json) => Impuesto(
    tipo: TipoImpuesto.values.byName((json['tipo'] ?? 'iva').toString()),
    tasa: _asDouble(json['tasa']),
    nombre: (json['nombre'] ?? '').toString(),
  );

  @override
  String toString() =>
      'Impuesto(tipo: ${tipo.name}, tasa: $tasa, nombre: $nombre)';
}

class VarianteProducto {
  final String id; // id variante (ej. "color-rojo-talla-m")
  final String nombre; // "Rojo / M"
  final Map<String, String> atributos; // {"color": "Rojo", "talla":"M"}
  final double? precioExtra; // si variante aumenta precio
  final int stock; // stock de esa variante
  final String? sku; // sku específico de variante
  final String? barcode; // UPC/EAN específico

  const VarianteProducto({
    required this.id,
    required this.nombre,
    this.atributos = const {},
    this.precioExtra,
    required this.stock,
    this.sku,
    this.barcode,
  });

  VarianteProducto copyWith({
    String? id,
    String? nombre,
    Map<String, String>? atributos,
    double? precioExtra,
    int? stock,
    String? sku,
    String? barcode,
  }) {
    return VarianteProducto(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      atributos: atributos ?? this.atributos,
      precioExtra: precioExtra ?? this.precioExtra,
      stock: stock ?? this.stock,
      sku: sku ?? this.sku,
      barcode: barcode ?? this.barcode,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nombre': nombre,
    'atributos': atributos,
    'precioExtra': precioExtra,
    'stock': stock,
    'sku': sku,
    'barcode': barcode,
  };

  factory VarianteProducto.fromJson(Map<String, dynamic> json) {
    final attrsRaw = json['atributos'];
    final attrs = <String, String>{};
    if (attrsRaw is Map) {
      for (final e in attrsRaw.entries) {
        attrs[e.key.toString()] = e.value.toString();
      }
    }

    return VarianteProducto(
      id: (json['id'] ?? '').toString(),
      nombre: (json['nombre'] ?? '').toString(),
      atributos: attrs,
      precioExtra: json['precioExtra'] == null
          ? null
          : _asDouble(json['precioExtra']),
      stock: _asInt(json['stock']),
      sku: json['sku']?.toString(),
      barcode: json['barcode']?.toString(),
    );
  }

  @override
  String toString() =>
      'VarianteProducto(id: $id, nombre: $nombre, stock: $stock)';
}

class Proveedor {
  final String id;
  final String nombre;
  final String? telefono;
  final String? email;

  const Proveedor({
    required this.id,
    required this.nombre,
    this.telefono,
    this.email,
  });

  Proveedor copyWith({
    String? id,
    String? nombre,
    String? telefono,
    String? email,
  }) {
    return Proveedor(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      telefono: telefono ?? this.telefono,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nombre': nombre,
    'telefono': telefono,
    'email': email,
  };

  factory Proveedor.fromJson(Map<String, dynamic> json) => Proveedor(
    id: (json['id'] ?? '').toString(),
    nombre: (json['nombre'] ?? '').toString(),
    telefono: json['telefono']?.toString(),
    email: json['email']?.toString(),
  );

  @override
  String toString() => 'Proveedor(id: $id, nombre: $nombre)';
}

class UbicacionTienda {
  final String departamento; // "Abarrotes", "Electrónica"
  final String pasillo; // "Pasillo 4"
  final String? estante; // "Estante B"
  final String? nivel; // "Nivel 2"

  const UbicacionTienda({
    required this.departamento,
    required this.pasillo,
    this.estante,
    this.nivel,
  });

  UbicacionTienda copyWith({
    String? departamento,
    String? pasillo,
    String? estante,
    String? nivel,
  }) {
    return UbicacionTienda(
      departamento: departamento ?? this.departamento,
      pasillo: pasillo ?? this.pasillo,
      estante: estante ?? this.estante,
      nivel: nivel ?? this.nivel,
    );
  }

  Map<String, dynamic> toJson() => {
    'departamento': departamento,
    'pasillo': pasillo,
    'estante': estante,
    'nivel': nivel,
  };

  factory UbicacionTienda.fromJson(Map<String, dynamic> json) =>
      UbicacionTienda(
        departamento: (json['departamento'] ?? '').toString(),
        pasillo: (json['pasillo'] ?? '').toString(),
        estante: json['estante']?.toString(),
        nivel: json['nivel']?.toString(),
      );

  @override
  String toString() => 'Ubicacion(depto: $departamento, pasillo: $pasillo)';
}

class Producto {
  // Identidad / códigos
  final String id; // uuid o id BD
  final String sku;
  final String? barcode;

  // Descripción
  final String nombre;
  final String marca;
  final String categoria;
  final String? descripcion;

  // Precio
  final double precioBase; // sin extras de variantes
  final double? precioAnterior;
  final String moneda;

  // Unidad / dimensiones
  final UnidadMedida unidad;
  final double? peso; // en kg si unidad es kg/g (tu decides convención)
  final double? volumen; // en litros si unidad es litro/ml

  // Inventario
  final int
  stock; // stock general (si manejas variantes, puede ser 0 y usar variantes)
  final bool activo;

  // Recursos
  final String imagen;

  // Rating
  final double rating;
  final int numResenas;

  // Fiscal
  final List<Impuesto> impuestos; // ej. IVA 16%
  final bool precioIncluyeImpuestos; // true si precioBase ya trae IVA

  // Variantes
  final List<VarianteProducto> variantes;

  // Proveedor / ubicación
  final Proveedor? proveedor;
  final UbicacionTienda? ubicacion;

  // Fechas
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Producto({
    required this.id,
    required this.sku,
    this.barcode,
    required this.nombre,
    required this.marca,
    required this.categoria,
    this.descripcion,
    required this.precioBase,
    this.precioAnterior,
    this.moneda = 'MXN',
    this.unidad = UnidadMedida.pieza,
    this.peso,
    this.volumen,
    required this.stock,
    this.activo = true,
    this.imagen = '',
    this.rating = 0.0,
    this.numResenas = 0,
    this.impuestos = const [],
    this.precioIncluyeImpuestos = false,
    this.variantes = const [],
    this.proveedor,
    this.ubicacion,
    this.createdAt,
    this.updatedAt,
  });

  bool get tieneDescuento =>
      precioAnterior != null && precioAnterior! > precioBase;

  double get porcentajeDescuento {
    if (!tieneDescuento) return 0;
    final ant = precioAnterior!;
    return ((ant - precioBase) / ant) * 100;
  }

  /// Precio final calculado según impuestos.
  /// - Si precioIncluyeImpuestos=true: devuelve precioBase tal cual.
  /// - Si no: suma impuestos sobre precioBase.
  double get precioConImpuestos {
    if (precioIncluyeImpuestos || impuestos.isEmpty) return precioBase;
    final totalTasa = impuestos.fold<double>(0, (acc, i) => acc + i.tasa);
    return precioBase * (1 + totalTasa);
  }

  /// Total de impuestos (cantidad), basado en precioBase.
  double get totalImpuestos {
    if (precioIncluyeImpuestos || impuestos.isEmpty) return 0;
    final totalTasa = impuestos.fold<double>(0, (acc, i) => acc + i.tasa);
    return precioBase * totalTasa;
  }

  Producto copyWith({
    String? id,
    String? sku,
    String? barcode,
    String? nombre,
    String? marca,
    String? categoria,
    String? descripcion,
    double? precioBase,
    double? precioAnterior,
    String? moneda,
    UnidadMedida? unidad,
    double? peso,
    double? volumen,
    int? stock,
    bool? activo,
    String? imagen,
    double? rating,
    int? numResenas,
    List<Impuesto>? impuestos,
    bool? precioIncluyeImpuestos,
    List<VarianteProducto>? variantes,
    Proveedor? proveedor,
    UbicacionTienda? ubicacion,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Producto(
      id: id ?? this.id,
      sku: sku ?? this.sku,
      barcode: barcode ?? this.barcode,
      nombre: nombre ?? this.nombre,
      marca: marca ?? this.marca,
      categoria: categoria ?? this.categoria,
      descripcion: descripcion ?? this.descripcion,
      precioBase: precioBase ?? this.precioBase,
      precioAnterior: precioAnterior ?? this.precioAnterior,
      moneda: moneda ?? this.moneda,
      unidad: unidad ?? this.unidad,
      peso: peso ?? this.peso,
      volumen: volumen ?? this.volumen,
      stock: stock ?? this.stock,
      activo: activo ?? this.activo,
      imagen: imagen ?? this.imagen,
      rating: rating ?? this.rating,
      numResenas: numResenas ?? this.numResenas,
      impuestos: impuestos ?? this.impuestos,
      precioIncluyeImpuestos:
          precioIncluyeImpuestos ?? this.precioIncluyeImpuestos,
      variantes: variantes ?? this.variantes,
      proveedor: proveedor ?? this.proveedor,
      ubicacion: ubicacion ?? this.ubicacion,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'sku': sku,
    'barcode': barcode,
    'nombre': nombre,
    'marca': marca,
    'categoria': categoria,
    'descripcion': descripcion,
    'precioBase': precioBase,
    'precioAnterior': precioAnterior,
    'moneda': moneda,
    'unidad': unidad.name,
    'peso': peso,
    'volumen': volumen,
    'stock': stock,
    'activo': activo,
    'imagenes': imagen,
    'rating': rating,
    'numResenas': numResenas,
    'impuestos': impuestos.map((e) => e.toJson()).toList(),
    'precioIncluyeImpuestos': precioIncluyeImpuestos,
    'variantes': variantes.map((e) => e.toJson()).toList(),
    'proveedor': proveedor?.toJson(),
    'ubicacion': ubicacion?.toJson(),
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };

  factory Producto.fromJson(Map<String, dynamic> json) {
    final impuestosRaw = json['impuestos'];
    final impuestos = <Impuesto>[];
    if (impuestosRaw is List) {
      for (final it in impuestosRaw) {
        if (it is Map) {
          impuestos.add(Impuesto.fromJson(it.cast<String, dynamic>()));
        }
      }
    }

    final varsRaw = json['variantes'];
    final variantes = <VarianteProducto>[];
    if (varsRaw is List) {
      for (final v in varsRaw) {
        if (v is Map) {
          variantes.add(VarianteProducto.fromJson(v.cast<String, dynamic>()));
        }
      }
    }

    final provRaw = json['proveedor'];
    final ubicRaw = json['ubicacion'];

    return Producto(
      id: (json['id'] ?? '').toString(),
      sku: (json['sku'] ?? '').toString(),
      barcode: json['barcode']?.toString(),
      nombre: (json['nombre'] ?? '').toString(),
      marca: (json['marca'] ?? '').toString(),
      categoria: (json['categoria'] ?? '').toString(),
      descripcion: json['descripcion']?.toString(),
      precioBase: _asDouble(json['precioBase']),
      precioAnterior: json['precioAnterior'] == null
          ? null
          : _asDouble(json['precioAnterior']),
      moneda: (json['moneda'] ?? 'MXN').toString(),
      unidad: UnidadMedida.values.byName(
        (json['unidad'] ?? 'pieza').toString(),
      ),
      peso: json['peso'] == null ? null : _asDouble(json['peso']),
      volumen: json['volumen'] == null ? null : _asDouble(json['volumen']),
      stock: _asInt(json['stock']),
      activo: (json['activo'] ?? true) == true,
      imagen: json['imagen'],
      rating: _asDouble(json['rating']),
      numResenas: _asInt(json['numResenas']),
      impuestos: impuestos,
      precioIncluyeImpuestos: (json['precioIncluyeImpuestos'] ?? false) == true,
      variantes: variantes,
      proveedor: provRaw is Map
          ? Proveedor.fromJson(provRaw.cast<String, dynamic>())
          : null,
      ubicacion: ubicRaw is Map
          ? UbicacionTienda.fromJson(ubicRaw.cast<String, dynamic>())
          : null,
      createdAt: _asDate(json['createdAt']),
      updatedAt: _asDate(json['updatedAt']),
    );
  }

  @override
  String toString() {
    return 'Producto(id: $id, sku: $sku, nombre: $nombre, marca: $marca, '
        'categoria: $categoria, precioBase: $precioBase $moneda, stock: $stock, '
        'unidad: ${unidad.name}, rating: $rating, activo: $activo)';
  }
}

/// Helpers (sin paquetes extra)
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
