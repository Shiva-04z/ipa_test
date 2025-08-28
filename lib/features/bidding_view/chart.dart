import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class DynamicBarLineChart extends StatelessWidget {
  final List<String> labels;
  final List<double> weights;
  final List<double> prices;


  const DynamicBarLineChart({
    super.key,
    required this.labels,
    required this.weights,
    required this.prices,
  });

  @override
  Widget build(BuildContext context) {
    final List<_ChartData> chartData = [];
    final int length = labels.length;
    if (weights.length != length || prices.length != length) {
      return const Center(child: Text('Error: Data lists have mismatched lengths.'));
    }

    for (int i = 0; i < length; i++) {
      chartData.add(_ChartData(labels[i], weights[i], prices[i]));
    }

    const double widthPerItem = 90.0;

    final double screenWidth = MediaQuery.of(context).size.width;

    final double calculatedWidth = length * widthPerItem;

    final double finalWidth = max(screenWidth - 32, calculatedWidth);


    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(

        width: 550,
        // --- Set the calculated width here ---
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: SfCartesianChart(
          backgroundColor: Colors.white,
          title: const ChartTitle(text: 'Product Weight vs. Cost Analysis'),
          primaryXAxis: const CategoryAxis(
            title: AxisTitle(text: 'Products'),
            // Adjust label intersection to prevent overlap when there are many items
            labelIntersectAction: AxisLabelIntersectAction.rotate45,
          ),
          axes: <ChartAxis>[
            NumericAxis(
              name: 'weightAxis',
              title: const AxisTitle(text: 'Weight in KG'),
              majorGridLines: const MajorGridLines(width: 0.5),
              numberFormat: NumberFormat.compact(),
              opposedPosition: false,
            ),
            NumericAxis(
              name: 'costAxis',
              title: const AxisTitle(text: 'Cost (Rs.)'),
              majorGridLines: const MajorGridLines(width: 0),
              numberFormat: NumberFormat.currency(locale: 'en_US', symbol: 'Rs.'),
              opposedPosition: true,
            ),
          ],
          legend: const Legend(isVisible: true, position: LegendPosition.bottom),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <CartesianSeries>[
            ColumnSeries<_ChartData, String>(
              name: 'Weight',
              dataSource: chartData,
              xValueMapper: (_ChartData data, _) => data.label,
              yValueMapper: (_ChartData data, _) => data.weight,
              yAxisName: 'weightAxis',
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              color: Colors.teal.withOpacity(0.8),
              width: 0.6,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            LineSeries<_ChartData, String>(
              name: 'Cost',
              dataSource: chartData,
              xValueMapper: (_ChartData data, _) => data.label,
              yValueMapper: (_ChartData data, _) => data.price,
              yAxisName: 'costAxis',
              markerSettings: const MarkerSettings(isVisible: true),
              color: Colors.amber[700],
              width: 3,
            )
          ],
        ),
      ),
    );
  }
}

/// A helper class to hold the data for each point in the chart.
class _ChartData {
  _ChartData(this.label, this.weight, this.price);
  final String label;
  final double weight;
  final double price;
}
