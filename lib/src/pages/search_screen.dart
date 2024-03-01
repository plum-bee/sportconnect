import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // Aquí están tus 5 cadenas de texto
  final List<String> items = [
    'Texto 1',
    'Texto 2',
    'Texto 3',
    'Texto 4',
    'Texto 5'
  ];
  String dropdownValue = 'Texto 1'; // Valor inicial del DropdownButton

  @override
  Widget build(BuildContext context) {
    var screenSize =
        MediaQuery.of(context).size; // Obtiene el tamaño de la pantalla

    return Scaffold(
      appBar: AppBar(
        title: Center(
          // Añade el widget Center aquí
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: screenSize.width *
                  0.5, // Ajusta el ancho de la imagen según tus necesidades
              maxHeight: screenSize.height *
                  0.05, // Ajusta el alto de la imagen según tus necesidades
            ),
            child: Image.asset(
              'assets/images/logo_text.png', // Reemplaza 'assets/images/logo_text.png' con la ruta de tu imagen
              fit: BoxFit
                  .fitWidth, // Esto hará que la imagen se ajuste al AppBar
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20.0), // Espacio entre la AppBar y el cuerpo
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(
                    color: Colors.blueAccent,
                    style: BorderStyle.solid,
                    width: 0.80),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: dropdownValue,
                  icon: const Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                  items: items.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
