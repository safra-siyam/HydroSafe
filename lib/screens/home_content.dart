// lib/screens/home_content.dart
import 'package:app/screens/spill_gates_content.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  int volume = 0;
  int flowRate = 0;

  @override
  void initState() {
    super.initState();
    _fetchValues();
  }

  void _fetchValues() {
    FirebaseDatabase.instance.ref("volume").onValue.listen((event) {
      setState(() {
        volume = (event.snapshot.value ?? 0) as int;
      });
    });

    FirebaseDatabase.instance.ref("flowRate").onValue.listen((event) {
      setState(() {
        flowRate = (event.snapshot.value ?? 0) as int;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBF5FF), // Light blue background
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Water Management System",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0A4DA2), // Dark blue text
                  ),
                ),
                const SizedBox(height: 16),
                boxData(
                  title: "Volume of Water",
                  value: "$volume cm\u00B3",
                  icon: Icons.water_drop,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0A84FF), Color(0xFF4285F4)],
                  ),
                ),
                const SizedBox(height: 16),
                boxData(
                  title: "Water Flow Rate",
                  value: "$flowRate cm\u00B3 s\u207B\u00B9",
                  icon: Icons.speed,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0066CC), Color(0xFF33A1FD)],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


//this is for the box data
Widget boxData({
  required String title,
  required String value,
  required IconData icon,
  required Gradient gradient,
}) {
  return Container(
    decoration: BoxDecoration(
      gradient: gradient,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.blue.shade100.withOpacity(0.5),
          blurRadius: 10,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 32,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Poppins-SemiBold',
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontFamily: 'Poppins-Bold',
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}