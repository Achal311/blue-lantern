import 'package:bluelantern/services/app_usage_local_service.dart';

abstract class AppService {
  Future<void> getAppUsageService();
}

class AppUsageService implements AppService {
  List<AppUsageInfo> _info = <AppUsageInfo>[];

  List<AppUsageInfo> get info => _info;

  @override
  Future<void> getAppUsageService() async {
    try {
      var endDate = DateTime.now();
      var startDate = endDate.subtract(Duration(hours: 1));
      var infoList = await AppUsage.getAppUsage(startDate, endDate);
      _info = infoList;
      print(_info);
    } on AppUsageException catch (exception) {
      print(exception);
    }
  }
}