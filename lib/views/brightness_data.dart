class BrightnessData {
  int ?id;
  double brightnessCount;
  String date;
  String dateTime;

  BrightnessData({this.id, required this.brightnessCount,required this.date,required this.dateTime});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'brightnessCount': brightnessCount,
      'date': date,
      'dateTime': dateTime,
    };
  }

  factory BrightnessData.fromMap(Map<String, dynamic> map) {
    return BrightnessData(
      id: map['id'],
      brightnessCount: map['brightnessCount'],
      date: map['date'],
      dateTime: map['dateTime'],
    );
  }
}
