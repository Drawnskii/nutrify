import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile_model.freezed.dart';
part 'user_profile_model.g.dart';

enum Sex { masculine, femenine }
enum UserGoal { loseWeight, maintenance, gainWeight }

@freezed
abstract class UserProfileModel with _$UserProfileModel {
  const UserProfileModel._(); // Necesario para agregar getters manuales

  const factory UserProfileModel({
    required String firstName,
    required String lastName,
    required DateTime dateOfBirth, // Change: int age -> DateTime dateOfBirth
    required double weight,
    required double? targetWeight,
    required Sex sex,
    required UserGoal userGoal,
    @Default(false) bool isOnboardingComplete,
  }) = _UserProfileModel;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) => _$UserProfileModelFromJson(json);

  // Helper to calculate age from date of birth
  int get age {
    final now = DateTime.now();
    int age = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month || (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }
}