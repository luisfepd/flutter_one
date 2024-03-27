import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../domain/either/either.dart';
import '../../../../../../domain/failures/http_request/http_request_failure.dart';
import '../../../../../../domain/models/performer/performer.dart';
import '../../../../../../domain/repositories/trending_repository.dart';
import 'performers_tile.dart';

typedef EitherListPerformer = Either<HttpRequestFailure, List<Performer>>;

class TrendingPerformers extends StatefulWidget {
  const TrendingPerformers({super.key});

  @override
  State<TrendingPerformers> createState() => _TrendingPerformersState();
}

class _TrendingPerformersState extends State<TrendingPerformers> {
  late Future<EitherListPerformer> _future;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _future = context.read<TrendingRepository>().getPerformers();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder<EitherListPerformer>(
        future: _future,
        builder: (_, snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return snapshot.data!.when(
            left: (failure) => Text(failure.toString()),
            right: (list) => PageView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                final performer = list[index];
                return PerformersTile(performer: performer);
              },
            ),
          );
        },
      ),
    );
  }
}
