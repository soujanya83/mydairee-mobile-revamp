import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/features/healthy_menu/reciepe/data/repositories/reciepe_repository.dart';
import 'package:mydiaree/features/healthy_menu/reciepe/presentation/bloc/list/reciepe_event.dart';
import 'package:mydiaree/features/healthy_menu/reciepe/presentation/bloc/list/reciepe_state.dart'; 

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final RecipeRepository repository = RecipeRepository();

  RecipeBloc() : super(RecipeInitial()) {
 

    // on<FetchIngredientsEvent>((event, emit) async {
    //   emit(RecipeLoading());
    //   final response = await repository.fetchIngredients();
    //   if (response.success) {
    //     emit(RecipeIngredientsLoaded(response.data!));
    //   } else {
    //     emit(RecipeError(response.message));
    //   }
    // });

    // on<FetchRecipesEvent>((event, emit) async {
    //   emit(RecipeLoading());
    //   final response = await repository.fetchRecipes(centerId: event.centerId);
    //   if (response.success) {
    //     emit(RecipeRecipesLoaded(response.data!));
    //   } else {
    //     emit(RecipeError(response.message));
    //   }
    // });

    // on<AddRecipeEvent>((event, emit) async {
    //   emit(RecipeLoading());
    //   final response = await repository.addRecipe(
    //     ingredient: event.ingredient,
    //     recipe: event.recipe,
    //     centerId: event.centerId,
    //   );
    //   if (response.success) {
    //     emit(RecipeSuccess(response.message));
    //   } else {
    //     emit(RecipeError(response.message));
    //   }
    // });

    // on<DeleteRecipeEvent>((event, emit) async {
    //   emit(RecipeLoading());
    //   final response = await repository.deleteRecipe(recipeId: event.recipeId);
    //   if (response.success) {
    //     emit(RecipeSuccess(response.message));
    //   } else {
    //     emit(RecipeError(response.message));
    //   }
    // });
  }
}