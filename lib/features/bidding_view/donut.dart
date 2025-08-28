import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../models/bilty_model.dart';

// The BiltyCategory and Bilty classes provided in the prompt are assumed to be in their respective files.
//
// class BiltyCategory { ... }
// class Bilty { ... }
//

/// A helper class to hold aggregated data for the overall chart.
class _ChartData {
  _ChartData(this.x, this.y);
  final String x;
  final double y;
}

/// A widget that displays a column of donut charts summarizing Bilty data.
///
/// It shows an overall chart by quality, and then separate charts for
/// each quality type (AAA, AA, GP) if they contain data.
class BiltyQualityDonutCharts extends StatelessWidget {
  final List<BiltyCategory> categoryData;

  const BiltyQualityDonutCharts({
    super.key,
    required this.categoryData,
  });

  /// A reusable method to build a styled donut chart.
  /// It is generic to handle different data types (_ChartData and BiltyCategory).
  Widget _buildDonutChart<T>({
    required String title,
    required List<T> dataSource,
    required String Function(T, int) xValueMapper,
    required num Function(T, int) yValueMapper,
    required String Function(T, int) dataLabelMapper,
  }) {
    return Container(
      height: 500,
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: SfCircularChart(
        title: ChartTitle(
          text: title,
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        legend: const Legend(
          isVisible: true,
          overflowMode: LegendItemOverflowMode.wrap,
          position: LegendPosition.bottom,
        ),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <CircularSeries>[
          DoughnutSeries<T, String>(
            dataSource: dataSource,
            xValueMapper: xValueMapper,
            yValueMapper: yValueMapper,
            dataLabelMapper: dataLabelMapper,
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              labelPosition: ChartDataLabelPosition.outside,
              connectorLineSettings: ConnectorLineSettings(
                type: ConnectorType.curve,
                length: '10%',
              ),
            ),
            innerRadius: '60%',
            explode: true,

            explodeIndex: 0,
          ),
        ],
        annotations: <CircularChartAnnotation>[
          CircularChartAnnotation(widget:
          Container(child:Image.asset("assets/images/apple.png"),width: 100, height:100)),
          if (dataSource.isEmpty)
            CircularChartAnnotation(
              widget: const Text(
                'No data to display',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 1. Prepare data for the Overall chart (Group by Quality)
    final Map<String, double> qualitySummary = {};
    for (var item in categoryData) {
      if (item.totalWeight > 0) {
        qualitySummary.update(
          item.quality,
              (value) => value + item.totalWeight,
          ifAbsent: () => item.totalWeight,
        );
      }
    }
    final List<_ChartData> overallData = qualitySummary.entries
        .map((e) => _ChartData(e.key, e.value))
        .toList();
    final double overallTotalWeight =
    overallData.fold(0.0, (sum, item) => sum + item.y);

    // 2. Prepare data for AAA, AA, and GP charts
    final List<BiltyCategory> aaaData = categoryData
        .where((item) => item.quality == 'AAA' && item.totalWeight > 0)
        .toList();
    final double aaaTotalWeight =
    aaaData.fold(0.0, (sum, item) => sum + item.totalWeight);

    final List<BiltyCategory> aaData = categoryData
        .where((item) => item.quality == 'AA' && item.totalWeight > 0)
        .toList();
    final double aaTotalWeight =
    aaData.fold(0.0, (sum, item) => sum + item.totalWeight);

    final List<BiltyCategory> gpData = categoryData
        .where((item) => item.quality == 'GP' && item.totalWeight > 0)
        .toList();
    final double gpTotalWeight =
    gpData.fold(0.0, (sum, item) => sum + item.totalWeight);

    // Build a list of charts to display
    final List<Widget> charts = [];

    // Add Overall chart if it has data
    if (overallTotalWeight > 0) {
      charts.add(_buildDonutChart<_ChartData>(
        title:
        'Overall Weight by Quality (${overallTotalWeight.toStringAsFixed(2)} kg)',
        dataSource: overallData,
        xValueMapper: (_ChartData data, _) => data.x,
        yValueMapper: (_ChartData data, _) => data.y,
        dataLabelMapper: (_ChartData data, _) =>
        '${data.x}\n(${data.y.toStringAsFixed(2)} kg)',
      ));
    }

    // Add AAA chart if it has data
    if (aaaTotalWeight > 0) {
      charts.add(_buildDonutChart<BiltyCategory>(
        title:
        'AAA Quality Breakdown (${aaaTotalWeight.toStringAsFixed(2)} kg)',
        dataSource: aaaData,
        xValueMapper: (BiltyCategory data, _) => data.category,
        yValueMapper: (BiltyCategory data, _) => data.totalWeight,
        dataLabelMapper: (BiltyCategory data, _) =>
        '${data.category}\n(${data.totalWeight} kg)',
      ));
    }

    // Add AA chart if it has data
    if (aaTotalWeight > 0) {
      charts.add(_buildDonutChart<BiltyCategory>(
        title: 'AA Quality Breakdown (${aaTotalWeight.toStringAsFixed(2)} kg)',
        dataSource: aaData,
        xValueMapper: (BiltyCategory data, _) => data.category,
        yValueMapper: (BiltyCategory data, _) => data.totalWeight,
        dataLabelMapper: (BiltyCategory data, _) =>
        '${data.category}\n(${data.totalWeight} kg)',
      ));
    }

    // Add GP chart if it has data
    if (gpTotalWeight > 0) {
      charts.add(_buildDonutChart<BiltyCategory>(
        title: 'GP Quality Breakdown (${gpTotalWeight.toStringAsFixed(2)} kg)',
        dataSource: gpData,
        xValueMapper: (BiltyCategory data, _) => data.category,
        yValueMapper: (BiltyCategory data, _) => data.totalWeight,
        dataLabelMapper: (BiltyCategory data, _) =>
        '${data.category}\n(${data.totalWeight} kg)',
      ));
    }

    // If no charts were generated, show a message. Otherwise, show the charts.
    return charts.isEmpty
        ? const Center(
      child: Text(
        'No weight data available to display charts.',
        style: TextStyle(color: Colors.grey, fontSize: 16),
      ),
    )
        : SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: charts,
        ),
      ),
    );
  }
}