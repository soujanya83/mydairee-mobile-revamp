import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/core/services/apiresoponse.dart';
import 'package:mydiaree/features/auth/admin/data/repositories/auth_repository.dart';
import 'package:mydiaree/features/auth/admin/presentation/bloc/updatepassowd/update_password_event.dart';
import 'package:mydiaree/features/auth/admin/presentation/bloc/updatepassowd/update_password_state.dart';

class UpdatePasswordBloc
    extends Bloc<UpdatePasswordEvent, UpdatePasswordState> {
  AdminAuthenticationRepository repository = AdminAuthenticationRepository();
  UpdatePasswordBloc() : super(UpdatePasswordInitial()) {
    on<UpdatePasswordSubmitted>((event, emit) async {
      emit(UpdatePasswordSubmitting());
      try {
        final response = await repository.updatePassword(
          email: event.email,
          newPassword: event.newPassword
        );
        if (response.success){
          emit(UpdatePasswordSuccess(
            message: response.message,
          ));
          return;
        } else {
          emit(UpdatePasswordFailure(
            message: response.message,
          ));
          return;
        }
      } catch (e) {
        emit(UpdatePasswordFailure(
          message: defaultErrorMessage(),
        ));
        return;
      }
    });
  }
}
