import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:davis/utils/colors.dart';
import 'package:davis/utils/language.dart';

enum ChartType { bar, pie, scatter }

class VisualizationTab extends StatefulWidget {
  final List<String> headers;
  final List<List<dynamic>> data;

  const VisualizationTab(
      {super.key, required this.headers, required this.data});

  @override
  State<VisualizationTab> createState() => _VisualizationTabState();
}

class _VisualizationTabState extends State<VisualizationTab> {
  String? _selectedColumn1;
  String? _selectedColumn2;
  Widget _chart = const SizedBox.shrink();
  ChartType _chartType = ChartType.bar;

  final TextEditingController _maxXController = TextEditingController();
  final TextEditingController _maxYController = TextEditingController();
  final TextEditingController _intervalXController = TextEditingController();
  final TextEditingController _intervalYController = TextEditingController();

  Color _chartColor = Colors.blue;
  List<Color> _pieColors = [];
  Map<String, int> _chartData = {};

  bool _isNumeric(dynamic s) {
    if (s == null) return false;
    return double.tryParse(s.toString()) != null;
  }

  void _generateChart() {
    if (_selectedColumn1 == null) return;

    final double? maxX = double.tryParse(_maxXController.text);
    final double? maxY = double.tryParse(_maxYController.text);
    final double? intervalX = double.tryParse(_intervalXController.text);
    final double? intervalY = double.tryParse(_intervalYController.text);

    final int index1 = widget.headers.indexOf(_selectedColumn1!);

    if (_selectedColumn2 != null) {
      _chartType = ChartType.scatter;
      final int index2 = widget.headers.indexOf(_selectedColumn2!);

      if (widget.data.isNotEmpty &&
          _isNumeric(widget.data[0][index1]) &&
          _isNumeric(widget.data[0][index2])) {
        final spots = <ScatterSpot>[];
        for (int i = 0; i < widget.data.length; i++) {
          final val1 = double.tryParse(widget.data[i][index1].toString());
          final val2 = double.tryParse(widget.data[i][index2].toString());
          if (val1 != null && val2 != null) {
            spots.add(ScatterSpot(val1, val2));
          }
        }
        if (spots.isNotEmpty) {
          setState(() {
            _chartData = {};
            _chart = _buildScatterChart(spots,
                maxX: maxX,
                maxY: maxY,
                intervalX: intervalX,
                intervalY: intervalY);
          });
        } else {
          _showError(AppLocalizations.of(context).get('error'));
        }
      } else {
        _showError(AppLocalizations.of(context).get('error'));
      }
    } else {
      if (widget.data.isNotEmpty && !_isNumeric(widget.data[0][index1])) {
        Map<String, int> counts = {};
        for (var row in widget.data) {
          final item = row[index1].toString();
          counts[item] = (counts[item] ?? 0) + 1;
        }

        _generatePieColors(counts.length);
        setState(() {
          _chartData = counts;
          if (_chartType == ChartType.bar) {
            _chart = _buildBarChart(counts, maxY: maxY, intervalY: intervalY);
          } else if (_chartType == ChartType.pie) {
            _chart = _buildPieChart(counts);
          }
        });
      } else {
        _showError(AppLocalizations.of(context).get('error'));
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.redAccent));
  }

  void _generatePieColors(int count) {
    final random = Random();
    _pieColors = List.generate(
        count,
        (_) => Color.fromARGB(255, random.nextInt(256), random.nextInt(256),
            random.nextInt(256)));
  }

