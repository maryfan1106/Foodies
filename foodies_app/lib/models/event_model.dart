class Event {
  final int eid;
  final String name;
  final String timestamp;
  final int budget;
  final int attendees;

  Event({
    this.eid,
    this.name,
    this.timestamp,
    this.budget,
    this.attendees
  });

  factory Event.fromJson(Map<String, dynamic> parsedJson){
    return Event(
      eid: parsedJson['eid'],
      name: parsedJson['name'],
      timestamp: parsedJson['timestamp'],
      budget: parsedJson['budget'],
      attendees: parsedJson['attendees'],
    );
  }
}

