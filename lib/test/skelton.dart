import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonProductCard extends StatelessWidget {
  const SkeletonProductCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
            ),
            const SizedBox(height: 8),
            Container(height: 16, width: double.infinity, margin: const EdgeInsets.symmetric(horizontal: 8), color: Colors.grey),
            const SizedBox(height: 4),
            Container(height: 16, width: 80, margin: const EdgeInsets.symmetric(horizontal: 8), color: Colors.grey),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}