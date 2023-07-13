import 'package:flutter/material.dart';
import 'package:app_usage/app_usage.dart';

class AppDailyData extends StatefulWidget {
  const AppDailyData({super.key});

  @override
  State<AppDailyData> createState() => _AppDailyDataState();
}


class _AppDailyDataState extends State<AppDailyData> {
  List<AppUsageInfo> _infos = [];
  @override
  void initState() {
    super.initState();
    getUsageStats();
    
  }

  void getUsageStats() async {
    try {
      // DateTime now = DateTime.now();
      // DateTime startDate = DateTime(now.year, now.month, now.day);
      // DateTime endDate = now;
      DateTime endDate = DateTime.now();
      DateTime startDate = endDate.subtract(const Duration(hours: 1));
      List<AppUsageInfo> infoList =
          await AppUsage().getAppUsage(startDate, endDate);

      setState(() => _infos = infoList);
        
      for (var info in infoList) {
        print(info.toString());
      }
      print(" This is start date ${startDate}");
      // print(now);
      print(endDate);
    } on AppUsageException catch (exception) {
      print(exception);
    }
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
                Text('App Usage'),
                SizedBox(width: 55,)
            ]),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            ),
        ),
      ),
      body: ListView.builder(
            itemCount: _infos.length,
            itemBuilder: (context, index) {
              return ListTile(
                  title: Text(_infos[index].appName, style: const TextStyle(color: Colors.white),),
                  trailing: Text("${_infos[index].usage.inHours}h ${(_infos[index].usage.inMinutes)%60}m ${((_infos[index].usage.inSeconds)%60)%60}s ",style: const TextStyle(color: Colors.white),));
            }),
        floatingActionButton: FloatingActionButton(
            onPressed: getUsageStats, child: const Icon(Icons.refresh)),
    );
  }
}