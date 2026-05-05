-- ============================================================
-- V&V Order Portal — Supabase Schema (idempotent — safe to re-run)
-- Project: TradeAgile  |  Region: Singapore
-- ============================================================

-- ============================================================
-- TABLES
-- ============================================================

CREATE TABLE IF NOT EXISTS companies (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  code            TEXT UNIQUE NOT NULL,
  name            TEXT NOT NULL,
  tin             TEXT,
  approver_name   TEXT DEFAULT 'Eisha',
  approver_mobile TEXT,
  created_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS branches (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  company_id  UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
  code        TEXT UNIQUE NOT NULL,
  name        TEXT NOT NULL,
  address     TEXT,
  mobile      TEXT,
  terms       TEXT NOT NULL DEFAULT 'Prepaid' CHECK (terms IN ('Net 15','Prepaid')),
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS profiles (
  id          UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  role        TEXT NOT NULL CHECK (role IN ('vv_admin','approver','super_approver','branch_user')),
  full_name   TEXT,
  branch_id   UUID REFERENCES branches(id),
  company_id  UUID REFERENCES companies(id),
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS products (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  sku         TEXT UNIQUE NOT NULL,
  name        TEXT NOT NULL,
  category    TEXT,
  brand       TEXT,
  variant     TEXT,
  uom         TEXT,
  price       NUMERIC(10,2),
  supplier    TEXT,
  image_url   TEXT,
  is_active   BOOLEAN DEFAULT TRUE,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS orders (
  id                     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id               TEXT UNIQUE NOT NULL,
  branch_id              UUID REFERENCES branches(id),
  company_id             UUID REFERENCES companies(id),
  status                 TEXT NOT NULL DEFAULT 'Pending Approval',
  fulfillment            TEXT DEFAULT 'Delivery',
  notes                  TEXT,
  total_php              NUMERIC(10,2) DEFAULT 0,
  invoice_number         TEXT,
  deposit_slip_url       TEXT,
  deposit_slip_validated BOOLEAN DEFAULT FALSE,
  rejection_reason       TEXT,
  placed_by              UUID REFERENCES auth.users(id),
  placed_at              TIMESTAMPTZ DEFAULT NOW(),
  created_at             TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS order_items (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id        UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
  product_sku     TEXT,
  product_name    TEXT NOT NULL,
  product_brand   TEXT,
  product_variant TEXT,
  product_uom     TEXT,
  qty             INTEGER NOT NULL DEFAULT 1,
  unit_price      NUMERIC(10,2) NOT NULL,
  total           NUMERIC(10,2) NOT NULL
);

CREATE TABLE IF NOT EXISTS order_history (
  id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
  action   TEXT NOT NULL,
  by_name  TEXT,
  at       TIMESTAMPTZ DEFAULT NOW(),
  note     TEXT
);

CREATE TABLE IF NOT EXISTS signups (
  id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  company_name   TEXT NOT NULL,
  tin            TEXT,
  address        TEXT,
  business_type  TEXT,
  volume         TEXT,
  contact_name   TEXT,
  contact_role   TEXT,
  email          TEXT,
  mobile         TEXT,
  branches       JSONB DEFAULT '[]',
  status         TEXT DEFAULT 'Pending' CHECK (status IN ('Pending','Approved','Declined')),
  terms          TEXT CHECK (terms IN ('Net 15','Prepaid')),
  decline_reason TEXT,
  created_at     TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS product_requests (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  branch_id    UUID REFERENCES branches(id),
  company_id   UUID REFERENCES companies(id),
  branch_name  TEXT,
  company_name TEXT,
  product_name TEXT NOT NULL,
  description  TEXT,
  photo_url    TEXT,
  status       TEXT DEFAULT 'Pending Review',
  admin_note   TEXT,
  created_at   TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS suppliers (
  id         TEXT PRIMARY KEY,
  code       TEXT UNIQUE,
  name       TEXT NOT NULL,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS consolidated_sheets (
  id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  sheet_id   TEXT UNIQUE NOT NULL,
  name       TEXT NOT NULL,
  order_ids  TEXT[],
  created_by UUID REFERENCES auth.users(id),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS announcements (
  id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title      TEXT NOT NULL,
  body       TEXT,
  posted_by  TEXT,
  posted_at  TIMESTAMPTZ DEFAULT NOW(),
  visible_to TEXT[] DEFAULT '{branch_user,approver,super_approver}'
);

-- ============================================================
-- INDEXES
-- ============================================================

CREATE INDEX IF NOT EXISTS idx_orders_status     ON orders(status);
CREATE INDEX IF NOT EXISTS idx_orders_branch_id  ON orders(branch_id);
CREATE INDEX IF NOT EXISTS idx_orders_company_id ON orders(company_id);
CREATE INDEX IF NOT EXISTS idx_orders_placed_at  ON orders(placed_at DESC);
CREATE INDEX IF NOT EXISTS idx_items_order_id    ON order_items(order_id);
CREATE INDEX IF NOT EXISTS idx_history_order_id  ON order_history(order_id);
CREATE INDEX IF NOT EXISTS idx_products_sku      ON products(sku);
CREATE INDEX IF NOT EXISTS idx_products_active   ON products(is_active);
CREATE INDEX IF NOT EXISTS idx_branches_company  ON branches(company_id);
CREATE INDEX IF NOT EXISTS idx_profiles_role     ON profiles(role);
CREATE INDEX IF NOT EXISTS idx_profiles_branch   ON profiles(branch_id);

-- ============================================================
-- RLS — enable on every table (no-op if already enabled)
-- ============================================================

ALTER TABLE companies           ENABLE ROW LEVEL SECURITY;
ALTER TABLE branches            ENABLE ROW LEVEL SECURITY;
ALTER TABLE profiles            ENABLE ROW LEVEL SECURITY;
ALTER TABLE products            ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders              ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_items         ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_history       ENABLE ROW LEVEL SECURITY;
ALTER TABLE signups             ENABLE ROW LEVEL SECURITY;
ALTER TABLE product_requests    ENABLE ROW LEVEL SECURITY;
ALTER TABLE suppliers           ENABLE ROW LEVEL SECURITY;
ALTER TABLE consolidated_sheets ENABLE ROW LEVEL SECURITY;
ALTER TABLE announcements       ENABLE ROW LEVEL SECURITY;

-- ============================================================
-- HELPER FUNCTIONS
-- ============================================================

CREATE OR REPLACE FUNCTION get_my_role()
RETURNS TEXT LANGUAGE sql SECURITY DEFINER STABLE AS $$
  SELECT role FROM profiles WHERE id = auth.uid()
$$;

CREATE OR REPLACE FUNCTION get_my_branch_id()
RETURNS UUID LANGUAGE sql SECURITY DEFINER STABLE AS $$
  SELECT branch_id FROM profiles WHERE id = auth.uid()
$$;

-- ============================================================
-- POLICIES  (drop-then-recreate = idempotent)
-- ============================================================

-- profiles
DROP POLICY IF EXISTS "profiles_read_own"    ON profiles;
DROP POLICY IF EXISTS "profiles_insert_own"  ON profiles;
DROP POLICY IF EXISTS "profiles_update"      ON profiles;

CREATE POLICY "profiles_read_own"   ON profiles FOR SELECT USING (auth.uid() = id OR get_my_role() = 'vv_admin');
CREATE POLICY "profiles_insert_own" ON profiles FOR INSERT WITH CHECK (auth.uid() = id OR get_my_role() = 'vv_admin');
CREATE POLICY "profiles_update"     ON profiles FOR UPDATE USING (auth.uid() = id OR get_my_role() = 'vv_admin');

-- companies
DROP POLICY IF EXISTS "companies_read"         ON companies;
DROP POLICY IF EXISTS "companies_admin_write"  ON companies;

CREATE POLICY "companies_read"        ON companies FOR SELECT USING (auth.uid() IS NOT NULL);
CREATE POLICY "companies_admin_write" ON companies FOR ALL USING (get_my_role() = 'vv_admin') WITH CHECK (get_my_role() = 'vv_admin');

-- branches
DROP POLICY IF EXISTS "branches_read"         ON branches;
DROP POLICY IF EXISTS "branches_admin_write"  ON branches;

CREATE POLICY "branches_read"        ON branches FOR SELECT USING (auth.uid() IS NOT NULL);
CREATE POLICY "branches_admin_write" ON branches FOR ALL USING (get_my_role() = 'vv_admin') WITH CHECK (get_my_role() = 'vv_admin');

-- products
DROP POLICY IF EXISTS "products_read"         ON products;
DROP POLICY IF EXISTS "products_admin_write"  ON products;

CREATE POLICY "products_read"        ON products FOR SELECT USING (auth.uid() IS NOT NULL);
CREATE POLICY "products_admin_write" ON products FOR ALL USING (get_my_role() = 'vv_admin') WITH CHECK (get_my_role() = 'vv_admin');

-- orders
DROP POLICY IF EXISTS "orders_select"  ON orders;
DROP POLICY IF EXISTS "orders_insert"  ON orders;
DROP POLICY IF EXISTS "orders_update"  ON orders;
DROP POLICY IF EXISTS "orders_delete"  ON orders;

CREATE POLICY "orders_select" ON orders FOR SELECT USING (
  get_my_role() IN ('vv_admin','approver','super_approver')
  OR (get_my_role() = 'branch_user' AND branch_id = get_my_branch_id())
);
CREATE POLICY "orders_insert" ON orders FOR INSERT WITH CHECK (
  get_my_role() IN ('vv_admin','approver','super_approver')
  OR (get_my_role() = 'branch_user' AND branch_id = get_my_branch_id())
);
CREATE POLICY "orders_update" ON orders FOR UPDATE USING (get_my_role() IN ('vv_admin','approver','super_approver'));
CREATE POLICY "orders_delete" ON orders FOR DELETE USING (get_my_role() = 'vv_admin');

-- order_items
DROP POLICY IF EXISTS "order_items_select"  ON order_items;
DROP POLICY IF EXISTS "order_items_insert"  ON order_items;
DROP POLICY IF EXISTS "order_items_update"  ON order_items;
DROP POLICY IF EXISTS "order_items_delete"  ON order_items;

CREATE POLICY "order_items_select" ON order_items FOR SELECT USING (
  get_my_role() IN ('vv_admin','approver','super_approver')
  OR EXISTS (SELECT 1 FROM orders o WHERE o.id = order_items.order_id AND o.branch_id = get_my_branch_id())
);
CREATE POLICY "order_items_insert" ON order_items FOR INSERT WITH CHECK (auth.uid() IS NOT NULL);
CREATE POLICY "order_items_update" ON order_items FOR UPDATE USING (get_my_role() = 'vv_admin');
CREATE POLICY "order_items_delete" ON order_items FOR DELETE USING (get_my_role() = 'vv_admin');

-- order_history
DROP POLICY IF EXISTS "order_history_select"  ON order_history;
DROP POLICY IF EXISTS "order_history_insert"  ON order_history;

CREATE POLICY "order_history_select" ON order_history FOR SELECT USING (
  get_my_role() IN ('vv_admin','approver','super_approver')
  OR EXISTS (SELECT 1 FROM orders o WHERE o.id = order_history.order_id AND o.branch_id = get_my_branch_id())
);
CREATE POLICY "order_history_insert" ON order_history FOR INSERT WITH CHECK (auth.uid() IS NOT NULL);

-- signups
DROP POLICY IF EXISTS "signups_public_insert"  ON signups;
DROP POLICY IF EXISTS "signups_admin"          ON signups;

CREATE POLICY "signups_public_insert" ON signups FOR INSERT WITH CHECK (TRUE);
CREATE POLICY "signups_admin"         ON signups FOR ALL USING (get_my_role() = 'vv_admin') WITH CHECK (get_my_role() = 'vv_admin');

-- product_requests
DROP POLICY IF EXISTS "requests_insert"  ON product_requests;
DROP POLICY IF EXISTS "requests_select"  ON product_requests;
DROP POLICY IF EXISTS "requests_update"  ON product_requests;

CREATE POLICY "requests_insert" ON product_requests FOR INSERT WITH CHECK (auth.uid() IS NOT NULL);
CREATE POLICY "requests_select" ON product_requests FOR SELECT USING (
  get_my_role() IN ('vv_admin','approver','super_approver')
  OR (get_my_role() = 'branch_user' AND branch_id = get_my_branch_id())
);
CREATE POLICY "requests_update" ON product_requests FOR UPDATE USING (get_my_role() = 'vv_admin');

-- suppliers
DROP POLICY IF EXISTS "suppliers_read"         ON suppliers;
DROP POLICY IF EXISTS "suppliers_admin_write"  ON suppliers;

CREATE POLICY "suppliers_read"        ON suppliers FOR SELECT USING (auth.uid() IS NOT NULL);
CREATE POLICY "suppliers_admin_write" ON suppliers FOR ALL USING (get_my_role() = 'vv_admin') WITH CHECK (get_my_role() = 'vv_admin');

-- consolidated_sheets
DROP POLICY IF EXISTS "sheets_admin" ON consolidated_sheets;

CREATE POLICY "sheets_admin" ON consolidated_sheets FOR ALL USING (get_my_role() = 'vv_admin') WITH CHECK (get_my_role() = 'vv_admin');

-- announcements
DROP POLICY IF EXISTS "announcements_read"         ON announcements;
DROP POLICY IF EXISTS "announcements_admin_write"  ON announcements;

CREATE POLICY "announcements_read"        ON announcements FOR SELECT USING (auth.uid() IS NOT NULL);
CREATE POLICY "announcements_admin_write" ON announcements FOR ALL USING (get_my_role() = 'vv_admin') WITH CHECK (get_my_role() = 'vv_admin');
