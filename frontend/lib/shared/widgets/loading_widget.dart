import 'package:flutter/material.dart';

import 'package:frontend/shared/widgets/shimmer_loader.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          children: [
            ShimmerLoader(height: 120, width: double.infinity),
            SizedBox(height: 16),
            ShimmerLoader(height: 250, width: double.infinity),
            SizedBox(height: 16),
            ShimmerLoader(height: 250, width: double.infinity),
          ],
        ),
      ),
    );
  }
}
