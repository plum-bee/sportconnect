import 'package:flutter/material.dart';
import 'package:sportconnect/src/models/sport.dart';
import 'package:sportconnect/src/services/sport_service.dart';
import 'package:sportconnect/src/pages/login_screen.dart';

class SkillLevelScreen extends StatelessWidget {
  final SportService sportService = SportService();

  SkillLevelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: Column(
            children: [
              const SizedBox(
                height: 16,
              ),
              Image.asset(
                'assets/images/logo.png',
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.height * 0.1,
                fit: BoxFit.contain,
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: FutureBuilder<List<Sport>>(
          future: sportService.getAllSports(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
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
                        _SkillLevelContainer(sports[i]),
                        if (i < sports.length - 1)
                          const SizedBox(
                            height: 50,
                          ),
                      ],
                    ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    },
                    child: const Text('Finish'),
                  ),
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
  final Sport sport;

  const _SkillLevelContainer(this.sport);

  @override
  _SkillLevelContainerState createState() => _SkillLevelContainerState();
}

class _SkillLevelContainerState extends State<_SkillLevelContainer> {
  bool _isChecked = false; // Estado del checkbox

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 8,
            ),
            Text(
              'Choose your skill level for ${widget.sport.name}:',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Checkbox(
              value: _isChecked,
              onChanged: (value) {
                setState(() {
                  _isChecked = value!;
                  // Aquí puedes guardar el estado del checkbox en la base de datos
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 12),
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
