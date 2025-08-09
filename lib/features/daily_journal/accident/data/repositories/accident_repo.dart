import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:mydiaree/core/config/app_urls.dart';
import 'package:mydiaree/core/services/api_services.dart';
import 'package:mydiaree/core/services/apiresoponse.dart';
import 'package:mydiaree/features/daily_journal/accident/data/models/accident_detail_response_model.dart';
import 'package:mydiaree/features/daily_journal/accident/data/models/accident_list_response_model.dart';
import 'package:mydiaree/features/daily_journal/accident/data/models/child_details_response_model.dart';
import 'package:mydiaree/features/daily_journal/accident/data/models/create_accident_response_model.dart';

class AccidentRepository {
  final String baseUrl = 'https://mydiaree.com.au/api';

  Future<ApiResponse<AccidentListResponseModel?>> getAccidents({
    required String centerId,
    String? roomId,
  }) async {
    final url = '$baseUrl/Accidents/list?centerid=$centerId${roomId != null ? '&roomid=$roomId' : ''}';
    
    return await getAndParseData<AccidentListResponseModel>(
      url,
      fromJson: (json) => AccidentListResponseModel.fromJson(json),
    );
  }
  
  Future<ApiResponse<CreateAccidentResponseModel?>> getCreateAccidentData({
    required String centerId,
    required String roomId,
  }) async {
    final url = '$baseUrl/Accidents/create?center_id=$centerId&roomid=$roomId';
    return await getAndParseData<CreateAccidentResponseModel>(
      url,
      fromJson: (json) => CreateAccidentResponseModel.fromJson(json),
    );
  }

  Future<ApiResponse<ChildDetailsResponseModel?>> getChildDetails( {
    required String childId,
  }) async {
    final url = '$baseUrl/Accident/getChildDetails';
    return await postAndParse<ChildDetailsResponseModel>(
      url,
      {'childid': childId},
      fromJson: (json) => ChildDetailsResponseModel.fromJson(json),
    );
  }

  Future<ApiResponse<AccidentDetailResponseModel?>> getAccidentDetails({
    required String accidentId,
    required String centerId,
    required String roomId,
  }) async {
    final url = '$baseUrl/Accidents/edit?id=$accidentId&centerid=$centerId&roomid=$roomId';
    return await getAndParseData<AccidentDetailResponseModel>(
      url,
      fromJson: (json) => AccidentDetailResponseModel.fromJson(json),
    );
  }

  Future<ApiResponse> saveAccident({
    String? id,
    required String centerId,
    required String roomId,
    required String personName,
    required String personRole,
    required String date,
    required String time,
    String? personSign,
    required String childId,
    required String childName,
    required String childDob,
    required String childAge,
    required String gender,
    required String incidentDate,
    required String incidentTime,
    required String incidentLocation,
    required String witnessName,
    required String witnessDate,
    String? witnessSign,
    required String genActyvt,
    required String cause,
    required String illnessSymptoms,
    required String missingUnaccounted,
    required String takenRemoved,
    String? injuryImage,
    required Map<String, dynamic> injuryTypes,
    required String remarks,
    required String actionTaken,
    required String emergServAttend,
    required String medAttention,
    required String medAttentionDetails,
    required String preventionStep1,
    required String preventionStep2,
    required String preventionStep3,
    required String parent1Name,
    required String contact1Method,
    required String contact1Date,
    required String contact1Time,
    required String contact1Made,
    required String contact1Msg,
    required String parent2Name,
    required String contact2Method,
    required String contact2Date,
    required String contact2Time,
    required String contact2Made,
    required String contact2Msg,
    required String responsiblePersonName,
    String? responsiblePersonSign,
    required String rpInternalNotifDate,
    required String rpInternalNotifTime,
    required String nominatedSupervisorName,
    String? nominatedSupervisorSign,
    required String nsvDate,
    required String nsvTime,
    required String otherAgency,
    required String enorDate,
    required String enorTime,
    required String regulatoryAuthority,
    required String enraDate,
    required String enraTime,
    required String addNotes,
  }) async {
    final url = '$baseUrl/Accident/saveAccident';
    
    final Map<String, dynamic> data = {
      if (id != null) 'id': id,
      'centerid': centerId,
      'roomid': roomId,
      'person_name': personName,
      'person_role': personRole,
      'date': date,
      'time': time,
      if (personSign != null) 'witness_sign': personSign,
      'childid': childId,
      'child_name': childName,
      'child_dob': childDob,
      'child_age': childAge,
      'gender': gender,
      'incident_date': incidentDate,
      'incident_time': incidentTime,
      'incident_location': incidentLocation,
      'witness_name': witnessName,
      'witness_date': witnessDate,
      if (witnessSign != null) 'witness_sign': witnessSign,
      'gen_actyvt': genActyvt,
      'cause': cause,
      'illness_symptoms': illnessSymptoms,
      'missing_unaccounted': missingUnaccounted,
      'taken_removed': takenRemoved,
      if (injuryImage != null) 'injury_image': injuryImage,
      ...injuryTypes,
      'remarks': remarks,
      'action_taken': actionTaken,
      'emrg_serv_attend': emergServAttend,
      'med_attention': medAttention,
      'med_attention_details': medAttentionDetails,
      'prevention_step_1': preventionStep1,
      'prevention_step_2': preventionStep2,
      'prevention_step_3': preventionStep3,
      'parent1_name': parent1Name,
      'contact1_method': contact1Method,
      'contact1_date': contact1Date,
      'contact1_time': contact1Time,
      'contact1_made': contact1Made,
      'contact1_msg': contact1Msg,
      'parent2_name': parent2Name,
      'contact2_method': contact2Method,
      'contact2_date': contact2Date,
      'contact2_time': contact2Time,
      'contact2_made': contact2Made,
      'contact2_msg': contact2Msg,
      'responsible_person_name': responsiblePersonName,
      if (responsiblePersonSign != null) 'responsible_person_sign': responsiblePersonSign,
      'rp_internal_notif_date': rpInternalNotifDate,
      'rp_internal_notif_time': rpInternalNotifTime,
      'nominated_supervisor_name': nominatedSupervisorName,
      if (nominatedSupervisorSign != null) 'nominated_supervisor_sign': nominatedSupervisorSign,
      'nsv_date': nsvDate,
      'nsv_time': nsvTime,
      'otheragency': otherAgency,
      'enor_date': enorDate,
      'enor_time': enorTime,
      'Regulatoryauthority': regulatoryAuthority,
      'enra_date': enraDate,
      'enra_time': enraTime,
      'add_notes': addNotes,
    };

    FormData formData = FormData.fromMap(data);
    print('============');
    print(data);
    return await ApiServices.postData(url, formData);
  }
}
