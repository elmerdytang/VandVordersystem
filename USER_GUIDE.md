# V&V Order Portal — User Guide

This guide covers how to use the V&V Order Portal for each role: **Customer Branch**, **Approver (Eisha)**, **V&V Admin**. Feel free to share with your team.

---

## 1. Getting Started

### Accessing the portal

- **Local testing:** open `http://localhost:8765` in your browser after starting the server
- **To start the server:**
  1. Open a terminal
  2. Navigate to `order-system/` directory
  3. Run: `python -m http.server 8765`
  4. Open browser to `http://localhost:8765`

### The login screen

Two tabs at the top:

- **🏪 Customer** — for branch staff placing orders
- **🔐 Staff Login** — for V&V admin and the central approver (Eisha)

There's also an **"Apply for an account →"** link for brand-new customers.

---

## 2. For New Customers — Signing Up

1. On the login screen, click **"Apply for an account →"**
2. Fill in:
   - **Company Information:** company name, TIN (required for BIR invoicing), address, business type, monthly order volume estimate
   - **Primary Contact:** your name, role, email, mobile
   - **Branches:** add one row per location that will order (click "+ Add another branch" for multi-branch setups)
   - **Order Approver:** tick "Same as primary contact" if that's you, or fill in who else approves orders on your side
3. Click **Submit Application**

You'll get a reference number (`SU-YYYYMMDD-XXX`). V&V typically approves within 1–2 business days and will email you credentials + payment terms.

---

## 3. For Customer Branch Staff (Ordering)

### Signing in

1. On login, stay on **🏪 Customer** tab
2. Pick your **Company** from the dropdown
3. Pick your **Branch**
4. Click **Continue**

### Placing an order

1. **Browse the catalog:**
   - Use the search bar to find items by SKU, name, or brand
   - Use the category filter (Medical, Utility, Office, Spa & Salon, Kitchen)
   - Each product shows: photo, name, brand, pack info, price, unit of measure
2. **Add to cart:** enter quantity, click **+ Add**. The cart on the right updates instantly.
3. **Manage the cart:**
   - Adjust quantities with + / − or type directly
   - Click **Remove** to delete a line
4. **Checkout:**
   - Click **Submit for Approval →**
   - Pick **🚚 Delivery** or **🏪 Pickup**
   - Add any notes (preferred delivery date, special handling)
   - Click **Submit for Approval**

Your order goes to your company's approver (Eisha). You'll see it appear in **📋 My Orders** tab under "Pending Approval."

### Requesting a product not in the catalog

1. In the Shop, click **📸 Request Product**
2. Fill in: product name, category, brand (if known), quantity, unit/pack size, description
3. **Upload a photo** (required) — click the camera area, pick an image from your device
4. Click **Submit Request**

V&V will review, source the product, and add it to the catalog. You'll see the outcome in your records.

### Tracking your orders

Click **📋 My Orders**. Orders are grouped by status:

- **Pending Approval** — waiting for your approver (Eisha)
- **Approved** — accepted, in V&V's fulfillment pipeline
- **Rejected** — declined by approver (reason shown in red banner)

Click **View Details** on any order to see full line items, timestamps, and the complete action history.

---

## 4. For Eisha — The Approver Dashboard

### Signing in

1. Click **🔐 Staff Login** tab
2. Enter username: `eisha` and password: `eisha2026` *(you can change these in the code)*
3. Click **Staff Sign In**

You'll land on **📊 My Dashboard** which aggregates activity across all 7 companies you approve for.

### Your three tabs

- **📊 My Dashboard** — stats across all companies, per-company/branch breakdown, top pending orders
- **⚠️ Pending Approvals** — everything waiting for your decision (with a filter by company and search)
- **📜 Approval History** — every past decision (approved, rejected, submitted to V&V)

### Approving an order

1. Open **⚠️ Pending Approvals**
2. Review the order card: company, branch, total, line count, fulfillment type, and any notes from the branch
3. Click **View Details** to inspect line items if needed
4. Click **Approve**:
   - Confirmation dialog shows total
   - System automatically opens a pre-filled email to V&V (`elmerdytang@gmail.com`)
   - **Click Send in your email client** to deliver the order to V&V
   - Order status flips to "Submitted to V&V"

### Rejecting an order

1. Click **Reject** on the order card
2. Enter a reason (required) — this is shown to the branch so they understand
3. Status becomes "Rejected" and branch sees it in their My Orders

