import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../domain/repositories/account_repository.dart';
import '../../../../domain/repositories/authentication_repository.dart';
import '../../../../domain/repositories/connectivity_repository.dart';
import '../../../global/controller/session_controller.dart';
import '../../../routes/routes.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _init();
    });
  }

  Future<void> _init() async {
    final connectivityRepository = context.read<ConnectivityRepository>();

    final AuthenticationRepository authenticationRepository = context.read();

    final AccountRepository accountRepository = context.read();

    final SessionController sessionController = context.read();

    final hasInternet = await connectivityRepository.hasInternet;

    //print('✅ has internet: $hasInternet');

    if (hasInternet) {
      final isSignedIn = await authenticationRepository.isSignedIn;

      if (isSignedIn) {
        final user = await accountRepository.getUserData();

        if (user != null) {
          sessionController.setUser(user);
          _goTo(Routes.home);
        }

        if (mounted) {
          if (user != null) {
            _goTo(Routes.home);
          } else {
            _goTo(Routes.signIn);
          }
        }
      } else {
        _goTo(Routes.signIn);
      }
    } else if (mounted) {
      _goTo(Routes.offline);
    }
  }

  void _goTo(String routeName) {
    Navigator.pushReplacementNamed(
      context,
      routeName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SizedBox(
          width: 80,
          height: 80,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
