import 'package:equatable/equatable.dart';

abstract class ParentSettingsEvent extends Equatable {
  const ParentSettingsEvent();

  @override
  List<Object?> get props => [];
}

class FetchParentsEvent extends ParentSettingsEvent {}

class AddParentEvent extends ParentSettingsEvent {
  final String name;
  final String email;
  final String password;
  final String contactNo;
  final String gender;
  final String avatarUrl;
  final List<Map<String, String>> children;

  const AddParentEvent({
    required this.name,
    required this.email,
    required this.password,
    required this.contactNo,
    required this.gender,
    required this.avatarUrl,
    required this.children,
  });

  @override
  List<Object?> get props => [
        name,
        email,
        password,
        contactNo,
        gender,
        avatarUrl,
        children,
      ];
}

class UpdateParentEvent extends ParentSettingsEvent {
  final String id;
  final String name;
  final String email;
  final String password;
  final String contactNo;
  final String gender;
  final String avatarUrl;
  final List<Map<String, String>> children;

  const UpdateParentEvent({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.contactNo,
    required this.gender,
    required this.avatarUrl,
    required this.children,
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
        children,
      ];
}

class DeleteParentEvent extends ParentSettingsEvent {
  final String parentId;

  const DeleteParentEvent(this.parentId);

  @override
  List<Object?> get props => [parentId];
}