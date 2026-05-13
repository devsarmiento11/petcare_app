import 'package:flutter/material.dart';

import 'appointment_screen.dart';

class HealthScreen extends StatelessWidget {
  const HealthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F4F4),
      appBar: AppBar(
        backgroundColor: const Color(0xff4E7A80),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Health',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: const [
          SectionTitle(title: 'Nearby Veterinarian'),
          VetCard(
            image: 'assets/images/vet1.jpg',
            name: 'Dr.KvSARMIENTO',
            subtitle: 'Bachelor of veterinary science',
            experience: '7 years',
          ),
          VetCard(
            image: 'assets/images/vet2.jpg',
            name: 'Dr. John Patrick',
            subtitle: 'Veterinary Dentist',
            experience: '4 years',
          ),
          VetCard(
            image: 'assets/images/vet3.jpg',
            name: 'Dr. Alexis Mer',
            subtitle: 'Bachelor of veterinary science',
            experience: '7 years',
          ),
          Divider(height: 28, thickness: 1),
          SectionTitle(title: 'Recommended Veterinarian'),
          VetCard(
            image: 'assets/images/vet2.jpg',
            name: 'Dr. Louie Rosario',
            subtitle: 'Veterinary Dentist',
            experience: '4 years',
            rating: '5.0',
            reviews: '100 reviews',
          ),
          VetCard(
            image: 'assets/images/vet4.jpeg',
            name: 'Dr. Pradip Mer',
            subtitle: 'Bachelor of veterinary science',
            experience: '7 years',
            rating: '4.5',
            reviews: '52 reviews',
          ),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18, bottom: 12, top: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 17,
        ),
      ),
    );
  }
}

class VetCard extends StatelessWidget {
  final String image;
  final String name;
  final String subtitle;
  final String experience;
  final String? rating;
  final String? reviews;

  const VetCard({
    super.key,
    required this.image,
    required this.name,
    required this.subtitle,
    required this.experience,
    this.rating,
    this.reviews,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasRating = rating != null;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
builder: (context) => AppointmentScreen(
                  doctorName: name,
                  doctorImage: image,
                  serviceCategory: 'veterinary',
                  serviceName: 'Veterinary Appointment',
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
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.18),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar
            ClipOval(
              child: Image.asset(
                image,
                height: 64,
                width: 64,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.blueGrey,
                    ),
                  ),
                  if (hasRating) ...[
                    const SizedBox(height: 2),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, size: 13, color: Colors.amber),
                        const SizedBox(width: 3),
                        Text(
                          rating!,
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            '(${reviews ?? ''})',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 16,
                        width: 16,
                        decoration: const BoxDecoration(
                          color: Color(0xff22AEEF),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.work_outline,
                          size: 10,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        experience,
                        style: const TextStyle(fontSize: 12),
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

