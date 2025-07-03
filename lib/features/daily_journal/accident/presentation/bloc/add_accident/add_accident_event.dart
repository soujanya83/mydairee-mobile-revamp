import 'dart:typed_data';
import 'package:equatable/equatable.dart';

abstract class AddAccidentEvent extends Equatable {
  const AddAccidentEvent();

  @override
  List<Object?> get props => [];
}

class SubmitAddAccidentEvent extends AddAccidentEvent {
  final String? id;
  final String centerId;
  final String roomId;
  final String name;
  final String positionRole;
  final DateTime? recordDate;
  final Uint8List? personSignature;
  final String? childId;
  final DateTime? childDob;
  final String? childAge;
  final String gender;
  final DateTime? incidentDate;
  final String? incidentTime;
  final String location;
  final Uint8List? childSignature;
  final DateTime? incidentDetailsDate;
  final String witnessName;
  final String activity;
  final String cause;
  final String circumstances;
  final String unaccountedDetails;
  final String lockedDetails;
  final List<String> injuryTypes;
  final String actionDetails;
  final String emergencyServices;
  final String? emergencyDetails;
  final String medicalAttention;
  final String? medicalDetails1;
  final String? medicalDetails2;
  final String? medicalDetails3;
  final String guardian1Name;
  final String guardian1Contact;
  final String? guardian1Time;
  final DateTime? guardian1Date;
  final bool guardian1Contacted;
  final bool guardian1MessageLeft;
  final String? guardian2Name;
  final String? guardian2Contact;
  final String? guardian2Time;
  final DateTime? guardian2Date;
  final bool guardian2Contacted;
  final bool guardian2MessageLeft;
  final String inChargeName;
  final Uint8List? inChargeSignature;
  final String? inChargeTime;
  final DateTime? inChargeDate;
  final String supervisorName;
  final Uint8List? supervisorSignature;
  final String? supervisorTime;
  final DateTime? supervisorDate;
  final String? agency;
  final String? agencyTime;
  final String? addmark;

  const SubmitAddAccidentEvent({
    this.id,
    required this.addmark,
    required this.centerId,
    required this.roomId,
    required this.name,
    required this.positionRole,
    this.recordDate,
    this.personSignature,
    this.childId,
    this.childDob,
    this.childAge,
    required this.gender,
    this.incidentDate,
    this.incidentTime,
    required this.location,
    this.childSignature,
    this.incidentDetailsDate,
    required this.witnessName,
    required this.activity,
    required this.cause,
    required this.circumstances,
    required this.unaccountedDetails,
    required this.lockedDetails,
    required this.injuryTypes,
    required this.actionDetails,
    required this.emergencyServices,
    this.emergencyDetails,
    required this.medicalAttention,
    this.medicalDetails1,
    this.medicalDetails2,
    this.medicalDetails3,
    required this.guardian1Name,
    required this.guardian1Contact,
    this.guardian1Time,
    this.guardian1Date,
    required this.guardian1Contacted,
    required this.guardian1MessageLeft,
    this.guardian2Name,
    this.guardian2Contact,
    this.guardian2Time,
    this.guardian2Date,
    required this.guardian2Contacted,
    required this.guardian2MessageLeft,
    required this.inChargeName,
    this.inChargeSignature,
    this.inChargeTime,
    this.inChargeDate,
    required this.supervisorName,
    this.supervisorSignature,
    this.supervisorTime,
    this.supervisorDate,
    this.agency,
    this.agencyTime,
  });

  @override
  List<Object?> get props => [
        id,
        centerId,
        roomId,
        name,
        positionRole,
        recordDate,
        personSignature,
        childId,
        childDob,
        childAge,
        gender,
        incidentDate,
        incidentTime,
        location,
        childSignature,
        incidentDetailsDate,
        witnessName,
        activity,
        cause,
        circumstances,
        unaccountedDetails,
        lockedDetails,
        injuryTypes,
        actionDetails,
        emergencyServices,
        emergencyDetails,
        medicalAttention,
        medicalDetails1,
        medicalDetails2,
        medicalDetails3,
        guardian1Name,
        guardian1Contact,
        guardian1Time,
        guardian1Date,
        guardian1Contacted,
        guardian1MessageLeft,
        guardian2Name,
        guardian2Contact,
        guardian2Time,
        guardian2Date,
        guardian2Contacted,
        guardian2MessageLeft,
        inChargeName,
        inChargeSignature,
        inChargeTime,
        inChargeDate,
        supervisorName,
        supervisorSignature,
        supervisorTime,
        supervisorDate,
        agency,
        agencyTime,
      ];
}