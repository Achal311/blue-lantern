import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';


class CircleGraph extends StatelessWidget {
  final String name;
  final double percentage;
  const CircleGraph({super.key, required this.name, required this.percentage});

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
                radius: 75.0,
                lineWidth: 20.0,
                animation: true,
                percent: percentage,
                center: Text(
                  name,
                  style:
                      const TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0, color: Colors.white), textAlign: TextAlign.center,
                ),
                circularStrokeCap: CircularStrokeCap.round,
                backgroundColor: const Color.fromRGBO(30, 144, 255, .26),
                progressColor: const Color.fromRGBO(30, 144, 255, 1),
              );
  }
}