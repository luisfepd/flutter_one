import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../global/widgets/request_failed.dart';
import '../../../controller/home_controller.dart';
import 'trending_tile.dart';
import 'trending_time_window.dart';

class TrendingList extends StatelessWidget {
  const TrendingList({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = context.watch();
    final state = controller.state;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TrendingTimeWindow(
          timeWindow: controller.state.timeWindow,
          onChanged: (timeWindowResult) async {
            controller.changeTimeWindow(timeWindowResult);
            controller.init();
          },
        ),
        const SizedBox(
          height: 10,
        ),
        AspectRatio(
          aspectRatio: 16 / 9,
          child: LayoutBuilder(
            builder: (_, constraints) {
              final width = constraints.maxHeight * 0.65;
              return Center(
                child: state.when(
                  loading: (_) => const CircularProgressIndicator(),
                  failed: (_) => RequestFailed(onRetry: () {}),
                  loaded: (_, list, __) => ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (_, index) {
                      final media = list[index];
                      return TrendingTile(
                        media: media,
                        width: width,
                      );
                    },
                    itemCount: list.length,
                    separatorBuilder: (_, __) => const SizedBox(
                      width: 10,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
