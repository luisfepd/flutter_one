import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import 'app/data/http/http.dart';
import 'app/data/repositories_implementation/account_repository_impl.dart';
import 'app/data/repositories_implementation/authentication_repository_impl.dart';
import 'app/data/repositories_implementation/connectiviy_repository_impl.dart';
import 'app/data/repositories_implementation/trending_repository_impl.dart';
import 'app/data/services/local/session_service.dart';
import 'app/data/services/remote/account_api.dart';
import 'app/data/services/remote/authentication_api.dart';
import 'app/data/services/remote/internet_checker.dart';
import 'app/data/services/remote/trending_api.dart';
import 'app/domain/repositories/account_repository.dart';
import 'app/domain/repositories/authentication_repository.dart';
import 'app/domain/repositories/connectivity_repository.dart';
import 'app/domain/repositories/trending_repository.dart';
import 'app/my_app.dart';
import 'app/presentation/global/controller/session_controller.dart';

void main() {
  final sessionService = SessionService(
    const FlutterSecureStorage(),
  );

  final http = Http(
      client: Client(),
      baseUrl: 'https://api.themoviedb.org/3',
      apiKey: 'fdc3ab9115779b22357e7cd4c97bb873');

  final accountAPI = AccountAPI(http: http);
  final authenticationRepository = runApp(MultiProvider(providers: [
    Provider<AccountRepository>(
      create: (_) => AccountRepositoryImpl(
        accountAPI,
        sessionService,
      ),
    ),
    Provider<ConnectivityRepository>(
      create: (_) =>
          ConnectivityRepositoryImpl(Connectivity(), InternetChecker()),
    ),
    Provider<AuthenticationRepository>(
        create: (_) => AuthenticationRepositoryImpl(
              AuthenticationAPI(http),
              sessionService,
              accountAPI,
            )),
    Provider<TrendingRepository>(
        create: (_) => TrendingRepositoryImpl(
              TrendingAPI(http),
            )),
    ChangeNotifierProvider<SessionController>(
        create: (context) => SessionController(
              authenticationRepository: context.read(),
            ))
  ], child: const MyApp()));
}
