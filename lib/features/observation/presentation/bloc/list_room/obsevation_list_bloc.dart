import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:mydiaree/features/observation/data/model/child_response.dart';
import 'package:mydiaree/features/observation/data/model/observation_api_response.dart';
import 'package:mydiaree/features/observation/data/model/staff_response.dart';
import 'package:mydiaree/features/observation/data/repositories/observation_repositories.dart';
import 'package:mydiaree/features/observation/presentation/bloc/list_room/observation_list_event.dart';
import 'package:mydiaree/features/observation/presentation/bloc/list_room/observation_list_state.dart';

class ObservationListBloc
    extends Bloc<ObservationListEvent, ObservationListState> {
  final ObservationRepository _repository = ObservationRepository();
  List<ChildObservationModel> _children = [];
  List<StaffModel> _staff = [];

  ObservationListBloc() : super(ObservationListInitial()) {
    on<FetchObservationsEvent>(_onFetchObservations);
    on<SearchObservationsEvent>(_onSearchObservations);
    on<FilterObservationsEvent>(_onFilterObservations);
    on<AdvancedFilterObservationsEvent>(_onAdvancedFilterObservations);
    on<FetchChildrenEvent>(_onFetchChildren);
    on<FetchStaffEvent>(_onFetchStaff);
    on<FetchFilterDataEvent>(_onFetchFilterData);
  }

  Future<void> _onFetchObservations(
    FetchObservationsEvent event,
    Emitter<ObservationListState> emit,
  ) async {
    // Only show loading state if we're starting from initial state
    if (state is! ObservationListLoaded) {
      emit(ObservationListLoading());
    }
    
    try {
      final response = await _repository.getObservations(
        centerId: event.centerId,
        searchQuery: event.searchQuery,
        statusFilter: event.statusFilter,
      );

      if (response.success && response.data != null) {
        emit(ObservationListLoaded(
          observationsData: response.data!,
          children: _children,
          staff: _staff,
        ));
      } else {
        emit(ObservationListError(message: response.message));
      }
    } catch (e) {
      emit(ObservationListError(message: 'Failed to load observations: $e'));
    }
  }

  Future<void> _onSearchObservations(
    SearchObservationsEvent event,
    Emitter<ObservationListState> emit,
  ) async {
    // If we already have a loaded state, show a temporary loading indicator
    if (state is ObservationListLoaded) {
      final currentState = state as ObservationListLoaded;
      emit(ObservationListLoaded(
        observationsData: currentState.observationsData,
        children: currentState.children,
        staff: currentState.staff,
        isSearching: true,
      ));
    }
    
    try {
      final response = await _repository.getObservations(
        centerId: event.centerId,
        searchQuery: event.searchQuery,
        statusFilter: event.statusFilter,
      );

      if (response.success && response.data != null) {
        emit(ObservationListLoaded(
          observationsData: response.data!,
          children: _children,
          staff: _staff,
        ));
      } else {
        // If search fails, restore previous state if possible
        if (state is ObservationListLoaded) {
          final currentState = state as ObservationListLoaded;
          emit(ObservationListLoaded(
            observationsData: currentState.observationsData,
            children: currentState.children,
            staff: currentState.staff,
          ));
        } else {
          emit(ObservationListError(message: response.message));
        }
      }
    } catch (e) {
      if (state is ObservationListLoaded) {
        final currentState = state as ObservationListLoaded;
        emit(ObservationListLoaded(
          observationsData: currentState.observationsData,
          children: currentState.children,
          staff: currentState.staff,
        ));
      } else {
        emit(ObservationListError(message: 'Failed to search observations: $e'));
      }
    }
  }

  Future<void> _onFilterObservations(
    FilterObservationsEvent event,
    Emitter<ObservationListState> emit,
  ) async {
    // Use the same approach as search - maintain state consistency
    if (state is ObservationListLoaded) {
      final currentState = state as ObservationListLoaded;
      emit(ObservationListLoaded(
        observationsData: currentState.observationsData,
        children: currentState.children,
        staff: currentState.staff,
        isFiltering: true,
      ));
    }
    
    try {
      final response = await _repository.getObservations(
        centerId: event.centerId,
        searchQuery: event.searchQuery,
        statusFilter: event.statusFilter,
      );


      if (response.success && response.data != null) {
        emit(ObservationListLoaded(
          observationsData: response.data!,
          children: _children,
          staff: _staff,
        ));
      } else {
        // Restore previous state if possible
        if (state is ObservationListLoaded) {
          final currentState = state as ObservationListLoaded;
          emit(ObservationListLoaded(
            observationsData: currentState.observationsData,
            children: currentState.children,
            staff: currentState.staff,
          ));
        } else {
          emit(ObservationListError(message: response.message));
        }
      }
    } catch (e) {
      if (state is ObservationListLoaded) {
        final currentState = state as ObservationListLoaded;
        emit(ObservationListLoaded(
          observationsData: currentState.observationsData,
          children: currentState.children,
          staff: currentState.staff,
        ));
      } else {
        emit(ObservationListError(message: 'Failed to filter observations: $e'));
      }
    }
  }

  Future<void> _onAdvancedFilterObservations(
    AdvancedFilterObservationsEvent event,
    Emitter<ObservationListState> emit,
  ) async {
    print('emit ObservationListLoading()');
    emit(ObservationListLoading());
    // First emit an intermediate state showing that filtering is in progress
    if (state is ObservationListLoaded) {
      final currentState = state as ObservationListLoaded;
      emit(ObservationListLoaded(
        observationsData: currentState.observationsData,
        children: currentState.children,
        staff: currentState.staff,
        isFiltering: true, // This will trigger the loading overlay in the UI
      ));
    } else {
      emit(ObservationListLoading());
    }
    
    try {
      final response = await _repository.filterObservations(
        centerId: event.centerId,
        authorIds: event.authorIds,
        childIds: event.childIds,
        fromDate: event.fromDate,
        toDate: event.toDate,
        statuses: event.statuses,
      );

      if (response.success && response.data != null) {
        // Preserve children and staff when emitting new state
        emit(ObservationListLoaded(
          observationsData: response.data!,
          children: _children,
          staff: _staff,
          isFiltering: false, // Make sure to turn off filtering flag
        ));
      } else {
        emit(ObservationListError(message: response.message));
      }
    } catch (e) {
      emit(ObservationListError(message: 'Failed to filter observations: $e'));
    }
  }

  Future<void> _onFetchChildren(
    FetchChildrenEvent event,
    Emitter<ObservationListState> emit,
  ) async {
    try {
      final response = await _repository.getChildren(
        centerId: event.centerId,
      );

      if (response.success && response.data != null) {
        _children = response.data!.children;
        
        // If we're in a loaded state, update it with the new children
        if (state is ObservationListLoaded) {
          final currentState = state as ObservationListLoaded;
          emit(ObservationListLoaded(
            observationsData: currentState.observationsData,
            children: _children,
            staff: currentState.staff,
          ));
        }
      }
    } catch (e) {
      // Just log the error but don't change state
      print('Failed to load children: $e');
    }
  }

  Future<void> _onFetchStaff(
    FetchStaffEvent event,
    Emitter<ObservationListState> emit,
  ) async {
    try {
      final response = await _repository.getStaff(
        centerId: event.centerId,
      );

      if (response.success && response.data != null) {
        _staff = response.data!.staff;
        
        // If we're in a loaded state, update it with the new staff
        if (state is ObservationListLoaded) {
          final currentState = state as ObservationListLoaded;
          emit(ObservationListLoaded(
            observationsData: currentState.observationsData,
            children: currentState.children,
            staff: _staff,
          ));
        }
      }
    } catch (e) {
      // Just log the error but don't change state
      print('Failed to load staff: $e');
    }
  }

  Future<void> _onFetchFilterData(
    FetchFilterDataEvent event,
    Emitter<ObservationListState> emit,
  ) async {
    // Fetch both children and staff in parallel
    await Future.wait([
      _repository.getChildren(centerId: event.centerId).then((response) {
        if (response.success && response.data != null) {
          _children = response.data!.children;
        }
      }).catchError((e) {
        print('Failed to load children: $e');
      }),
      
      _repository.getStaff(centerId: event.centerId).then((response) {
        if (response.success && response.data != null) {
          _staff = response.data!.staff;
        }
      }).catchError((e) {
        print('Failed to load staff: $e');
      }),
    ]);
    
    // If we're in a loaded state, update it with the new data
    if (state is ObservationListLoaded) {
      final currentState = state as ObservationListLoaded;
      emit(ObservationListLoaded(
        observationsData: currentState.observationsData,
        children: _children,
        staff: _staff,
      ));
    }
  }
}
