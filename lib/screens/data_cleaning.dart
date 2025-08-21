import 'package:flutter/material.dart';
import 'package:davis/utils/colors.dart';
import 'package:davis/utils/language.dart';

class DataCleaningTab extends StatelessWidget {
  final List<String> headers;
  final List<List<dynamic>> data;
  final Function(List<List<dynamic>>) onDataUpdated;

  const DataCleaningTab(
      {super.key,
      required this.headers,
      required this.data,
      required this.onDataUpdated});

  void _fillWithMean(int columnIndex) {
    final numericData = data
        .map((row) => row[columnIndex])
        .whereType<num>()
        .map((n) => n.toDouble())
        .toList();
    if (numericData.isEmpty) return;
    final mean = numericData.reduce((a, b) => a + b) / numericData.length;

    final newData =
        List<List<dynamic>>.from(data.map((row) => List<dynamic>.from(row)));
    for (var row in newData) {
      if (row[columnIndex] == null ||
          row[columnIndex].toString().trim().isEmpty) {
        row[columnIndex] = double.parse(mean.toStringAsFixed(2));
      }
    }
    onDataUpdated(newData);
  }

  void _fillWithMedian(int columnIndex) {
    final numericData = data
        .map((row) => row[columnIndex])
        .whereType<num>()
        .map((n) => n.toDouble())
        .toList();
    if (numericData.isEmpty) return;
    numericData.sort();
    final double median;
    if (numericData.length % 2 == 0) {
      median = (numericData[numericData.length ~/ 2 - 1] +
              numericData[numericData.length ~/ 2]) /
          2;
    } else {
      median = numericData[numericData.length ~/ 2];
    }

    final newData =
        List<List<dynamic>>.from(data.map((row) => List<dynamic>.from(row)));
    for (var row in newData) {
      if (row[columnIndex] == null ||
          row[columnIndex].toString().trim().isEmpty) {
        row[columnIndex] = median;
      }
    }
    onDataUpdated(newData);
  }

  void _fillWithMode(int columnIndex) {
    final columnData = data
        .map((row) => row[columnIndex])
        .where((cell) => cell != null && cell.toString().trim().isNotEmpty)
        .toList();
    if (columnData.isEmpty) return;
    final frequencyMap = <dynamic, int>{};
    for (var item in columnData) {
      frequencyMap[item] = (frequencyMap[item] ?? 0) + 1;
    }
    final mode =
        frequencyMap.entries.reduce((a, b) => a.value > b.value ? a : b).key;

    final newData =
        List<List<dynamic>>.from(data.map((row) => List<dynamic>.from(row)));
    for (var row in newData) {
      if (row[columnIndex] == null ||
          row[columnIndex].toString().trim().isEmpty) {
        row[columnIndex] = mode;
      }
    }
    onDataUpdated(newData);
  }

  void _fillWithCustomValue(int columnIndex, dynamic customValue) {
    final newData =
        List<List<dynamic>>.from(data.map((row) => List<dynamic>.from(row)));
    for (var row in newData) {
      if (row[columnIndex] == null ||
          row[columnIndex].toString().trim().isEmpty) {
        row[columnIndex] = customValue;
      }
    }
    onDataUpdated(newData);
  }

  void _transformRemoveChar(int columnIndex, String charToRemove) {
    final newData =
        List<List<dynamic>>.from(data.map((row) => List<dynamic>.from(row)));
    for (var row in newData) {
      if (row[columnIndex] != null) {
        final originalValue = row[columnIndex].toString();
        final newValueString = originalValue.replaceAll(charToRemove, '');
        final newValue = double.tryParse(newValueString);
        row[columnIndex] =
            newValue ?? newValueString; // Keep as string if not parsable
      }
    }
    onDataUpdated(newData);
  }

  void _transformMapValues(int columnIndex, Map<String, dynamic> mapping) {
    final newData =
        List<List<dynamic>>.from(data.map((row) => List<dynamic>.from(row)));
    for (var row in newData) {
      final originalValue = row[columnIndex]?.toString();
      if (mapping.containsKey(originalValue)) {
        row[columnIndex] = mapping[originalValue];
      }
    }
    onDataUpdated(newData);
  }

