import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/features/healthy_menu/ingredients/data/repositories/ingredient_repository.dart';
import 'package:mydiaree/features/healthy_menu/ingredients/presentation/bloc/ingredient_event.dart';
import 'package:mydiaree/features/healthy_menu/ingredients/presentation/bloc/ingredient_state.dart';
import 'package:mydiaree/features/healthy_menu/reciepe/data/repositories/reciepe_repository.dart'; 

class IngredientBloc extends Bloc<IngredientEvent, IngredientState> {
  final IngredientRepository repository = IngredientRepository();

  IngredientBloc() : super(IngredientInitial()) {
    on<FetchIngredientsEvent>((event, emit) async {
      emit(IngredientLoading());
      final response = await repository.fetchIngredients();
      if (response.success) {
        emit(IngredientLoaded(response.data!));
      } else {
        emit(IngredientError(response.message));
      }
    });

    on<AddIngredientEvent>((event, emit) async {
      emit(IngredientLoading());
      final response = await repository.addIngredient(
        name: event.name,
        creator: event.creator,
      );
      if (response.success) {
        emit(IngredientSuccess(response.message));
      } else {
        emit(IngredientError(response.message));
      }
    });

    on<EditIngredientEvent>((event, emit) async {
      emit(IngredientLoading());
      final response = await repository.updateIngredient(
        id: event.id,
        name: event.name,
        creator: event.creator,
      );
      if (response.success) {
        emit(IngredientSuccess(response.message));
      } else {
        emit(IngredientError(response.message));
      }
    });

    on<DeleteIngredientEvent>((event, emit) async {
      emit(IngredientLoading());
      final response = await repository.deleteIngredient(event.id);
      if (response.success) {
        emit(IngredientSuccess(response.message));
      } else {
        emit(IngredientError(response.message));
      }
    });
  }
}