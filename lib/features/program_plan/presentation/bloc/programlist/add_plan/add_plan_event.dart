import 'package:equatable/equatable.dart';

abstract class AddPlanEvent extends Equatable {
  const AddPlanEvent();

  @override
  List<Object?> get props => [];
}

class SubmitAddPlanEvent extends AddPlanEvent {
  final String? planId;
  final String month;
  final String year;
  final String roomId;
  final List<String> educators;
  final List<String> children;

  final String focusArea;
  final String outdoorExperiences;
  final String inquiryTopic;
  final String sustainabilityTopic;
  final String specialEvents;
  final String childrenVoices;
  final String familiesInput;
  final String groupExperience;
  final String spontaneousExperience;
  final String mindfulnessExperience;
  final String eylf;

  final String practicalLife;
  final String sensorial;
  final String math;
  final String language;
  final String culture;

  const SubmitAddPlanEvent({
    this.planId,
    required this.month,
    required this.year,
    required this.roomId,
    required this.educators,
    required this.children,
    required this.focusArea,
    required this.outdoorExperiences,
    required this.inquiryTopic,
    required this.sustainabilityTopic,
    required this.specialEvents,
    required this.childrenVoices,
    required this.familiesInput,
    required this.groupExperience,
    required this.spontaneousExperience,
    required this.mindfulnessExperience,
    required this.eylf,
    required this.practicalLife,
    required this.sensorial,
    required this.math,
    required this.language,
    required this.culture,
  });

  @override
  List<Object?> get props => [
        planId,
        month,
        year,
        roomId,
        educators,
        children,
        focusArea,
        outdoorExperiences,
        inquiryTopic,
        sustainabilityTopic,
        specialEvents,
        childrenVoices,
        familiesInput,
        groupExperience,
        spontaneousExperience,
        mindfulnessExperience,
        eylf,
        practicalLife,
        sensorial,
        math,
        language,
        culture,
      ];
}
