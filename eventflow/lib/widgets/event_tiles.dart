import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:eventflow/models/event_model.dart';
import 'package:eventflow/providers/event_provider.dart';
import 'package:eventflow/providers/my_events_provider.dart';
import 'package:eventflow/providers/favorites_provider.dart';
import 'package:eventflow/screens/event_details.dart';
import 'package:eventflow/screens/create_event.dart';

class EventTiles extends StatelessWidget {
   const EventTiles({
     super.key,
     required this.eventModel,
     this.showHeader = true,
     this.isMyEvents = false,
   });

   final List<EventModel> eventModel;
   final bool showHeader;
   final bool isMyEvents;

  Widget _buildEventImage(String? imageUrl) {
    if (imageUrl == null) {
      return Container(color: const Color(0xFF13D0A1));
    }

    // Check if it's a network URL
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return FadeInImage.assetNetwork(
        placeholder: '', // Empty placeholder to avoid showing anything initially
        image: imageUrl,
        fit: BoxFit.cover,
        placeholderErrorBuilder: (context, error, stackTrace) {
          return Container(color: const Color(0xFF13D0A1));
        },
        imageErrorBuilder: (context, error, stackTrace) {
          print('Error loading image: $error');
          return Container(
            color: const Color(0xFF13D0A1),
            child: const Icon(Icons.error, color: Colors.white),
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
            child: const Icon(Icons.image_not_supported, color: Colors.white),
          );
        },
      );
    }

    // Default fallback
    return Container(color: const Color(0xFF13D0A1));
  }

  @override
  Widget build(BuildContext context) {
    if (eventModel.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showHeader)
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
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40.0),
              child: Text(
                'No events present',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showHeader)
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: ListView.separated(
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
                              borderRadius: BorderRadius.circular(16),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: _buildEventImage(
                              eventModel[index].eventImageUrl,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        // ---EVENT DETAILS---
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                // ---EVENT DATE AND TIME---
                                Row(
                                  children: [
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
                                    if (eventModel[index].dateTime != null &&
                                        eventModel[index].dateTime!.isBefore(DateTime.now()))
                                      Container(
                                        margin: const EdgeInsets.only(left: 8),
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.red.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Text(
                                          'PAST',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                  ],
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
                                // Favourite and Ticket buttons or Edit/Delete buttons
                                if (isMyEvents)
                                  Consumer<MyEventsProvider>(
                                    builder: (context, myEventsProvider, child) {
                                      return Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                              Icons.edit,
                                              color: Colors.blue,
                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => CreateEventScreen(
                                                    eventToEdit: eventModel[index],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                            onPressed: () async {
                                              final confirm = await showDialog<bool>(
                                                context: context,
                                                builder: (context) => AlertDialog(
                                                  title: const Text('Delete Event'),
                                                  content: const Text('Are you sure you want to delete this event?'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () => Navigator.of(context).pop(false),
                                                      child: const Text('Cancel'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () => Navigator.of(context).pop(true),
                                                      child: const Text('Delete'),
                                                    ),
                                                  ],
                                                ),
                                              );
                                              if (confirm == true) {
                                                await myEventsProvider.deleteEvent(eventModel[index]);
                                              }
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  )
                                else
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
                                            onPressed: () async {
                                              await eventProvider.toggleFavourite(
                                                eventModel[index],
                                              );
                                              // Refresh favorites after toggling
                                              final favoritesProvider = Provider.of<FavoritesProvider>(context, listen: false);
                                              await favoritesProvider.loadFavorites();
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              eventModel[index].hasTicket
                                                  ? Icons.confirmation_number
                                                  : Icons
                                                      .confirmation_number_outlined,
                                              color: eventModel[index].hasTicket
                                                  ? Colors.green
                                                  : Colors.grey,
                                            ),
                                            onPressed: () async {
                                              await eventProvider.toggleTicket(
                                                eventModel[index],
                                              );
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
        ),
      ],
    );
  }
}