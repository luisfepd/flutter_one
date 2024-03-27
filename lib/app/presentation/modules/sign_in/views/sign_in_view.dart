import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../domain/repositories/authentication_repository.dart';
import '../../../routes/routes.dart';
import '../../splash/views/widgets/submit_button.dart';
import '../controller/sign_in_controller.dart';
import '../controller/state/sign_in_state.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SignInController>(
      create: (_) => SignInController(
        const SignInState(),
        authenticationRepository: context.read<AuthenticationRepository>(),
      ),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              child: Builder(builder: (context) {
                final controller = Provider.of<SignInController>(
                  context,
                  listen: true,
                );
                return AbsorbPointer(
                  absorbing: controller.state.fetching,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onChanged: (text) {
                          controller.onUserNameChanged(text);
                        },
                        decoration: const InputDecoration(
                          hintText: 'username',
                        ),
                        validator: (text) {
                          text = text?.trim().toLowerCase() ?? '';
                          if (text.isEmpty) {
                            return 'Invalid username';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onChanged: (text) {
                          controller.onPasswordChanged(text);
                        },
                        decoration: const InputDecoration(
                          hintText: 'password',
                        ),
                        validator: (text) {
                          text = text?.replaceAll(' ', '') ?? '';
                          if (text.length < 4) {
                            return 'Invalid password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const SubmitButton(),
                    ],
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit(BuildContext context) async {
    final SignInController controller = context.read();

    //controller.onFetchingChanged(true);

    final result = await context.read<AuthenticationRepository>().signIn(
          controller.state.username,
          controller.state.password,
        );

    // if (!mounted) {
    //   return;
    // }

    result.when(
      left: (failure) {
        final message = failure.when(
            notFound: () => 'Not Found',
            network: () => 'Network Error',
            unauthorized: () => 'Invalid password',
            unknown: () => 'error',
            notVerified: () => 'Email Not verified');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      },
      right: (user) {
        Navigator.pushReplacementNamed(
          context,
          Routes.home,
        );
      },
    );
  }
}
