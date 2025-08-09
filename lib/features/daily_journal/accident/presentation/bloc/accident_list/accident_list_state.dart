import 'package:mydiaree/features/daily_journal/accident/data/models/accident_list_response_model.dart';

abstract class AccidentListState {}

class AccidentListInitial extends AccidentListState {}

class AccidentListLoading extends AccidentListState {}

class AccidentListLoaded extends AccidentListState {
  final AccidentListResponseModel response;
  final String? selectedCenterId;
  final String? selectedRoomId;
  final String searchQuery;
  
  AccidentListLoaded({
    required this.response,
    this.selectedCenterId,
    this.selectedRoomId,
    this.searchQuery = '',
  });
  
  AccidentListLoaded copyWith({
    AccidentListResponseModel? response,
    String? selectedCenterId,
    String? selectedRoomId,
    String? searchQuery,
  }) {
    return AccidentListLoaded(
      response: response ?? this.response,
      selectedCenterId: selectedCenterId ?? this.selectedCenterId,
      selectedRoomId: selectedRoomId ?? this.selectedRoomId,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
  
  List<AccidentModel> get filteredAccidents {
    final accidents = response.data.accidents;
    
    if (searchQuery.isEmpty) {
      return accidents;
    }
    
    return accidents.where((accident) => 
      accident.child_name.toLowerCase().contains(searchQuery.toLowerCase())).toList();
  }
}

class AccidentListError extends AccidentListState {
  final String message;
  
  AccidentListError(this.message);
}
