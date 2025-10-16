import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:eventflow/models/event_model.dart';
import 'package:eventflow/providers/auth_provider.dart';
import 'package:eventflow/providers/event_provider.dart';
import 'package:eventflow/widgets/custom_button.dart';

class EventDetails extends StatefulWidget {
  const EventDetails({super.key, required this.eventModel});

  final EventModel eventModel;

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  bool _isFavorited = false;
  int _attendeeCount = 0;

  @override
  void initState() {
    super.initState();
    _calculateAttendeeCount();
  }

  void _calculateAttendeeCount() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final eventProvider = Provider.of<EventProvider>(context, listen: false);

    final currentUserEmail = authProvider.user?['email'];
    if (widget.eventModel.createdBy == currentUserEmail) {
      // Count how many events have this event's name and hasTicket = true
      _attendeeCount = eventProvider.events
          .where((event) => event.name == widget.eventModel.name && event.hasTicket)
          .length;
    }
  }

  String _getTimeRange() {
    if (widget.eventModel.dateTime != null) {
      String startTime = DateFormat('h:mm a').format(widget.eventModel.dateTime!);

      if (widget.eventModel.endTime != null) {
        String endTime = DateFormat('h:mm a').format(widget.eventModel.endTime!);
        return '$startTime - $endTime';
      } else {
        return startTime;
      }
    }
    return '10:00 AM - 12:00 PM'; // Default fallback
  }

  Widget _buildEventImage(String? imageUrl) {
    if (imageUrl == null) {
      return Container(color: const Color(0xFF13D0A1));
    }

    // Check if it's a network URL
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: Colors.grey[300],
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          print('Error loading image: $error');
          return Container(
            color: const Color(0xFF13D0A1),
            child: const Icon(Icons.error, color: Colors.white, size: 50),
          );
        },
      );
    }

    // Check if it's a local asset
    if (imageUrl.startsWith('lib/assets/')) {
      return Image.asset(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: const Color(0xFF13D0A1),
            child: const Icon(
              Icons.image_not_supported,
              color: Colors.white,
              size: 50,
            ),
          );
        },
      );
    }

    // Default fallback
    return Container(color: const Color(0xFF13D0A1));
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final currentUserEmail = authProvider.user?['email'];
    final isEventOwner = widget.eventModel.createdBy == currentUserEmail;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // IMAGE with Hero
                  Stack(
                    children: [
                      Hero(
                        tag: 'event-image-${widget.eventModel.name}',
                        child: Container(
                          height: 300,
                          width: double.infinity,
                          child: _buildEventImage(widget.eventModel.eventImageUrl),
                        ),
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
                            icon: const Icon(Icons.arrow_back, color: Colors.black),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Content area
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        // EVENT TITLE
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.eventModel.name,
                                style: const TextStyle(
                                  fontSize: 34,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (widget.eventModel.dateTime != null &&
                                widget.eventModel.dateTime!.isBefore(DateTime.now()))
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Text(
                                  'PAST',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Row(
                          children: [
                            // DATE
                            const Icon(Icons.calendar_month),
                            const SizedBox(width: 10),
                            Text(
                              widget.eventModel.dateTime != null
                                  ? DateFormat(
                                      'EEE, MMMM d, yyyy',
                                    ).format(widget.eventModel.dateTime!)
                                  : '',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // TIME
                        Row(
                          children: [
                            const Icon(Icons.access_time, size: 16),
                            const SizedBox(width: 5),
                            Text(
                              _getTimeRange(),
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // const Text(
                        //   'Add to Calendar',
                        //   style: TextStyle(
                        //     fontSize: 14,
                        //     color: Colors.blue,
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),
                        const SizedBox(height: 30),
                        Row(
                          children: [
                            const Icon(Icons.location_on),
                            const SizedBox(width: 10),
                            // LOCATION
                            Expanded(
                              child: Text(
                                widget.eventModel.location,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.eventModel.location,
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 10),
                        // const Text(
                        //   'Get Directions',
                        //   style: TextStyle(
                        //     fontSize: 14,
                        //     color: Colors.blue,
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),
                        const SizedBox(height: 30),
                        // DESCRIPTION
                        const Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.eventModel.description.isNotEmpty ? widget.eventModel.description : 'No description available.',
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 20),
                        // ATTENDEE COUNT (only for event owner)
                        if (isEventOwner)
                          Row(
                            children: [
                              const Icon(Icons.people),
                              const SizedBox(width: 10),
                              Text(
                                'Attendees: $_attendeeCount',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        if (isEventOwner)
                          const SizedBox(height: 20),
                        // HOST
                        if (widget.eventModel.createdBy != null || widget.eventModel.createdByName != null)
                          Row(
                            children: [
                              const Icon(Icons.person),
                              const SizedBox(width: 10),
                              Text(
                                'Hosted by: ${widget.eventModel.createdByName ?? widget.eventModel.createdBy ?? 'Unknown'}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        if (widget.eventModel.createdBy != null || widget.eventModel.createdByName != null)
                          const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Buttons at the bottom
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Get Tickets',
                    onPressed: () async {
                      final eventProvider = Provider.of<EventProvider>(context, listen: false);
                      await eventProvider.toggleTicket(widget.eventModel);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: const Color(0xFF13D0A1),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: Icon(
                      widget.eventModel.isFavourite ? Icons.favorite : Icons.favorite_border,
                      color: widget.eventModel.isFavourite
                          ? Colors.red
                          : const Color(0xFF13D0A1),
                    ),
                    onPressed: () async {
                      final eventProvider = Provider.of<EventProvider>(context, listen: false);
                      await eventProvider.toggleFavourite(widget.eventModel);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

