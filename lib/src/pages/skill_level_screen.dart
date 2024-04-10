// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:sportconnect/src/models/sport.dart';
import 'package:sportconnect/src/services/sport_service.dart';

class SkillLevelScreen extends StatelessWidget {
  final SportService sportService = SportService();

  SkillLevelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center, 
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: MediaQuery.of(context).size.width *
                    0.1,
                height: MediaQuery.of(context).size.height *
                    0.1,
                fit: BoxFit.contain,
              ),
              const SizedBox(
                width: 8, // Add space between the image and the title
              ),
              Text(
                'Sport Connect',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        centerTitle: false, // Set centerTitle to false
      ),
      body: Center(
        child: FutureBuilder<List<Sport>>(
          future: sportService.getAllSports(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(); // Muestra un indicador de carga mientras se obtienen los datos
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final sports = snapshot.data!;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  for (var i = 0; i < sports.length; i++)
                    Column(
                      children: [
                        _SkillLevelContainer(sports[i].name),
                        if (i < sports.length - 1)
                          const SizedBox(
                              height:
                                  10), // Agrega espacio entre los contenedores de cada deporte
                      ],
                    ),
                  const SizedBox(height: 20),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

class _SkillLevelContainer extends StatefulWidget {
  final String sportName;

  const _SkillLevelContainer(this.sportName);

  @override
  _SkillLevelContainerState createState() => _SkillLevelContainerState();
}

class _SkillLevelContainerState extends State<_SkillLevelContainer> {
  double _value = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 8,
            ), // Agrega espacio entre la imagen y el texto
            Text(
              'Choose your skill level for ${widget.sportName}:',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 12), // Agrega espacio entre el texto y el slider
        _SkillLevelSlider(),
      ],
    );
  }
}

class _SkillLevelSlider extends StatefulWidget {
  @override
  _SkillLevelSliderState createState() => _SkillLevelSliderState();
}

class _SkillLevelSliderState extends State<_SkillLevelSlider> {
  double _value = 0;

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: _value,
      onChanged: (newValue) {
        setState(() {
          _value = newValue;
        });
      },
      min: 0,
      max: 2,
      divisions: 2,
      label: _value == 0
          ? 'Beginner'
          : _value == 1
              ? 'Intermediate'
              : 'Advanced',
    );
  }
}
