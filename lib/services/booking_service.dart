import '../models/booking.dart';
import '../models/pet.dart';
import '../models/service.dart';

class BookingService {
  final List<Booking> _bookings = [];

  Future<List<Booking>> getBookings() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_bookings);
  }

  Future<Booking> createBooking({
    required Pet pet,
    required PetService service,
    required DateTime date,
    required String time,
    String? notes,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    
    final booking = Booking(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      pet: pet,
      service: service,
      date: date,
      time: time,
      totalPrice: service.price + 5.0,
      notes: notes,
    );
    
    _bookings.add(booking);
    return booking;
  }

  Future<void> cancelBooking(String bookingId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _bookings.removeWhere((b) => b.id == bookingId);
  }

  Future<Booking?> getBookingById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _bookings.firstWhere((b) => b.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<Booking>> getUpcomingBookings() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final now = DateTime.now();
    return _bookings.where((b) => b.date.isAfter(now)).toList();
  }
}
