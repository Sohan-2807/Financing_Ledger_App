```markdown
# 🏦 Finance Pro

> A production-ready, offline-first mobile application built for micro-lenders and collection agents to digitize daily operations, manage loans, enforce legal agreements, and eliminate paper ledgers.

---

## 📌 Overview

**Finance Pro** addresses the operational and legal challenges faced by small financial businesses, independent lenders, and field collection agents. Managing daily and weekly collection schedules, tracking overdue penalties, generating legally binding agreements, and migrating legacy paper records often lead to manual accounting errors.

This app provides a complete digital ledger system that runs **100% offline**, ensuring high performance, zero server dependency, and strict data privacy.

---

## ✨ Key Features

### ⚖️ Bilingual Legal Bond & Master Agreement (English & Telugu)
- **Official Bilingual Contracts:** Generates polished A4 Master Loan Agreements in both English and Telugu with clean, professional typography powered by Google Fonts (`Noto Sans Telugu`).
- **Watermarked Branding:** Features a subtle, high-resolution company logo watermark embedded beneath the document layer.
- **Strict Financial Terms:** Enforces standardized terms, including a 2% daily late penalty on overdue amounts, explicit field-collection consent, and guarantor obligations.
- **Signatures & Legal Consent:** Includes borrower agreement checkboxes, localized declaration statements, and designated signature blocks for both the borrower and authorized signatory.
- **Direct WhatsApp Dispatch:** Generates and shares customer-specific agreement PDFs directly to borrower WhatsApp numbers with a single tap.

### 📊 Dashboard & Financial Analytics
- **Real-Time KPIs:** Monitor total disbursed capital, outstanding balances, expected daily targets, and overall recovery rates at a glance.
- **Interactive Drill-Down Screens:** Tap on dashboard metrics (like Outstanding or This Month Given) to inspect detailed, customer-grouped loan breakdowns, disbursement dates, and live remaining balances.
- **Monthly Disbursement Trends:** Interactive visual bar charts tracking monthly capital deployment across the calendar year.

### 📅 Smart Collection Calendar
- **Unpaid-Only Calendar Indicators:** Dynamic visual markers highlight dates with active dues. Indicators automatically clear as collections are finalized.
- **Daily & Weekly Schedules:** Full support for flexible collection frequencies tailored to individual borrower agreements.

### 💬 1-Click Consolidated WhatsApp Reminders
- **Multi-Installment Summaries:** Automatically aggregates all pending and overdue installments for a specific borrower into a single, itemized WhatsApp message.
- **OS-Level Compatibility:** Built-in direct intent routing to bypass Android 11+ package visibility restrictions (`canLaunchUrl` blocks).

### 📄 Automated PDF Generation & Printing
- **A4 Loan Summaries:** Comprehensive statement breakdowns including repayment progress bars, customer profiles, and complete payment histories.
- **A5 Payment Receipts:** On-the-spot printable digital receipts generated immediately upon collection confirmation.
- **Master Bond Papers:** Instant legal bond export tailored to customer profiles.

### 🔄 Legacy Paper Migration & Loan Overrides
- **Paper-to-Digital Migration:** Features a "Cleared Upto Date" calculator that automatically computes completed historical cycles without manual counting.
- **Loan Refinancing & Overrides:** Seamlessly close existing running loans and transfer remaining balances into new agreements while auto-calculating net cash differences.

---

## 🛠️ Architecture & Tech Stack

- **Framework:** Flutter (Dart `>=3.0.0`)
- **Architecture Pattern:** Provider State Management (Reactive UI pipeline)
- **Local Database:** `sqflite` (SQLite) with custom relational schemas, transactional integrity, foreign keys, indexes, and cascade deletion.
- **PDF & Typography:** `pdf`, `printing`, and `google_fonts` for vector document generation, watermark rendering, and Telugu font support.
- **Native Interoperability:** `url_launcher` utilizing direct intent modes (`LaunchMode.externalApplication`) for external phone dialer, SMS, and WhatsApp dispatch.

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (`>=3.0.0`)
- Android Studio or VS Code with Flutter and Dart extensions installed.
- Java Development Kit (JDK 17 recommended).

### Installation

1. **Clone the repository:**
   ```bash
   git clone [https://github.com/Sohan-2807/Finance_pro.git](https://github.com/Sohan-2807/Finance_pro.git)
   cd Finance_pro

```

2. **Install dependencies:**
```bash
flutter pub get

```


3. **Verify assets:**
Ensure `assets/logo.png` and `assets/icon/app_logo.png` are present in the `assets/` directory and registered in `pubspec.yaml`:
```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/logo.png
    - assets/icon/app_logo.png

```


4. **Run the application:**
```bash
flutter run

```



---

## 📁 Project Structure

```text
lib/
├── main.dart                   # Application entry point & theme configuration
├── database_helper.dart        # SQLite schema, migrations, and cascade queries
├── finance_provider.dart       # State management & business logic layer
├── customer_loan_modules.dart  # Data models (Customer, Loan, Installment, Payment)
├── dashboard_view.dart         # Main analytics overview with interactive KPI cards
├── outstanding_screen.dart     # Customer-grouped outstanding balance audit screen
├── month_given_screen.dart     # Monthly capital disbursement breakdown screen
├── customers_view.dart         # Customer directory, profile view & loan history
├── collections_view.dart       # Due collection lists & payment processing
├── reports_view.dart           # Financial reports & ledger export
├── bond_pdf_service.dart       # Bilingual legal agreement generator with watermark
├── loan_pdf_service.dart       # Customer statements & payment receipt generator
└── navigation_shell.dart       # Bottom navigation bar & routing shell

```

```

```
