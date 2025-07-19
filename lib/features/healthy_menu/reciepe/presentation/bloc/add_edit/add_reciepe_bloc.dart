import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/features/healthy_menu/reciepe/data/repositories/reciepe_repository.dart'; 
import 'package:mydiaree/features/healthy_menu/reciepe/presentation/bloc/add_edit/add_reciepe_event.dart';
import 'package:mydiaree/features/healthy_menu/reciepe/presentation/bloc/add_edit/add_reciepe_state.dart';

class AddRecipeBloc extends Bloc<AddRecipeScreenEvent, AddRecipeState> {
  final RecipeRepository repository = RecipeRepository();

  AddRecipeBloc() : super(AddRecipeInitial()) {
    on<FetchIngredientsForAddEvent>((event, emit) async {
      emit(AddRecipeLoading());
      final response = await repository.fetchIngredients();
      if (response.success) {
        emit(AddRecipeIngredientsLoaded(response.data!));
      } else {
        emit(AddRecipeError(response.message));
      }
    });

    on<CreateRecipeEvent>((event, emit) async {
      emit(AddRecipeLoading());
      final response = await repository.addRecipe(
        itemName: event.itemName,
        mealType: event.mealType,
        ingredientId: event.ingredientId,
        description: event.description,
        imagePath: event.imagePath,
        creator: event.creator,
      );
      if (response.success) {
        emit(AddRecipeSuccess(response.message));
      } else {
        emit(AddRecipeError(response.message));
      }
    });

    on<EditRecipeEvent>((event, emit) async {
      emit(AddRecipeLoading());
      final response = await repository.addRecipe(
        id: event.id.toString(),
        itemName: event.itemName,
        mealType: event.mealType,
        ingredientId: event.ingredientId,
        description: event.description,
        imagePath: event.imagePath,
        creator: event.creator,
      );
      if (response.success) {
        emit(AddRecipeSuccess(response.message));
      } else {
        emit(AddRecipeError(response.message));
      }
    });
  }
}