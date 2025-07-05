import 'package:apple_grower/navigation/routes_constant.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'grower_session_controller.dart';

class GrowerSessionView extends GetView<GrowerSessionController> {
  final TextEditingController nameController = TextEditingController();
  final Map<String, TextEditingController> bidControllers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grower Bidding Session'),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("Bidding will start at ${controller.date.value.substring(0,10)} and ${controller.startTime.value}",style: TextStyle(fontSize: 22)),
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
              Obx(() {
                if (controller.error.isNotEmpty) {
                  return Center(
                    child: Text(
                      controller.error.value,
                      style: const TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  );
                }

                // Filter out qualities with zero weight
                final activeQualities = controller.qualityCategories.keys
                    .where((quality) =>
                (controller.qualityTotalWeights[quality] ?? 0) > 0)
                    .toList();

                if (activeQualities.isEmpty) {
                  return Center(
                    child: Text(
                      'No data available',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }

                // Calculate total value and total landing value
                double totalValue = 0;
                double totalLandingValue = 0;
                controller.qualityCategories.forEach((quality, categories) {
                  final weights = controller.qualityWeights[quality] ?? [];
                  final prices = controller.qualityPrices[quality] ?? [];
                  final landingCosts =
                      controller.qualityLandingCosts[quality] ?? [];
                  for (int i = 0;
                  i < weights.length &&
                      i < prices.length &&
                      i < landingCosts.length;
                  i++) {
                    totalValue += weights[i] * prices[i];
                    totalLandingValue += weights[i] * landingCosts[i];
                  }
                });

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      // Real-time total value and landing value
                      // Tab View
                      SizedBox(
                        width: double.infinity,
                        child: DefaultTabController(
                          length: activeQualities.length,
                          child: Column(
                            children: [
                              Container(
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: TabBar(
                                  tabs: activeQualities
                                      .map((quality) => Tab(
                                    child: Text(
                                      '$quality\n${controller.qualityTotalWeights[quality]?.toStringAsFixed(1) ?? '0'} kg',
                                      textAlign: TextAlign.center,
                                      style:
                                      const TextStyle(fontSize: 12),
                                    ),
                                  ))
                                      .toList(),
                                  isScrollable: true,
                                  labelColor: Colors.blue,
                                  unselectedLabelColor: Colors.grey[600],
                                  indicator: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.blue[100],
                                  ),
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                                  labelPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                height: 500,
                                child: TabBarView(
                                  children: activeQualities
                                      .map((quality) =>
                                      _buildQualityChart(quality))
                                      .toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              SizedBox(height: 10,),
              Obx(()=> (controller.growerApproval.value)?Text("Approved"): ElevatedButton(onPressed: ()=>controller.approve(), child: Text("Give Approval"))),
              SizedBox(height: 10,),
              Obx(() => Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: controller.sessionActive.value
                      ? Colors.green[50]
                      : Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  controller.sessionActive.value
                      ? 'SESSION ACTIVE'
                      : 'SESSION INACTIVE',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: controller.sessionActive.value
                        ? Colors.green
                        : Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    letterSpacing: 1.2,
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
  
  

  Widget _buildQualityChart(String quality) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Header with totals
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$quality Quality',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Total Weight: ${controller.qualityTotalWeights[quality]?.toStringAsFixed(2) ?? '0'} kg',
                        style: const TextStyle(fontSize: 12),
                      ),

                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Chart
            Expanded(
              child: Container(
                height: 500,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: LineChart(
                    LineChartData(
                      minY: 0,
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: true,
                        horizontalInterval: _calculateInterval(
                            controller.qualityWeights[quality] ?? []),
                        verticalInterval: 1,
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: Colors.grey[300],
                          strokeWidth: 1,
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border.all(color: Colors.grey, width: 1),
                      ),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            interval: _calculateInterval(
                                controller.qualityWeights[quality] ?? []),
                            getTitlesWidget: (value, meta) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 4),
                                child: Text(
                                  value.toInt().toString(),
                                  style: const TextStyle(fontSize: 10),
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
                              final categories =
                                  controller.qualityCategories[quality] ?? [];
                              if (idx < 0 || idx >= categories.length) {
                                return const SizedBox.shrink();
                              }
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
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
                        topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: List.generate(
                            controller.qualityWeights[quality]?.length ?? 0,
                                (i) => FlSpot(i.toDouble(),
                                controller.qualityWeights[quality]?[i] ?? 0),
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
                            controller.qualityPrices[quality]?.length ?? 0,
                                (i) => FlSpot(i.toDouble(),
                                controller.qualityPrices[quality]?[i] ?? 0),
                          ),
                          isCurved: true,
                          color: Colors.red,
                          barWidth: 3,
                          dotData: FlDotData(show: true),
                        ),
                        LineChartBarData(
                          spots: List.generate(
                            controller.qualityLandingCosts[quality]?.length ?? 0,
                                (i) => FlSpot(i.toDouble(),
                                controller.qualityLandingCosts[quality]?[i] ?? 0),
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
                                label = 'Weight: ${spot.y.toStringAsFixed(2)} kg';
                              } else if (spot.barIndex == 1) {
                                label = 'Price: ₹${spot.y.toStringAsFixed(2)}';
                              } else {
                                label = 'Landing: ₹${spot.y.toStringAsFixed(2)}';
                              }
                              return LineTooltipItem(
                                label,
                                const TextStyle(color: Colors.white),
                              );
                            }).toList();
                          },
                        ),
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
          ],
        ),
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
}
