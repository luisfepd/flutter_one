import 'package:flutter/material.dart';

import '../../../../../../domain/enums.dart';

class TrendingTimeWindow extends StatelessWidget {
  const TrendingTimeWindow({
    super.key,
    required this.timeWindow,
    required this.onChanged,
  });

  final void Function(TimeWindow) onChanged;
  final TimeWindow timeWindow;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: Row(
        children: [
          const Text(
            'Trending',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Material(
              color: const Color(0xfff0f0f0),
              borderRadius: BorderRadius.circular(30),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: DropdownButton<TimeWindow>(
                  value: timeWindow,
                  isDense: true,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(
                      value: TimeWindow.day,
                      child: Text('Last 24H'),
                    ),
                    DropdownMenuItem(
                      value: TimeWindow.week,
                      child: Text('Last Week'),
                    ),
                  ],
                  onChanged: (mTimeWindow) {
                    if (mTimeWindow != null && timeWindow != mTimeWindow) {
                      onChanged(mTimeWindow);
                    }
                  },
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
        ],
      ),
    );
  }
}
