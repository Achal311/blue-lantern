import 'package:bluelantern/views/dailydata.dart';
import 'package:bluelantern/views/weeklydata.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/circlegraph.dart';
import 'dart:async';
import 'package:screen_brightness/screen_brightness.dart';
import 'database_helper.dart';
import 'brightness_data.dart';
import 'package:app_usage/app_usage.dart';


class HomePage extends StatefulWidget {
  
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<AppUsageInfo> _infos = [];
  Timer? _timer;
  List<BrightnessData> brightnessDataList = [];
  final user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();
    _fetchBrightnessData();
    getUsageStats2();
    _startTimer();
  }
  void _fetchBrightnessData() async {
    List<BrightnessData> dataList =
        await DatabaseHelper.instance.getBrightnessDataList();
    setState(() {
      brightnessDataList = dataList;
    });
  }
  void _startTimer() {
    const duration =  Duration(minutes: 30);
    _timer = Timer.periodic(duration, (Timer timer) {
      _saveBrightnessData();
    });
  }
  Future<void> _saveBrightnessData() async {
    double brightness = await ScreenBrightness().current;
    String date = DateTime.now().toString().split(' ')[0];
    String dateTime = DateTime.now().toString();

    BrightnessData brightnessData = BrightnessData(
      brightnessCount: brightness,
      date: date,
      dateTime: dateTime,
    );

    await DatabaseHelper.instance.insertBrightnessData(brightnessData);
    print('Brightness data saved: $brightness');
    print('Brightness data saved: $date');
    print('Brightness data saved: $dateTime');
  }

Duration totalUsageTime = Duration.zero;

void getUsageStats2() async {
  try {
    // DateTime now = DateTime.now();
    // DateTime startDate = DateTime(now.year, now.month, now.day);
    // DateTime endDate = startDate.add(const Duration(days: 1));
    DateTime endDate = DateTime.now();
    DateTime startDate = endDate.subtract(const Duration(hours: 1));
    List<AppUsageInfo> infoList =
        await AppUsage().getAppUsage(startDate, endDate);
    setState(() => _infos = infoList);

    totalUsageTime = Duration.zero;

    for (var info in infoList) {
      totalUsageTime += info.usage;
    }

    print('Total App Usage Time: ${totalUsageTime.toString()}');
  } on AppUsageException catch (exception) {
    print(exception);
  }
}
int blueLightUsage(){
  double ans = recommendation(totalUsageTime.inMinutes, averageBrightness);
  if(ans<=70){
    return 0;
  } if(ans<=120){
    return 1;
  } else{
    return 2;
  }
 }
  
double recommendation(int usage, double avgIntensity){
    double lightInt = avgIntensity*0.10*500*0.15*0.15;
    double ans = (lightInt*0.4)+(usage*0.6);
    return ans;
  }

  double averageBrightness = 0;
  Future<void> avg() async{
    averageBrightness = await DatabaseHelper.instance.getAverageBrightnessCount();
    print('Average Brightness Count for Today: $averageBrightness');
  }
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  double percentage(){
    int ans = blueLightUsage();
    if(ans == 0){
      return 0.85;
    } if(ans == 1){
      return 0.7;
    } else{
      return 0.65;
    }
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(26, 26, 26, 1),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical :15.0, horizontal: 0),
          child: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Home')
            ]),

            backgroundColor: Colors.transparent,
            elevation: 0.0,
            actions: [
            IconButton(onPressed: signUserOut, 
            icon: const Icon(Icons.logout),
            )
            ],
            ),
        ),
      ),


      body: ListView(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: const [
              Text('Hello', style: TextStyle(color: Colors.white, fontSize: 30,fontWeight: FontWeight.w500,),),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children:  const [
              Text('Achal Mehta', style: TextStyle(color: Colors.white, fontSize: 30,fontWeight: FontWeight.w500),),
            ],
          ),
        ),
        const SizedBox(height: 10,),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: GestureDetector(
            onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DailyData()),
            );
          },
            child: Container(
              decoration: BoxDecoration(
                boxShadow: const [BoxShadow (
                  color: Color.fromRGBO(16, 16, 16, 1),
                  blurRadius: 2.0,
                  spreadRadius: 0,
                  offset: Offset(2, 4),
                )],
                borderRadius: BorderRadius.circular(15),
                gradient:const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors:[
                    Color.fromRGBO(41, 50, 55, 1),
                    Color.fromRGBO(41, 50, 55, 0),
                  ])
              ),
              height: 250,
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 10 , 0, 0),
                  child: Row(
                    children: const [
                      Text('Today',
                        style:
                              TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                CircleGraph(
                  name: '${(percentage()*100).toStringAsFixed(0)} \nPoints',
                  percentage: percentage(),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 15 , 0, 0),
                  child: Text('${totalUsageTime.inHours.toString()}h ${((totalUsageTime.inMinutes)%60).toString()}m',
                    style:
                          const TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0, color: Colors.white),
                  ),
                ),
              ]),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: GestureDetector(
            onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const WeeklyData()),
            );
          },
            child: Container(
              decoration: BoxDecoration(
                boxShadow: const [BoxShadow (
                  color: Color.fromRGBO(16, 16, 16, 1),
                  blurRadius: 2.0,
                  spreadRadius: 0,
                  offset: Offset(2, 4),
                )],
                borderRadius: BorderRadius.circular(15),
                gradient:const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors:[
                    Color.fromRGBO(41, 50, 55, 1),
                    Color.fromRGBO(41, 50, 55, 0),
                  ])
              ),
              height: 300,
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 10 , 0, 0),
                  child: Row(
                    children: const [
                      Text('Weekly Data',
                        style:
                              TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0, color: Colors.white),
                      ),
                    ],
                  ),
                ),


              ]),
            ),
          ),
        ),
      ],),
      floatingActionButton: FloatingActionButton(onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },child: const Icon(Icons.refresh)),
    );
  }
}