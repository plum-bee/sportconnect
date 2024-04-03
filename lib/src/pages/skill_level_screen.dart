// ignore_for_file: unused_element

import 'package:flutter/material.dart';

class SkillLevelScreen extends StatelessWidget {
  const SkillLevelScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: Column(
            children: [
              const SizedBox(
                  height:
                      16), // Agrega un espacio entre la imagen y el borde superior
              Image.asset(
                'assets/images/logo.png',
                width: screenSize.width *
                    0.5, // Ajusta el tamaño de la imagen del AppBar según sea necesario
                height: screenSize.height *
                    0.1, // Ajusta el tamaño de la imagen del AppBar según sea necesario
                fit: BoxFit
                    .contain, // Ajusta el tamaño de la imagen de forma que quepa dentro del AppBar
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            _SkillLevelContainer(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _SkillLevelContainer extends StatefulWidget {
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
            Image.asset(
              'assets/images/logo.png',
              width: 12, // Ajusta el tamaño de la imagen según sea necesario
              height: 12, // Ajusta el tamaño de la imagen según sea necesario
            ),
            const SizedBox(
                width: 8), // Agrega espacio entre la imagen y el texto
            const Text(
              'Choose your skill level:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
