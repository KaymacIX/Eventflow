class PopularEventModel {
  String name;
  DateTime? dateTime;
  String location;

  PopularEventModel({
    required this.name,
    this.dateTime,
    required this.location,
  });

  // dummy data

  static List<PopularEventModel> getPopularEvents() {
    List<PopularEventModel> popularEvents = [];

    popularEvents.add(
      PopularEventModel(
        name: 'Music Concert',
        dateTime: DateTime(2024, 7, 15, 19, 30),
        location: 'New York City',
      ), // category 1
    );

    popularEvents.add(
      PopularEventModel(
        name: 'Art Exhibition',
        dateTime: DateTime(2024, 8, 1, 10, 0),
        location: 'Los Angeles',
      ), // category 2
    );

    popularEvents.add(
      PopularEventModel(
        name: 'Tech Conference',
        dateTime: DateTime(2024, 9, 10, 9, 0),
        location: 'San Francisco',
      ), // category 3
    );

    return popularEvents;
  }
}
