# InvoiceFlow - Mobile (Flutter)

A premium, cross-platform mobile application built with **Flutter** for managing invoices and customers. Part of the **InvoiceFlow** ecosystem, this app brings professional business tools to your fingertips with a modern, high-performance experience.

## Features

- **Dynamic Dashboard**: View business health, real-time revenue collection, and system metrics.
- **Invoice Tracking**: 
  - Manage the full lifecycle of invoices with CRUD support.
  - Quick-filter actions (Paid, Pending, Overdue, Draft).
  - "Latest Addition" sorting with Newest/Oldest toggle.
  - High-performance search by reference, customer name, or ID.
- **Customer CRM**: 
  - Centralized customer profiles with one-tap details.
  - Smart Navigation: Filter invoices by customer name or ID with one-tap shortcuts from any screen.
  - Detailed client-specific revenue and activity logs.
- **Modern Premium UI/UX**: 
  - Dark mode design with glassmorphism and smooth animations.
  - Optimized layouts with robust overflow handling for varied mobile screen widths.
- **Error Resilient**: Robust API error handling with built-in retry mechanisms and user-friendly SnackBar messaging.

## Technology Stack

- **Framework**: [Flutter](https://flutter.dev/) (latest stable version)
- **Language**: [Dart](https://dart.dev/)
- **State Management**: [Provider](https://pub.dev/packages/provider)
- **Networking**: [Http](https://pub.dev/packages/http)
- **Theming**: Custom Dark Theme with Inter via Google Fonts.
- **Localization**: Intl (Currency and Date formatting).

## Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- A running instance of the [InvoiceFlow Backend](https://github.com/Success1050/invoice-backend).

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

### Running the Project

1. **Configure API Endpoint**: Update `lib/services/api_service.dart` with your machine's local IP address.
   ```dart
   static const String baseUrl = 'http://YOUR_LOCAL_IP:3000';
   ```

2. **Run the application**:
   ```bash
   flutter run
   ```

## Related Repositories
- **Backend (NestJS)**: [invoice-backend](https://github.com/Success1050/invoice-backend)
- **Web Frontend (Next.js)**: [invoice-frontend](https://github.com/Success1050/invoice-frontend)

---
*Developed by Emmanuel Success as part of the Full-Stack Developer Assessment.*
