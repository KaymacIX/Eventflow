import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:eventflow/models/event_model.dart';
import 'package:eventflow/widgets/custom_button.dart';

class EventDetails extends StatefulWidget {
  const EventDetails({super.key, required this.eventModel});

  final EventModel eventModel;

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column( // Outer Column: will contain the scrollable content and the button
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // IMAGE PLACEHOLDER with Hero - This remains outside the scrollable area
          Stack(
            children: [
              Hero(
                tag: 'event-image-${widget.eventModel.name}',
                child: Container(height: 300, color: Color(0xFF13D0A1)),
              ),
              Positioned(
                left: 20,
                bottom: 20,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.9),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
            ],
          ),
          // Scrollable content area
          Expanded( // Make the content area expand to fill available vertical space
            child: SingleChildScrollView( // Allow content to scroll if it overflows
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column( // Inner column for the details
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    // EVENT TITLE
                    Text(
                      widget.eventModel.name,
                      style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 30),
                    Row(
                      children: [
                        // DATE
                        Icon(Icons.calendar_month),
                        SizedBox(width: 10),
                        Text(
                          widget.eventModel.dateTime != null
                              ? DateFormat(
                            'EEE, MMMM d, yyyy',
                          ).format(widget.eventModel.dateTime!)
                              : '',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    // TIME
                    Text('10:00 AM - 12:00 PM', style: TextStyle(fontSize: 14)),
                    SizedBox(height: 10),
                    Text(
                      'Add to Calendar',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 30),
                    Row(
                      children: [
                        Icon(Icons.location_on),
                        SizedBox(width: 10),
                        // LOCATION
                        Text(
                          widget.eventModel.location,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // ADDRESS
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Main Campus, TLC 1, Lusaka',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Get Directions',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 30),
                    // DESCRIPTION
                    Text(
                      'Description',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'This is a detailed description of the event. It provides information about what to expect, who will be there, and any other relevant details that attendees might need to know.',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 20), // Add some space before the button if button is not sticky
                  ],
                ),
              ),
            ),
          ),
          // Button at the bottom, outside the scrollable area but within the main Column
          Padding( // Optional: Add padding around the button
            padding: const EdgeInsets.all(20.0),
            child: CustomButton(
              text: 'Attend',
              onPressed: () {},
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
