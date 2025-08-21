import 'package:flutter/material.dart';
import 'package:davis/utils/colors.dart';
import 'package:davis/utils/language.dart';

class DataPreviewTab extends StatelessWidget {
  final List<String> headers;
  final List<List<dynamic>> data;

  const DataPreviewTab({super.key, required this.headers, required this.data});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: AppColors.background,
            shape: RoundedRectangleBorder(
              //borderRadius: BorderRadius.circular(12.0),
              side: const BorderSide(
                color: AppColors.card,
                width: 3.0,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(localizations.get('dataset_info'),
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 10),
                  Text('${localizations.get('rows')}: ${data.length}'),
                  Text('${localizations.get('columns')}: ${headers.length}'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
              child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.card, // Color of the border
                width: 3, // Thickness of the border
              ),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  border: TableBorder(
                    horizontalInside: BorderSide(
                      color: Colors.green,
                      width: 3.0,
                    ),
                    verticalInside: BorderSide(
                      color: Colors.green,
                      width: 3.0,
                    ),
                  ),
                  columns: headers
                      .map((h) => DataColumn(
                          label: Text(h,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textTitle))))
                      .toList(),
                  rows: data
                      .take(100)
                      .map((row) => DataRow(
                          cells: row
                              .map((cell) => DataCell(Text(cell.toString())))
                              .toList()))
                      .toList(),
                ),
              ),
            ),
          )),
        ],
      ),
    );
  }
}
