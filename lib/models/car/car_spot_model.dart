import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import '../user/user_model.dart';
import 'car_model.dart';

part 'car_spot_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CarSpotModel {
  final String id;
  DateTime createdAt;
  @JsonKey(name: 'user')
  UserModel? userProfile;
  CarModel? car;
  String imageUrl;
  // dynamic latLng, stored as 'POINT(lon lat)' in Supabase
  dynamic latLng;
  final String address;
  Map<String, dynamic>? location;
  bool isClaimed;

  CarSpotModel({
    required this.id,
    required this.createdAt,
    this.userProfile,
    this.car,
    required this.imageUrl,
    this.latLng,
    this.location,
    required this.address,
    required this.isClaimed,
  });

  factory CarSpotModel.fromJson(Map<String, dynamic> json) =>
      _$CarSpotModelFromJson(json);

  Map<String, dynamic> toJson() => _$CarSpotModelToJson(this);

  static const query =
      '*, car(*, make(*), production: car_production(*), specs: car_specs(*), history: car_history(*)), user: users!car_spots_user_fkey(*)';

  // Getter for backward compatibility - returns user ID
  String get user => userProfile?.id ?? '';

  // Create a copy with method
  CarSpotModel copyWith({
    String? id,
    DateTime? createdAt,
    UserModel? userProfile,
    CarModel? car,
    String? imageUrl,
    dynamic latLng,
    Map<String, dynamic>? location,
    bool? isClaimed,
    String? address,
  }) {
    return CarSpotModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      userProfile: userProfile ?? this.userProfile,
      car: car ?? this.car,
      imageUrl: imageUrl ?? this.imageUrl,
      latLng: latLng ?? this.latLng,
      location: location ?? this.location,
      isClaimed: isClaimed ?? this.isClaimed,
      address: address ?? this.address,
    );
  }

  // extract longitude from latLng which is coming from the supabase
  double? get longitude {
    if (latLng == null) return null;
    String wkbHex = latLng.toString();
    Uint8List bytes = _hexToBytes(wkbHex);

    // Extract longitude and latitude from the binary data
    double longitude = _byteDataToDouble(bytes.sublist(9, 17));
    return longitude;
  }

  // extract latitude from latLng which is coming from the supabase
  double? get latitude {
    if (latLng == null) return null;
    String wkbHex = latLng.toString();
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
