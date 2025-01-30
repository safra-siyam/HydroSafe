import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class InfoContent extends StatefulWidget {
  const InfoContent({super.key});

  @override
  State<InfoContent> createState() => _InfoContentState();
}

class _InfoContentState extends State<InfoContent> {
  int availableWater = 0; // in liters
  int flowRate = 0; // in cm³/s
  double velocity = 0.0; // in cm/s
  int dailyWaterRequirement = 1000; // Example: adjust based on land area
  int requiredTankLevel = 5000; // Example: required minimum water level
  double pipeCrossSectionArea = 50.0; // Example: in cm² (adjust based on pipe size)

  @override
  void initState() {
    super.initState();
    _fetchWaterData();
  }

  void _fetchWaterData() {
    FirebaseDatabase.instance.ref("volume").onValue.listen((event) {
      setState(() {
        availableWater = (event.snapshot.value ?? 0) as int;
      });
    });

    FirebaseDatabase.instance.ref("flowRate").onValue.listen((event) {
      setState(() {
        flowRate = (event.snapshot.value ?? 0) as int;
        velocity = _calculateVelocity(flowRate);
      });
    });
  }

  int getDaysSufficient() {
    return availableWater > 0 ? (availableWater ~/ dailyWaterRequirement) : 0;
  }

  double _calculateVelocity(int flowRate) {
    return pipeCrossSectionArea > 0 ? flowRate / pipeCrossSectionArea : 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _infoCard(
            title: "Available Water",
            value: "$availableWater Liters",
            icon: Icons.water_drop,
            color: Colors.blue.shade400,
          ),
          _infoCard(
            title: "Water Sufficiency",
            value: "${getDaysSufficient()} Days",
            icon: Icons.calendar_today,
           color: Colors.blue.shade400,
          ),
          _infoCard(
            title: "Required Tank Level",
            value: "$requiredTankLevel Liters",
            icon: Icons.storage,
            color: Colors.blue.shade400,
          ),
          _infoCard(
            title: "Daily Water Requirement",
            value: "$dailyWaterRequirement Liters",
            icon: Icons.waterfall_chart,
            color: Colors.blue.shade400,
          ),
          _infoCard(
            title: "Water Flow Rate",
            value: "$flowRate cm³/s",
            icon: Icons.speed,
            color: Colors.blue.shade400,
          ),
          _infoCard(
            title: "Water Velocity",
            value: "${velocity.toStringAsFixed(2)} cm/s",
            icon: Icons.waves,
            color: Colors.blue.shade400,
          ),
        ],
      ),
    );
  }

  Widget _infoCard({required String title, required String value, required IconData icon, required Color color}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: color,
      child: ListTile(
        leading: Icon(icon, color: Colors.white, size: 30),
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}
