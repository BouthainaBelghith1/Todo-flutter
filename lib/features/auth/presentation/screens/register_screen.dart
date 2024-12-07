import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/core/utils/snack_bar_message.dart';
import 'package:todo_app/features/auth/presentation/bloc/user_manager/user_manager_bloc.dart';
import 'package:todo_app/features/auth/presentation/widgets/register_form.dart';

class RegisterScreen extends StatelessWidget{
  const RegisterScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocListener<UserManagerBloc, UserManagerState>(
      listener: (context, state) {
        if (state is RegisteredUserState) {
          GoRouter.of(context).goNamed('login');
        }
        if (state is RegisterUserErrorState) {
          SnackBarMessage()
              .showErrorSnackBar(message: state.message, context: context);
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Register")),
        body: RegisterForm(),
      ),
    );
  }
}