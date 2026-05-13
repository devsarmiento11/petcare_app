import 'package:flutter/material.dart';

class BookSuccessScreen extends StatelessWidget {
  const BookSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),
      body: SafeArea(
        child: Column(
          children: [
            _topBar(context),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  children: [
                    const Spacer(flex: 2),

                    _successIllustration(),

                    const SizedBox(height: 28),

                    const Text(
                      "Appointment Book\nSuccessfully",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 21,
                        height: 1.3,
                        fontWeight: FontWeight.w800,
                        color: Color(0xff191725),
                      ),
                    ),

                    const Spacer(flex: 3),

                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.popUntil(context, (route) => route.isFirst);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff3F7C86),
                          foregroundColor: const Color(0xff191725),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          "Back to home",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 95),
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
      height: 56,
      width: double.infinity,
      color: const Color(0xff3F7C86),
      alignment: Alignment.centerLeft,
      child: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(
          Icons.arrow_back,
          size: 22,
          color: Color(0xff191725),
        ),
      ),
    );
  }

  Widget _successIllustration() {
    return SizedBox(
      height: 145,
      width: 180,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 0,
            child: Container(
              height: 115,
              width: 105,
              decoration: BoxDecoration(
                color: const Color(0xffF1F2F3),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),

          Positioned(
            top: 15,
            child: Container(
              height: 82,
              width: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    width: 38,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xff65C983),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  const SizedBox(height: 13),
                  Container(
                    width: 45,
                    height: 20,
                    decoration: BoxDecoration(
                      color: const Color(0xffE8F3FA),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 35,
                    height: 6,
                    decoration: BoxDecoration(
                      color: const Color(0xff65C983),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xff83C6B0),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 5,
            child: Container(
              height: 48,
              width: 145,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 25,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            left: 15,
            bottom: 18,
            child: Container(
              height: 30,
              width: 30,
              decoration: const BoxDecoration(
                color: Color(0xff54C85C),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),

          Positioned(
            right: 25,
            bottom: 30,
            child: Container(
              width: 60,
              height: 7,
              decoration: BoxDecoration(
                color: const Color(0xff2E60B8),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),

          Positioned(
            right: 45,
            bottom: 17,
            child: Container(
              width: 75,
              height: 7,
              decoration: BoxDecoration(
                color: const Color(0xff2E60B8),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}