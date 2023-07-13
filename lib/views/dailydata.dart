import 'package:bluelantern/views/app_usage_list.dart';
import 'package:bluelantern/views/brightness_list.dart';
import 'package:flutter/material.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:bluelantern/components/buttons.dart';
import 'database_helper.dart';
import 'brightness_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:app_usage/app_usage.dart';


class DailyData extends StatefulWidget {
  const DailyData({super.key});

  @override
  State<DailyData> createState() => _DailyDataState();
}

class _DailyDataState extends State<DailyData> {
  List<AppUsageInfo> _infos = [];
  double brightness = 0.0;
   List<BrightnessData> brightnessDataList = [];

  @override
  void initState() {
    super.initState();
    getCurrentBrightness();
    _fetchBrightnessData();
    getUsageStats2();
    avg();
  }
  
  Duration totalUsageTime = Duration.zero;

void getUsageStats2() async {
  try {
    // DateTime now = DateTime.now();
    // DateTime startDate = DateTime(now.year, now.month, now.day);
    // DateTime endDate = startDate.add(Duration(days: 1));
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

  Future<void> getCurrentBrightness() async {
    double currentBrightness = await ScreenBrightness().current;
    setState(() {
      brightness = currentBrightness;
    });
  }
  double averageBrightness = 0;
  Future<void> avg() async{
    averageBrightness = await DatabaseHelper.instance.getAverageBrightnessCount();
    // print('Average Brightness Count for Today: $averageBrightness');
  }

  double recommendation(int usage, double avgIntensity){
    double lightInt = avgIntensity*0.10*500*0.15*0.15;
    double ans = (lightInt*0.4)+(usage*0.6);
    return ans;
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

  void _fetchBrightnessData() async {
    List<BrightnessData> dataList =
        await DatabaseHelper.instance.getBrightnessDataList();
    setState(() {
      brightnessDataList = dataList;
    });
  }
  List<FlSpot> _createDataPoints() {
  DateTime now = DateTime.now();
  DateTime today = DateTime(now.year, now.month, now.day);

  List<BrightnessData> filteredData = brightnessDataList.where((data) {
    DateTime dataDate = DateTime.parse(data.date);
    return dataDate.year == today.year &&
        dataDate.month == today.month &&
        dataDate.day == today.day;
  }).toList();

  return filteredData.map((data) {
    DateTime dateTime = DateTime.parse(data.dateTime);
    return FlSpot(
      dateTime.hour.toDouble(),
      data.brightnessCount,
    );
  }).toList();
}

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
                Text('Daily Usage'),
                SizedBox(width: 15,)
            ]),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            actions: [
            IconButton(onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const DailyData()),
            );
          }, 
            icon: const Icon(Icons.refresh),
            )
            ],
            ),
        ),
      ),

      body: Center(
        child: SingleChildScrollView(
          child: Column(children: [
            
            const SizedBox(height: 15,),
            AspectRatio(
                  aspectRatio: 1.5,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 30, 5),
                    child: Column(
                      children: [
                        Expanded(
                          child: brightnessDataList.isNotEmpty
                              ? LineChart(
                                  LineChartData(
                                    titlesData: FlTitlesData(
                                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                    bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true,interval: 6)),
                                    ),
                                    // DateTime.now().startOfDay().second.toDouble(),
                                    minX: 0,
                                    maxX: 24,
                                    minY: 0,
                                    maxY: 1,
                                    gridData: FlGridData(
                                      show: true,
                                      getDrawingHorizontalLine: (value){
                                        return FlLine(
                                          color: const Color.fromRGBO(129, 129, 129, 1),
                                          strokeWidth: 1
                                        );
                                      },
                                      drawVerticalLine: false,
                                    ),
                                    borderData: FlBorderData(
                                      show: true,
                                      border: const Border(bottom: BorderSide(), top: BorderSide()),
                                    ),                                
                                    lineBarsData: [
                                      LineChartBarData(
                                        spots: _createDataPoints(),
                                        isCurved: false,
                                        color: const Color.fromARGB(255, 74, 172, 252),
                                        barWidth: 2,
                            
                                        dotData: FlDotData(show: false),
                                        belowBarData: BarAreaData(
                                          show: true,
                                          gradient: const LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors:[
                                                Color.fromRGBO(32, 116, 199, .9),
                                                Color.fromRGBO(30, 144, 255, 0)
                                            ]),
                                          ),
                                      ),
                                    ],
                                  ),
                                )
                              : const Center(
                                  child: Text('No data available'),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
            const SizedBox(height: 15,),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (blueLightUsage() == 0)
                Padding(
                  padding: const EdgeInsets.all(15.0),
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
                  height: 270,
                  child: Column(
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text('Low Usage of your Mobile phone',style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: Text('Your bluelight exposure is in safe area as recommended by doctors. You contiune following this lifestyle which very healthy for your eyes.',style: TextStyle(color: Color.fromRGBO(148, 138, 138, 1), fontSize: 20, fontWeight: FontWeight.w500),textAlign: TextAlign.center,),
                      ),
                    ],
                  ),
                  ),
                ),
              if (blueLightUsage() == 1)
                Padding(
                  padding: const EdgeInsets.all(15.0),
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
                  child: Column(
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text('Moderate Usage of your Mobile phone',style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),textAlign: TextAlign.center, ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: Text('Your bluelight exposure is not in very harmful area but good suggestion would be try to avoid using your phone with darker ambient lighting.',style: TextStyle(color: Color.fromRGBO(148, 138, 138, 1), fontSize: 20, fontWeight: FontWeight.w500),textAlign: TextAlign.center,),
                      ),
                    ],
                  ),
                  ),
                ),
              if (blueLightUsage() == 2)
                Padding(
                  padding: const EdgeInsets.all(15.0),
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
                  height: 500,
                  child: Column(
                    children: const [
                       Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text('High Usage of your Mobile phone',style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: Text('Your bluelight exposure is very high from the amount recommended by the doctors. High screen time can lead to eye dryness and cause strain to your eyes as well as head ache. And research shows it has cognitive effects on young minds. So Try to limit your screen time to 2-3 hrs. Try to avoid long session you screen exposure. You can implement 20 20 20 rule which states you take break every 20 min and look at an object 20 feet away for minimum of 20 seconds.',style: TextStyle(color: Color.fromRGBO(148, 138, 138, 1), fontSize: 20, fontWeight: FontWeight.w500),textAlign: TextAlign.center,),
                      ),
                    ],
                  ),
                  ),
                ),
            ],
            ),
            const SizedBox(height: 20,),
            MyButton(onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AppDailyData()),
              );
            }, name: 'App Usage'),
            const SizedBox(height: 15,),
            MyButton(onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  const BrightnessScreen()),
              );
            }, name: 'Brightness Details'),
            const SizedBox(height: 15,),
            MyButton(onTap: _saveBrightnessData, name: 'Update Data'),
            const SizedBox(height: 50,),
            Text('Current Brightness: ${brightness.toStringAsFixed(2)}',style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),),
            Text('Algorithm Score :${(recommendation(totalUsageTime.inMinutes, averageBrightness)).toStringAsFixed(3)}',style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),),
            const SizedBox(height: 50,),
          ]),
        ),
      ),
    );
  }
}