class ShuttleOutlet {
  final String id;
  final String name;
  final String city;
  final String address;

  const ShuttleOutlet({
    required this.id,
    required this.name,
    required this.city,
    required this.address,
  });

  String get displayName => '$city - $name';
}

class ShuttleSchedule {
  final String id;
  final String routeTitle;
  final String originOutlet;
  final String destinationOutlet;
  final String departureTime;
  final String arrivalTime;
  final String duration;
  final String vehicleName;
  final String vehicleType;
  final int price;
  final int totalSeats;
  final int availableSeats;
  final List<String> facilities;
  final List<int> occupiedSeats;

  const ShuttleSchedule({
    required this.id,
    required this.routeTitle,
    required this.originOutlet,
    required this.destinationOutlet,
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
    required this.vehicleName,
    required this.vehicleType,
    required this.price,
    required this.totalSeats,
    required this.availableSeats,
    this.facilities = const [
      'AC Dingin',
      'Reclining Seat',
      'USB Charger',
      'Bagasi 20kg',
      'Air Mineral',
    ],
    this.occupiedSeats = const [],
  });

  int get hourInt {
    try {
      return int.parse(departureTime.split(':').first);
    } catch (_) {
      return 0;
    }
  }

  String get timeOfDayCategory {
    if (hourInt >= 5 && hourInt < 11) return 'Pagi';
    if (hourInt >= 11 && hourInt < 15) return 'Siang';
    if (hourInt >= 15 && hourInt < 18) return 'Sore';
    return 'Malam';
  }
}

class ShuttleDataHelper {
  static const List<ShuttleOutlet> outlets = [
    ShuttleOutlet(
      id: 'PDG-01',
      city: 'Padang',
      name: 'Pool Pusat Tunggul Hitam',
      address: 'Jl. Angkasa Puri No. 4, Padang Utara',
    ),
    ShuttleOutlet(
      id: 'BIM-01',
      city: 'Padang Pariaman',
      name: 'Bandara Internasional Minangkabau (BIM)',
      address: 'Lobi Kedatangan Terminal Bandara BIM',
    ),
    ShuttleOutlet(
      id: 'BKT-01',
      city: 'Bukittinggi',
      name: 'Pool Jam Gadang',
      address: 'Jl. Sudirman No. 18, Pusat Kota Bukittinggi',
    ),
    ShuttleOutlet(
      id: 'PYK-01',
      city: 'Payakumbuh',
      name: 'Pool Ngalau Indah',
      address: 'Jl. Soekarno Hatta No. 45, Payakumbuh',
    ),
    ShuttleOutlet(
      id: 'PDP-01',
      city: 'Padang Panjang',
      name: 'Rest Area Lembah Anai',
      address: 'Jl. Sutan Syahrir No. 12, Silaiang',
    ),
    ShuttleOutlet(
      id: 'SLK-01',
      city: 'Solok',
      name: 'Pool Danau Singkarak',
      address: 'Jl. Raya Solok - Padang Km 5',
    ),
    ShuttleOutlet(
      id: 'PRM-01',
      city: 'Pariaman',
      name: 'Pool Pantai Gandoriah',
      address: 'Jl. Sam Ratulangi No. 8, Pariaman',
    ),
    ShuttleOutlet(
      id: 'PKU-01',
      city: 'Pekanbaru',
      name: 'Pool Jl. Riau / Sudirman',
      address: 'Jl. Riau No. 88, Pekanbaru',
    ),
  ];

  static List<ShuttleSchedule> getSchedules({
    required String origin,
    required String destination,
    required DateTime date,
    int passengers = 1,
  }) {
    // Generate realistic schedule list based on selected route
    final isBIMRoute = origin.contains('BIM') || destination.contains('BIM');
    final isPekanbaru = origin.contains('Pekanbaru') || destination.contains('Pekanbaru');
    final isPayakumbuh = origin.contains('Payakumbuh') || destination.contains('Payakumbuh');
    final isBukittinggi = origin.contains('Bukittinggi') || destination.contains('Bukittinggi');

    int basePrice = 65000;
    String baseDuration = '2 Jam 15 Menit';
    String route = '$origin ➔ $destination';

    if (isBIMRoute) {
      basePrice = 50000;
      baseDuration = '45 Menit';
    } else if (isPekanbaru) {
      basePrice = 180000;
      baseDuration = '5.5 Jam';
    } else if (isPayakumbuh) {
      basePrice = 75000;
      baseDuration = '2.5 Jam';
    } else if (isBukittinggi) {
      basePrice = 65000;
      baseDuration = '2 Jam 15 Menit';
    }

    final timeSlots = [
      ('06:30', '08:45', 'Toyota HiAce Premio Executive', 'Executive', basePrice, 10, [1, 4]),
      ('08:00', '10:15', 'Toyota HiAce Commuter Luxury', 'Luxury', basePrice + 5000, 12, [2, 3, 7]),
      ('09:30', '11:45', 'Toyota HiAce Premio Executive', 'Executive', basePrice, 10, [5]),
      ('11:00', '13:15', 'Toyota Innova Reborn VIP', 'VIP Shuttle', basePrice + 10000, 7, [1, 2]),
      ('13:30', '15:45', 'Toyota HiAce Premio Executive', 'Executive', basePrice, 10, [3, 8]),
      ('15:00', '17:15', 'Toyota HiAce Commuter Luxury', 'Luxury', basePrice + 5000, 12, [4, 6]),
      ('16:30', '18:45', 'Toyota HiAce Premio Executive', 'Executive', basePrice, 10, [1, 2, 7]),
      ('18:00', '20:15', 'Toyota Innova Reborn VIP', 'VIP Shuttle', basePrice + 10000, 7, [3]),
      ('19:30', '21:45', 'Toyota HiAce Premio Night Express', 'Executive', basePrice, 10, [2, 5]),
      ('21:00', '23:15', 'Toyota HiAce Luxury Night', 'Luxury', basePrice + 5000, 12, [1]),
    ];

    return timeSlots.map((slot) {
      final occupied = slot.$7;
      final total = slot.$6;
      final available = total - occupied.length;

      return ShuttleSchedule(
        id: 'SCH-${slot.$1.replaceAll(':', '')}',
        routeTitle: route,
        originOutlet: origin,
        destinationOutlet: destination,
        departureTime: slot.$1,
        arrivalTime: slot.$2,
        duration: baseDuration,
        vehicleName: slot.$3,
        vehicleType: slot.$4,
        price: slot.$5,
        totalSeats: total,
        availableSeats: available,
        occupiedSeats: occupied,
        facilities: [
          'AC Dingin',
          'Reclining Seat',
          'USB Charger Port',
          'Bagasi 20kg',
          'Air Mineral',
          if (slot.$4 == 'VIP Shuttle') 'Snack Ringan',
        ],
      );
    }).where((s) => s.availableSeats >= passengers).toList();
  }
}
