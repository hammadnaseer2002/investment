# Property Investment Calculator

Offline-first Flutter MVP for analyzing property buying, renting, financing,
holding and selling decisions. Built from the Requirements & Development
Plan (RDP) v1.0, September 2026.

## Getting started

This zip contains the `lib/`, `test/`, `assets/` folders, `pubspec.yaml` and
`analysis_options.yaml`. It is meant to be dropped into a project created
with:

```
flutter create --org com.infinitystack property_investment_calculator
```

Copy `lib/`, `test/`, `assets/`, `pubspec.yaml` and `analysis_options.yaml`
from this zip into that generated project (overwriting the default
`lib/main.dart` and `pubspec.yaml`), then:

```
flutter pub get
flutter run
```

## Architecture (RDP section 21)

```
Presentation (features/, widgets/)
        │
Domain / Calculation (core/calculation)   <-- pure, unit-tested formulas
        │
Data (core/models, core/storage)
        │
Services (core/services)                  <-- PDF, currency formatting
```

## Folder structure

```
lib/
├── main.dart                     # entry point, Hive init
├── app.dart                      # MaterialApp, theme, routes
├── core/
│   ├── theme/                    # AppColors, AppTheme
│   ├── constants/                # AppStrings, AppRoutes
│   ├── models/                   # Investment + sub-models (RDP 22)
│   ├── calculation/               # InvestmentCalculator - pure formulas (RDP 17)
│   ├── storage/                  # InvestmentRepository (Hive, offline-first)
│   ├── services/                 # PdfReportService, CurrencyFormatter
│   └── utils/                    # Validators
├── features/
│   ├── splash/
│   ├── onboarding/
│   ├── get_started/
│   ├── dashboard/
│   ├── new_investment/           # Property Details → Purchase Costs →
│   │                              # Financing → Rental Income → Expenses
│   ├── investment_analysis/
│   ├── final_report/
│   ├── my_investments/
│   ├── compare_properties/
│   ├── buy_vs_rent/
│   ├── sell_property/
│   ├── quick_calculators/
│   ├── ai_property_analyst/      # future module placeholder
│   └── settings/
└── widgets/                      # CurrencyInputField, PercentageInputField,
                                   # PrimaryButton, SectionCard, BottomNavShell
test/
└── calculation/
    └── investment_calculator_test.dart
```

## Notes

- All formulas live in `core/calculation/investment_calculator.dart` only -
  never inside UI widgets (RDP section 30).
- Screens currently hold local form state; wiring form values into
  `Investment` objects and persisting via `InvestmentRepository` is the next
  implementation step.
- MVP currency is PKR; `CurrencyFormatter` is structured to add USD/GBP/AED
  without touching the calculation layer (RDP section 19).
- Every projection screen should surface the disclaimer in
  `AppStrings.disclaimer`.
