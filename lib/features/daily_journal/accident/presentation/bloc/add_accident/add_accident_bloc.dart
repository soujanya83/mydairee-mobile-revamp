import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/features/daily_journal/accident/data/repositories/accident_repo.dart';
import 'package:mydiaree/features/daily_journal/accident/presentation/bloc/add_accident/add_accident_event.dart';
import 'package:mydiaree/features/daily_journal/accident/presentation/bloc/add_accident/add_accident_state.dart';

class AddAccidentBloc extends Bloc<AddAccidentEvent, AddAccidentState> {
  AccidentRepository accidentRepository = AccidentRepository();

  AddAccidentBloc() : super(AddAccidentInitial()) {
    on<SubmitAddAccidentEvent>(_onSubmitAddAccident);
  }

  Future<void> _onSubmitAddAccident(
      SubmitAddAccidentEvent event, Emitter<AddAccidentState> emit) async {
    emit(AddAccidentLoading());
    try {
      final response = await accidentRepository.addOrEditAccident(
        id: event.id,
        centerId: event.centerId,
        roomId: event.roomId,
        name: event.name,
        positionRole: event.positionRole,
        recordDate: event.recordDate,
        personSignature: event.personSignature,
        childId: event.childId,
        childDob: event.childDob,
        childAge: event.childAge,
        gender: event.gender,
        incidentDate: event.incidentDate,
        incidentTime: event.incidentTime,
        location: event.location,
        childSignature: event.childSignature,
        incidentDetailsDate: event.incidentDetailsDate,
        witnessName: event.witnessName,
        activity: event.activity,
        cause: event.cause,
        circumstances: event.circumstances,
        unaccountedDetails: event.unaccountedDetails,
        lockedDetails: event.lockedDetails,
        injuryTypes: event.injuryTypes,
        actionDetails: event.actionDetails,
        emergencyServices: event.emergencyServices,
        emergencyDetails: event.emergencyDetails,
        medicalAttention: event.medicalAttention,
        medicalDetails1: event.medicalDetails1,
        medicalDetails2: event.medicalDetails2,
        medicalDetails3: event.medicalDetails3,
        guardian1Name: event.guardian1Name,
        guardian1Contact: event.guardian1Contact,
        guardian1Time: event.guardian1Time,
        guardian1Date: event.guardian1Date,
        guardian1Contacted: event.guardian1Contacted,
        guardian1MessageLeft: event.guardian1MessageLeft,
        guardian2Name: event.guardian2Name,
        guardian2Contact: event.guardian2Contact,
        guardian2Time: event.guardian2Time,
        guardian2Date: event.guardian2Date,
        guardian2Contacted: event.guardian2Contacted,
        guardian2MessageLeft: event.guardian2MessageLeft,
        inChargeName: event.inChargeName,
        inChargeSignature: event.inChargeSignature,
        inChargeTime: event.inChargeTime,
        inChargeDate: event.inChargeDate,
        supervisorName: event.supervisorName,
        supervisorSignature: event.supervisorSignature,
        supervisorTime: event.supervisorTime,
        supervisorDate: event.supervisorDate,
        agency: event.agency,
        agencyTime: event.agencyTime,
      );

      emit(AddAccidentSuccess(message: response.data));
    } catch (e) {
      emit(AddAccidentFailure(error: e.toString()));
    }
  }
}
