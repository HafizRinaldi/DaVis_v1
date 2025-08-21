import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:davis/screens/correlation_screen.dart';
import 'package:davis/screens/data_cleaning.dart';
import 'package:davis/screens/main_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'dart:convert' show utf8;
import 'dart:io';
import 'dart:math';

import 'package:davis/screens/preview_screen.dart';
import 'package:davis/screens/visualization_screen.dart';
import 'package:davis/utils/colors.dart';
import 'package:davis/utils/language.dart';

void main() {
  runApp(const DataScienceApp());
}

class DataScienceApp extends StatefulWidget {
  const DataScienceApp({super.key});

  @override
  State<DataScienceApp> createState() => _DataScienceAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    _DataScienceAppState? state =
        context.findAncestorStateOfType<_DataScienceAppState>();
    state?.setLocale(newLocale);
  }
}

class _DataScienceAppState extends State<DataScienceApp> {
  Locale _locale = const Locale('en');

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Data Science App',
      debugShowCheckedModeBanner: false,
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('id', ''),
      ],
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        cardColor: AppColors.card,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: AppColors.text),
          titleLarge: TextStyle(
              color: AppColors.textTitle, fontWeight: FontWeight.bold),
          labelLarge: TextStyle(color: AppColors.textTitle),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textTitle,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.black26,
        ),
      ),
      home: const CsvUploaderScreen(),
    );
  }
}

class AnalysisScreen extends StatefulWidget {
  final List<String> headers;
  final List<List<dynamic>> data;
  final String fileName;

  const AnalysisScreen({
    super.key,
    required this.headers,
    required this.data,
    required this.fileName,
  });

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  late List<List<dynamic>> _currentData;

  @override
  void initState() {
    super.initState();
    _currentData = List<List<dynamic>>.from(
        widget.data.map((row) => List<dynamic>.from(row)));
  }

  void _updateData(List<List<dynamic>> newData) {
    setState(() {
      _currentData = newData;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Data telah diperbarui!"),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.fileName),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(
                  icon: const Icon(Icons.table_rows),
                  text: localizations.get('data_preview')),
              Tab(
                  icon: const Icon(Icons.bar_chart),
                  text: localizations.get('visualization')),
              Tab(
                  icon: const Icon(Icons.link),
                  text: localizations.get('correlation')),
              Tab(
                  icon: const Icon(Icons.cleaning_services),
                  text: localizations.get('data_cleaning')),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            DataPreviewTab(headers: widget.headers, data: _currentData),
            VisualizationTab(headers: widget.headers, data: _currentData),
            CorrelationTab(headers: widget.headers, data: _currentData),
            DataCleaningTab(
              headers: widget.headers,
              data: _currentData,
              onDataUpdated: _updateData,
            ),
          ],
        ),
      ),
    );
  }
}
