import 'package:bloc/bloc.dart';
import 'package:mydiaree/core/services/apiresoponse.dart';
import 'package:mydiaree/features/auth/data/repositories/auth_repository.dart';
import 'package:mydiaree/features/auth/presentation/bloc/signup/signup_event.dart';
import 'package:mydiaree/features/auth/presentation/bloc/signup/signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignUpState> {
  final AuthenticationRepository repository = AuthenticationRepository();

  SignupBloc() : super(const SignUpInitial()) {
    on<SignupSubmitted>((event, emit) async {
      emit(SignUpLoading());
      try {
        final response = await repository.registerUser(
          name: event.name,
          username: event.username,
          email: event.email,
          password: event.password,
          contact: event.contact,
        );
        if (response.success) {
          emit(SignUpSuccess(
            message: response.message,
            signupData: response.data,
          ));
        } else {
          emit(SignUpError(message: response.message.toString()));
        }
      } catch (e) {
        emit(SignUpError(message: defaultErrorMessage()));
      }
    });
  }
}
