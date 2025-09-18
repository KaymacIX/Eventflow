class EventModel {
  String name;
  DateTime? dateTime;
  String location;
  bool boxIsSelected = false; // New property to track selection state

  EventModel({
    required this.name,
    this.dateTime,
    required this.location,
    required this.boxIsSelected,
  });

  // DUMMY DATA

  static List<EventModel> getEvents() {
    List<EventModel> events = [];

    events.add(
      EventModel(
        name: 'Music Concert',
        dateTime: DateTime(2024, 7, 15, 19, 30),
        location: 'New York City',
        boxIsSelected: false,
      ), // category 1
    );

    events.add(
      EventModel(
        name: 'Art Exhibition',
        dateTime: DateTime(2024, 8, 1, 10, 0),
        location: 'Los Angeles',
        boxIsSelected: false,
      ), // category 2
    );

    events.add(
      EventModel(
        name: 'Tech Conference',
        dateTime: DateTime(2024, 9, 10, 9, 0),
        location: 'San Francisco',
        boxIsSelected: false,
      ), // category 3
    );

    events.add(
      EventModel(
        name: 'Food Festival',
        dateTime: DateTime(2024, 10, 5, 12, 0),
        location: 'Chicago',
        boxIsSelected: false,
      ), // category 4
    );

    events.add(
      EventModel(
        name: 'Marathon',
        dateTime: DateTime(2024, 11, 20, 7, 0),
        location: 'Boston',
        boxIsSelected: false,
      ), // category 5
    );

    return events;
  }
}
