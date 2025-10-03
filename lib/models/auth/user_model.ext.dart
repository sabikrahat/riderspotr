// // GENERATED CODE - DO NOT MODIFY BY HAND

// part of 'user_model.dart';

// extension UserModelExtension on UserModel {
//   //copywith
//   UserModel copyWith({
//     String? firstName,
//     String? lastName,
//     String? username,
//     DateTime? dob,
//     String? knowledgeLevel,
//     String? experience,
//     String? location,
//     dynamic locationLatLng,
//   }) {
//     return UserModel(
//       id: id,
//       email: email,
//       firstName: firstName ?? this.firstName,
//       lastName: lastName ?? this.lastName,
//       username: username ?? this.username,
//       dob: dob ?? this.dob,
//       knowledgeLevel: knowledgeLevel ?? this.knowledgeLevel,
//       experience: experience ?? this.experience,
//       location: location ?? this.location,
//       locationLatLng: locationLatLng ?? this.locationLatLng,
//       createdAt: createdAt,
//     );
//   }

//   Map<String, dynamic> toJosn() {
//     return {
//       _Json.id: id,
//       _Json.email: email,
//       _Json.firstName: firstName,
//       _Json.lastName: lastName,
//       _Json.username: username,
//       _Json.dob: dob?.toUtc().toIso8601String(),
//       _Json.knowledgeLevel: knowledgeLevel,
//       _Json.experience: experience,
//       _Json.location: location,
//       _Json.locationLatLng: locationLatLng == null
//           ? null
//           : locationLatLng is String
//           ? 'POINT($longitude $latitude)'
//           : 'POINT(${locationLatLng.longitude} ${locationLatLng.latitude})',
//       _Json.createdAt: createdAt.toUtc().toIso8601String(),
//     };
//   }

//   // extract longitude from locationLatLng which is coming from the supabase
//   double get longitude {
//     String wkbHex = locationLatLng.toString();
//     Uint8List bytes = _hexToBytes(wkbHex);

//     // Extract longitude and latitude from the binary data
//     double longitude = _byteDataToDouble(bytes.sublist(9, 17));
//     return longitude;
//   }

//   // extract latitude from locationLatLng which is coming from the supabase
//   double get latitude {
//     String wkbHex = locationLatLng.toString();
//     Uint8List bytes = _hexToBytes(wkbHex);

//     // Extract longitude and latitude from the binary data
//     double latitude = _byteDataToDouble(bytes.sublist(17, 25));
//     return latitude;
//   }

//   // Convert hex string to byte array
//   Uint8List _hexToBytes(String hex) {
//     return Uint8List.fromList(
//       List<int>.generate(
//         hex.length ~/ 2,
//         (i) => int.parse(hex.substring(i * 2, i * 2 + 2), radix: 16),
//       ),
//     );
//   }

//   // Convert 8-byte array to double
//   double _byteDataToDouble(List<int> bytes) {
//     ByteData byteData = ByteData.sublistView(Uint8List.fromList(bytes));
//     return byteData.getFloat64(0, Endian.little);
//   }

//   bool get isProfileComplete {
//     return firstName != null && lastName != null && username != null && dob != null;
//   }

//   bool get isExperienceComplete {
//     return knowledgeLevel != null && experience != null;
//   }

//   bool get isLocationComplete {
//     return location != null && locationLatLng != null;
//   }
// }
