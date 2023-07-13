import 'package:flutter/material.dart';

class WeeklyData extends StatefulWidget {
  const WeeklyData({super.key});

  @override
  State<WeeklyData> createState() => _WeeklyDataState();
}

class _WeeklyDataState extends State<WeeklyData> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: const Color.fromRGBO(26, 26, 26, 1),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical :15.0, horizontal: 10),
          child: AppBar(
            leading: IconButton(onPressed: () {
            Navigator.pop(context);
              }, 
            icon: const Icon(Icons.arrow_back_ios),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Weekly data'),
                SizedBox(width: 55,)
            ]),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            ),
        ),
      ),
    );
  }
}