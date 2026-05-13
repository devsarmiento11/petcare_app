import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';



import '../models/service.dart' as app_service_model;
import '../services/booking_service.dart';
import '../services/pet_service.dart' as pet_store_service;






import 'booksuccess_screen.dart';



class BookAppointmentScreen extends StatefulWidget {
  final String doctorName;
  final String serviceCategory;
  final String serviceName;
  final double servicePrice;

  const BookAppointmentScreen({
    super.key,
    required this.doctorName,
    required this.serviceCategory,
    required this.serviceName,
    required this.servicePrice,
  });

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  int selectedDay = 27;
  String selectedTime = "11:30";

  bool _isBooking = false;

  final BookingService _bookingService = BookingService();


  final List<String> times = [
    "9:30",
    "10:30",
    "11:30",
    "3:30",
    "4:30",
    "5:30",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f4f4),
      body: SafeArea(
        child: Column(
          children: [
            _topBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Choose a Date",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _calendarCard(),
                    const SizedBox(height: 26),
                    const Text(
                      "Pick a Time",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _timeGrid(),
                    const SizedBox(height: 28),
                    _bookButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _topBar(BuildContext context) {
    return Container(
      height: 72,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xff2f6f78),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(2),
          bottomRight: Radius.circular(2),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.black),
          ),
          Expanded(
            child: Center(
              child: Text(
                "${widget.doctorName}'s",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _calendarCard() {
    final List<String> weekDays = ["M", "Tu", "W", "Th", "F", "Sa", "Su"];

    final List<int> days = [
      25, 30, 31, 1, 2, 3, 4,
      5, 6, 7, 8, 9, 10, 11,
      12, 13, 14, 15, 16, 17, 18,
      19, 20, 21, 22, 23, 24, 25,
      26, 27, 28, 29, 30, 31, 1,
      2, 3, 4, 5, 6, 7, 8,
    ];

    return Center(
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "March",
                  style: TextStyle(
                    color: Color(0xff5aae68),
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
                Icon(Icons.keyboard_arrow_down,
                    size: 16, color: Color(0xff5aae68)),
                SizedBox(width: 16),
                Text(
                  "2026",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                Icon(Icons.keyboard_arrow_down, size: 16),
              ],
            ),
            const SizedBox(height: 18),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: weekDays.map((day) {
                return SizedBox(
                  width: 28,
                  child: Center(
                    child: Text(
                      day,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 10),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: days.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 7,
                crossAxisSpacing: 7,
              ),
              itemBuilder: (context, index) {
                final day = days[index];
                final bool isSelected = day == selectedDay;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDay = day;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? const Color(0xff58b363)
                          : Colors.transparent,
                    ),
                    child: Center(
                      child: Text(
                        "$day",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? Colors.white
                              : Colors.black.withOpacity(0.55),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _timeGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: times.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 16,
        childAspectRatio: 4.3,
      ),
      itemBuilder: (context, index) {
        final time = times[index];
        final bool isSelected = selectedTime == time;

        return GestureDetector(
          onTap: () {
            setState(() {
              selectedTime = time;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xff2f6f78) : Colors.white,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: Colors.black.withOpacity(0.10),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.10),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                time,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _bookButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: _isBooking
            ? null
            : () async {
                setState(() {
                  _isBooking = true;
                });

                try {
                  final user = FirebaseAuth.instance.currentUser;
                  if (user == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please login to book.')),
                    );
                    return;
                  }

                  // Fetch the user’s pets from Firestore and pick the first one.
                  // (You can extend this later to show a pet picker UI.)
                  final petStoreService = pet_store_service.PetService();

                  final pets = await petStoreService.getUserPets(user.uid);


                  if (pets.isEmpty) {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please add a pet profile first.')),
                    );
                    return;
                  }
                  final pet = pets.first;

final service = app_service_model.PetService(
                    id: widget.serviceCategory,
                    name: widget.serviceName,
                    description: '${widget.serviceName} service',
                    price: widget.servicePrice,
                    category: widget.serviceCategory,
                    imageUrl: '',
                    rating: 0.0,
                  );

                  final bookingDate = DateTime(2026, 3, selectedDay);

                  await _bookingService.createBookingInFirestore(
                    uid: user.uid,
                    pet: pet,
                    service: service,
                    date: bookingDate,
                    time: selectedTime,
                    notes: null,
                  );


                  if (!mounted) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const BookSuccessScreen(),
                    ),
                  );
                } catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Booking failed: $e')),
                  );
                } finally {
                  if (mounted) {
                    setState(() {
                      _isBooking = false;
                    });
                  }
                }
              },

        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff2f6f78),
          foregroundColor: Colors.white,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        child: _isBooking
            ? const Center(
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Book an Appointment",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 14),
                  Icon(Icons.calendar_month_outlined, size: 20),
                ],
              ),

      ),
    );
  }
}

