// Repository
import 'dart:typed_data';

import 'package:mydiaree/core/config/app_urls.dart';
import 'package:mydiaree/core/services/apiresoponse.dart';

class AccidentRepository {
  Future<List<Accident>> fetchAccidents() async {
    // Replace with actual data fetching logic
    await Future.delayed(const Duration(seconds: 1));
    return [
      Accident(
        childName: 'John Doe',
        createdBy: 'Teacher A',
        date: '2024-06-01',
      ),
      Accident(
        childName: 'Jane Smith',
        createdBy: 'Teacher B',
        date: '2024-06-02',
      ),
    ];
  }

  Future<ApiResponse> addOrEditAccident({
    String? id,
    required String centerId,
    required String roomId,
    required String name,
    required String positionRole,
    DateTime? recordDate,
    Uint8List? personSignature,
    String? childId,
    DateTime? childDob,
    String? childAge,
    required String gender,
    DateTime? incidentDate,
    String? incidentTime,
    required String location,
    Uint8List? childSignature,
    DateTime? incidentDetailsDate,
    required String witnessName,
    required String activity,
    required String cause,
    required String circumstances,
    required String unaccountedDetails,
    required String lockedDetails,
    required List<String> injuryTypes,
    required String actionDetails,
    required String emergencyServices,
    String? emergencyDetails,
    required String medicalAttention,
    String? medicalDetails1,
    String? medicalDetails2,
    String? medicalDetails3,
    required String guardian1Name,
    required String guardian1Contact,
    String? guardian1Time,
    DateTime? guardian1Date,
    required bool guardian1Contacted,
    required bool guardian1MessageLeft,
    String? guardian2Name,
    String? guardian2Contact,
    String? guardian2Time,
    DateTime? guardian2Date,
    required bool guardian2Contacted,
    required bool guardian2MessageLeft,
    required String inChargeName,
    Uint8List? inChargeSignature,
    String? inChargeTime,
    DateTime? inChargeDate,
    required String supervisorName,
    Uint8List? supervisorSignature,
    String? supervisorTime,
    DateTime? supervisorDate,
    String? agency,
    String? agencyTime,
  }) async {
    final Map<String, dynamic> data = {
      if (id != null) 'id': id,
      'center_id': centerId,
      'room_id': roomId,
      'name': name,
      'position_role': positionRole,
      if (recordDate != null) 'record_date': recordDate.toIso8601String(),
      if (personSignature != null) 'person_signature': personSignature,
      if (childId != null) 'child_id': childId,
      if (childDob != null) 'child_dob': childDob.toIso8601String(),
      if (childAge != null) 'child_age': childAge,
      'gender': gender,
      if (incidentDate != null) 'incident_date': incidentDate.toIso8601String(),
      if (incidentTime != null) 'incident_time': incidentTime,
      'location': location,
      if (childSignature != null) 'child_signature': childSignature,
      if (incidentDetailsDate != null)
        'incident_details_date': incidentDetailsDate.toIso8601String(),
      'witness_name': witnessName,
      'activity': activity,
      'cause': cause,
      'circumstances': circumstances,
      'unaccounted_details': unaccountedDetails,
      'locked_details': lockedDetails,
      'injury_types': injuryTypes,
      'action_details': actionDetails,
      'emergency_services': emergencyServices,
      if (emergencyDetails != null) 'emergency_details': emergencyDetails,
      'medical_attention': medicalAttention,
      if (medicalDetails1 != null) 'medical_details_1': medicalDetails1,
      if (medicalDetails2 != null) 'medical_details_2': medicalDetails2,
      if (medicalDetails3 != null) 'medical_details_3': medicalDetails3,
      'guardian1_name': guardian1Name,
      'guardian1_contact': guardian1Contact,
      if (guardian1Time != null) 'guardian1_time': guardian1Time,
      if (guardian1Date != null)
        'guardian1_date': guardian1Date.toIso8601String(),
      'guardian1_contacted': guardian1Contacted,
      'guardian1_message_left': guardian1MessageLeft,
      if (guardian2Name != null) 'guardian2_name': guardian2Name,
      if (guardian2Contact != null) 'guardian2_contact': guardian2Contact,
      if (guardian2Time != null) 'guardian2_time': guardian2Time,
      if (guardian2Date != null)
        'guardian2_date': guardian2Date.toIso8601String(),
      'guardian2_contacted': guardian2Contacted,
      'guardian2_message_left': guardian2MessageLeft,
      'in_charge_name': inChargeName,
      if (inChargeSignature != null) 'in_charge_signature': inChargeSignature,
      if (inChargeTime != null) 'in_charge_time': inChargeTime,
      if (inChargeDate != null)
        'in_charge_date': inChargeDate.toIso8601String(),
      'supervisor_name': supervisorName,
      if (supervisorSignature != null)
        'supervisor_signature': supervisorSignature,
      if (supervisorTime != null) 'supervisor_time': supervisorTime,
      if (supervisorDate != null)
        'supervisor_date': supervisorDate.toIso8601String(),
      if (agency != null) 'agency': agency,
      if (agencyTime != null) 'agency_time': agencyTime,
    };

    return postAndParse(
      AppUrls.addAccident,
      dummy: true,
      data,
    );
  }
}

// Model (for reference)
class Accident {
  final String childName;
  final String createdBy;
  final String date;

  Accident({
    required this.childName,
    required this.createdBy,
    required this.date,
  });
}
