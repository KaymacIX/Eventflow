import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:eventflow/models/event_model.dart';
import 'package:eventflow/screens/event_details.dart';

class EventTiles extends StatelessWidget {
  const EventTiles({super.key, required this.eventModel});

  final List<EventModel> eventModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
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
          physics: NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) => SizedBox(height: 10),
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
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: Offset(0, 2),
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
                            color: Color(0xFF13D0A1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                      SizedBox(width: 4),
                      // ---EVENT DETAILS---
                      // ---EVENT DATE AND TIME---
                      Padding(
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
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            // ---EVENT NAME---
                            Text(
                              eventModel[index].name,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            // ---EVENT LOCATION---
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 14,
                                  color: Colors.grey,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  eventModel[index].location,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ],
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
