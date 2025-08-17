import 'package:equatable/equatable.dart';

abstract class StaffSettingsEvent extends Equatable {
  const StaffSettingsEvent();

  @override
  List<Object?> get props => [];
}

class FetchStaffEvent extends StaffSettingsEvent {
  String centerId;

  FetchStaffEvent({required this.centerId});
}

class AddStaffEvent extends StaffSettingsEvent {
  final String name;
  final String email;
  final String password;
  final String contactNo;
  final String gender;
  final String avatarUrl;
  final String userType;

  const AddStaffEvent({
    required this.name,
    required this.email,
    required this.password,
    required this.contactNo,
    required this.gender,
    required this.avatarUrl,
    required this.userType,
  });

  @override
  List<Object?> get props => [
        name,
        email,
        password,
        contactNo,
        gender,
        avatarUrl,
        userType,
      ];
}

class UpdateStaffEvent extends StaffSettingsEvent {
  final String id;
  final String name;
  final String email;
  final String password;
  final String contactNo;
  final String gender;
  final String avatarUrl;
  final String userType;

  const UpdateStaffEvent({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.contactNo,
    required this.gender,
    required this.avatarUrl,
    required this.userType,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        password,
        contactNo,
        gender,
        avatarUrl,
        userType,
      ];
}

class DeleteStaffEvent extends StaffSettingsEvent {
  final String staffId;

  const DeleteStaffEvent(this.staffId);

  @override
  List<Object?> get props => [staffId];
}