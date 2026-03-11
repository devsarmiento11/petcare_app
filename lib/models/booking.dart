import 'pet.dart';
import 'service.dart';

class Booking {
  final String id;
  final Pet pet;
  final PetService service;
  final DateTime date;
  final String time;
  final String status;
  final double totalPrice;
  final String? notes;

  Booking({
    required this.id,
    required this.pet,
    required this.service,
    required this.date,
    required this.time,
    this.status = 'pending',
    required this.totalPrice,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'pet': pet.toJson(),
        'service': service.toJson(),
        'date': date.toIso8601String(),
        'time': time,
        'status': status,
        'totalPrice': totalPrice,
        'notes': notes,
      };

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
        id: json['id'],
        pet: Pet.fromJson(json['pet']),
        service: PetService.fromJson(json['service']),
        date: DateTime.parse(json['date']),
        time: json['time'],
        status: json['status'] ?? 'pending',
        totalPrice: json['totalPrice'].toDouble(),
        notes: json['notes'],
      );
}
