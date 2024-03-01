// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class SearchScreen extends StatefulWidget {
//   const SearchScreen({super.key});

//   @override
//   _SearchScreenState createState() => _SearchScreenState();
// }

// class _SearchScreenState extends State<SearchScreen> {
//   // Aquí están tus 5 cadenas de texto
//   final List<String> items = [
//     'Texto 1',
//     'Texto 2',
//     'Texto 3',
//     'Texto 4',
//     'Texto 5'
//   ];
//   String dropdownValue = 'Texto 1'; // Valor inicial del DropdownButton
//   final TextEditingController _searchController =
//       TextEditingController(); // Controlador para el campo de búsqueda

//   // Inicializa el controlador del mapa de Google
//   final Completer<GoogleMapController> _mapController = Completer();

//   @override
//   Widget build(BuildContext context) {
//     var screenSize =
//         MediaQuery.of(context).size; // Obtiene el tamaño de la pantalla

//     return Scaffold(
//       appBar: AppBar(
//         title: Center(
//           // Añade el widget Center aquí
//           child: ConstrainedBox(
//             constraints: BoxConstraints(
//               maxWidth: screenSize.width *
//                   0.5, // Ajusta el ancho de la imagen según tus necesidades
//               maxHeight: screenSize.height *
//                   0.05, // Ajusta el alto de la imagen según tus necesidades
//             ),
//             child: Image.asset(
//               'assets/images/logo_text.png', // Reemplaza 'assets/images/logo_text.png' con la ruta de tu imagen
//               fit: BoxFit
//                   .fitWidth, // Esto hará que la imagen se ajuste al AppBar
//             ),
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         // Añade el widget SingleChildScrollView aquí
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               DropdownButton<String>(
//                 value: dropdownValue,
//                 icon: const Icon(Icons.arrow_downward),
//                 iconSize: 24,
//                 elevation: 16,
//                 style: const TextStyle(color: Colors.deepPurple),
//                 underline: Container(
//                   height: 2,
//                   color: Colors.deepPurpleAccent,
//                 ),
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     dropdownValue = newValue!;
//                   });
//                 },
//                 items: items.map<DropdownMenuItem<String>>((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//               ),
//               const SizedBox(
//                   height:
//                       20.0), // Espacio entre el DropdownButton y el campo de búsqueda
//               TextField(
//                 controller: _searchController,
//                 decoration: const InputDecoration(
//                   labelText: 'Search',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(
//                   height: 20.0), // Espacio entre el campo de búsqueda y el mapa
//               Container(
//                 height: screenSize.height *
//                     0.5, // Ajusta el alto del mapa según tus necesidades
//                 child: GoogleMap(
//                   mapType: MapType.normal,
//                   initialCameraPosition: const CameraPosition(
//                     target: LatLng(
//                         40.7128, -74.0060), // Coordenadas iniciales del mapa
//                     zoom: 14.4746,
//                   ),
//                   onMapCreated: (GoogleMapController controller) {
//                     _mapController.complete(controller);
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
