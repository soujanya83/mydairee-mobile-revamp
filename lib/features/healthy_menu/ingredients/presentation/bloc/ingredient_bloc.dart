import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/features/healthy_menu/ingredients/data/repositories/ingredient_repository.dart';
import 'package:mydiaree/features/healthy_menu/ingredients/presentation/bloc/ingredient_event.dart';
import 'package:mydiaree/features/healthy_menu/ingredients/presentation/bloc/ingredient_state.dart';

class IngredientBloc extends Bloc<IngredientEvent, IngredientState> {
  final IngredientRepository repository = IngredientRepository();
  
  IngredientBloc() : super(IngredientInitial()) {
    on<FetchIngredientsEvent>(_onFetchIngredients);
  }

  void _onFetchIngredients(FetchIngredientsEvent event, Emitter<IngredientState> emit) async {
    emit(IngredientLoading());
    
    try {
      final response = await repository.fetchIngredients();
      if (response.success && response.data != null) {
        emit(IngredientLoaded(response.data!.ingredients));
      } else {
        emit(IngredientError(response.message));
      }
    } catch (e) {
      emit(IngredientError('Failed to load ingredients: ${e.toString()}'));
    }
  }
}