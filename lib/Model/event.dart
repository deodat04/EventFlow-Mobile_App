class Event {
  final String id;
  final String name;
  final String eventType;
  final String imageUrl;
  final String date;
  final String location;
  final String time;
  final String about;
  final int price;
  final dynamic key;

  Event({
    required this.id,
    required this.name,
    required this.eventType,
    required this.imageUrl,
    required this.date,
    required this.location,
    required this.time,
    required this.about,
    required this.price,
    required this.key,
  });

  factory Event.fromMap(Map<String, dynamic> data, String documentId) {
    return Event(
      id: documentId,
      name: data['name'] ?? '',
      eventType: data['eventType'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      date: data['date'] ?? '',
      location: data['location'] ?? '',
      time: data['time'] ?? '',
      about: data['about'] ?? '',
      price: data['price'] ?? '',
       key: data['key'] ?? '',
    );
  }

  

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'eventType': eventType,
      'imageUrl': imageUrl,
      'date': date,
      'location': location,
      'time': time,
      'about': about,
      'price': price,
      'key': key,
    };
  }
}
