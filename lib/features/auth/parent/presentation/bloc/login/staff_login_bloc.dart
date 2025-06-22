import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/core/services/apiresoponse.dart';
import 'package:mydiaree/features/auth/parent/data/repositories/staff_auth_repo.dart';
import 'package:mydiaree/features/auth/parent/presentation/bloc/login/staff_event.dart';
import 'package:mydiaree/features/auth/parent/presentation/bloc/login/staff_login_state.dart';

class ParentLoginBloc extends Bloc<ParentLoginEvent, ParentLoginState> {
  ParentAuthenticationRepository repository = ParentAuthenticationRepository();

  ParentLoginBloc() : super(ParentLoginInitial()) {
    on<ParentLoginSubmitted>((event, emit) async {
      if (state is ParentLoginInitial || state is ParentLoginError) {
        emit(ParentLoginLoading());
        try {
          final response = await repository.parentLoginWithPass(
            email: event.email,
            password: event.password,
          );
          if (response.success) {
            emit(ParentLoginSuccess(
              message: response.message,
              loginData: response.data,
            ));
          } else {
            emit(ParentLoginError(message: response.message));
          }
        } catch (e) {
          emit(ParentLoginError(message: defaultErrorMessage()));
        }
        emit(ParentLoginInitial());
      }
    });
  }
}
