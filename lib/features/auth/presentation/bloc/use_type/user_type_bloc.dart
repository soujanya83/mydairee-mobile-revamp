
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mydiaree/features/auth/presentation/bloc/use_type/user_state.dart';
import 'package:mydiaree/features/auth/presentation/bloc/use_type/user_type_event.dart';

class UserTypeBloc extends Bloc<UserTypeEvent, UserTypeState> {
  UserTypeBloc(): super(UserTypeState()){

    on<SelectUserTypeEvent>((event, emit) {
      emit(UserTypeState(selectedRole: event.userType,showNextButton: true));
    });

    on<ButtonPressEvent>((event,emit){
      
    });

  }
}