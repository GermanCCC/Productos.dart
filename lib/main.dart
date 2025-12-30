import 'package:flutter/material.dart';
import 'package:prueba/components/users_card.dart';
import 'package:prueba/helpers/helpers.dart';
import 'package:prueba/models/user.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 255, 0, 0),
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Prueba usuarios'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Formulario
  final GlobalKey<FormState> _userForm = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();

  // Sexo seleccionado
  Sexo? _sexoSeleccionado;
  // usuarios registrados
  final List<User> _usuarios = [
    User(nombre: 'German', apellido: 'Caraveo', sexo: Sexo.hombre),
  ];

  void _mostrarSnackRegistroExitoso() {
    final messenger = ScaffoldMessenger.of(context);
    final width = MediaQuery.of(context).size.width;

    messenger.hideCurrentSnackBar();

    messenger.showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: Center(
          child: SizedBox(
            width: width * 0.25,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Registro exitoso',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    final ok = _userForm.currentState!.validate();
    if (!ok) return;

    setState(() {
      _usuarios.add(
        User(
          nombre: _nombreController.text.trim(),
          apellido: _apellidoController.text.trim(),
          sexo: _sexoSeleccionado!,
        ),
      );
    });

    _mostrarSnackRegistroExitoso();

    _nombreController.clear();
    _apellidoController.clear();
    _contrasenaController.clear();
    setState(() => _sexoSeleccionado = null);
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _contrasenaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              final json = _usuarios.first.toJson();
            },
            icon: Icon(Icons.add),
          ),
        ],
        backgroundColor: const Color(0xFFDD464D),

        title: Center(
          child: Text(widget.title, style: const TextStyle(fontSize: 24)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // -------- PANEL IZQUIERDO --------
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE4E4E4),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Form(
                      key: _userForm,
                      child: Column(
                        children: [
                          // Nombre + Apellido
                          Row(
                            children: [
                              const Icon(Icons.person),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextFormField(
                                  controller: _nombreController,
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty) {
                                      return 'Nombre requerido';
                                    }
                                    if (v.trim().length < 3) {
                                      return 'Nombre muy corto';
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    labelText: 'Nombre',
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextFormField(
                                  controller: _apellidoController,
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty) {
                                      return 'Apellido requerido';
                                    }
                                    if (v.trim().length < 3) {
                                      return 'Apellido muy corto';
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    labelText: 'Apellido',
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          // Selector de sexo (Row con icono afuera)
                          Row(
                            children: [
                              const Icon(Icons.wc, color: Colors.black),
                              const SizedBox(width: 10),
                              Expanded(
                                child: DropdownButtonFormField<Sexo>(
                                  value: _sexoSeleccionado,
                                  decoration: const InputDecoration(
                                    labelText: 'Sexo',
                                  ),
                                  items: const [
                                    DropdownMenuItem(
                                      value: Sexo.hombre,
                                      child: Text('Hombre'),
                                    ),
                                    DropdownMenuItem(
                                      value: Sexo.mujer,
                                      child: Text('Mujer'),
                                    ),
                                    DropdownMenuItem(
                                      value: Sexo.otro,
                                      child: Text('Otro'),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    setState(() => _sexoSeleccionado = value);
                                  },
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Selecciona un sexo';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          // Contraseña
                          Row(
                            children: [
                              const Icon(Icons.lock),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextFormField(
                                  controller: _contrasenaController,
                                  obscureText: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Contraseña requerida';
                                    }
                                    if (value.length < 8) {
                                      return 'Mínimo 8 caracteres';
                                    }
                                    if (!RegExp(r'[A-Z]').hasMatch(value)) {
                                      return 'Debe tener mayúscula';
                                    }
                                    if (!RegExp(r'[0-9]').hasMatch(value)) {
                                      return 'Debe tener número';
                                    }
                                    if (!RegExp(
                                      r'[!@#$%^&*(),.?":{}|<>_+\-=/\\\[\];`~]',
                                    ).hasMatch(value)) {
                                      return 'Debe tener carácter especial';
                                    }
                                    if (RegExp(r'\s').hasMatch(value)) {
                                      return 'No debe tener espacios';
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    labelText: 'Contraseña',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    ElevatedButton.icon(
                      onPressed: _submitForm,
                      icon: const Icon(Icons.login),
                      label: const Text('Register'),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.group),
                      label: Text('Users (${_usuarios.length})'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 15),

            // -------- PANEL DERECHO --------
            Expanded(
              flex: 6,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE4E4E4),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: _usuarios.isEmpty
                    ? const Center(
                        child: Text(
                          'No hay usuarios registrados',
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _usuarios.length,
                        itemBuilder: (context, index) {
                          final u = _usuarios[index];
                          return UsersCard(user: u);
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
