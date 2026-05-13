import 'package:flutter/material.dart';

import 'bookappointment_screen.dart';

class AppointmentScreen extends StatelessWidget {
  final String doctorName;
  final String doctorImage;

  final String serviceCategory;
  final String serviceName;
  final double servicePrice;

  const AppointmentScreen({
    super.key,
    required this.doctorName,
    required this.doctorImage,
    required this.serviceCategory,
    required this.serviceName,
    required this.servicePrice,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F4F4),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 55,
              color: const Color(0xff4E7A80),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        doctorName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Image.asset(
                      doctorImage,
                      width: double.infinity,
                      height: 210,
                      fit: BoxFit.cover,
                    ),
                    Transform.translate(
                      offset: const Offset(0, -25),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 22),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.12),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              doctorName,
                              style: const TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              serviceCategory == 'grooming'
                                  ? 'Grooming Service'
                                  : 'Veterinary Dentist',
                              style: TextStyle(
                                color: const Color(0xff4E7A80),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: const [
                                Text(
                                  '5.0',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 3),
                                Icon(Icons.star, size: 15, color: Colors.amber),
                                Icon(Icons.star, size: 15, color: Colors.amber),
                                Icon(Icons.star, size: 15, color: Colors.amber),
                                Icon(Icons.star, size: 15, color: Colors.amber),
                                Icon(Icons.star_half, size: 15, color: Colors.amber),
                                SizedBox(width: 5),
                                Text(
                                  '(100 reviews)',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: const [
                                Icon(Icons.access_time, size: 13, color: Colors.grey),
                                SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    'Monday - Friday at 8:00 am - 5:00pm',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                Icon(Icons.location_on, size: 13, color: Colors.grey),
                                SizedBox(width: 3),
                                Text(
                                  '2.5 km',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              '₱ ${servicePrice.toStringAsFixed(0)}  for ${serviceCategory == 'grooming' ? 'Grooming' : 'an Appointment'}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      child: Transform.translate(
                        offset: const Offset(0, -10),
                        child: Text(
                          'Dr. $doctorName, book the appointment now !',
                          style: const TextStyle(
                            fontSize: 12,
                            height: 1.5,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 10, 22, 18),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff4E7A80),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookAppointmentScreen(
                          doctorName: doctorName,
                          serviceCategory: serviceCategory,
                          serviceName: serviceName,
                          servicePrice: servicePrice,
                        ),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Expanded(
                        child: Center(
                          child: Text(
                            'Book an Appointment',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Icon(Icons.calendar_month, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

