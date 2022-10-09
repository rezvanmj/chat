import 'package:chat_project/presentation/core/const_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../application/confirm/confirm_bloc.dart';
import '../../application/confirm/confirm_event.dart';
import '../../application/confirm/confirm_state.dart';
import '../../core/service_locator.dart';
import '../../domain/core/enums.dart';
import '../../domain/core/general_exceptions.dart';

class ConfirmView extends StatelessWidget {
  const ConfirmView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ConfirmBloc>(),
      child: BlocConsumer<ConfirmBloc, ConfirmState>(
        listener: _blocListener,
        builder: _blocBuilder,
      ),
    );
  }

  Widget _blocBuilder(context, state) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm'),
      ),
      body: Column(
        children: [
          _codeInput(state),
          if (state.isLoading!)
            const CircularProgressIndicator()
          else
            OutlinedButton(
                onPressed: () {
                  BlocProvider.of<ConfirmBloc>(context).add(Confirmed());
                },
                child: const Text('confirm'))
        ],
      ),
    );
  }

  Widget _codeInput(state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: TextFormField(
          controller: state.confirmCodeController,
          decoration: const InputDecoration(label: Text('code')),
        ),
      ),
    );
  }

  void _blocListener(context, state) async {
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
      // Navigator.of(context)
      //     .pushNamedAndRemoveUntil(skeletonPage, (route) => false);
    }
    // failure
    if (state.apiResponse?.response is Failure) {
      final failure = state.apiResponse!.response as Failure;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(failure.failuer.toString()),
          backgroundColor: Colors.red,
        ),
      );

      /// 403 response
      if (failure.failuer is NotTrustedException) {
        const SnackBar(
          content: Text('FAILED'),
        );
      }
    }
  }
}
