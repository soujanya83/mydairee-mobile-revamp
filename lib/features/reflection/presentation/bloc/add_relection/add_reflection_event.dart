import 'package:equatable/equatable.dart';

abstract class AddReflectionEvent extends Equatable {
  const AddReflectionEvent();

  @override
  List<Object?> get props => [];
}

class SubmitAddReflectionEvent extends AddReflectionEvent {
  final String? reflectionId;
  final String title;
  final String about;
  final String eylf;
  final String roomId;
  final List<String> children;
  final List<String> educators;
  final List<String> media;

  const SubmitAddReflectionEvent({
    this.reflectionId,
    required this.title,
    required this.about,
    required this.eylf,
    required this.roomId,
    required this.children,
    required this.educators,
    required this.media,
  });

  @override
  List<Object?> get props => [
        reflectionId,
        title,
        about,
        eylf,
        roomId,
        children,
        educators,
        media,
      ];
}