  Widget _buildScatterChart(List<ScatterSpot> spots,
      {double? maxX, double? maxY, double? intervalX, double? intervalY}) {
    final double minX = spots.map((s) => s.x).reduce(min);
    final double autoMaxX = spots.map((s) => s.x).reduce(max);
    final double minY = spots.map((s) => s.y).reduce(min);
    final double autoMaxY = spots.map((s) => s.y).reduce(max);

    return ScatterChart(
      ScatterChartData(
        scatterSpots: spots
            .map((s) => ScatterSpot(s.x, s.y, color: _chartColor))
            .toList(),
        minX: minX,
        maxX: maxX ?? autoMaxX,
        minY: minY,
        maxY: maxY ?? autoMaxY,
        gridData: FlGridData(
          show: true,
          getDrawingHorizontalLine: (value) =>
              FlLine(color: Colors.white24, strokeWidth: 0.5),
          getDrawingVerticalLine: (value) =>
              FlLine(color: Colors.white24, strokeWidth: 0.5),
          horizontalInterval: intervalY,
          verticalInterval: intervalX,
        ),
        borderData:
            FlBorderData(show: true, border: Border.all(color: Colors.white38)),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
              sideTitles: SideTitles(
                  showTitles: true, reservedSize: 40, interval: intervalY)),
          bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                  showTitles: true, reservedSize: 30, interval: intervalX)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
      ),
    );
  }

  Widget _buildBarChart(Map<String, int> data,
      {double? maxY, double? intervalY}) {
    final List<BarChartGroupData> barGroups = [];
    int i = 0;
    data.forEach((key, value) {
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
                toY: value.toDouble(),
                color: _pieColors[i % _pieColors.length],
                width: 22,
                borderRadius: BorderRadius.zero)
          ],
        ),
      );
      i++;
    });

    final double autoMaxY =
        data.values.isEmpty ? 10 : data.values.reduce(max).toDouble();
    final double chartWidth = data.length * 60.0;

    return SizedBox(
      width: chartWidth,
      child: BarChart(
        BarChartData(
          barGroups: barGroups,
          maxY: maxY ?? autoMaxY * 1.2,
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < data.keys.length) {
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      angle: -pi / 4,
                      space: 8.0,
                      child: Text(
                        data.keys.elementAt(index),
                        style: const TextStyle(fontSize: 10),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }
                  return const Text('');
                },
                reservedSize: 42,
              ),
            ),
            leftTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true, reservedSize: 40, interval: intervalY)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: intervalY),
        ),
      ),
    );
  }

  Widget _buildPieChart(Map<String, int> data) {
    final total = data.values.fold(0, (sum, item) => sum + item);
    final List<PieChartSectionData> sections = [];
    int i = 0;
    data.forEach((key, value) {
      final percentage = (value / total * 100);
      sections.add(PieChartSectionData(
        color: _pieColors[i % _pieColors.length],
        value: value.toDouble(),
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 100,
        titleStyle: const TextStyle(
            fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
      ));
      i++;
    });

    return PieChart(PieChartData(sections: sections, centerSpaceRadius: 40));
  }

  void _showColorPicker() {
    final List<Color> colors = [
      Colors.blue,
      Colors.green,
      Colors.red,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.amber
    ];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        title: Text(AppLocalizations.of(context).get('pick_color'),
            style: TextStyle(color: AppColors.background)),
        content: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: colors
              .map((color) => GestureDetector(
                    onTap: () {
                      setState(() => _chartColor = color);
                      Navigator.of(context).pop();
                      _generateChart();
                    },
                    child: CircleAvatar(backgroundColor: color, radius: 20),
                  ))
              .toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildDropdown(localizations.get('select_column_1'), _selectedColumn1,
              (val) {
            setState(() {
              _selectedColumn1 = val;
              _selectedColumn2 = null;
              _chart = const SizedBox.shrink();
              _chartData = {};
            });
          }),
          if (_selectedColumn1 != null) const SizedBox(height: 12),
          if (_selectedColumn1 != null &&
              _isNumeric(
                  widget.data[0][widget.headers.indexOf(_selectedColumn1!)]))
            _buildDropdown(
                localizations.get('select_column_2'), _selectedColumn2, (val) {
              setState(() {
                _selectedColumn2 = val;
                _chart = const SizedBox.shrink();
                _chartData = {};
              });
            }),
          if (_selectedColumn1 != null &&
              !_isNumeric(
                  widget.data[0][widget.headers.indexOf(_selectedColumn1!)]))
            DropdownButtonFormField<ChartType>(
              dropdownColor: AppColors.card,
              value: _chartType,
              items: [
                DropdownMenuItem(
                    value: ChartType.bar,
                    child: Text(
                      localizations.get('bar_chart'),
                      style: TextStyle(color: AppColors.text),
                    )),
                DropdownMenuItem(
                    value: ChartType.pie,
                    child: Text(
                      localizations.get('pie_chart'),
                      style: TextStyle(color: AppColors.text),
                    )),
              ],
              onChanged: (val) => setState(() {
                _chartType = val!;
                _chartData = {};
              }),
              iconEnabledColor: Colors.green,
              decoration: InputDecoration(
                labelText: localizations.get('chart_type'),
                labelStyle: const TextStyle(
                  color: AppColors.textTitle,
                ),
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(
                    color: Colors.green,
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(
                    color: Colors.green,
                    width: 2.0,
                  ),
                ),
              ),
            ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _generateChart,
            child: Text(
              localizations.get('create_chart'),
              style: TextStyle(color: AppColors.background),
            ),
          ),
          const SizedBox(height: 10),
          if (_chart is! SizedBox) _buildChartControls(),
          const SizedBox(height: 20),
          Container(
            height: 400,
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Card(
              color: AppColors.background,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _chartType == ChartType.bar
                    ? SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: _chart,
                      )
                    : Center(child: _chart),
              ),
            ),
          ),
          if (_chartData.isNotEmpty)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: _buildLegend(),
            )
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Card(
      color: AppColors.background,
      margin: const EdgeInsets.only(top: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _chartData.entries.toList().asMap().entries.map((entry) {
            int index = entry.key;
            String category = entry.value.key;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    color: _pieColors[index % _pieColors.length],
                  ),
                  const SizedBox(width: 8),
                  Text(category),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildChartControls() {
    final localizations = AppLocalizations.of(context);
    bool isCategorical = _selectedColumn2 == null;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: const BorderSide(
          color: AppColors.card,
          width: 3.0,
        ),
      ),
      color: AppColors.card,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  localizations.get('chart_settings'),
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontSize: 16, color: AppColors.background),
                ),
                Row(
                  children: [
                    if (!isCategorical || _chartType == ChartType.bar)
                      IconButton(
                          icon: const Icon(Icons.color_lens),
                          tooltip: localizations.get('pick_color'),
                          onPressed: _showColorPicker),
                    if (!isCategorical || _chartType == ChartType.bar)
                      IconButton(
                          icon: const Icon(Icons.shuffle),
                          tooltip: localizations.get('random_color'),
                          onPressed: () {
                            setState(() => _chartColor = Color(
                                    (Random().nextDouble() * 0xFFFFFF).toInt())
                                .withOpacity(1.0));
                            _generateChart();
                          }),
                  ],
                )
              ],
            ),
            const SizedBox(height: 10),
            if (!isCategorical || _chartType == ChartType.bar) ...[
              Row(
                children: [
                  if (!isCategorical)
                    Expanded(
                        child: _buildTextField(
                            _maxXController, localizations.get('max_x'))),
                  if (!isCategorical) const SizedBox(width: 10),
                  Expanded(
                      child: _buildTextField(
                          _maxYController, localizations.get('max_y'))),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  if (!isCategorical)
                    Expanded(
                        child: _buildTextField(_intervalXController,
                            localizations.get('interval_x'))),
                  if (!isCategorical) const SizedBox(width: 10),
                  Expanded(
                      child: _buildTextField(_intervalYController,
                          localizations.get('interval_y'))),
                ],
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        isDense: true,
      ),
    );
  }

  Widget _buildDropdown(
      String hint, String? value, ValueChanged<String?> onChanged) {
    final items = widget.headers.where((h) {
      if (hint.contains("Kolom 2") && _selectedColumn1 != null) {
        return h != _selectedColumn1;
      }
      return true;
    }).toList();

    return DropdownButtonFormField<String>(
      style: const TextStyle(
        color: Colors.black,
        fontSize: 16,
      ),
      dropdownColor: AppColors.card,
      value: value,
      hint: Text(hint, style: const TextStyle(color: AppColors.text)),
      isExpanded: true,
      iconEnabledColor: Colors.green,
      items: items.map((String header) {
        return DropdownMenuItem<String>(
          value: header,
          child: Text(header),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.green, width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.green, width: 2.0),
        ),
      ),
    );
  }
}
