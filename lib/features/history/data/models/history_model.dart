import 'package:key_handover_flutter/core/constants/key_status.dart';

class HistoryModel {
  final int? id;
  final String keyName;
  final String personName;
  final String takenTime;
  final String returnedTime;
  final KeyStatus status;

  HistoryModel({
    this.id,
    required this.keyName,
    required this.personName,
    required this.takenTime,
    required this.returnedTime,
    required this.status,
  });

  HistoryModel copyWith({
    int? id,
    String? keyName,
    String? personName,
    String? takenTime,
    String? returnedTime,
    KeyStatus? status,
  }) {
    return HistoryModel(
      id: id ?? this.id,
      keyName: keyName ?? this.keyName,
      personName: personName ?? this.personName,
      takenTime: takenTime ?? this.takenTime,
      returnedTime: returnedTime ?? this.returnedTime,
      status: status ?? this.status,
    );
  }

  Map<String, Object?> toJson() => {
        'id': id,
        'keyName': keyName,
        'personName': personName,
        'takenTime': takenTime,
        'returnedTime': returnedTime,
        'status': status.name,
      };

  static HistoryModel fromJson(Map<String, Object?> json) {
    return HistoryModel(
      id: json['id'] as int?,
      keyName: json['keyName'] as String,
      personName: json['personName'] as String,
      takenTime: json['takenTime'] as String,
      returnedTime: json['returnedTime'] as String,
      status: KeyStatus.values.firstWhere(
        (e) => e.name == json['status'] as String,
        orElse: () => KeyStatus.available,
      ),
    );
  }
}