### Uploading a deposit slip

When a customer pays via GCash or bank transfer, upload proof of payment:

1. On the order card (Pending Approvals or Approval History), click **📎 Upload Slip**
2. Pick the deposit screenshot from your device (auto-resized to save storage)
3. Once uploaded, the button turns green → **✓ Slip on file**
4. Admin (V&V) will then validate the slip

To replace a slip: click View Details → click **Replace** in the Payment section.

---

## 5. For V&V Admin — Operations Dashboard

### Signing in

1. Click **🔐 Staff Login** tab
2. Enter username: `admin` and password: `vvadmin2026`
3. Click **Staff Sign In**

### Your six tabs

- **📊 Dashboard** — stats, consolidated procurement list, slips to validate, orders needing invoices
- **📦 All Orders** — every order with status pipeline control
- **📈 Analytics** — revenue trends, by-customer, by-branch, fast-moving SKUs
- **📋 Catalog** — product CRUD (add/edit/bulk edit/activate/deactivate/images)
- **✉️ Signups** — review new customer applications
- **📸 Product Requests** — respond to branch-submitted product requests

### Dashboard at a glance

Six stat cards show key numbers:

| Card | Meaning |
|---|---|
| New from Approvers | Orders Eisha approved, awaiting your confirmation |
| In Fulfillment | Orders in Confirmed → Out for Delivery |
| Delivered (unpaid) | Outstanding A/R — delivered but not yet paid |
| Today's Orders | Count of orders placed today |
| Revenue This Month | Only counts orders marked **Paid** |
| At Customer (pending) | Orders sitting at customer side (Pending Approval) |
| Slips to Validate | Eisha uploaded deposit slips awaiting your check |
| Delivered — Need Invoice | Deliveries you haven't yet issued a BIR SI for |

Below the stats you see:

- **📦 Consolidated Procurement List** — items to buy from suppliers to fulfill new orders (grouped by supplier, with print + supplier filter)
- **🧾 Deposit Slips Awaiting Validation** — click slip to view full-size, then **✓ Validate** after confirming payment received in your bank/GCash
- **📝 Delivered but Not Yet Invoiced** — list of deliveries missing SI numbers, with **+ Add SI #** button
- **💰 A/R — Outstanding by Customer** — total owed per customer

### Driving an order through its lifecycle

On **📦 All Orders**, each row has a status dropdown. Advance through:

```
Submitted to V&V → Confirmed → Procuring → Ready → Out for Delivery → Delivered → Paid
```

Status changes are logged in the order history with timestamp.

### Logging a manual / offline order

Use this for deliveries that happened outside the portal (Viber orders, etc.):

1. Go to **📦 All Orders**
2. Click **+ Log Manual Order**
3. Pick company + branch
4. Enter delivery date + total amount (PHP, VAT-incl)
5. Pick status (Delivered is default — awaiting payment)
6. Optional: enter SI # if you've already issued a BIR invoice, or leave blank to mark as uninvoiced
7. Add any notes
8. Click **Save Order**

### Splitting an order

When part of an order is ready but the rest needs to go out later:

1. Open the order in **View Details**
2. Click **✂️ Split Order**
3. For each line item, enter how much to split into a new order (rest stays on the original)
4. Optional: add a reason
5. Click **Create Split**

Result: original order keeps the remaining items; a new order (`ORD-XXXX-A`, `ORD-XXXX-B`) holds what was split out. Both have independent status and can be billed separately.

### Managing the catalog

Go to **📋 Catalog** to add/edit/bulk-edit products.

**Add a product:**
1. Click **+ Add Product**
2. Fill in: SKU (blank = auto-generate based on category), name, brand, category, supplier, variant/pack, UOM, price
3. Toggle **Active** (visible in Shop)
4. Optionally upload a product photo (auto-resized to 600px)
5. Click **Save**

**Edit a product:** click **Edit** on any row → change fields → Save.

**Bulk edit:**
1. Tick checkboxes on rows (or the top-left box to select all visible)
2. A dark bar appears at the top with actions:
   - **✓ Mark Active** / **🚫 Deactivate** — changes visibility in Shop
   - **🏭 Set Supplier…** — type supplier name (applies to all selected)
   - **📂 Set Category…** — type one of: Medical, Utility, Office, Spa_Salon, Kitchen
   - **💵 Adjust Price…** — use syntax `+10%` (raise 10%), `-5%` (drop 5%), `+50` (add ₱50), `=200` (set all to ₱200)