  void _showCustomFillDialog(BuildContext context, int columnIndex) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.card,
          title: Text(AppLocalizations.of(context).get('fill_custom_value'),
              style: TextStyle(color: AppColors.background)),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: '...'),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  AppLocalizations.of(context).get('BACK'),
                  style: TextStyle(color: AppColors.background),
                )),
            TextButton(
              onPressed: () {
                final value = double.tryParse(controller.text);
                if (value != null) {
                  _fillWithCustomValue(columnIndex, value);
                  Navigator.pop(context);
                }
              },
              child: Text(AppLocalizations.of(context).get('ok'),
                  style: TextStyle(color: AppColors.background)),
            ),
          ],
        );
      },
    );
  }

  void _showRemoveCharDialog(BuildContext context, int columnIndex) {
    final controller = TextEditingController();
    final columnData =
        data.map((row) => row[columnIndex]?.toString() ?? '').take(100);
    final specialChars = <String>{};
    final regex = RegExp(r'[^\w\s,]');
    for (var cell in columnData) {
      specialChars.addAll(regex.allMatches(cell).map((m) => m.group(0)!));
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.card,
          title: Text(
            AppLocalizations.of(context).get('remove_char'),
            style: TextStyle(color: AppColors.background),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (specialChars.isNotEmpty) ...[
                const Text('Karakter terdeteksi:'),
                Wrap(
                  spacing: 8,
                  children: specialChars
                      .map((char) => ElevatedButton(
                            child: Text(char),
                            onPressed: () {
                              _transformRemoveChar(columnIndex, char);
                              Navigator.pop(context);
                            },
                          ))
                      .toList(),
                ),
                const Divider(height: 20),
              ],
              TextField(
                controller: controller,
                decoration: const InputDecoration(hintText: '...'),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  AppLocalizations.of(context).get('BACK'),
                  style: TextStyle(color: AppColors.background),
                )),
            TextButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  _transformRemoveChar(columnIndex, controller.text);
                  Navigator.pop(context);
                }
              },
              child: Text(AppLocalizations.of(context).get('ok'),
                  style: TextStyle(color: AppColors.background)),
            ),
          ],
        );
      },
    );
  }

  void _showMappingDialog(BuildContext context, int columnIndex) {
    final columnData =
        data.map((row) => row[columnIndex]?.toString()).toSet().toList();
    final controllers = {for (var v in columnData) v: TextEditingController()};

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.card,
          title: Text(AppLocalizations.of(context).get('map_values'),
              style: TextStyle(color: AppColors.background)),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: columnData.map((value) {
                return ListTile(
                  title: Text(value ?? 'NULL'),
                  subtitle: TextField(
                    controller: controllers[value],
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: '...'),
                  ),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(AppLocalizations.of(context).get('BACK'),
                    style: TextStyle(color: AppColors.background))),
            TextButton(
              onPressed: () {
                final mapping = <String, dynamic>{};
                controllers.forEach((originalValue, controller) {
                  if (controller.text.isNotEmpty) {
                    final newValue = int.tryParse(controller.text);
                    if (newValue != null) {
                      mapping[originalValue ?? ''] = newValue;
                    }
                  }
                });
                if (mapping.isNotEmpty) {
                  _transformMapValues(columnIndex, mapping);
                }
                Navigator.pop(context);
              },
              child: Text(AppLocalizations.of(context).get('ok'),
                  style: TextStyle(color: AppColors.background)),
            ),
          ],
        );
      },
    );
  }

  void _showTransformationActions(BuildContext context, int columnIndex) {
    final localizations = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.edit_off),
              title: Text(localizations.get('remove_char')),
              onTap: () {
                Navigator.pop(context);
                _showRemoveCharDialog(context, columnIndex);
              },
            ),
            ListTile(
              leading: const Icon(Icons.find_replace),
              title: Text(localizations.get('map_values')),
              onTap: () {
                Navigator.pop(context);
                _showMappingDialog(context, columnIndex);
              },
            ),
          ],
        );
      },
    );
  }

  void _showFillActions(BuildContext context, int columnIndex, bool isNumeric) {
    final localizations = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.edit_note),
              title: Text(localizations.get('fill_custom_value')),
              onTap: () {
                Navigator.pop(context);
                _showCustomFillDialog(context, columnIndex);
              },
            ),
            ListTile(
              leading: const Icon(Icons.calculate),
              title: Text(localizations.get('fill_mode')),
              onTap: () {
                _fillWithMode(columnIndex);
                Navigator.pop(context);
              },
            ),
            if (isNumeric) ...[
              ListTile(
                leading: const Icon(Icons.functions),
                title: Text(localizations.get('fill_mean')),
                onTap: () {
                  _fillWithMean(columnIndex);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.align_vertical_center),
                title: Text(localizations.get('fill_median')),
                onTap: () {
                  _fillWithMedian(columnIndex);
                  Navigator.pop(context);
                },
              ),
            ],
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: headers.length,
      itemBuilder: (context, index) {
        final header = headers[index];
        final columnData = data.map((row) => row[index]).toList();
        final isNumeric = data.isNotEmpty &&
            data.firstWhere((row) => row[index] != null,
                orElse: () => [null])[index] is num;

        final missingCount = columnData
            .where((cell) => cell == null || cell.toString().trim().isEmpty)
            .length;
        final missingPercentage = (missingCount / data.length) * 100;

        List<dynamic> outliers = [];
        if (isNumeric) {
          final numericData =
              columnData.whereType<num>().map((n) => n.toDouble()).toList();
          numericData.sort();
          if (numericData.length > 4) {
            final q1 = numericData[(numericData.length * 0.25).floor()];
            final q3 = numericData[(numericData.length * 0.75).floor()];
            final iqr = q3 - q1;
            final lowerBound = q1 - 1.5 * iqr;
            final upperBound = q3 + 1.5 * iqr;
            outliers = columnData
                .where((d) => d is num && (d < lowerBound || d > upperBound))
                .toList();
          }
        }

        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: const BorderSide(
              color: AppColors.card,
              width: 3.0,
            ),
          ),
          color: Colors.white,
          margin: const EdgeInsets.symmetric(vertical: 6.0),
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(header, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 12),
                    Text(localizations.get('missing_data_percentage'),
                        style: TextStyle(color: AppColors.text.withOpacity(1))),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: missingPercentage / 100,
                      backgroundColor: Colors.grey.shade700,
                      color: missingPercentage > 20
                          ? Colors.orange
                          : AppColors.primary,
                    ),
                    const SizedBox(height: 4),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text('${missingPercentage.toStringAsFixed(2)}%'),
                    ),
                    if (outliers.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Text(localizations.get('outliers_found'),
                          style: TextStyle(
                              color: AppColors.text.withOpacity(0.8))),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 4.0,
                        children: outliers
                            .take(10)
                            .map((o) => Chip(
                                  label: Text(o.toString()),
                                  backgroundColor: AppColors.correlationNegative
                                      .withOpacity(0.5),
                                ))
                            .toList(),
                      ),
                    ],
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.transform),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.card,
                              foregroundColor: AppColors.background),
                          label: Text(
                            localizations.get('transform'),
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () =>
                              _showTransformationActions(context, index),
                        ),
                        const SizedBox(width: 8),
                        if (missingPercentage > 0)
                          ElevatedButton.icon(
                            icon: const Icon(Icons.auto_fix_high),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.card,
                                foregroundColor: AppColors.background),
                            label: Text(
                              localizations.get('handle_missing_values'),
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () =>
                                _showFillActions(context, index, isNumeric),
                          ),
                      ],
                    ),
                  ],
                ),
              )),
        );
      },
    );
  }
}
