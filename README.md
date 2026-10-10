# 🏦 Finance Pro

> A production-ready, offline-first mobile app for micro-lenders and collection agents to digitize daily operations, manage loans, enforce legal agreements, and eliminate paper ledgers.

![Flutter](https://img.shields.io/badge/Flutter-%3E%3D3.0.0-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-%3E%3D3.0.0-0175C2?logo=dart&logoColor=white)
![Database](https://img.shields.io/badge/Database-SQLite-003B57?logo=sqlite&logoColor=white)
![Mode](https://img.shields.io/badge/Mode-100%25%20Offline-success)

---

## 📌 Overview

**Finance Pro** addresses the operational and legal challenges faced by small financial businesses, independent lenders, and field collection agents. Managing daily and weekly collection schedules, tracking overdue penalties, generating legally binding agreements, and migrating legacy paper records often lead to manual accounting errors.

This app provides a complete digital ledger system that runs **100% offline**, ensuring high performance, zero server dependency, and strict data privacy.

---

## ✨ Key Features

### ⚖️ Bilingual Legal Bond & Master Agreement (English & Telugu)
- **Official bilingual contracts:** Generates polished A4 Master Loan Agreements in English and Telugu, with professional typography powered by Google Fonts (`Noto Sans Telugu`).
- **Watermarked branding:** Subtle, high-resolution company logo watermark embedded beneath the document layer.
- **Strict financial terms:** Standardized terms including a 2% daily late penalty on overdue amounts, explicit field-collection consent, and guarantor obligations.
- **Signatures & legal consent:** Borrower agreement checkboxes, localized declaration statements, and signature blocks for the borrower and the authorized signatory.
- **Direct WhatsApp dispatch:** Share customer-specific agreement PDFs to the borrower's WhatsApp number with a single tap.

### 📊 Dashboard & Financial Analytics
- **Real-time KPIs:** Total disbursed capital, outstanding balances, expected daily targets, and overall recovery rate at a glance.
- **Interactive drill-down screens:** Tap metrics (e.g., *Outstanding*, *This Month Given*) to view customer-grouped loan breakdowns, disbursement dates, and live remaining balances.
- **Monthly disbursement trends:** Interactive bar charts showing monthly capital deployment across the year.

### 📅 Smart Collection Calendar
- **Unpaid-only indicators:** Visual markers highlight dates with active dues and clear automatically once collections are finalized.
- **Daily & weekly schedules:** Flexible collection frequencies tailored to each borrower's agreement.

### 💬 1-Click Consolidated WhatsApp Reminders
- **Multi-installment summaries:** Aggregates all pending and overdue installments for a borrower into a single, itemized WhatsApp message.
- **OS-level compatibility:** Direct intent routing bypasses Android 11+ package visibility restrictions (`canLaunchUrl` blocks).

### 📄 Automated PDF Generation & Printing
- **A4 loan summaries:** Statement breakdowns with repayment progress bars, customer profiles, and full payment histories.
- **A5 payment receipts:** Printable digital receipts generated immediately on collection confirmation.
- **Master bond papers:** Instant legal bond export tailored to each customer profile.

### 🔄 Legacy Paper Migration & Loan Overrides
- **Paper-to-digital migration:** A "Cleared Upto Date" calculator automatically computes completed historical cycles, with no manual counting.
- **Loan refinancing & overrides:** Close running loans and transfer remaining balances into new agreements, with net cash difference calculated automatically.

---

## 🛠️ Architecture & Tech Stack

| Layer | Technology |
|-------|------------|
| **Framework** | Flutter (Dart `>=3.0.0`) |
| **State management** | Provider (reactive UI pipeline) |
| **Local database** | `sqflite` (SQLite) with custom relational schemas, transactions, foreign keys, indexes, and cascade deletion |
| **PDF & typography** | `pdf`, `printing`, `google_fonts` for vector documents, watermarks, and Telugu font support |
| **Native interop** | `url_launcher` with `LaunchMode.externalApplication` for phone dialer, SMS, and WhatsApp |

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (`>=3.0.0`)
- Android Studio or VS Code with the Flutter and Dart extensions
- Java Development Kit (JDK 17 recommended)

### Installation

**1. Clone the repository**

```bash
git clone https://github.com/Sohan-2807/Finance_pro.git
cd Finance_pro
```

**2. Install dependencies**

```bash
flutter pub get
```

**3. Verify assets**

Make sure `assets/logo.png` and `assets/icon/app_logo.png` exist and are registered in `pubspec.yaml`:

```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/logo.png
    - assets/icon/app_logo.png
```

**4. Run the app**

```bash
flutter run
```

---

## 📁 Project Structure

```text
lib/
├── main.dart                   # App entry point & theme configuration
├── database_helper.dart        # SQLite schema, migrations, cascade queries
├── finance_provider.dart       # State management & business logic
├── customer_loan_modules.dart  # Data models (Customer, Loan, Installment, Payment)
├── dashboard_view.dart         # Analytics overview with interactive KPI cards
├── outstanding_screen.dart     # Customer-grouped outstanding balance audit
├── month_given_screen.dart     # Monthly capital disbursement breakdown
├── customers_view.dart         # Customer directory, profiles & loan history
├── collections_view.dart       # Due collection lists & payment processing
├── reports_view.dart           # Financial reports & ledger export
├── bond_pdf_service.dart       # Bilingual legal agreement generator with watermark
├── loan_pdf_service.dart       # Customer statements & payment receipts
└── navigation_shell.dart       # Bottom navigation bar & routing shell
```

---

## 👤 Author

**Sohan** — [@Sohan-2807](https://github.com/Sohan-2807)
