# V&V Standard Operating Procedures

Business operating procedures for running the V&V wholesale supply business with the V&V Order Portal.

This is the **operational runbook** — how to *do* the work consistently. For software usage instructions, see [USER_GUIDE.md](USER_GUIDE.md).

---

## Table of Contents

1. [Operating Cadence (Daily / Weekly / Monthly)](#1-operating-cadence)
2. [SOP-001 — Order Intake & Approval Flow](#sop-001--order-intake--approval-flow)
3. [SOP-002 — Order Fulfillment & Delivery](#sop-002--order-fulfillment--delivery)
4. [SOP-003 — Payment Collection & Deposit Slip Validation](#sop-003--payment-collection--deposit-slip-validation)
5. [SOP-004 — Invoice (BIR SI) Issuance](#sop-004--invoice-bir-si-issuance)
6. [SOP-005 — A/R Follow-up & Collection](#sop-005--ar-follow-up--collection)
7. [SOP-006 — Customer Onboarding](#sop-006--customer-onboarding)
8. [SOP-007 — Product Request Handling](#sop-007--product-request-handling)
9. [SOP-008 — Consolidated Procurement](#sop-008--consolidated-procurement)
10. [SOP-009 — Catalog & Pricing Maintenance](#sop-009--catalog--pricing-maintenance)
11. [SOP-010 — Order Splitting (Partial Delivery)](#sop-010--order-splitting-partial-delivery)
12. [SOP-011 — Customer Escalations & Rejected Orders](#sop-011--customer-escalations--rejected-orders)
13. [SOP-012 — Data Backup & Security](#sop-012--data-backup--security)
14. [Roles & Responsibilities](#13-roles--responsibilities)

---

## 1. Operating Cadence

### 🌞 Every morning (V&V Admin — 15 min)

- [ ] Open portal, log in as admin (`admin` / `vvadmin2026`)
- [ ] **Dashboard** → review stat cards:
  - **New from Approvers** — confirm these orders today (advance to Confirmed)
  - **Slips to Validate** — open your bank app, confirm each payment landed, click **✓ Validate**
  - **Delivered — Need Invoice** — issue BIR SI for each, then click **+ Add SI #**
- [ ] Check **Consolidated Procurement List** — decide which suppliers to visit/call today
- [ ] Print today's procurement run (filter by supplier if multiple trips)
- [ ] Brief the driver on today's deliveries (which orders, routes, payment status)

### 🌙 Every evening (V&V Admin — 10 min)

- [ ] Advance today's delivered orders to **Delivered** status
- [ ] Record any deposit slips Eisha uploaded during the day — validate after bank confirms
- [ ] Review Pending Approvals that have been sitting >24h — check with Eisha if she needs a nudge

### 📆 Weekly (Monday morning — 30 min)

- [ ] **Analytics tab** → check:
  - Monthly revenue trend — is this month tracking with last?
  - Top fast-moving SKUs — anything unexpected? Any SKUs going hot that need higher stock-readiness from your suppliers?
  - Revenue by customer — any customer's volume dropped significantly? Flag for a check-in call
- [ ] A/R review:
  - Sort "Delivered (unpaid)" by age
  - Any Net 15 order past 15 days → SOP-005 collection workflow
- [ ] Check product requests queue — are there any "Pending Review" over a week old? Move to Sourcing or Decline

### 🗓️ Monthly (first business day — 60 min)

- [ ] Export full orders CSV (**📦 All Orders → ⬇ Export CSV**) → save to month folder
- [ ] Reconcile Paid orders against bank statements
- [ ] Review catalog for dead SKUs: filter by "Inactive only" — any to purge? Any "Active" that haven't sold in 3+ months that should be deactivated?
- [ ] Review supplier performance: which suppliers had longest lead times this month? Any consistent stock-outs? Consider alternate sourcing
- [ ] Send monthly statement of account to any customer with outstanding A/R
- [ ] Back up portal data (SOP-012)

---

## SOP-001 — Order Intake & Approval Flow

**Purpose:** Ensure every order is properly captured, approved by the customer's central approver, and routed to V&V for fulfillment.

### Process

```
Branch User  →  Places order  →  Pending Approval
                                      ↓
Eisha        →  Reviews     →  Approve  →  Submitted to V&V
                              Reject → back to branch with reason
                                      ↓
V&V Admin    →  Receives   →  Confirms   →  Procures  →  Delivers  →  Paid
```

### Steps

1. **Branch user** logs into portal (🏪 Customer tab), adds items to cart, hits **Submit for Approval**.
2. **Eisha** gets Viber notification (informal), opens portal (🔐 Staff Login as `eisha`), reviews Pending Approvals.
3. **Eisha approves or rejects within 24 hours.** On approve, the system opens her email client pre-filled with the order → she hits Send → V&V receives it.
4. **V&V admin** sees the order in Dashboard → "New from Approvers" counter → advances status to **Confirmed**.

### Service levels

| Step | Target |
|---|---|
| Approver decision | Within 24 hours of branch submission |
| Admin confirmation | Same day (morning batch) |
| Delivery (Metro Manila) | Within 2 business days of Confirmed |
| Delivery (outside NCR) | Case by case |

### Exceptions

- **Approver unavailable (>48h):** Admin can message branch to ask Eisha directly; or, if urgent, admin can manually log an offline order and process it (SOP-011).

---

## SOP-002 — Order Fulfillment & Delivery

**Purpose:** Get products to customers quickly and correctly.

### States

| Status | What it means | Who moves it |
|---|---|---|
| **Submitted to V&V** | Approver sent to V&V, not yet confirmed | Admin → Confirmed |
| **Confirmed** | V&V has accepted the order, will fulfill | Admin → Procuring |
| **Procuring** | Waiting for supplier pickup / delivery of raw items | Admin → Ready |
| **Ready** | All items on hand, ready to deliver | Admin → Out for Delivery |
| **Out for Delivery** | Driver has the order | Admin → Delivered |
| **Delivered** | Customer received it | Admin → Paid (after payment) |
| **Paid** | Revenue recognized | terminal |

### Daily fulfillment steps

1. **Morning:** Admin opens Dashboard → check "New from Approvers"
2. Confirm each new order (change status to **Confirmed**)
3. Open the **Consolidated Procurement List** → group by supplier (already done)
4. Print or use on phone → go to supplier / order from supplier
5. When items are in hand: advance order(s) to **Ready**
6. Brief driver → advance to **Out for Delivery**
7. Driver delivers → driver confirms with customer signature or photo → admin advances to **Delivered**

### Delivery rules

- **Own driver only.** No third-party couriers (Lalamove, Grab, LBC) unless specifically approved.
- **No fixed zones/days.** Delivery scheduled ad hoc per order. Small orders piggyback onto big routes.
- **Pickup option** is offered at checkout if customer prefers.
- **Driver never handles cash.** All payments digital (GCash/bank).

### If goods damaged on delivery

- Driver photographs damage, notes it in the order notes
- Admin contacts customer same day
- Replacement delivered next business day, or refund credit issued
- No returns of opened/used medical items

---

## SOP-003 — Payment Collection & Deposit Slip Validation

**Purpose:** Confirm customer payments and update A/R accurately.

### Payment terms by customer type

| Type | Rule |
|---|---|
| **Loyal customers (Net 15)** | Pay within 15 days of delivery |
| **Prepaid customers** | Pay before delivery — order only ships once payment confirmed |

### Prepaid payment flow

```
Order approved → Admin sends GCash / bank details to branch
               → Branch pays
               → Eisha uploads deposit slip via portal
               → Admin validates against bank app
               → Admin advances to Confirmed → Procuring → (rest of flow)
```

### Net 15 payment flow

```
Order delivered → Invoice issued → Customer has 15 days
               → Customer pays within 15 days
               → Eisha uploads deposit slip
               → Admin validates against bank app
               → Admin advances status to Paid
```

### Validating a deposit slip (V&V Admin)

1. Dashboard → "🧾 Deposit Slips Awaiting Validation" section
2. Click thumbnail to view full-size slip
3. Open your GCash or bank app — match amount + date + sender
4. If matches: click **✓ Validate** on the slip entry
5. If mismatched or not received: contact Eisha → have her re-upload or correct

### If customer overpays or underpays

- **Overpay:** Record actual paid amount in notes; carry excess as credit for next order
- **Underpay:** Leave order status at Delivered; message Eisha to collect balance; do not mark Paid until full amount received

### Never

- ❌ Accept cash from customers
- ❌ Have the driver collect payment
- ❌ Mark Paid based on a customer's word — always verify bank/GCash receipt

---

## SOP-004 — Invoice (BIR SI) Issuance

**Purpose:** Issue a BIR-compliant Sales Invoice for every delivery, and record the SI number in the portal for reference.

### When

- For **Prepaid customers:** issue SI before delivery (once payment received)
- For **Net 15 customers:** issue SI on day of delivery

### Who issues

V&V Admin (Elmer) using the external BIR-registered invoice system/book. **The portal does NOT generate BIR invoices.** It only stores the SI # you enter manually.

### Steps

1. Prepare SI in your BIR-registered system (handwritten or printed, per your current setup)
2. Include:
   - Customer's full company name + TIN
   - Address
   - Itemized line items (from order lines in the portal if needed for detail)
   - Amount, VAT breakdown, Total VAT-incl
   - V&V TIN, address, TIN header
3. In the portal → open order → find "📝 Delivered but Not Yet Invoiced" section on Dashboard OR All Orders → **+ Add SI #**
4. Enter the SI number exactly as written on the invoice
5. History entry auto-logged with timestamp

### SI numbering

- Sequential per your BIR authority-to-print (ATP) range
- Don't skip numbers; voided SIs still get a sequence entry
- Lost/damaged SI copies: follow BIR rules for issuing a certified true copy

---

## SOP-005 — A/R Follow-up & Collection

**Purpose:** Collect outstanding Net 15 payments promptly without damaging the customer relationship.

### Trigger

Any order with status **Delivered** and `invoice_number` set, older than:
- **Day 10** from delivery → gentle reminder
- **Day 15** (due date) → payment reminder
- **Day 20** (5 days overdue) → escalation
- **Day 30** (15 days overdue) → stop new orders from that customer until settled

### Escalation ladder

| Days past delivery | Action |
|---|---|
| 0–10 | No action needed |
| 11–14 | Informal Viber message to Eisha: "Friendly reminder — SI #XXX due YYYY-MM-DD" |
| 15 | Formal email with SOA attached; copy Eisha |
| 16–19 | Daily Viber follow-up |
| 20+ | Phone call to Eisha + customer's primary contact |
| 30+ | Stop new-order fulfillment. Email stating pause until balance is settled |
| 45+ | Involve finance (Elmer direct with customer owner) |

### Finding overdue orders in the portal

1. Dashboard → "💰 A/R — Outstanding by Customer" shows totals
2. All Orders → filter Status = **Delivered**, sort by date ascending → oldest first
3. Anything dated >15 days before today is overdue

### Soft-collection script (Viber to Eisha)

> "Hi Ma'am Eisha, just a heads-up — SI #XXX for ₱YYY delivered [date] is now [N days] past due. Happy to send the GCash details again if needed. Let me know when settlement is scheduled. Salamat!"

---

## SOP-006 — Customer Onboarding

**Purpose:** Get new customers set up quickly with correct payment terms and approver configuration.

### Steps — Admin side

1. Customer submits signup via the portal's **"Apply for an account"** link
2. Admin logs in → **✉️ Signups** tab → reviews application
3. Check:
   - [ ] TIN is valid format (NNN-NNN-NNN-NNNN)
   - [ ] Business address matches what they gave
   - [ ] Phone number format is correct
   - [ ] No duplicate of existing customer
4. **Approve** → prompt asks for payment terms:
   - `1 = Net 15 (loyal)` — for known/trusted customers only
   - `2 = Prepaid` — default for new/unknown customers
5. Portal auto-creates the company + branches; assigns Eisha as approver
6. Send credentials email to customer:

> Subject: Your V&V Order Portal account is ready
>
> Hi [Contact Name],
>
> Your V&V account has been approved. You can now place orders at:
> [portal URL]
>
> Your payment terms: [Net 15 / Prepaid]
> Your approver: Eisha (mobile: +63 917 109 5850)
>
> Click "Customer" on the login screen → pick your company and branch to start.
>
> For questions, reply to this email or Viber me.
>
> — V&V Team

### Graduation: Prepaid → Net 15

- After **6 months** of consistent on-time payments OR **10+ completed orders**
- Admin contacts customer to offer terms upgrade
- Edit each of their branches in the portal to change terms

### Rejection criteria (SOP)

- Invalid TIN or business registration
- Duplicate application
- No physical address (pure online ops with no legal entity)
- Previous bad-payment history with V&V

---

## SOP-007 — Product Request Handling

**Purpose:** Decide quickly whether a branch-requested product can be added to the catalog.

### Timeline

- **Day 0–2:** Acknowledge (mark as Sourcing)
- **Day 3–7:** Decide (Add or Decline)

### Evaluation checklist

- [ ] Can I source this locally? (Check existing suppliers first, then explore)
- [ ] Is there enough volume potential? (Will other branches also order it, or is it one-off?)
- [ ] What's the realistic cost? (Margin target: 25%+)
- [ ] Is there a regulatory issue? (e.g., controlled medical items)
- [ ] Is the photo clear enough to source the exact variant?

### Decision paths

**Add to Catalog:**
1. Confirm cost + decide sales price (cost × 1.3 minimum, or match market)
2. Click **✓ Add to Catalog** in the portal → enter price
3. System creates SKU + adds to shop
4. Notify branch the item is now orderable

**Decline:**
1. Click **✗ Decline** → enter clear reason (this is shown to the branch)
2. Acceptable reasons: "Unable to source locally," "MOQ too high for current demand," "Non-compliant item," "Alternative [SKU-XXX] already in catalog"

### Sourcing

See SOP-008 for the procurement process once Added to Catalog.

---

## SOP-008 — Consolidated Procurement

**Purpose:** Buy raw stock from suppliers efficiently to fulfill confirmed orders.

### Process

1. **Dashboard → 📦 Consolidated Procurement List** auto-aggregates items needed from "Submitted to V&V" orders
2. Items grouped by preferred supplier
3. Pick a supplier in the filter dropdown → **🖨️ Print** → take the printed list
4. Visit / call / order from supplier
5. As each item arrives, tick it off the printed list
6. On receipt: advance the corresponding orders to **Ready**

### Daily batching tip

Consolidate your supplier visits — don't go to BBraun for 3 orders across 3 days; batch them into one visit when possible.

### For unassigned products

Items in the "Unassigned" section of procurement need a supplier set:
1. After you source it, go to **📋 Catalog**
2. Filter by "⚠️ Unassigned"
3. Bulk-select related items, click **🏭 Set Supplier…** → type the name
4. Next time, they'll auto-group with that supplier

### Supplier relationship management

- Keep supplier contact info in the **Suppliers** tab of the cleaned xlsx (currently mostly blank — fill in as relationships form)
- Negotiate volume discounts quarterly
- Always have a secondary supplier for top-moving SKUs

---

## SOP-009 — Catalog & Pricing Maintenance

**Purpose:** Keep product catalog accurate, priced competitively, and free of dead SKUs.

### Adding a new product

1. **📋 Catalog → + Add Product**
2. Fill in: name, brand, category, supplier, variant/pack, UOM, sales price
3. Upload product photo (keeps Shop visual)
4. Leave SKU blank → auto-generates like `MED-0200`
5. Save → live in Shop immediately

### Updating a price

**Single SKU:**
1. Catalog → search SKU → click Edit → change price → Save

**Bulk (e.g., quarterly price increase):**
1. Filter by category or supplier
2. Select all relevant rows (header checkbox)
3. Click **💵 Adjust Price…**
4. Enter adjustment: `+10%` (raise by 10%), `=200` (set all to ₱200), `+50` (add ₱50 each)

### Deactivating SKUs

When a product is discontinued by supplier or no longer sells:
1. Select the SKU(s) in Catalog
2. Click **🚫 Deactivate (hide from Shop)**
3. Product disappears from customer shop but stays in admin for reactivation / reference

### Quarterly catalog review

- [ ] Any SKUs not sold in 3+ months? → Consider deactivating
- [ ] Any supplier prices increased? → Update your sales prices
- [ ] Any categorization changes needed? (e.g., a SKU originally "Utility" that's actually "Medical")
- [ ] Any products in "Unassigned" supplier? → Assign or investigate

---

## SOP-010 — Order Splitting (Partial Delivery)

**Purpose:** Deliver what's ready now, bill separately for items still being procured.

### When to split

- Part of an order is in hand, rest is still coming from supplier
- Customer is urgent about some items but not others
- Driver can only carry part of the load

### Process

1. Open the order in **View Details**
2. Click **✂️ Split Order**
3. For each line: enter how much to split into a NEW order (rest stays on original)
4. Add a note explaining why (shown in order history)
5. Confirm

### Result

- Original order (`ORD-XXXX`) keeps what stays
- New split order (`ORD-XXXX-A`, then `-B`, etc.) holds what left
- Both have independent statuses — advance each separately
- **Bill them separately** — each gets its own SI when the BIR invoice is issued

### Don't split if

- Order is already in Pending Approval (wait for approver first)
- Order is already Delivered or Paid (past the point of useful splitting)

---

## SOP-011 — Customer Escalations & Rejected Orders

### Rejected orders

When Eisha rejects a branch's order, the branch sees the reason in their **My Orders** tab.

**Branch action:** Adjust the order (fix quantity, remove item, etc.) and re-submit as a new order.

**Admin action:** None needed unless the rejection pattern indicates an approver issue.

### Customer complaints

| Type | Response |
|---|---|
| Wrong item delivered | Admin to deliver correct item next business day; note incident in order history |
| Damaged item | Photo proof from customer; replacement or credit; see SOP-002 damage flow |
| Missing items | Verify picking list against delivery; reconcile; redeliver if V&V error |
| Late delivery | Apologize; note in order; if pattern, review driver scheduling |
| Wrong pricing on invoice | Verify against portal order total; issue corrected SI if error |

### Offline / urgent orders (Viber fallback)

If the portal is down or the customer can't use it (e.g., Eisha on vacation):

1. Take the order via Viber as before
2. Use **📦 All Orders → + Log Manual Order** to record it
3. Set status to where the order actually is (Confirmed, Delivered, etc.)
4. Add invoice number once issued
5. Note in the order: "Offline — [reason]"

This keeps analytics and A/R accurate even when the portal's not used live.

---

## SOP-012 — Data Backup & Security

**Purpose:** Don't lose data. Don't leak data.

### What to back up

- **Code + configs:** Already in GitHub (`VandVordersystem` private repo) — auto-backed-up on every `git push`
- **Orders data:** Lives in browser localStorage — **NOT auto-backed-up**
- **Historical sales:** In `order-system/data/legacy_orders.json` (in the repo)
- **Raw xlsx:** In `_references/` locally — not in git (contains costs + PII)

### Weekly order backup

Every Friday:

1. Admin → **📦 All Orders → ⬇ Export CSV**
2. Save with date: `vv-orders-YYYY-MM-DD.csv`
3. Keep 3 months of weekly exports in a backup folder (Google Drive, OneDrive, or similar)

### Full xlsx backup

Monthly:

- Zip `_references/` folder with password
- Upload to a secure cloud folder (Google Drive with 2FA)

### Passwords & credentials

- **Never** commit passwords, API keys, or bank credentials to git
- **Change demo credentials** (`admin/vvadmin2026`, `eisha/eisha2026`) before production deployment
- **Portal auth** is demo-grade — true multi-user auth requires Odoo or a real backend. Don't treat the current portal as production until migrated.

### If browser data is lost

- Reinstall / clear browser → re-open portal → `legacy_orders.json` re-loads 236 historical orders automatically
- Portal-entered orders (post-launch) are **lost** — recover from the most recent CSV export
- Companies/products edited via admin UI are lost too — would need to re-apply edits

**Moral:** Don't treat the current portal as durable storage. Back up often. Migrate to Odoo ASAP for real persistence.

---

## 13. Roles & Responsibilities

| Role | Who | What they own |
|---|---|---|
| **Owner / V&V Admin** | Elmer Dy Tang | All admin operations; BIR invoicing; A/R; catalog management; supplier relationships; financials |
| **Multi-Company Approver** | Eisha | Approving/rejecting orders for all 7 customer companies; uploading deposit slips; coordinating payments with customer branches |
| **Customer Branch User** | Branch staff (varies per customer) | Placing orders; tracking their own orders; requesting products not in catalog |
| **Driver** | V&V internal | Executing deliveries; reporting damage/issues; confirming delivery with customer |

### Decision authority

| Decision | Who approves |
|---|---|
| New customer payment terms (Net 15 vs Prepaid) | V&V Admin |
| Product price changes | V&V Admin |
| Add new product to catalog | V&V Admin |
| Supplier switch for a SKU | V&V Admin |
| Waive/extend Net 15 term for a specific overdue order | V&V Admin (case by case) |
| Approve/reject customer order | Eisha (per-order) |
| Request a new product | Any branch user |
| Escalate to owner | Any customer or Eisha |

---

## Document control

- **Version:** 1.0
- **Last updated:** 2026-04-20
- **Owner:** Elmer Dy Tang
- **Review cadence:** Quarterly; ad hoc when a process changes materially

Changes to these SOPs should be committed to the repo with a clear message (e.g., `docs: update SOP-005 collection ladder`).
