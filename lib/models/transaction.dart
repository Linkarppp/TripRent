class TransactionRecord {
  final String id;
  final String orderCode;
  final String customerName;
  final String itemName;
  final int totalAmount;
  final String paymentMethod;
  final String status; // 'Menunggu Verifikasi' | 'Lunas' | 'Ditolak'
  final DateTime transactionDate;
  final String? proofImageUrl;
  final String? notes;

  bool get isPending => status == 'Menunggu Verifikasi' || status == 'Pending';
  bool get isApproved => status == 'Lunas';
  bool get isRejected => status == 'Ditolak';

  const TransactionRecord({
    required this.id,
    required this.orderCode,
    required this.customerName,
    required this.itemName,
    required this.totalAmount,
    required this.paymentMethod,
    required this.status,
    required this.transactionDate,
    this.proofImageUrl,
    this.notes,
  });

  TransactionRecord copyWith({
    String? id,
    String? orderCode,
    String? customerName,
    String? itemName,
    int? totalAmount,
    String? paymentMethod,
    String? status,
    DateTime? transactionDate,
    String? proofImageUrl,
    String? notes,
  }) {
    return TransactionRecord(
      id: id ?? this.id,
      orderCode: orderCode ?? this.orderCode,
      customerName: customerName ?? this.customerName,
      itemName: itemName ?? this.itemName,
      totalAmount: totalAmount ?? this.totalAmount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      status: status ?? this.status,
      transactionDate: transactionDate ?? this.transactionDate,
      proofImageUrl: proofImageUrl ?? this.proofImageUrl,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderCode': orderCode,
      'customerName': customerName,
      'itemName': itemName,
      'totalAmount': totalAmount,
      'paymentMethod': paymentMethod,
      'status': status,
      'transactionDate': transactionDate.toIso8601String(),
      'proofImageUrl': proofImageUrl,
      'notes': notes,
    };
  }

  factory TransactionRecord.fromJson(Map<String, dynamic> json) {
    return TransactionRecord(
      id: json['id'] ?? '',
      orderCode: json['orderCode'] ?? '',
      customerName: json['customerName'] ?? '',
      itemName: json['itemName'] ?? '',
      totalAmount: json['totalAmount'] is int
          ? json['totalAmount']
          : int.tryParse(json['totalAmount']?.toString() ?? '0') ?? 0,
      paymentMethod: json['paymentMethod'] ?? 'Transfer Bank BCA',
      status: json['status'] ?? 'Menunggu Verifikasi',
      transactionDate: json['transactionDate'] != null
          ? DateTime.tryParse(json['transactionDate'].toString()) ?? DateTime.now()
          : DateTime.now(),
      proofImageUrl: json['proofImageUrl'],
      notes: json['notes'],
    );
  }
}