**Filtering:**
- Search by SKU, name, or brand
- Filter by category, supplier (including "⚠️ Unassigned"), or status (Active / All / Inactive)

### Approving customer signups

Go to **✉️ Signups**:

1. Review application (company, TIN, contact, branches, proposed approver)
2. Click **✓ Approve**
3. Prompt asks for payment terms: `1 = Net 15 (loyal)` or `2 = Prepaid`
4. System creates the company + branches + assigns Eisha as approver
5. Customer can now log in via the Customer tab

To decline: click **✗ Decline**, enter reason (will be recorded).

### Handling product requests

Go to **📸 Product Requests**:

1. Review the request card including the photo
2. Options:
   - **🔍 Sourcing** — you're looking into it (status changes, request stays in queue)
   - **✓ Add to Catalog** — prompts for price; system auto-generates SKU, creates product, makes it orderable
   - **✗ Decline** — enter reason; branch sees the reason

### Printing procurement lists

On the **📊 Dashboard**, when orders are sitting in "Submitted to V&V":

1. Optional: pick a supplier in the filter dropdown to print only that supplier's list
2. Click **🖨️ Print**
3. New window opens with:
   - Header (date, counts, source orders)
   - Each supplier's section (with page breaks if printing All)
   - Checkbox column to tick off items as you buy them
   - Source orders appendix for traceability
4. Print dialog auto-opens

---

## 6. Payment Terms & Deposit Slip Flow

### Loyal customers (Net 15)

- Order → Approved → Delivered
- Customer has 15 days from delivery to pay
- When customer pays: Eisha uploads deposit slip → Admin validates → Admin advances status to **Paid**

### Non-loyal customers (Prepaid)

- Order → Approved → Delivered only after payment confirmed
- Customer pays via GCash/bank → Eisha uploads deposit slip → Admin validates
- Driver releases delivery only once slip is validated
- Status: Confirmed → Procuring → Ready → Out for Delivery → Delivered → Paid

The driver **never** collects cash on site.

---

## 7. Exporting Data

**CSV of all orders:** Admin → **📦 All Orders** → **⬇ Export CSV**. Downloads a one-row-per-line-item CSV with all order and customer fields. Useful for Excel analysis or handing to an accountant.

---

## 8. What's NOT in the portal (by design)

- **BIR invoices** — you issue these separately in your existing system. The portal stores the SI # you enter for reference.
- **Inventory tracking** — V&V procures JIT per order
- **Expiry / lot numbers** — not tracked
- **Cash collection by driver** — driver never carries cash

---

## 9. Troubleshooting

| Problem | Fix |
|---|---|
| Login dropdown empty | Server not running → start with `python -m http.server 8765` in `order-system/` |
| Approve opens email draft but customer has no email client | Tell Eisha to copy the order text manually and paste into Viber/email |
| "Save failed — photo may be too large" | Image is pushing past browser storage; pick a smaller image or remove an existing one |
| Lost all orders after clearing browser data | Orders live in localStorage — clearing wipes them. Historical orders auto-reload from `legacy_orders.json` |
| Customer can't see their account after signup | Admin needs to approve the signup first (**✉️ Signups** tab) |

---

## 10. Default Credentials

Change these in [index.html](order-system/index.html) (search for `STAFF_CREDS`):

| Role | Username | Password |
|---|---|---|
| V&V Admin | `admin` | `vvadmin2026` |
| Eisha (Super Approver) | `eisha` | `eisha2026` |

**Change these before going to production.** This is a demo credential store — real auth requires a backend.

---

## 11. What Comes Next (roadmap)

This portal is a **working prototype** for validating the workflow. Target production platform is **Odoo Community** self-hosted on Alibaba Cloud (~$10/month), which will give:

- Real backend database (no localStorage limitations)
- Multi-device access (orders visible across phones, laptops)
- Proper multi-user auth with password policies
- Integrated BIR invoice generation (if configured)
- Built-in A/R aging, sales reports, CRM

Until Odoo is live, this portal serves as:
1. A **UX reference** — every feature here maps 1:1 to an Odoo configuration decision
2. A **working bridge** — capture orders now, migrate data to Odoo when ready
3. A **data cleanup tool** — the 236 historical orders and 718 SKUs are already structured for Odoo import

---

**Questions or something broken?** File an issue on the GitHub repo (once created), or reach Elmer directly.
