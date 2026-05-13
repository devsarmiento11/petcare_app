import 'package:flutter/material.dart';

import 'appointment_screen.dart';

class GroomingScreen extends StatelessWidget {
  const GroomingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F4F4),
      appBar: AppBar(
        backgroundColor: const Color(0xff4E7A80),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Grooming",
          style: TextStyle(color: Colors.black, fontSize: 14),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: const [
          SectionTitle(title: "Nearby Grooming room"),
          GroomingCard(
            image: "assets/images/groom1.jpg",
            name: "Comb and Collar",
            status: "OPEN",
            distance: "2.5 km",
            visits: "100s",
            closed: false,
          ),
          GroomingCard(
            image: "assets/images/groom2.jpg",
            name: "Cosmo Dog Cares",
            status: "CLOSED",
            distance: "2 km",
            visits: "120s",
            closed: true,
          ),
          Divider(height: 30),
          SectionTitle(title: "Recommended  Grooming room"),
          GroomingCard(
            image: "assets/images/groom3.jpg",
            name: "Dirty Paws Dog Spa",
            status: "OPEN",
            distance: "2.5 km",
            visits: "120s",
            closed: false,
          ),
          GroomingCard(
            image: "assets/images/groom4.jpg",
            name: "Golden Bone",
            status: "CLOSED",
            distance: "2.5 km",
            visits: "100s",
            closed: true,
          ),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 5),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}

class GroomingCard extends StatelessWidget {
  final String image;
  final String name;
  final String status;
  final String distance;
  final String visits;
  final bool closed;

  const GroomingCard({
    super.key,
    required this.image,
    required this.name,
    required this.status,
    required this.distance,
    required this.visits,
    this.closed = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: closed
          ? null
          : () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AppointmentScreen(
                    doctorName: name,
                    doctorImage: image,
                    serviceCategory: 'grooming',
                    serviceName: name,
                    servicePrice: 1000,
                  ),
                ),
              );
            },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 6,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                image,
                height: 55,
                width: 65,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: const [
                      Icon(Icons.star, size: 13, color: Colors.amber),
                      Icon(Icons.star, size: 13, color: Colors.amber),
                      Icon(Icons.star, size: 13, color: Colors.amber),
                      Icon(Icons.star, size: 13, color: Colors.amber),
                      Icon(Icons.star_half, size: 13, color: Colors.amber),
                      SizedBox(width: 5),
                      Text(
                        "5.0 (100 reviews)",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        status,
                        style: TextStyle(
                          fontSize: 9,
                          color: closed ? Colors.red : Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 18),
                      const Icon(Icons.near_me_outlined, size: 12),
                      const SizedBox(width: 3),
                      Text(distance, style: const TextStyle(fontSize: 9)),
                      const SizedBox(width: 18),
                      const Icon(Icons.watch_later_outlined, size: 12),
                      const SizedBox(width: 3),
                      Text(visits, style: const TextStyle(fontSize: 9)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    children: [
                      Icon(Icons.access_time, size: 12, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(
                        "Monday - Friday at 8:00 am - 5:00pm",
                        style: TextStyle(
                          fontSize: 8,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

