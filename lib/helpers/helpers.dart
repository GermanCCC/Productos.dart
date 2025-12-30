// Funciones anónimas
// Son funciones que no tienen ombre
//Funciones nombradas lo que tiene dentro una función se llaman parámetros
//Parámetros indexados
void saludar(String nombre, int edad) {
  print('Hola Mundo $nombre');
}

void saludo({required String nombre, required int edad}) {
  print('Hola Mundo $nombre de $edad años');
}

String saludars() {
  return 'Hola Mundo';
}
