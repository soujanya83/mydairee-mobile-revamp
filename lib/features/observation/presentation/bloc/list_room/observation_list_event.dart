import 'package:equatable/equatable.dart';

abstract class ObservationListEvent extends Equatable {
  const ObservationListEvent();

  @override
  List<Object> get props => [];
}

class FetchObservationsEvent extends ObservationListEvent {
  final String centerId;
  final String? searchQuery;
  final String? statusFilter;

  const FetchObservationsEvent({
    required this.centerId,
    this.searchQuery,
    this.statusFilter,
  });

  @override
  List<Object> get props => [centerId];
}

class DeleteSelectedObservationsEvent extends ObservationListEvent {
  final String observationsId;
  final String centerId;
  const DeleteSelectedObservationsEvent(this.observationsId, {required this.centerId});

  @override
  List<Object> get props => [observationsId, centerId];
}

class SearchObservationsEvent extends ObservationListEvent {
  final String centerId;
  final String? searchQuery;
  final String? statusFilter;

  const SearchObservationsEvent({
    required this.centerId,
    this.searchQuery,
    this.statusFilter,
  });

  @override
  List<Object> get props => [centerId];
}

class FilterObservationsEvent extends ObservationListEvent {
  final String centerId;
  final String? searchQuery;
  final String? statusFilter;

  const FilterObservationsEvent({
    required this.centerId,
    this.searchQuery,
    this.statusFilter,
  });

  @override
  List<Object> get props => [centerId];
}

class AdvancedFilterObservationsEvent extends ObservationListEvent {
  final String centerId;
  final List<String>? authorIds;
  final List<String>? childIds;
  final String? fromDate;
  final String? toDate;
  final List<String>? statuses;

  const AdvancedFilterObservationsEvent({
    required this.centerId,
    this.authorIds,
    this.childIds,
    this.fromDate,
    this.toDate,
    this.statuses,
  });

  @override
  List<Object> get props => [centerId];
}

class FetchChildrenEvent extends ObservationListEvent {
  final String centerId;

  const FetchChildrenEvent({
    required this.centerId,
  });

  @override
  List<Object> get props => [centerId];
}

class FetchStaffEvent extends ObservationListEvent {
  final String centerId;

  const FetchStaffEvent({
    required this.centerId,
  });

  @override
  List<Object> get props => [centerId];
}

class FetchFilterDataEvent extends ObservationListEvent {
  final String centerId;

  const FetchFilterDataEvent({
    required this.centerId,
  });

  @override
  List<Object> get props => [centerId];
}
