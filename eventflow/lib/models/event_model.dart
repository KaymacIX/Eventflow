import 'package:flutter_dotenv/flutter_dotenv.dart';

class EventModel {
  String name;
  DateTime? dateTime;
  DateTime? endTime;
  String location;
  String description;
  bool boxIsSelected = false;
  bool isFavourite = false;
  bool hasTicket = false;
  String? eventImageUrl;
  String? createdBy; // User ID or email of the event creator
  String? createdByName; // User name of the event creator

  EventModel({
    required this.name,
    this.dateTime,
    this.endTime,
    required this.location,
    required this.description,
    required this.boxIsSelected,
    required this.isFavourite,
    required this.hasTicket,
    this.eventImageUrl,
    this.createdBy,
    this.createdByName,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    String? imageUrl = json['image_url'];
    
    if (imageUrl != null && !imageUrl.startsWith('http')) {
      // Get base URL from .env using flutter_dotenv
      String baseUrl = dotenv.env['BASE_URL'] ?? '';
      
      // Remove trailing /api if present
      if (baseUrl.endsWith('/api')) {
        baseUrl = baseUrl.substring(0, baseUrl.length - 4);
      }
      
      // Remove leading slash from imageUrl if present
      if (imageUrl.startsWith('/')) {
        imageUrl = imageUrl.substring(1);
      }
      
      // Construct full URL
      imageUrl = '$baseUrl/$imageUrl';
      print('Event image URL: $imageUrl');
    }
    
    return EventModel(
      name: json['title'] ?? '',
      dateTime: json['start_time'] != null
          ? DateTime.tryParse(json['start_time'])
          : null,
      endTime: json['end_time'] != null
          ? DateTime.tryParse(json['end_time'])
          : null,
      location: json['location'] ?? '',
      description: json['description'] ?? '',
      boxIsSelected: false,
      isFavourite: json['is_favourite'] ?? false,
      hasTicket: json['has_ticket'] ?? false,
      eventImageUrl: imageUrl,
      createdBy: json['created_by'] ?? json['user_id']?.toString(),
      createdByName: json['created_by_name'] ?? json['user']?['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': name,
      'start_time': dateTime?.toIso8601String(),
      'end_time': endTime?.toIso8601String(),
      'location': location,
      'description': description,
      'is_favourite': isFavourite,
      'has_ticket': hasTicket,
      'image_url': eventImageUrl,
      'created_by': createdBy,
      'created_by_name': createdByName,
    };
  }

}