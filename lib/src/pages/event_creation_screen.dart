import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sportconnect/src/models/location.dart';
import 'package:sportconnect/src/models/sport.dart';
import 'package:sportconnect/src/models/skill_level.dart';
import 'package:sportconnect/src/services/location_service.dart';
import 'package:sportconnect/src/services/sport_service.dart';
import 'package:sportconnect/src/services/skill_level_service.dart';
import 'package:get/get.dart';
import 'package:sportconnect/src/controllers/event_controller.dart';
import 'package:sportconnect/src/models/event.dart';
import 'package:sportconnect/main.dart';

class EventCreationPage extends StatefulWidget {
  final Location? location;
  EventCreationPage({Key? key, this.location}) : super(key: key);

  @override
  _EventCreationPageState createState() => _EventCreationPageState();
}

class _EventCreationPageState extends State<EventCreationPage> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  late Future<List<Location>> _locations;
  late Future<List<Sport>> _sports;
  late Future<List<SkillLevel>> _skillLevels;
  final EventController eventController = Get.find<EventController>();

  static const Color primaryColor = Color(0xFF145D55);
  static const Color accentColor = Color(0xFF9FBEB9);
  static const Color cardColor = Color(0xFF1D1E33);

  TextStyle labelTextStyle = const TextStyle(
      fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white);
  TextStyle helperTextStyle = const TextStyle(fontSize: 14, color: accentColor);

  @override
  void initState() {
    super.initState();
    _locations = LocationService().getAllLocations();
    _sports = SportService().getAllSports();
    _skillLevels = SkillLevelService().getAllSkillLevels();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Event"),
        backgroundColor: primaryColor,
      ),
      body: FutureBuilder(
        future: Future.wait([_locations, _sports, _skillLevels]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasData) {
            List<Location> locations = snapshot.data![0] as List<Location>;
            List<Sport> sports = snapshot.data![1] as List<Sport>;
            List<SkillLevel> skillLevels =
                snapshot.data![2] as List<SkillLevel>;

            Location? initialLocation = widget.location != null
                ? locations.firstWhere(
                    (loc) => loc.idLocation == widget.location!.idLocation,
                  )
                : null;

            return FormBuilder(
              key: _fbKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    FormBuilderDropdown<Location>(
                      name: 'location',
                      initialValue: initialLocation,
                      decoration: InputDecoration(
                        labelText: 'Select Location',
                        helperText: 'Choose the location of the event',
                        border: const OutlineInputBorder(),
                        filled: true,
                        fillColor: cardColor,
                        labelStyle: labelTextStyle,
                        helperStyle: helperTextStyle,
                      ),
                      items: locations
                          .map((location) => DropdownMenuItem(
                                value: location,
                                child: Text(location.name,
                                    style:
                                        const TextStyle(color: Colors.white)),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 10),
                    FormBuilderDropdown<Sport>(
                      name: 'sport',
                      decoration: InputDecoration(
                        labelText: 'Select Sport',
                        helperText: 'Choose the sport for the event',
                        border: const OutlineInputBorder(),
                        filled: true,
                        fillColor: cardColor,
                        labelStyle: labelTextStyle,
                        helperStyle: helperTextStyle,
                      ),
                      items: sports
                          .map((sport) => DropdownMenuItem(
                                value: sport,
                                child: Text(sport.name,
                                    style:
                                        const TextStyle(color: Colors.white)),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 10),
                    FormBuilderDropdown<SkillLevel>(
                      name: 'skill_level',
                      decoration: InputDecoration(
                        labelText: 'Select Skill Level',
                        helperText: 'Choose the skill level required',
                        border: const OutlineInputBorder(),
                        filled: true,
                        fillColor: cardColor,
                        labelStyle: labelTextStyle,
                        helperStyle: helperTextStyle,
                      ),
                      items: skillLevels
                          .map((skillLevel) => DropdownMenuItem(
                                value: skillLevel,
                                child: Text(skillLevel.name,
                                    style:
                                        const TextStyle(color: Colors.white)),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 10),
                    FormBuilderDateTimePicker(
                      name: 'start_time',
                      decoration: InputDecoration(
                        labelText: 'Select Start Time',
                        helperText: 'Choose the start time for the event',
                        border: const OutlineInputBorder(),
                        filled: true,
                        fillColor: cardColor,
                        labelStyle: labelTextStyle,
                        helperStyle: helperTextStyle,
                      ),
                      initialTime: TimeOfDay(hour: 12, minute: 0),
                      inputType: InputType.both,
                      format: DateFormat('yyyy-MM-dd HH:mm'),
                      locale: Locale.fromSubtags(languageCode: 'en'),
                    ),
                    const SizedBox(height: 10),
                    FormBuilderSwitch(
                      name: 'is_registration_open',
                      title:
                          Text('Is Registration Open?', style: labelTextStyle),
                      initialValue: false,
                      activeColor: primaryColor,
                      inactiveTrackColor: accentColor,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (_fbKey.currentState!.saveAndValidate()) {
                          final formValues = _fbKey.currentState!.value;
                          final formattedStartTime = formValues['start_time'];

                          try {
                            final response = await supabase
                                .from('events')
                                .insert({
                                  'id_location':
                                      formValues['location'].idLocation,
                                  'id_sport': formValues['sport'].idSport,
                                  'id_skill_level':
                                      formValues['skill_level'].idSkillLevel,
                                  'start_time':
                                      formattedStartTime.toIso8601String(),
                                  'is_registration_open':
                                      formValues['is_registration_open'],
                                  'organizer_id': supabase.auth.currentUser?.id,
                                })
                                .select("*")
                                .single();

                            if (response != null) {
                              Event newEvent = Event.fromMap(response);
                              eventController.addNewEvent(newEvent);
                              eventController.refreshEventInfo();
                              eventController.joinEvent(newEvent.idEvent);

                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      'Event successfully created and joined!')));
                              Navigator.of(context).pop();
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Failed to create event: $e')));
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: primaryColor,
                      ),
                      child: Text('Submit'),
                    )
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}', style: helperTextStyle);
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
