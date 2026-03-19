# InvoiceFlow Mobile 📱

A premium, cross-platform mobile application built with **Flutter** for managing invoices and customers. This app provides a seamless interface to track business finances, search through records, and manage your client base on the go.

## ✨ Features

- **Dashboard Overview**: Real-time business statistics, revenue collection tracking, and system health breakdown.
- **Invoice Management**: 
  - Full CRUD support (Create, Read, Update, Delete).
  - Status-based filtering (Paid, Pending, Overdue, Draft).
  - Search by reference, customer name, or ID.
- **Customer Database**:
  - Manage client profiles with contact details.
  - Detailed view showing customer-specific activity and total revenue.
- **Premium UI/UX**:
  - Modern Dark Mode design with vibrant gradients.
  - Fully responsive layout optimized for varied screen sizes.
  - Glassmorphism effects and smooth transitions.
- **Robust Error Handling**: Graceful API error handling with user-friendly retry mechanisms.

## 🛠️ Tech Stack

- **Core**: Flutter / Dart
- **State Management**: Provider
- **Networking**: Http
- **Theming**: Custom Dark Theme with Google Fonts (Inter)
- **Formatting**: Intl (Currency & Date)

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- A running instance of the **InvoiceFlow Backend** (NestJS)

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/Success1050/invoice-mobile.git
   cd invoice_app
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Configure API Endpoint**:
   Open `lib/services/api_service.dart` and update the `baseUrl` to your machine's local IP address:
   ```dart
   static const String baseUrl = 'http://YOUR_LOCAL_IP:5000';
   ```

4. **Run the application**:
   ```bash
   flutter run
   ```

## 📂 Project Structure

```
lib/
├── models/      # Data entities (Invoice, Customer)
├── providers/   # State management (DataProvider)
├── screens/     # Application pages (Dashboard, Details, etc.)
├── services/    # API communication (ApiService)
├── theme/       # Global styling and color palette
└── widgets/     # Reusable UI components
```

## 🔧 Backend Setup Tip

Ensure your NestJS backend is listening on all network interfaces (`0.0.0.0`) so that a physical device on your network can communicate with it.

---
*Created as part of the Full-Stack Developer Assessment.*
