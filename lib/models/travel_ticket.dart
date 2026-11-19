class TravelTicket {
  final int id;
  final String title;
  final String category;
  final String origin;
  final String destination;
  final int price;
  final String estimatedDuration;
  final String vehicleName;
  final List<String> departureTimes;
  final int availableSeats;
  final String image;
  final String description;

  const TravelTicket({
    required this.id,
    required this.title,
    required this.category,
    required this.origin,
    required this.destination,
    required this.price,
    required this.estimatedDuration,
    required this.vehicleName,
    required this.departureTimes,
    required this.availableSeats,
    required this.image,
    required this.description,
  });
}
