# V&V Order Portal

Internal B2B ordering portal for **V&V wholesale supplies** — a prototype validating the workflow before migrating to Odoo Community on Alibaba Cloud.

## What it does

Replaces manual PDF-over-Viber order capture with a self-service web portal where:

- **Customer branches** browse a catalog (700+ SKUs), build a cart, and submit orders
- **A customer-side approver** (Eisha) reviews every branch order in a consolidated dashboard before it reaches V&V
- **V&V admin** drives orders through fulfillment (Submitted → Confirmed → Procuring → Out for Delivery → Delivered → Paid), prints consolidated procurement lists grouped by supplier, validates deposit slips, and tracks A/R

## Key features

- Product catalog with photos, categories, search, brand/variant
- Cart, checkout with delivery or pickup option
- Customer-side approval workflow (multi-company super approver)
- V&V admin dashboard with stats, procurement list (supplier-grouped, printable), A/R aging
- Order lifecycle with status dropdown control
- **Order splitting** for partial deliveries with independent billing
- **Deposit slip upload + validation** (Eisha uploads proof, Admin validates after bank confirms)
- **Customer signup form** with admin approval workflow
- **Product request** with required photo — customers request items not in catalog
- **Catalog CRUD** with bulk edit (activate/deactivate, bulk set supplier/category, bulk price adjustments)
- **Analytics** tab — monthly revenue, by-customer/branch, fast-moving SKUs
- **Manual order entry** for offline/historical deliveries
- **Historical data import** — 236 sales from the legacy `Sales Tracker 2025.xlsx` imported automatically
- CSV export for accounting handoff

## Tech

- **Frontend only** — single static HTML file + JSON data files
- **No backend** — orders persist in browser `localStorage` (demo limitation; Odoo will replace this)
- **Photo storage** — base64 in localStorage, images auto-resized client-side
- **Served by:** `python -m http.server`

## Quick start

```bash
cd order-system
python -m http.server 8765
```

Open `http://localhost:8765` in your browser.

### Demo credentials (change before production)

| Role | Username | Password |
|---|---|---|
| V&V Admin | `admin` | `vvadmin2026` |
| Eisha (Multi-Company Approver) | `eisha` | `eisha2026` |

Branch users log in via the **🏪 Customer** tab by picking company + branch (demo auth — no password).

## Repository layout

```
vv-order-portal/
├── CLAUDE.md                 Project context for AI-assisted development
├── USER_GUIDE.md             Complete user-facing manual (all three roles)
├── README.md                 This file
├── .gitignore                Keeps raw xlsx (with costs/PII) out of git
├── _references/
│   └── cleanup.py            Data-cleanup script for the source xlsx (pure code)
└── order-system/
    ├── index.html            The entire portal (HTML + CSS + JS inline)
    └── data/
        ├── products.json     681 active SKUs with prices, suppliers, categories
        ├── companies.json    7 customer companies with nested branches + approver
        └── legacy_orders.json 236 historical orders from Sales Tracker 2025
```

The raw xlsx files (`Sales Tracker 2025.xlsx`, `Sales Tracker 2025 - cleaned.xlsx`) live locally only — they contain cost data and PII and are `.gitignore`'d.

## Roadmap

This portal is a **working prototype for UX validation and workflow iteration**. Every feature here maps 1:1 to an Odoo Community configuration decision. Once we migrate:

- Real backend database replaces localStorage
- Multi-device access (phones, laptops)
- Proper multi-user auth
- Built-in A/R aging and sales reports
- Email + SMS notifications via Semaphore PH

See [CLAUDE.md](CLAUDE.md) for full project context and business rules.
See [USER_GUIDE.md](USER_GUIDE.md) for step-by-step usage instructions for every role.

## License

Proprietary — internal V&V use only. All customer data (companies, TINs, addresses, pricing) is confidential.
