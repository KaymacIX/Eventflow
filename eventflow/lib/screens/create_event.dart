import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:eventflow/models/event_model.dart';
import 'package:eventflow/providers/event_provider.dart';
import 'package:eventflow/providers/auth_provider.dart';
import 'package:eventflow/widgets/app_bar.dart';
import 'package:eventflow/widgets/custom_button.dart';
import 'package:eventflow/widgets/custom_text_field.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../utils/api_service.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  String? _selectedImagePath;
  DateTime? _selectedDateTime;
  DateTime? _selectedEndDateTime;
  double? _selectedLongitude;
  double? _selectedLatitude;
  final LatLng _defaultCenter = LatLng(-15.3875, 28.3228); // Lusaka default
  void _pickEndDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        setState(() {
          _selectedEndDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _pickDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final eventProvider = Provider.of<EventProvider>(context, listen: false);
      final currentUserEmail = authProvider.user?['email'];

      try {
        final api = ApiService();
        print('API Base URL: ${api.baseUrl}'); // Debug log

        final Map<String, dynamic> data = {
          'title': _nameController.text,
          'description': _descriptionController.text,
          'start_time': _selectedDateTime?.toIso8601String() ?? '',
          'end_time': _selectedEndDateTime?.toIso8601String() ?? '',
          'location': _locationController.text,
          'longitude': _selectedLongitude?.toString() ?? '',
          'latitude': _selectedLatitude?.toString() ?? '',
        };

        print('Request data: $data'); // Debug log

        List<MapEntry<String, File>>? files;
        if (_selectedImagePath != null) {
          files = [MapEntry('image', File(_selectedImagePath!))];
        }

        final response = await api.postMultipart(
          '/events',
          data: data,
          files: files,
        );

        print('Response: ${response.toJson()}'); // Debug log

        if (!mounted) return;
        if (response.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Event created successfully')),
          );
          Navigator.of(context).pop();
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(response.responseMessage)));
        }
      } catch (e) {
        print('Submit form error: $e'); // Debug log
        
        // Fallback: Add event locally if API fails
        final newEvent = EventModel(
          name: _nameController.text,
          dateTime: _selectedDateTime,
          endTime: _selectedEndDateTime,
          location: _locationController.text,
          description: _descriptionController.text,
          boxIsSelected: false,
          isFavourite: false,
          hasTicket: false,
          eventImageUrl: _selectedImagePath,
          createdBy: currentUserEmail,
        );
        
        eventProvider.addEvent(newEvent);
        
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event created successfully (offline mode)')),
        );
        Navigator.of(context).pop();
      }
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImagePath = image.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Appbar(title: 'Create Event'),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 20),
              CustomTextField(
                label: 'Event Name',
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an event name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: 'Description',
                controller: _descriptionController,
                validator: (value) {
                  return null;
                },
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: 'Location Name',
                controller: _locationController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a location';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Map picker
              SizedBox(
                height: 200,
                child: FlutterMap(
                  options: MapOptions(
                    center:
                        _selectedLatitude != null && _selectedLongitude != null
                        ? LatLng(_selectedLatitude!, _selectedLongitude!)
                        : _defaultCenter,
                    zoom: 13.0,
                    onTap: (tapPosition, latlng) {
                      setState(() {
                        _selectedLatitude = latlng.latitude;
                        _selectedLongitude = latlng.longitude;
                      });
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: const ['a', 'b', 'c'],
                    ),
                    if (_selectedLatitude != null && _selectedLongitude != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: LatLng(
                              _selectedLatitude!,
                              _selectedLongitude!,
                            ),
                            width: 40,
                            height: 40,
                            child: const Icon(
                              Icons.location_on,
                              color: Colors.red,
                              size: 40,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedLatitude != null && _selectedLongitude != null
                          ? 'Lat: $_selectedLatitude, Lng: $_selectedLongitude'
                          : 'No coordinates selected',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  // TODO: Add map picker interaction
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedImagePath == null
                          ? 'No image selected'
                          : 'Image selected: ${_selectedImagePath!.split('/').last}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: const Text('Pick Image'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDateTime == null
                          ? 'No start date selected'
                          : 'Start: ${_selectedDateTime!.toLocal()}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  TextButton(
                    onPressed: _pickDateTime,
                    child: const Text('Pick Start Date & Time'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedEndDateTime == null
                          ? 'No end date selected'
                          : 'End: ${_selectedEndDateTime!.toLocal()}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  TextButton(
                    onPressed: _pickEndDateTime,
                    child: const Text('Pick End Date & Time'),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              CustomButton(text: 'Create Event', onPressed: _submitForm),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
