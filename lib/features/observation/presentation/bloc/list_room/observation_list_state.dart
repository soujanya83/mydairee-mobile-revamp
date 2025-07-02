import 'package:equatable/equatable.dart';
import 'package:mydiaree/features/observation/data/model/observation_list_model.dart';

enum DeletionStatus { initial, inProgress, success, failure }

class ObservationListState extends Equatable {
  const ObservationListState();

  @override
  List<Object> get props => [];
}

class ObservationListInitial extends ObservationListState {}

class ObservationListLoading extends ObservationListState {}

class ObservationListError extends ObservationListState {
  final String message;

  const ObservationListError({required this.message});

  @override
  List<Object> get props => [message];
}

class ObservationListLoaded extends ObservationListState {
  final ObservationListModel observationsData;

  const ObservationListLoaded({
    required this.observationsData,
  });

  @override
  List<Object> get props => [
        observationsData,
      ];
}

class ObservationDeletedState extends ObservationListState {}
