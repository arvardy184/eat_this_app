import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProductDetailShimmer extends StatelessWidget {
  const ProductDetailShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Shimmer
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: double.infinity,
              height: 250,
              color: Colors.white,
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Nutriscore Shimmer
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: _buildShimmerContainer(height: 24),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: _buildShimmerContainer(height: 24),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Description Shimmer
                _buildShimmerContainer(height: 60),
                const SizedBox(height: 24),

                // Section Title
                _buildShimmerContainer(width: 120, height: 20),
                const SizedBox(height: 8),

                // Ingredients Shimmer
                _buildShimmerContainer(height: 80),
                const SizedBox(height: 24),

                // Allergens Section
                _buildShimmerContainer(width: 100, height: 20),
                const SizedBox(height: 8),
                Row(
                  children: List.generate(3, (index) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: _buildShimmerContainer(height: 32),
                    ),
                  )),
                ),
                const SizedBox(height: 24),

                // Categories Section
                _buildShimmerContainer(width: 100, height: 20),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(4, (index) => 
                    _buildShimmerContainer(width: 100, height: 32),
                  ),
                ),
                const SizedBox(height: 24),

                // Nutrients Table Shimmer
                _buildShimmerContainer(width: 150, height: 20),
                const SizedBox(height: 8),
                Table(
                  children: List.generate(5, (index) => TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _buildShimmerContainer(height: 20),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _buildShimmerContainer(height: 20),
                      ),
                    ],
                  )),
                ),
                const SizedBox(height: 24),

                // Alternative Products Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildShimmerContainer(width: 150, height: 20),
                    _buildShimmerContainer(width: 40, height: 40, radius: 20),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 280,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: _buildAlternativeProductShimmer(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerContainer({
    double? width, 
    required double height,
    double radius = 8,
  }) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }

  Widget _buildAlternativeProductShimmer() {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: _buildShimmerContainer(
              width: double.infinity,
              height: 120,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildShimmerContainer(
                  width: double.infinity,
                  height: 16,
                ),
                const SizedBox(height: 8),
                Row(
                  children: List.generate(2, (index) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: _buildShimmerContainer(height: 24),
                    ),
                  )),
                ),
              ],
            ),
          ),
          _buildShimmerContainer(
            width: double.infinity,
            height: 36,
          ),
        ],
      ),
    );
  }
}