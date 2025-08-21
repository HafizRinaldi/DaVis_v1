import 'dart:math';

import 'package:flutter/material.dart';
import 'package:davis/utils/colors.dart';
import 'package:davis/utils/language.dart';

class CorrelationTab extends StatelessWidget {
  final List<String> headers;
  final List<List<dynamic>> data;

  const CorrelationTab({super.key, required this.headers, required this.data});

  double _pearsonCorrelation(List<double> x, List<double> y) {
    if (x.length != y.length || x.isEmpty) return 0.0;

    int n = x.length;
    double sumX = x.reduce((a, b) => a + b);
    double sumY = y.reduce((a, b) => a + b);
    double sumXY = 0;
    for (int i = 0; i < n; i++) {
      sumXY += x[i] * y[i];
    }
    double sumX2 = x.map((e) => e * e).reduce((a, b) => a + b);
    double sumY2 = y.map((e) => e * e).reduce((a, b) => a + b);

    double numerator = n * sumXY - sumX * sumY;
    double denominator =
        sqrt((n * sumX2 - sumX * sumX) * (n * sumY2 - sumY * sumY));

    if (denominator == 0)
      return double.nan; // Return NaN if denominator is zero
    return numerator / denominator;
  }

  Color _getColorForValue(double value) {
    if (value.isNaN) return Colors.grey.shade700;
    final double opacity = value.abs();
    if (value > 0) {
      return AppColors.correlationPositive.withOpacity(opacity);
    } else {
      return AppColors.correlationNegative.withOpacity(opacity);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final numericIndices = <int>[];
    final numericHeaders = <String>[];
    for (int i = 0; i < headers.length; i++) {
      if (data.isNotEmpty &&
          data.firstWhere((row) => row[i] != null, orElse: () => [null])[i]
              is num) {
        numericIndices.add(i);
        numericHeaders.add(headers[i]);
      }
    }

    if (numericHeaders.isEmpty) {
      return Center(
          child: Text(localizations.get('no_numeric_columns'),
              style: TextStyle(color: AppColors.text)));
    }

    final numericData = <String, List<double>>{};
    for (int i = 0; i < numericHeaders.length; i++) {
      final header = numericHeaders[i];
      final index = numericIndices[i];
      numericData[header] =
          data.map((row) => (row[index] as num?)?.toDouble() ?? 0.0).toList();
    }

    final correlationMatrix = <String, Map<String, double>>{};
    for (var h1 in numericHeaders) {
      correlationMatrix[h1] = {};
      for (var h2 in numericHeaders) {
        final double correlation =
            _pearsonCorrelation(numericData[h1]!, numericData[h2]!);
        correlationMatrix[h1]![h2] = correlation;
      }
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: [
              const DataColumn(label: Text('')),
              ...numericHeaders.map((h) => DataColumn(
                  label: Text(h,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textTitle))))
            ],
            rows: numericHeaders.map((h1) {
              return DataRow(cells: [
                DataCell(Text(h1,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textTitle))),
                ...numericHeaders.map((h2) {
                  final value = correlationMatrix[h1]![h2]!;
                  return DataCell(
                    Container(
                      color: _getColorForValue(value),
                      alignment: Alignment.center,
                      child: Text(
                        value.isNaN ? "N/A" : value.toStringAsFixed(2),
                        style: const TextStyle(
                            color: AppColors.textTitle,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                }).toList()
              ]);
            }).toList(),
          ),
        ),
      ),
    );
  }
}
