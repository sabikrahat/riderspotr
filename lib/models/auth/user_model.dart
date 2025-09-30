import 'dart:typed_data';

import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UserModel {
  final String id;
  final String email;
  String? firstName;
  String? lastName;
  String? username;
  DateTime? dob;
  String? knowledgeLevel;
  String? experience;
  String? location;
  dynamic locationLatLng;
  DateTime createdAt;

  UserModel({
    required this.id,
    required this.email,
    this.firstName,
    this.lastName,
    this.username,
    this.dob,
    this.knowledgeLevel,
    this.experience,
    this.location,
    this.locationLatLng,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  // extract longitude from locationLatLng which is coming from the supabase
  double get longitude {
    String wkbHex = locationLatLng.toString();
    Uint8List bytes = _hexToBytes(wkbHex);

    // Extract longitude and latitude from the binary data
    double longitude = _byteDataToDouble(bytes.sublist(9, 17));
    return longitude;
  }

  // extract latitude from locationLatLng which is coming from the supabase
  double get latitude {
    String wkbHex = locationLatLng.toString();
    Uint8List bytes = _hexToBytes(wkbHex);

    // Extract longitude and latitude from the binary data
    double latitude = _byteDataToDouble(bytes.sublist(17, 25));
    return latitude;
  }

  // Convert hex string to byte array
  Uint8List _hexToBytes(String hex) {
    return Uint8List.fromList(
      List<int>.generate(
        hex.length ~/ 2,
        (i) => int.parse(hex.substring(i * 2, i * 2 + 2), radix: 16),
      ),
    );
  }

  // Convert 8-byte array to double
  double _byteDataToDouble(List<int> bytes) {
    ByteData byteData = ByteData.sublistView(Uint8List.fromList(bytes));
    return byteData.getFloat64(0, Endian.little);
  }
}
