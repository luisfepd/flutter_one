import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../global/widgets/request_failed.dart';
import '../../../controller/home_controller.dart';
import 'performers_tile.dart';

class TrendingPerformers extends StatefulWidget {
  const TrendingPerformers({super.key});

  @override
  State<TrendingPerformers> createState() => _TrendingPerformersState();
}

class _TrendingPerformersState extends State<TrendingPerformers> {
  final _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final HomeController controller = context.watch();
    final state = controller.state;
    return Expanded(
        child: state.when(
            loading: (_) => const Center(child: CircularProgressIndicator()),
            failed: (_) => RequestFailed(onRetry: () {}),
            loaded: (_, __, performers) => Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    PageView.builder(
                      controller: _pageController,
                      itemCount: performers.length,
                      itemBuilder: (context, index) {
                        final performer = performers[index];
                        return PerformersTile(performer: performer);
                      },
                    ),
                    Positioned(
                      bottom: 30,
                      child: AnimatedBuilder(
                        animation: _pageController,
                        builder: (_, __) {
                          final int currentCard =
                              _pageController.page?.toInt() ?? 0;
                          return Row(
                            children: List.generate(
                                performers.length,
                                (index) => Icon(
                                      Icons.circle,
                                      size: 14,
                                      color: currentCard == index
                                          ? Colors.red
                                          : Colors.white30,
                                    )),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                )));
  }
}
