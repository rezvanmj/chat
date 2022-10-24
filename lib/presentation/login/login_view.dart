import 'package:chat_project/application/login/login_event.dart';
import 'package:chat_project/presentation/core/const_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../application/login/login_bloc.dart';
import '../../application/login/login_state.dart';
import '../../core/service_locator.dart';
import '../../domain/core/enums.dart';
import '../../domain/core/general_exceptions.dart';
import '../../domain/login/auth_exception.dart';
import '../core/const_values.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (context) => getIt<LoginBloc>(),
      child: BlocConsumer<LoginBloc, LoginState>(
        listener: _blocListen,
        builder: _blocBuilder,
      ),
    );
  }

  Widget _blocBuilder(context, state) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(login),
        ),
        body: _loginBody(state, context));
  }

  void _blocListen(context, state) async {
    // success
    if (state.apiResponse?.response is Success) {
      Navigator.of(context).pushNamedAndRemoveUntil(homePage, (route) => false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('signInSuccessMessage'),
          backgroundColor: Colors.green,
        ),
      );
      // navigating to
      const SnackBar(
        content: Text('SUCCESS'),
      );
    }
    // failure
    if (state.apiResponse?.response is Failure) {
      final failure = state.apiResponse!.response as Failure;
      if (failure.failuer is IncorrectUsernameAndPasswordException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(failure.failuer.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }

      /// 403 response
      if (failure.failuer is NotTrustedException) {
        const SnackBar(
          content: Text('FAILED'),
        );
        Navigator.of(context).pushNamed(confirmPage);
      }
    }
  }

  _loginBody(LoginState state, BuildContext context) {
    return Form(
      key: state.usePassKey,
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: _usernameField(state),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: _passwordField(state, context),
          ),
          const SizedBox(
            height: 50,
          ),
          if (state.isLoading!)
            const CircularProgressIndicator()
          else
            OutlinedButton(
                onPressed: () {
                  if (state.usePassKey.currentState!.validate()) {
                    BlocProvider.of<LoginBloc>(context)
                        .add(ChangeLoadingEvent());
                  } else {}
                },
                child: const Text('Login'))
        ],
      ),
    );
  }

  Widget _passwordField(LoginState state, BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
          label: const Text('password'),
          suffixIcon: state.isShowingPass!
              ? IconButton(
                  onPressed: () {
                    BlocProvider.of<LoginBloc>(context)
                        .add(ChangeVisiblityPassEvent());
                  },
                  icon: const Icon(Icons.visibility_off))
              : IconButton(
                  onPressed: () {
                    BlocProvider.of<LoginBloc>(context)
                        .add(ChangeVisiblityPassEvent());
                  },
                  icon: const Icon(Icons.remove_red_eye))),
      controller: state.passwordController,
      obscureText: !state.isShowingPass! ?? false,
    );
  }

  Widget _usernameField(LoginState state) {
    return TextFormField(
      decoration: const InputDecoration(label: Text('username')),
      controller: state.usernameController,
    );
  }
}
