// 📁 add_room_state.dart
import 'package:equatable/equatable.dart';
import 'package:mydiaree/features/observation/data/model/observation_detail_model.dart';

abstract class ViewObservationState extends Equatable {
  const ViewObservationState();
  
  @override
  List<Object> get props => [];
}

class ViewObservationInitial extends ViewObservationState {}

class ViewObservationLoading extends ViewObservationState {}

class ViewObservationLoaded extends ViewObservationState {
  final ObservationDetailData data;
  
  const ViewObservationLoaded({required this.data});
  
  @override
  List<Object> get props => [data];
}

class ViewObservationFailure extends ViewObservationState {
  final String error;
  
  const ViewObservationFailure({required this.error});
  
  @override
  List<Object> get props => [error];
}
