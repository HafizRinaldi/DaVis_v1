import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:davis/main.dart';
import 'package:davis/utils/colors.dart';
import 'package:davis/utils/language.dart';

class CsvUploaderScreen extends StatefulWidget {
  const CsvUploaderScreen({super.key});

  @override
  State<CsvUploaderScreen> createState() => _CsvUploaderScreenState();
}

class _CsvUploaderScreenState extends State<CsvUploaderScreen> {
  bool _isLoading = false;

  Future<void> _pickAndParseCsv() async {
    setState(() => _isLoading = true);
    final localizations = AppLocalizations.of(context);

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result != null && result.files.single.path != null) {
        final path = result.files.single.path!;
        final file = File(path);
        final csvString = await file.readAsString(encoding: utf8);
        final List<List<dynamic>> csvTable =
            const CsvToListConverter(shouldParseNumbers: true, eol: '\n')
                .convert(csvString);

        if (csvTable.length > 1) {
          final headers = csvTable[0].map((e) => e.toString()).toList();
          final data = csvTable.sublist(1);
          final fileName = result.files.single.name;

          if (mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AnalysisScreen(
                  headers: headers,
                  data: data,
                  fileName: fileName,
                ),
              ),
            );
          }
        } else {
          _showErrorDialog(localizations.get('file_empty_error'));
        }
      }
    } catch (e) {
      _showErrorDialog("${localizations.get('file_processing_error')}$e");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).get('error')),
        content: Text(message),
        actions: [
          TextButton(
            child: Text(AppLocalizations.of(context).get('ok')),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.get('app_title')),
        centerTitle: true,
        actions: [
          PopupMenuButton<Locale>(
            onSelected: (Locale locale) {
              DataScienceApp.setLocale(context, locale);
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<Locale>>[
              const PopupMenuItem<Locale>(
                value: Locale('id'),
                child: Text('Indonesia'),
              ),
              const PopupMenuItem<Locale>(
                value: Locale('en'),
                child: Text('English'),
              ),
            ],
            icon: const Icon(Icons.language),
          ),
        ],
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/logo_davis.png', // Pastikan Anda membuat folder 'assets' dan memasukkan logo.png
                      height: 120,
                    ),
                    Icon(Icons.cloud_upload_outlined,
                        size: 80, color: AppColors.primary),
                    const SizedBox(height: 20),
                    Text(
                      localizations.get('upload_prompt'),
                      textAlign: TextAlign.center,
                      style:
                          const TextStyle(fontSize: 18, color: AppColors.text),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton.icon(
                      icon: const Icon(
                        Icons.attach_file,
                        color: Colors.white,
                      ),
                      label: Text(
                        localizations.get('select_file'),
                        style: const TextStyle(
                            fontSize: 18, color: AppColors.background),
                      ),
                      onPressed: _pickAndParseCsv,
                    ),
                    const SizedBox(height: 40),
                    _buildFeatureExplanation(
                      context,
                      icon: Icons.table_rows,
                      title: localizations.get('feature_1_title'),
                      description: localizations.get('feature_1_desc'),
                    ),
                    _buildFeatureExplanation(
                      context,
                      icon: Icons.pie_chart,
                      title: localizations.get('feature_2_title'),
                      description: localizations.get('feature_2_desc'),
                    ),
                    _buildFeatureExplanation(
                      context,
                      icon: Icons.link,
                      title: localizations.get('feature_3_title'),
                      description: localizations.get('feature_3_desc'),
                    ),
                    _buildFeatureExplanation(
                      context,
                      icon: Icons.cleaning_services,
                      title: localizations.get('feature_4_title'),
                      description: localizations.get('feature_4_desc'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildFeatureExplanation(BuildContext context,
      {required IconData icon,
      required String title,
      required String description}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 30),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textTitle,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(description,
                    style: const TextStyle(color: AppColors.text)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
