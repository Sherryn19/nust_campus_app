enum EventType { workshop, seminar, conference, social, sports, career }

class Event {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String location;
  final DateTime date;
  final DateTime startTime;
  final DateTime endTime;
  final EventType type;
  final List<String> tags;
  final String organizer;
  final int capacity;
  final int registeredCount;
  final bool isFeatured;
  final bool isSaved;
  final String? registrationLink;
  final String? venueUrl;

  const Event({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.location,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.type,
    required this.tags,
    required this.organizer,
    required this.capacity,
    required this.registeredCount,
    this.isFeatured = false,
    this.isSaved = false,
    this.registrationLink,
    this.venueUrl,
  });

  Event copyWith({bool? isSaved}) => Event(
        id: id,
        title: title,
        description: description,
        imageUrl: imageUrl,
        location: location,
        date: date,
        startTime: startTime,
        endTime: endTime,
        type: type,
        tags: tags,
        organizer: organizer,
        capacity: capacity,
        registeredCount: registeredCount,
        isFeatured: isFeatured,
        isSaved: isSaved ?? this.isSaved,
        registrationLink: registrationLink,
        venueUrl: venueUrl,
      );

  String get typeLabel {
    switch (type) {
      case EventType.workshop: return 'Workshop';
      case EventType.seminar: return 'Seminar';
      case EventType.conference: return 'Conference';
      case EventType.social: return 'Social';
      case EventType.sports: return 'Sports';
      case EventType.career: return 'Career';
    }
  }
}
