class User {
  final String id;
  final String username;
  final String email;
  final String namaLengkap;
  final String noTelp;
  final String password;
  final String? foto;
  final String level;
  final String role; // 'admin' | 'user' | 'driver'
  final String status; // 'aktif' | 'nonaktif'
  final int? driverId; // Relasi ke ID Supir jika rolenya adalah 'driver'

  const User({
    required this.id,
    required this.username,
    required this.email,
    required this.namaLengkap,
    required this.noTelp,
    required this.password,
    this.foto,
    this.level = 'VIP Member',
    this.role = 'user',
    this.status = 'aktif',
    this.driverId,
  });

  bool get isAdmin =>
      role.toLowerCase() == 'admin' ||
      level.toLowerCase().contains('admin') ||
      username.toLowerCase() == 'admin' ||
      email.toLowerCase().contains('admin');

  bool get isDriver =>
      role.toLowerCase() == 'driver' ||
      role.toLowerCase() == 'supir' ||
      level.toLowerCase().contains('supir') ||
      level.toLowerCase().contains('driver');

  bool get isUser => !isAdmin && !isDriver;

  bool get isAktif => status.toLowerCase() != 'nonaktif';

  String get roleDisplayName {
    if (isAdmin) return 'Administrator';
    if (isDriver) return 'Supir (Driver)';
    return 'Pelanggan (User)';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'namaLengkap': namaLengkap,
      'noTelp': noTelp,
      'password': password,
      'foto': foto,
      'level': level,
      'role': role,
      'status': status,
      'driverId': driverId,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    final levelVal = json['level'] as String? ?? 'Member';
    final roleVal = json['role'] as String? ??
        (levelVal.toLowerCase().contains('admin')
            ? 'admin'
            : (levelVal.toLowerCase().contains('driver') ||
                    levelVal.toLowerCase().contains('supir')
                ? 'driver'
                : 'user'));
    return User(
      id: json['id'] as String? ?? '',
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      namaLengkap: json['namaLengkap'] as String? ?? '',
      noTelp: json['noTelp'] as String? ?? '',
      password: json['password'] as String? ?? '',
      foto: json['foto'] as String?,
      level: levelVal,
      role: roleVal,
      status: json['status'] as String? ?? 'aktif',
      driverId: json['driverId'] is int
          ? json['driverId'] as int
          : int.tryParse(json['driverId']?.toString() ?? ''),
    );
  }

  User copyWith({
    String? id,
    String? username,
    String? email,
    String? namaLengkap,
    String? noTelp,
    String? password,
    String? foto,
    String? level,
    String? role,
    String? status,
    int? driverId,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      namaLengkap: namaLengkap ?? this.namaLengkap,
      noTelp: noTelp ?? this.noTelp,
      password: password ?? this.password,
      foto: foto ?? this.foto,
      level: level ?? this.level,
      role: role ?? this.role,
      status: status ?? this.status,
      driverId: driverId ?? this.driverId,
    );
  }
}
