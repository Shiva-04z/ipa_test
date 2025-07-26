import 'package:apple_grower/navigation/routes_constant.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/globals.dart' as glb;
import 'bidder_session_controller.dart';

class BidderSessionView extends GetView<BidderSessionController> {
  final Map<String, Map<String, TextEditingController>> bidControllers = {};
  final Map<String, Map<String, bool>> bidSubmitted = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bidder Session'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          final qualities = controller.nonZeroCategories;
          if (qualities.isEmpty) {
            return Column(
              children: [
                 Center(
                  child: Text(
                    'No categories available for bidding.',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            );
          }
          return DefaultTabController(
            length: qualities.length,
            child: Column(
              children: [
                const Text('Overall Highest Bidder:',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 0),
                        color: Colors.orange[50],
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(
                                    ()=> Text(
                                    'Name: '
                                        '${controller.highestBidderPerQuality['global'] ?? '-'}',
                                    style: const TextStyle(
                                        color: Colors.deepPurple,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                              ),
                              const SizedBox(height: 4),
                              Obx(
                                    ()=> Text(
                                    'Total Amount: ₹'
                                        '${controller.highestTotals.value?? '-'}',
                                    style: const TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Quality Content
                Expanded(
                  child: TabBarView(
                    children: qualities.map((quality) {
                      final weights = controller.qualityWeights[quality] ?? [];
                      final prices = controller.qualityPrices[quality] ?? [];
                      final landingCosts =
                          controller.qualityLandingCosts[quality] ?? [];
                      final categories =
                          controller.qualityCategories[quality] ?? [];

                      // Initialize controllers and submission status
                      bidControllers.putIfAbsent(quality, () => {});
                      bidSubmitted.putIfAbsent(quality, () => {});

                      // Only non-zero subcategories
                      final nonZeroIndices =
                          List.generate(categories.length, (i) => i)
                              .where((i) => weights[i] > 0)
                              .toList();
                      final nonZeroCategories =
                          nonZeroIndices.map((i) => categories[i]).toList();
                      final nonZeroMinPrices =
                          nonZeroIndices.map((i) => prices[i]).toList();
                      final nonZeroWeights =
                          nonZeroIndices.map((i) => weights[i]).toList();

                      // Initialize controllers with min prices
                      for (int idx = 0; idx < nonZeroCategories.length; idx++) {
                        final cat = nonZeroCategories[idx];
                        bidControllers[quality]!.putIfAbsent(
                            cat,
                            () => TextEditingController(
                                text:
                                    nonZeroMinPrices[idx].toStringAsFixed(2)));
                        bidSubmitted[quality]!.putIfAbsent(cat, () => false);
                      }

                      // Use a StatefulBuilder or ValueNotifier to update totalPrice in real time as bid fields change
                      ValueNotifier<double> totalPriceNotifier = ValueNotifier(
                        calculateQualityTotal(
                            quality, nonZeroCategories, nonZeroWeights),
                      );

                      // Attach listeners to each bidController for this quality
                      for (int idx = 0; idx < nonZeroCategories.length; idx++) {
                        final cat = nonZeroCategories[idx];
                        bidControllers[quality]![cat]!
                            .removeListener(() {}); // Remove any previous
                        bidControllers[quality]![cat]!.addListener(() {
                          totalPriceNotifier.value = calculateQualityTotal(
                              quality, nonZeroCategories, nonZeroWeights);
                        });
                      }

                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header with quality info
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '$quality Quality',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  Text(
                                    'Total Weight: ${controller.qualityTotalWeights[quality]?.toStringAsFixed(2) ?? '0'} kg',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Chart
                            SizedBox(
                              height: 250,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: LineChart(
                                  LineChartData(
                                    minY: 0,
                                    gridData: FlGridData(
                                      show: true,
                                      drawVerticalLine: true,
                                      horizontalInterval: _calculateInterval(
                                          controller.qualityWeights[quality] ??
                                              []),
                                      verticalInterval: 1,
                                      getDrawingHorizontalLine: (value) =>
                                          FlLine(
                                        color: Colors.grey[300],
                                        strokeWidth: 1,
                                      ),
                                    ),
                                    borderData: FlBorderData(
                                      show: true,
                                      border: Border.all(
                                          color: Colors.grey, width: 1),
                                    ),
                                    titlesData: FlTitlesData(
                                      leftTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          reservedSize: 40,
                                          interval: _calculateInterval(
                                              controller.qualityWeights[
                                                      quality] ??
                                                  []),
                                          getTitlesWidget: (value, meta) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 4),
                                              child: Text(
                                                value.toInt().toString(),
                                                style: const TextStyle(
                                                    fontSize: 10),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      bottomTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          interval: 1,
                                          getTitlesWidget: (value, meta) {
                                            int idx = value.toInt();
                                            if (idx < 0 ||
                                                idx >= categories.length) {
                                              return const SizedBox.shrink();
                                            }
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: Text(
                                                categories[idx],
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            );
                                          },
                                          reservedSize: 60,
                                        ),
                                      ),
                                      topTitles: AxisTitles(
                                          sideTitles:
                                              SideTitles(showTitles: false)),
                                      rightTitles: AxisTitles(
                                          sideTitles:
                                              SideTitles(showTitles: false)),
                                    ),
                                    lineBarsData: [
                                      LineChartBarData(
                                        spots: List.generate(
                                          controller.qualityWeights[quality]
                                                  ?.length ??
                                              0,
                                          (i) => FlSpot(
                                              i.toDouble(),
                                              controller.qualityWeights[quality]
                                                      ?[i] ??
                                                  0),
                                        ),
                                        isCurved: true,
                                        color: Colors.blue,
                                        barWidth: 3,
                                        dotData: FlDotData(show: true),
                                        belowBarData: BarAreaData(
                                          show: true,
                                          color: Colors.blue.withOpacity(0.1),
                                        ),
                                      ),
                                      LineChartBarData(
                                        spots: List.generate(
                                          controller.qualityPrices[quality]
                                                  ?.length ??
                                              0,
                                          (i) => FlSpot(
                                              i.toDouble(),
                                              controller.qualityPrices[quality]
                                                      ?[i] ??
                                                  0),
                                        ),
                                        isCurved: true,
                                        color: Colors.red,
                                        barWidth: 3,
                                        dotData: FlDotData(show: true),
                                      ),
                                      LineChartBarData(
                                        spots: List.generate(
                                          controller
                                                  .qualityLandingCosts[quality]
                                                  ?.length ??
                                              0,
                                          (i) => FlSpot(
                                              i.toDouble(),
                                              controller.qualityLandingCosts[
                                                      quality]?[i] ??
                                                  0),
                                        ),
                                        isCurved: true,
                                        color: Colors.green,
                                        barWidth: 3,
                                        dotData: FlDotData(show: true),
                                      ),
                                    ],
                                    lineTouchData: LineTouchData(
                                      enabled: true,
                                      touchTooltipData: LineTouchTooltipData(
                                        tooltipBgColor: Colors.black87,
                                        getTooltipItems: (touchedSpots) {
                                          return touchedSpots.map((spot) {
                                            String label;
                                            if (spot.barIndex == 0) {
                                              label =
                                                  'Weight: ${spot.y.toStringAsFixed(2)} kg';
                                            } else if (spot.barIndex == 1) {
                                              label =
                                                  'Price: ₹${spot.y.toStringAsFixed(2)}';
                                            } else {
                                              label =
                                                  'Landing: ₹${spot.y.toStringAsFixed(2)}';
                                            }
                                            return LineTooltipItem(
                                              label,
                                              const TextStyle(
                                                  color: Colors.white),
                                            );
                                          }).toList();
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Legend
                            Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 16,
                              runSpacing: 8,
                              children: [
                                _buildLegendDot(Colors.blue, 'Weight (Kg)'),
                                _buildLegendDot(Colors.red, 'Per Kg Price'),
                                _buildLegendDot(Colors.green, 'Landing Cost'),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Show total price
                            ValueListenableBuilder<double>(
                              valueListenable: totalPriceNotifier,
                              builder: (context, totalPrice, _) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text('Total Price: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text('₹${totalPrice.toStringAsFixed(2)}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green)),
                                      const SizedBox(width: 16),
                                      ElevatedButton(
                                        onPressed: () async {
                                          final categories = nonZeroCategories;
                                          final weights = nonZeroWeights;
                                          final Map<String, dynamic>
                                              qualityBidData = {};
                                          for (int idx = 0;
                                              idx < categories.length;
                                              idx++) {
                                            final cat = categories[idx];
                                            final bidPerKg = double.tryParse(
                                                    bidControllers[quality]![
                                                            cat]!
                                                        .text) ??
                                                0.0;
                                            final weight = weights[idx];
                                            qualityBidData[cat] = {
                                              'bidPerKg': bidPerKg,
                                              'weight': weight,
                                              'total': bidPerKg * weight,
                                            };
                                          }
                                          qualityBidData['totalAmount'] =
                                              totalPrice;
                                          await controller.submitQualityBid(
                                              glb.personName.value,
                                              quality,
                                              qualityBidData);
                                          Get.snackbar('Success',
                                              'All bids for $quality submitted!',
                                              backgroundColor:
                                                  Colors.green[100]);
                                        },
                                        child: const Text('Submit All'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            const Padding(
                              padding: EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                'Note: You must submit separately for each quality.',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.orange,
                                    fontStyle: FontStyle.italic),
                                textAlign: TextAlign.center,
                              ),
                            ),

                            // Subcategory bids
                            const Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text(
                                'Enter price per kg for each subcategory:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Subcategory cards
                            ...nonZeroCategories.map((category) {
                              final index = nonZeroCategories.indexOf(category);
                              final minPrice = nonZeroMinPrices[index];
                              final weight = nonZeroWeights[index];
                              final isSubmitted =
                                  bidSubmitted[quality]?[category] ?? false;

                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            category,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            '${weight.toStringAsFixed(2)} kg',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Minimum Price: ₹${minPrice.toStringAsFixed(2)}/kg',
                                        style: const TextStyle(
                                          color: Colors.blue,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      TextField(
                                        controller: bidControllers[quality]
                                            ?[category],
                                        keyboardType:
                                            TextInputType.numberWithOptions(
                                                decimal: true),
                                        decoration: InputDecoration(
                                          labelText: 'Your Price (₹/kg)',
                                          border: const OutlineInputBorder(),
                                          suffixIcon: isSubmitted
                                              ? const Icon(Icons.check_circle,
                                                  color: Colors.green)
                                              : null,
                                        ),
                                        enabled: !isSubmitted,
                                      ),
                                      const SizedBox(height: 12),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: ElevatedButton(
                                          onPressed: isSubmitted
                                              ? null
                                              : () async {
                                                  final bidValue = double
                                                      .tryParse(bidControllers[
                                                                      quality]
                                                                  ?[category]
                                                              ?.text ??
                                                          '0');
                                                  if (bidValue == null ||
                                                      bidValue < minPrice) {
                                                    Get.snackbar(
                                                      'Invalid Bid',
                                                      'Bid must be at least ₹${minPrice.toStringAsFixed(2)}',
                                                      backgroundColor:
                                                          Colors.red[100],
                                                    );
                                                    return;
                                                  }

                                                  // Submit this category bid
                                                  final success =
                                                      await controller
                                                          .submitCategoryBid(
                                                    glb.personName.value,
                                                    quality,
                                                    category,
                                                    bidValue,
                                                    weight,
                                                  );

                                                  if (success) {
                                                    bidSubmitted[quality]![
                                                        category] = true;
                                                    Get.snackbar(
                                                      'Success',
                                                      'Bid submitted for $category',
                                                      backgroundColor:
                                                          Colors.green[100],
                                                    );
                                                    // Refresh UI
                                                    bidControllers[quality]
                                                                ?[category]
                                                            ?.text =
                                                        bidValue
                                                            .toStringAsFixed(2);
                                                  } else {
                                                    Get.snackbar(
                                                      'Error',
                                                      'Failed to submit bid',
                                                      backgroundColor:
                                                          Colors.red[100],
                                                    );
                                                  }
                                                },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: isSubmitted
                                                ? Colors.grey
                                                : Colors.blue,
                                            foregroundColor: Colors.white,
                                          ),
                                          child: Text(isSubmitted
                                              ? 'Submitted'
                                              : 'Submit Bid'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildLegendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  double _calculateInterval(List<double> values) {
    if (values.isEmpty) return 100;
    final maxValue = values.reduce((a, b) => a > b ? a : b);
    if (maxValue <= 100) return 20;
    if (maxValue <= 500) return 50;
    if (maxValue <= 1000) return 100;
    return 200;
  }

  double calculateQualityTotal(String quality, List<String> nonZeroCategories,
      List<double> nonZeroWeights) {
    double total = 0.0;
    for (int idx = 0; idx < nonZeroCategories.length; idx++) {
      final cat = nonZeroCategories[idx];
      final bidPerKg =
          double.tryParse(bidControllers[quality]![cat]!.text) ?? 0.0;
      final weight = nonZeroWeights[idx];
      total += bidPerKg * weight;
    }
    return total;
  }
}
