import 'dart:convert';

String responseItemToJson(ResponseItem data) => json.encode(data.toJson());

class ResponseItem {
  ResponseItem({
    this.data,
    required this.message,
    required this.status,
    this.statusInt = 0,
    this.fullData,
  });

  dynamic data;
  dynamic fullData;
  String message;
  bool status;
  int statusInt;

  Map<String, dynamic> toJson() => {
        "data": data,
        "msg": fullData,
        "fullData": message,
        "status": status,
        "statusInt": statusInt,
      };
}
