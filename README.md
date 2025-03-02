# Charity App

A Flutter application for managing donations, built with **MVVM architecture** and **GraphQL** for efficient data handling. This project follows best practices to ensure maintainability, scalability, and clean code.

---

## 🚀 Features
- View donation statistics and analytics.
- Add new donations with categories.
- Dark mode support.
- Real-time data fetching from a GraphQL backend.
- Modular architecture using **MVVM**.

---

## 🏗️ Architecture Overview (MVVM)
This project is structured following the **Model-View-ViewModel (MVVM)** pattern with **Riverpod** for state management and **GraphQL** for API interactions.

```
lib/
 ├── core/
 │    ├── models/               # Data models (Charity, etc.)
 │    ├── services/             # External services (GraphQL, API clients, etc.)
 │    ├── theme/                # Theme and UI settings
 │
 ├── providers/                 # Global providers for state management
 │
 ├── repositories/              # Business logic and data handling
 │    ├── charity_repository.dart
 │
 ├── viewmodels/                # ViewModels (Handles state & business logic)
 │    ├── charity_stats_view_model.dart
 │
 ├── views/                     # Screens (Only UI logic)
 │    ├── charity_list_view.dart
 │
 ├── widgets/                   # Reusable UI components
 │    ├── add_donation_dialog.dart
 │    ├── analytics_tab.dart
 │    ├── donations_chart.dart
 │    ├── impact_metric.dart
 │    ├── metric_card.dart
 │    ├── overview_tab.dart
 │    ├── recent_donations_list.dart
 │
 ├── main.dart                   # App entry point
```

---

## 🛠️ Technologies Used
- **Flutter** (Framework for cross-platform development)
- **Dart** (Programming language)
- **Riverpod** (State management)
- **GraphQL** (Backend API communication)
- **fl_chart** (For graphical data visualization)
- **flutter_riverpod** (Dependency injection and state management)

---

## 📦 Installation & Setup
### Prerequisites
- Flutter installed ([Download Flutter](https://flutter.dev/docs/get-started/install))
- Dart SDK installed
- A GraphQL backend (Ensure the API is running)

### Steps
1. **Clone the repository**
```sh
  git clone https://github.com/your-username/charity-app.git
  cd charity-app
```

2. **Install dependencies**
```sh
  flutter pub get
```

3. **Run the app**
```sh
  flutter run
```

---

## 📌 Folder Breakdown
### **1️⃣ Models (`core/models/`)
- Defines data structures for donations and related objects.

### **2️⃣ Services (`core/services/`)
- Handles API calls (GraphQLService).

### **3️⃣ Repositories (`repositories/`)
- Bridges services and ViewModels, ensuring separation of concerns.

### **4️⃣ ViewModels (`viewmodels/`)
- Contains state management and business logic (MVVM layer).

### **5️⃣ Views (`views/`)
- UI screens, consuming data from ViewModels.

### **6️⃣ Widgets (`widgets/`)
- Reusable UI components like charts, lists, and cards.

---

## 🚀 API Integration (GraphQL)
The app communicates with a GraphQL backend via **GraphQLService**.

Example Query (Fetching donations):
```dart
const String query = '''
  query {
    donations {
      id
      donorName
      category
      amount
      month
    }
  }
''';
```

Example Mutation (Adding a donation):
```dart
const String mutation = '''
  mutation AddDonation(\$donorName: String!, \$category: String!, \$amount: Float!) {
    addDonation(donorName: \$donorName, category: \$category, amount: \$amount) {
      id
      donorName
      category
      amount
      month
    }
  }
''';
```

---

## 🔧 Customization & Scaling
- **Modular structure** allows for easy feature expansion.
- **GraphQL support** ensures dynamic and efficient data fetching.
- **MVVM + Riverpod** improves maintainability and state management.
- **Reusable widgets** allow for easy UI modifications.

---

## 📝 Contributing
Want to contribute? Follow these steps:
1. Fork the repository.
2. Create a new branch (`feature/new-feature`).
3. Commit your changes.
4. Push to your fork and submit a pull request!

---

## 🏆 Credits & Authors
Developed by **José Ángel Prieto**. Feel free to connect on GitHub! 🚀

---

## 📜 License
This project is licensed under the **MIT License**. You are free to use, modify, and distribute this code.

