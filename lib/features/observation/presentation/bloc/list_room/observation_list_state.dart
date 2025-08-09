import 'package:equatable/equatable.dart';
import 'package:mydiaree/features/observation/data/model/child_response.dart';
import 'package:mydiaree/features/observation/data/model/observation_api_response.dart';
import 'package:mydiaree/features/observation/data/model/staff_response.dart';

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
  final ObservationApiResponse observationsData;
  final List<ChildObservationModel> children;
  final List<StaffModel> staff;
  final bool isSearching;
  final bool isFiltering;

  const ObservationListLoaded({
    required this.observationsData,
    this.children = const [],
    this.staff = const [],
    this.isSearching = false,
    this.isFiltering = false,
  });

  @override
  List<Object> get props => [
        observationsData,
        children,
        staff,
        isSearching,
        isFiltering,
      ];
}

class ObservationDeletedState extends ObservationListState {}
