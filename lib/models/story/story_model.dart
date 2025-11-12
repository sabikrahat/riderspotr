import '../../models/car/car_spot_model.dart';

class StoryModel {
  final String id;
  final String userId;
  final String? username;
  final String? profilePictureUrl;
  final CarSpotModel carSpot;
  final DateTime createdAt;

  StoryModel({
    required this.id,
    required this.userId,
    required this.username,
    required this.profilePictureUrl,
    required this.carSpot,
    required this.createdAt,
  });

  factory StoryModel.fromCarSpot(
    CarSpotModel carSpot,
    String? username,
    String? profilePictureUrl,
  ) {
    return StoryModel(
      id: carSpot.id,
      userId: carSpot.user,
      username: username,
      profilePictureUrl: profilePictureUrl,
      carSpot: carSpot,
      createdAt: carSpot.createdAt,
    );
  }
}

class StoryItemModel {
  final String id;
  final String imageUrl;
  final String carMake;
  final String carModel;
  final String address;
  final DateTime createdAt;

  StoryItemModel({
    required this.id,
    required this.imageUrl,
    required this.carMake,
    required this.carModel,
    required this.address,
    required this.createdAt,
  });
}
