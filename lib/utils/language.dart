import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const _localizedValues = <String, Map<String, String>>{
    'en': {
      'app_title': 'CSV Data Analyzer',
      'upload_prompt': 'Upload a CSV File to Start Analysis',
      'select_file': 'Select CSV File',
      'feature_1_title': 'Data Preview',
      'feature_1_desc':
          'View your raw data in a table format and get basic information like row and column counts.',
      'feature_2_title': 'Visualization',
      'feature_2_desc':
          'Automatically generate various charts like Bar, Pie, or Scatter plots to visualize your data.',
      'feature_3_title': 'Correlation',
      'feature_3_desc':
          'Instantly find relationships between numeric columns with a color-coded correlation matrix.',
      'feature_4_title': 'Data Cleaning',
      'feature_4_desc':
          'Identify and handle missing values, transform data, and prepare your dataset for analysis.',
      'error': 'Error',
      'ok': 'OK',
      'file_empty_error': 'CSV file is empty or contains only a header.',
      'file_processing_error': 'An error occurred while processing the file: ',
      'data_preview': 'Data Preview',
      'visualization': 'Visualization',
      'correlation': 'Correlation',
      'data_cleaning': 'Data Cleaning',
      'dataset_info': 'Dataset Information',
      'rows': 'Rows',
      'columns': 'Columns',
      'chart_settings': 'Chart Settings',
      'max_y': 'Max Y',
      'interval_y': 'Interval Y',
      'max_x': 'Max X',
      'interval_x': 'Interval X',
      'create_chart': 'Create/Update Chart',
      'pick_color': 'Pick Color',
      'random_color': 'Random Color',
      'chart_type': 'Chart Type',
      'bar_chart': 'Bar Chart',
      'pie_chart': 'Pie Chart',
      'select_column_1': 'Select Column 1 (X-Axis / Category)',
      'select_column_2': 'Select Column 2 (Y-Axis, Optional)',
      'no_numeric_columns': 'No numeric columns to analyze.',
      'missing_data_percentage': 'Missing Data Percentage:',
      'outliers_found': 'Potential Outliers Found:',
      'handle_missing_values': 'Handle Missing Values',
      'transform': 'Transform',
      'fill_custom_value': 'Fill with Custom Value...',
      'fill_mode': 'Fill with Mode (Most Frequent)',
      'fill_mean': 'Fill with Mean (Average)',
      'fill_median': 'Fill with Median (Middle Value)',
      'remove_char': 'Remove Character...',
      'map_values': 'Map Values to Number...',
    },
    'id': {
      'app_title': 'Penganalisis Data CSV',
      'upload_prompt': 'Unggah File CSV untuk Memulai Analisis',
      'select_file': 'Pilih File CSV',
      'feature_1_title': 'Pratinjau Data',
      'feature_1_desc':
          'Lihat data mentah Anda dalam format tabel dan dapatkan info dasar seperti jumlah baris dan kolom.',
      'feature_2_title': 'Visualisasi',
      'feature_2_desc':
          'Buat berbagai grafik secara otomatis seperti Bar, Pie, atau Scatter plot untuk memvisualisasikan data Anda.',
      'feature_3_title': 'Korelasi',
      'feature_3_desc':
          'Temukan hubungan antar kolom numerik secara instan dengan matriks korelasi berkode warna.',
      'feature_4_title': 'Pembersihan Data',
      'feature_4_desc':
          'Identifikasi dan tangani nilai yang hilang, transformasi data, dan siapkan dataset Anda untuk analisis.',
      'error': 'Kesalahan',
      'ok': 'OK',
      'file_empty_error': 'File CSV kosong atau hanya berisi header.',
      'file_processing_error': 'Terjadi kesalahan saat memproses file: ',
      'data_preview': 'Pratinjau Data',
      'visualization': 'Visualisasi',
      'correlation': 'Korelasi',
      'data_cleaning': 'Pembersihan Data',
      'dataset_info': 'Informasi Dataset',
      'rows': 'Baris',
      'columns': 'Kolom',
      'chart_settings': 'Pengaturan Grafik',
      'max_y': 'Maks Y',
      'interval_y': 'Interval Y',
      'max_x': 'Maks X',
      'interval_x': 'Interval X',
      'create_chart': 'Buat/Perbarui Grafik',
      'pick_color': 'Pilih Warna',
      'random_color': 'Warna Acak',
      'chart_type': 'Tipe Grafik',
      'bar_chart': 'Grafik Batang',
      'pie_chart': 'Grafik Lingkaran',
      'select_column_1': 'Pilih Kolom 1 (Sumbu X / Kategori)',
      'select_column_2': 'Pilih Kolom 2 (Sumbu Y, Opsional)',
      'no_numeric_columns': 'Tidak ada kolom numerik untuk dianalisis.',
      'missing_data_percentage': 'Persentase Data Kosong:',
      'outliers_found': 'Potensi Outlier Ditemukan:',
      'handle_missing_values': 'Tangani Nilai Kosong',
      'transform': 'Transformasi',
      'fill_custom_value': 'Isi dengan Nilai Kustom...',
      'fill_mode': 'Isi dengan Modus (Paling Sering Muncul)',
      'fill_mean': 'Isi dengan Mean (Rata-rata)',
      'fill_median': 'Isi dengan Median (Nilai Tengah)',
      'remove_char': 'Hapus Karakter...',
      'map_values': 'Petakan Nilai ke Angka...',
    },
  };

  String get(String key) {
    return _localizedValues[locale.languageCode]![key] ?? key;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'id'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async =>
      AppLocalizations(locale);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
