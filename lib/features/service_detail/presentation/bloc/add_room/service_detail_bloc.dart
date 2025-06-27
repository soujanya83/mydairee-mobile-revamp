// Bloc
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/features/service_detail/data/repositories/room_repositories.dart'; 
import 'service_detail_event.dart';
import 'service_detail_state.dart';

class ServiceDetailBloc extends Bloc<ServiceDetailEvent, ServiceDetailState> {
  final ServiceRepository repository = ServiceRepository();

  ServiceDetailBloc() : super(ServiceDetailInitial()) {
    on<SubmitServiceDetailEvent>((event, emit) async {
      emit(ServiceDetailLoading());
      try {
        final response = await repository.submitServiceDetail(
          serviceData: event.serviceData,
        );
        if (response.success) {
          emit(ServiceDetailSuccess(response.message));
        } else {
          emit(ServiceDetailFailure(response.message));
        }
      } catch (e) {
        emit(ServiceDetailFailure(e.toString()));
      }
    });
  }
}