import 'package:key_handover_flutter/core/constants/key_status.dart';

class KeyModel {
  final int? id;
  final String name;
  final String keyId;
  final KeyStatus status;
  final String? holderName;
  final String? holderDept;
  final String? holderPhone;
  final String? borrowedAt;
  final String? expectedReturn;

  KeyModel({
    this.id,
    required this.name,
    required this.keyId,
    required this.status,
    this.holderName,
    this.holderDept,
    this.holderPhone,
    this.borrowedAt,
    this.expectedReturn,
  });

  KeyModel copyWith({
    int? id,
    String? name,
    String? keyId,
    KeyStatus? status,
    String? holderName,
    String? holderDept,
    String? holderPhone,
    String? borrowedAt,
    String? expectedReturn,
  }) {
    return KeyModel(
      id: id ?? this.id,
      name: name ?? this.name,
      keyId: keyId ?? this.keyId,
      status: status ?? this.status,
      holderName: holderName ?? this.holderName,
      holderDept: holderDept ?? this.holderDept,
      holderPhone: holderPhone ?? this.holderPhone,
      borrowedAt: borrowedAt ?? this.borrowedAt,
      expectedReturn: expectedReturn ?? this.expectedReturn,
    );
  }

  Map<String, Object?> toJson() => {
        'id': id,
        'name': name,
        'keyId': keyId,
        'status': status.name,
        'holderName': holderName,
        'holderDept': holderDept,
        'holderPhone': holderPhone,
        'borrowedAt': borrowedAt,
        'expectedReturn': expectedReturn,
      };

  static KeyModel fromJson(Map<String, Object?> json) {
    return KeyModel(
      id: json['id'] as int?,
      name: json['name'] as String,
      keyId: json['keyId'] as String,
      status: KeyStatus.values.firstWhere(
        (e) => e.name == json['status'] as String,
        orElse: () => KeyStatus.available,
      ),
      holderName: json['holderName'] as String?,
      holderDept: json['holderDept'] as String?,
      holderPhone: json['holderPhone'] as String?,
      borrowedAt: json['borrowedAt'] as String?,
      expectedReturn: json['expectedReturn'] as String?,
    );
  }
}
