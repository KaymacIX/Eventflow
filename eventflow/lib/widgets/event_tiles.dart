import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:eventflow/models/event_model.dart';
import 'package:eventflow/providers/event_provider.dart';
import 'package:eventflow/screens/event_details.dart';

class EventTiles extends StatelessWidget {
  const EventTiles({super.key, required this.eventModel});

  final List<EventModel> eventModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            'Events',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        ListView.separated(
          itemCount: eventModel.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            return Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                highlightColor: Colors.grey,
                splashColor: Colors.blue,
                hoverColor: Colors.grey,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return EventDetails(eventModel: eventModel[index]);
                      },
                    ),
                  );
                },
                child: Container(
                  height: 125,
                  decoration: BoxDecoration(
                    color: eventModel[index].boxIsSelected
                        ? Colors.grey[200]
                        : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // ---image container with Hero---
                      Hero(
                        tag: 'event-image-${eventModel[index].name}',
                        child: Container(
                          width: 125,
                          height: 125,
                          decoration: BoxDecoration(
                            color: const Color(0xFF13D0A1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      // ---EVENT DETAILS---
                      // ---EVENT DATE AND TIME---
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ---EVENT DATE AND TIME---
                              Text(
                                eventModel[index].dateTime != null
                                    ? DateFormat(
                                        'EEE, MMM d  ·  h:mm a',
                                      ).format(eventModel[index].dateTime!)
                                    : '',
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              // ---EVENT NAME---
                              Text(
                                eventModel[index].name,
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              // ---EVENT LOCATION---
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    size: 14,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: Text(
                                      eventModel[index].location,
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // Favourite and Ticket buttons
                              Consumer<EventProvider>(
                                builder: (context, eventProvider, child) {
                                  return Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          eventModel[index].isFavourite
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: eventModel[index].isFavourite
                                              ? Colors.red
                                              : Colors.grey,
                                        ),
                                        onPressed: () {
                                          eventProvider.toggleFavourite(eventModel[index]);
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          eventModel[index].hasTicket
                                              ? Icons.confirmation_number
                                              : Icons.confirmation_number_outlined,
                                          color: eventModel[index].hasTicket
                                              ? Colors.green
                                              : Colors.grey,
                                        ),
                                        onPressed: () {
                                          eventProvider.toggleTicket(eventModel[index]);
                                        },
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
