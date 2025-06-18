import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/core/cubit/globle_model/center_model.dart';
import 'package:mydiaree/core/cubit/globle_model/children_model.dart';
import 'package:mydiaree/core/cubit/globle_model/educator_model.dart';
import 'package:mydiaree/core/cubit/globle_repository.dart';

class GlobalDataState {
  final ChildModel? childrenData;
  final CenterModel? centersData;
  final EducatorModel? educatorsData;

  GlobalDataState(
      {required this.childrenData,
      required this.centersData,
      required this.educatorsData});

  GlobalDataState copyWith({
    ChildModel? childrenData,
    CenterModel? centersData,
    EducatorModel? educatorsData,
  }) {
    return GlobalDataState(
        childrenData: childrenData ?? this.childrenData,
        centersData: centersData ?? this.centersData,
        educatorsData: educatorsData ?? this.educatorsData);
  }
}

class GlobalDataCubit extends Cubit<GlobalDataState> {
  final GlobleRepository repository;

  GlobalDataCubit(this.repository)
      : super(GlobalDataState(
            childrenData: null, centersData: null, educatorsData: null));

  Future<void> loadChildren() async {
    final response = await repository.getChildren();
    emit(state.copyWith(childrenData: response.data));
  }

  Future<void> loadCenters() async {
    final response = await repository.getCenters();
    emit(state.copyWith(centersData: response.data));
  }

  Future<void> loadEducators() async {
    final response = await repository.getEducators();
    emit(state.copyWith(educatorsData: response.data));
  }

  Future<void> loadAll() async {
    final childrenData = await repository.getChildren();
    final centersData = await repository.getCenters();
    final educatorsData = await repository.getEducators();
    emit(GlobalDataState(
        educatorsData: educatorsData.data,
        childrenData: childrenData.data,
        centersData: centersData.data));
  }

  void clearData() {
    emit(GlobalDataState(
        childrenData: null, centersData: null, educatorsData: null));
  }
}
