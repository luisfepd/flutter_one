import 'package:flutter/material.dart';

import '../../../generated/assets.gen.dart';

class RequestFailed extends StatelessWidget {
  const RequestFailed({
    super.key,
    required this.onRetry,
    this.text,
  });

  final VoidCallback onRetry;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.black12,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Assets.svgs.error404.svg(),
          ),
          // Image.asset(
          //   Assets.images.error404.path,
          //   fit: BoxFit.cover,
          //   width: 150,
          // ),
          Text(text ?? 'Request Failed'),
          MaterialButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
