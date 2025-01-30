import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class SpillGatesContent extends StatefulWidget {
  const SpillGatesContent({super.key});

  @override
  State<SpillGatesContent> createState() => _SpillGatesContentState();
}

class _SpillGatesContentState extends State<SpillGatesContent> {
  bool spillGate1 = false;
  bool spillGate2 = false;

  @override
  void initState() {
    super.initState();
    _fetchSpillGateStatus();
  }

  void _fetchSpillGateStatus() {
    FirebaseDatabase.instance.ref("spillGates/spillGate1").onValue.listen((event) {
      setState(() {
        spillGate1 = (event.snapshot.value ?? 0) == 1;
      });
    });

    FirebaseDatabase.instance.ref("spillGates/spillGate2").onValue.listen((event) {
      setState(() {
        spillGate2 = (event.snapshot.value ?? 0) == 1;
      });
    });
  }

  void _onSpillGateToggled(bool value, int gateNumber) {
    setState(() {
      if (gateNumber == 1) {
        spillGate1 = value;
      } else {
        spillGate2 = value;
      }
    });

    FirebaseDatabase.instance
        .ref("spillGates/spillGate$gateNumber")
        .set(value ? 1 : 0)
        .onError((error, stackTrace) {
      print("Error writing to Firebase: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBF5FF), // Light blue background
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Spill Gates Control",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0A4DA2),
                ),
              ),
              const SizedBox(height: 16),
              _spillGateCard(
                title: "Spill Gate 01",
                value: spillGate1,
                onChanged: (value) => _onSpillGateToggled(value, 1),
                gradient: const LinearGradient(
                  colors: [Color(0xFF0A84FF), Color(0xFF4285F4)],
                ),
              ),
              const SizedBox(height: 16),
              _spillGateCard(
                title: "Spill Gate 02",
                value: spillGate2,
                onChanged: (value) => _onSpillGateToggled(value, 2),
                gradient: const LinearGradient(
                  colors: [Color(0xFF0066CC), Color(0xFF33A1FD)],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _spillGateCard({
  required String title,
  required bool value,
  required ValueChanged<bool> onChanged,
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.water_drop,
                  size: 32,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Poppins-SemiBold',
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: Colors.lightBlueAccent,
          ),
        ],
      ),
    ),
  );
}