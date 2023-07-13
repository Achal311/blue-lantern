import 'package:bluelantern/views/dailydata.dart';
import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'brightness_data.dart';


class BrightnessScreen extends StatefulWidget {
  const BrightnessScreen({super.key});

  @override
  State<BrightnessScreen> createState() => _BrightnessScreenState();
}

class _BrightnessScreenState extends State<BrightnessScreen> {
  
  List<BrightnessData> brightnessDataList = [];

  @override
  void initState() {
    super.initState();
    _fetchBrightnessData();
  }

  void _fetchBrightnessData() async {
    List<BrightnessData> dataList =
        await DatabaseHelper.instance.getBrightnessDataList();
    setState(() {
      brightnessDataList = dataList;
    });
  }


 @override
Widget build(BuildContext context) {
  return Scaffold(
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
                Text('Brightness Details'),
                SizedBox(width: 55,)
            ]),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            ),
        ),
      ),
    body: Column(
      children: [
        const Text(
          'Brightness data updated every 1 min',
          style: TextStyle(fontSize: 20.0, color: Colors.white), textAlign: TextAlign.center, 
        ),
        const SizedBox(height: 16),
        Container(

        ),
        Expanded(
          child: ListView.builder(
            itemCount: brightnessDataList.length,
            itemBuilder: (context, index) {
              BrightnessData data = brightnessDataList[index];
              return ListTile(
                title: Text('Brightness Count: ${data.brightnessCount.toStringAsFixed(5)}',style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),),
                subtitle: Text('Date: ${data.date}',style: TextStyle(color: Colors.grey),),
                trailing: Text('Time: ${data.dateTime}',style: TextStyle(color: Colors.grey),),
              );
            },
          ),
        ),
      ],
    ),
  );
}
}