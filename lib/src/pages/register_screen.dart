import 'package:flutter/material.dart';
import 'package:sportconnect/src/pages/login_screen.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var screenSize =
        MediaQuery.of(context).size; // Obtiene el tamaño de la pantalla

    return Scaffold(
      body: LayoutBuilder(
        // Añade el widget LayoutBuilder aquí
        builder: (BuildContext context, BoxConstraints constraints) {
          return Center(
            // Añade el widget Center aquí
            child: SingleChildScrollView(
              // Añade el widget SingleChildScrollView aquí
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo_full.png', // Reemplaza 'assets/tu_imagen.png' con la ruta de tu imagen
                      width: screenSize.width *
                          0.3, // Ajusta el tamaño de la imagen según tus necesidades
                      height: screenSize.height *
                          0.3, // Ajusta el tamaño de la imagen según tus necesidades
                    ),
                    const SizedBox(
                        height:
                            20.0), // Espacio entre la imagen y el formulario
                    FormBuilder(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: constraints.maxWidth *
                                0.6, // Ajusta el ancho del campo de texto
                            child: FormBuilderTextField(
                              name: 'name',
                              decoration: const InputDecoration(
                                labelText: 'Name',
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Container(
                            width: constraints.maxWidth *
                                0.6, // Ajusta el ancho del campo de texto
                            child: FormBuilderTextField(
                              name: 'surname',
                              decoration: const InputDecoration(
                                labelText: 'Surname',
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Container(
                            width: constraints.maxWidth *
                                0.6, // Ajusta el ancho del campo de texto
                            child: FormBuilderTextField(
                              name: 'email',
                              decoration: const InputDecoration(
                                labelText: 'Email',
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Container(
                            width: constraints.maxWidth *
                                0.6, // Ajusta el ancho del campo de texto
                            child: FormBuilderTextField(
                              name: 'password',
                              decoration: const InputDecoration(
                                labelText: 'Password',
                              ),
                              obscureText: true,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          ElevatedButton(
                            onPressed: () {
                              /* Logica */
                            },
                            child: const Text('Sign Up'),
                          ),
                          const SizedBox(height: 16.0),
                          const Text('OR'),
                          const SizedBox(height: 16.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Have an account?'),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen()),
                                  );
                                },
                                child: const Text('Log in'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
