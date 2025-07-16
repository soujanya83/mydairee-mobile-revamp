import 'package:equatable/equatable.dart';

abstract class SuperAdminSettingsEvent extends Equatable {
  const SuperAdminSettingsEvent();

  @override
  List<Object?> get props => [];
}

class FetchSuperAdminsEvent extends SuperAdminSettingsEvent {}

class AddSuperAdminEvent extends SuperAdminSettingsEvent {
  final String name;
  final String email;
  final String password;
  final String contactNo;
  final String gender;
  final String avatarUrl;
  final String centerName;
  final String streetAddress;
  final String city;
  final String state;
  final String zip;

  const AddSuperAdminEvent({
    required this.name,
    required this.email,
    required this.password,
    required this.contactNo,
    required this.gender,
    required this.avatarUrl,
    required this.centerName,
    required this.streetAddress,
    required this.city,
    required this.state,
    required this.zip,
  });

  @override
  List<Object?> get props => [
        name,
        email,
        password,
        contactNo,
        gender,
        avatarUrl,
        centerName,
        streetAddress,
        city,
        state,
        zip,
      ];
}

class UpdateSuperAdminEvent extends SuperAdminSettingsEvent {
  final String id;
  final String name;
  final String email;
  final String password;
  final String contactNo;
  final String gender;
  final String avatarUrl;
  final String centerName;
  final String streetAddress;
  final String city;
  final String state;
  final String zip;

  const UpdateSuperAdminEvent({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.contactNo,
    required this.gender,
    required this.avatarUrl,
    required this.centerName,
    required this.streetAddress,
    required this.city,
    required this.state,
    required this.zip,
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
        centerName,
        streetAddress,
        city,
        state,
        zip,
      ];
}

class DeleteSuperAdminEvent extends SuperAdminSettingsEvent {
  final String superAdminId;

  const DeleteSuperAdminEvent(this.superAdminId);

  @override
  List<Object?> get props => [superAdminId];
}