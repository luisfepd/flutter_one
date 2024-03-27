import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../global/controller/session_controller.dart';
import '../../../../routes/routes.dart';
import '../../../sign_in/controller/sign_in_controller.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    final SignInController controller = Provider.of(context, listen: true);
    if (controller.state.fetching) {
      return const CircularProgressIndicator();
    }
    return MaterialButton(
      onPressed: () {
        final isValid = Form.of(context).validate();
        if (isValid) {
          _submit(context);
        }
      },
      color: Colors.red,
      child: const Text('Sign in'),
    );
  }

  Future<void> _submit(BuildContext context) async {
    final SignInController controller = context.read();

    final result = await controller.submit();

    if (!controller.mounted) {
      return;
    }

    result.when(
      left: (failure) {
        final message = failure.when(
            notFound: () => 'Not Found',
            network: () => 'Network Error',
            unauthorized: () => 'Invalid password',
            unknown: () => 'error',
            notVerified: () => 'Not verified');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      },
      right: (user) {
        SessionController sessionController = context.read();
        sessionController.setUser(user);
        Navigator.pushReplacementNamed(
          context,
          Routes.home,
        );
      },
    );
  }
}
