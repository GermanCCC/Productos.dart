import 'package:flutter/material.dart';

enum Sexo { hombre, mujer, otro }

class User {
  final String nombre;
  final String apellido;
  final Sexo sexo;

  User({required this.nombre, required this.apellido, required this.sexo});

  String get nombreCompleto => '$nombre $apellido';
  IconData get iconoSexo {
    switch (sexo) {
      case Sexo.hombre:
        return Icons.male;
      case Sexo.mujer:
        return Icons.female;
      case Sexo.otro:
        return Icons.transgender;
    }
  }

  Color get colorSexo {
    switch (sexo) {
      case Sexo.hombre:
        return Colors.blue;
      case Sexo.mujer:
        return Colors.pink;
      case Sexo.otro:
        return Colors.grey.shade700;
    }
  }

  @override
  String toString() {
    return """-------USUARIO-------
  Nombre: $nombre
  Apellido: $apellido
  Sexo: ${sexo.name}""";
  }

  //####toJson####
  Map<String, dynamic> toJson() {
    return {'nombre': nombre, 'apellido': apellido, 'sexo': sexo.name};
  }

  //####fromJson###
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      nombre: json['nombre'],
      apellido: json['apellido'],
      sexo: Sexo.values.firstWhere((e) => e.name == json['sexo']),
    );
  }

  // Función copyWith
  User copyWith({String? nombre, String? apellido, Sexo? sexo}) => User(
    apellido: apellido ?? this.apellido,
    nombre: nombre ?? this.nombre,
    sexo: sexo ?? this.sexo,
  );
}
