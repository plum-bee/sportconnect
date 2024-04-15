import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sportconnect/src/models/location.dart';
import 'package:sportconnect/src/models/sport.dart';
import 'package:sportconnect/src/models/skill_level.dart';
import 'package:sportconnect/src/models/event.dart';
import 'package:sportconnect/src/services/location_service.dart';
import 'package:sportconnect/src/services/sport_service.dart';
import 'package:sportconnect/src/services/skill_level_service.dart';
import 'package:sportconnect/src/controllers/event_controller.dart';
import 'package:get/get.dart';

class EventEditScreen extends StatefulWidget {
  final int eventId;

  EventEditScreen({Key? key, required this.eventId}) : super(key: key);

  @override
  _EventEditScreenState createState() => _EventEditScreenState();
}

class _EventEditScreenState extends State<EventEditScreen> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  late Future<Event> _event;
  late Future<List<Location>> _locations;
  late Future<List<Sport>> _sports;
  late Future<List<SkillLevel>> _skillLevels;

  EventController eventController = Get.find<EventController>();

  static const Color primaryColor = Color(0xFF145D55);
  static const Color accentColor = Color(0xFF9FBEB9);
  static const Color cardColor = Color(0xFF1D1E33);

  TextStyle labelTextStyle = const TextStyle(
      fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white);
  TextStyle helperTextStyle = const TextStyle(fontSize: 14, color: accentColor);

  @override
  void initState() {
    super.initState();
    _event = eventController.eventService.getEventById(widget.eventId);
    _locations = LocationService().getAllLocations();
    _sports = SportService().getAllSports();
    _skillLevels = SkillLevelService().getAllSkillLevels();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Event"),
        backgroundColor: primaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text("Confirm"),
                  content: Text("Are you sure you want to delete this event?"),
                  actions: <Widget>[
                    TextButton(
                      child: Text("Cancel"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text("Delete"),
                      onPressed: () async {
                        try {
                          await eventController.eventService
                              .deleteEvent(widget.eventId);
                          await eventController.refreshEventInfo();
                          Navigator.of(context).pushReplacementNamed('/main');
                        } catch (e) {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Failed to delete event: $e')),
                          );
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: Future.wait([_event, _locations, _sports, _skillLevels]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasData) {
            Event event = snapshot.data![0];
            List<Location> locations = snapshot.data![1];
            List<Sport> sports = snapshot.data![2];
            List<SkillLevel> skillLevels = snapshot.data![3];

            return FormBuilder(
              key: _fbKey,
              initialValue: {
                'location': event.idLocation,
                'sport': event.idSport,
                'skill_level': event.idSkillLevel,
                'start_time': event.startTime,
                'is_registration_open': event.isRegistrationOpen,
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    FormBuilderDropdown(
                      name: 'location',
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
                                value: location.idLocation,
                                child: Text(location.name,
                                    style:
                                        const TextStyle(color: Colors.white)),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 10),
                    FormBuilderDropdown(
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
                                value: sport.idSport,
                                child: Text(sport.name,
                                    style:
                                        const TextStyle(color: Colors.white)),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 10),
                    FormBuilderDropdown(
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
                                value: skillLevel.idSkillLevel,
                                child: Text(skillLevel.name,
                                    style:
                                        const TextStyle(color: Colors.white)),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 10),
                    FormBuilderDateTimePicker(
                      name: 'start_time',
                      initialValue: event.startTime,
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100),
                      format: DateFormat('yyyy-MM-dd HH:mm'),
                      decoration: InputDecoration(
                        labelText: 'Event Start Time',
                        helperText: 'Select event start time',
                        border: const OutlineInputBorder(),
                        filled: true,
                        fillColor: cardColor,
                        labelStyle: labelTextStyle,
                        helperStyle: helperTextStyle,
                      ),
                    ),
                    FormBuilderSwitch(
                      name: 'is_registration_open',
                      title:
                          Text('Is Registration Open?', style: labelTextStyle),
                      initialValue: event.isRegistrationOpen,
                      activeColor: primaryColor,
                      inactiveTrackColor: accentColor,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (_fbKey.currentState!.saveAndValidate()) {
                          final formValues = _fbKey.currentState!.value;
                          final updatedEvent = Event(
                            idEvent: widget.eventId,
                            idLocation: formValues['location'],
                            idSport: formValues['sport'],
                            idSkillLevel: formValues['skill_level'],
                            startTime: formValues['start_time'],
                            isRegistrationOpen:
                                formValues['is_registration_open'],
                            organizerId: event.organizerId,
                          );

                          try {
                            await eventController.eventService
                                .updateEvent(updatedEvent);
                            eventController
                                .updateEventDetails(updatedEvent.idEvent);
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Event successfully updated!')));
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Failed to update event: $e')));
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: primaryColor,
                        overlayColor: Colors.white,
                      ),
                      child: Text('Update'),
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
