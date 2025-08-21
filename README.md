# Flutter CSV Data Analyzer 📊

Welcome to the Flutter CSV Data Analyzer, a powerful and intuitive mobile application built with Flutter for quick and easy initial data analysis directly from your device. This app is designed for data analysts, students, and anyone interested in gaining insights from CSV datasets on the go.

Upload a CSV file and instantly get insights through data previews, dynamic visualizations, correlation matrices, and a suite of advanced data cleaning tools.

## 🎯 **Project Vision**

In a world driven by data, the ability to perform quick analysis is crucial. Traditional data analysis tools are often desktop-bound, creating a gap for professionals and enthusiasts who need to work on the move. This application bridges that gap by providing a comprehensive suite of analysis tools in a mobile-first package. Our goal is to empower users to explore, clean, and visualize their data anytime, anywhere.

## ✨ **Key Features**

This application is packed with features to make preliminary data analysis seamless and efficient.

| Feature | Description |
| :--- | :--- |
| 📂 **CSV Upload & Preview** | Easily upload CSV files from your device's local storage. The app's robust parser intelligently handles various delimiters and automatically converts data into a structured format. Get an instant preview of your dataset in a scrollable table, along with essential metadata like row and column counts. |
| 📈 **Dynamic Visualization** | Generate insightful charts automatically based on your data types. Choose between **Bar Charts** and **Pie Charts** for categorical data distribution, and **Scatter Plots** to investigate relationships between two numerical variables. |
| 🎨 **Chart Customization** | Take full control of your charts. Interactively customize colors with a built-in color picker or a randomizer. Fine-tune your view by setting custom axis ranges (Maximum Y/X) and defining grid intervals to zoom in on specific areas of your data. |
| 🔗 **Correlation Matrix** | Instantly discover potential linear relationships between all numeric columns in your dataset. The matrix is automatically generated and color-coded (green for positive, red for negative correlation) to provide a quick, interpretable overview of how variables interact. |
| 🧹 **Advanced Data Cleaning** | A powerful suite of tools to prepare your data for analysis. Handle missing or null values by filling them with calculated metrics like the **mean**, **median**, **mode**, or a specific **custom value** you provide. |
| 🔄 **Data Transformation** | Clean and preprocess your data with advanced tools. The **Remove Character** function intelligently detects non-alphanumeric symbols (e.g., '$', '%', '#') in your data and offers them as one-click removal options. The **Map Values** feature allows you to encode categorical data (e.g., "Male"/"Female") into numerical formats (e.g., 1/0), a critical step for many machine learning models. |
| 🌐 **Multi-Language Support** | The app is fully internationalized. Users can switch between **English** and **Indonesian** on the fly to use the app in their preferred language, with all UI elements and text dynamically updating. |

## 📸 **Screenshots**

| | |
|:---:|:---:|
| *Main Screen & Feature Explanations* | *Visualization Tab with Legend* |
|  |  |
| *Correlation Matrix Example* | *Smart Data Cleaning Menu* |
|  |  |

## 🛠️ **Technology Stack**

This project is built using a modern and robust tech stack:

* **Framework**: [Flutter](https://flutter.dev/)
* **Language**: [Dart](https://dart.dev/)
* **Key Packages**:
    * `file_picker`: For native file selection.
    * `csv`: For robust CSV parsing.
    * `fl_chart`: For creating beautiful and interactive charts.
    * `flutter_localizations`: For internationalization and multi-language support.

## 🚀 **Getting Started**

Follow these instructions to get the project up and running on your local machine for development and testing purposes.

### **Prerequisites**

* **Flutter SDK**: Make sure you have the Flutter SDK installed. For installation guides, see the [official Flutter documentation](https://flutter.dev/docs/get-started/install).
* **Code Editor**: An editor like VS Code or Android Studio is recommended.

### **Installation & Setup**

1.  **Clone this repository:**
    ```sh
    git clone https://github.com/HafizRinaldi/DaVis_v1.git
    ```

2.  **Navigate to the project directory:**
    ```sh
    cd davis_v1
    ```

3.  **Install dependencies:**
    Ensure you have the following dependencies in your `pubspec.yaml` file:
    ```yaml
    dependencies:
      flutter:
        sdk: flutter
      flutter_localizations:
        sdk: flutter
      file_picker: ^6.2.1
      csv: ^6.0.0
      fl_chart: ^0.68.0
    ```
    Then, run the command from your terminal:
    ```sh
    flutter pub get
    ```

4.  **Run the application:**
    ```sh
    flutter run
    ```

## 🔧 **Customization**

The application is designed to be easily customizable.

* **Colors**: To change the application's color scheme, simply modify the static color variables in the `lib/utils/colors/colors.dart` file. All UI components reference these variables, ensuring consistent changes across the app.
* **Language**: To add more languages or change existing text, edit the `_localizedValues` map located in the `lib/utils/language.dart` file. Add a new language code entry and provide the translated strings.

## 🤝 **Contributing**

Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".

1.  **Fork the Project**
2.  **Create your Feature Branch** (`git checkout -b feature/AmazingFeature`)
3.  **Commit your Changes** (`git commit -m 'Add some AmazingFeature'`)
4.  **Push to the Branch** (`git push origin feature/AmazingFeature`)
5.  **Open a Pull Request**

## 🛣️ **Roadmap & Future Development**

This application is currently in active development. We have an exciting roadmap of features planned for future updates:

* **Export Cleaned CSV**: Functionality to save the cleaned and transformed dataset as a new CSV file directly to your device.
* **Download Charts**: An option to save the generated visualizations (Bar, Pie, Scatter plots) as high-quality images (e.g., PNG).
* **More Chart Types**: Introduction of additional chart types, such as Line Charts for time-series data and Box Plots for statistical distribution.
* **Advanced Statistics**: A dedicated tab for more advanced statistical summaries, including mean, median, standard deviation, and variance for each numeric column.

Have an idea for a new feature? Feel free to open an issue to discuss it!

## 📜 **License**

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.


