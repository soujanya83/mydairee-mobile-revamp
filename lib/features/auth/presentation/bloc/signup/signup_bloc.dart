import 'package:bloc/bloc.dart';
import 'package:mydiaree/features/auth/data/repositories/auth_repository.dart';
import 'package:mydiaree/features/auth/presentation/bloc/signup/signup_event.dart';
import 'package:mydiaree/features/auth/presentation/bloc/signup/signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignUpState> {
  final AuthenticationRepository repository = AuthenticationRepository();

  SignupBloc() : super(const SignUpInitial()) {
    on<SignupNameChanged>((event, emit) {
      emit((state as SignUpInitial).copyWith(name: event.name));
    });

    on<SignupUsernameChanged>((event, emit) {
      emit((state as SignUpInitial).copyWith(username: event.username));
    });

    on<SignupEmailChanged>((event, emit) {
      emit((state as SignUpInitial).copyWith(email: event.email));
    });

    on<SignupPasswordChanged>((event, emit) {
      emit((state as SignUpInitial).copyWith(password: event.password));
    });

    on<SignupContactChanged>((event, emit) {
      emit((state as SignUpInitial).copyWith(contact: event.contact));
    });

    on<SignupGenderChanged>((event, emit) {
      emit((state as SignUpInitial).copyWith(gender: event.gender));
    });

    on<SignupDobChanged>((event, emit) {
      emit((state as SignUpInitial).copyWith(dob: event.dob));
    });

    on<SignupImageChanged>((event, emit) {
      emit((state as SignUpInitial).copyWith(profileImage: event.image));
    });

    on<SignupSubmitted>((event, emit) async {
      emit(SignUpLoading.fromState(state));
      try {
        final response = await repository.registerUser(
          name: state.name,
          username: state.username,
          email: state.email,
          password: state.password,
          contact: state.contact,
        );
        if (response.success) {
          emit(SignUpSuccess(
            message: response.message,
            signupData: response.data,
          ));
        } else {
          emit(SignUpError.fromState(state, response.message.toString()));
        }
      } catch (e) {
        emit(SignUpError.fromState(state, e.toString()));
      }
    });
  }
}
