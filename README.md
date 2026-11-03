# Textile Planning Dashboard

GitHub Pages-ready dashboard based on the supplied workbook and demo layout.

## Files
- `index.html` — production dashboard with Supabase email/password login and shared data.
- `config.js` — enter your Supabase project URL and anon/publishable key.
- `supabase_setup.sql` — database tables and Row Level Security policies.
- `preview.html` — design preview using the attached October 2026 data; do **not** deploy this file if the data must remain private.

## Required Excel sheets
The upload validates these exact sheet names:
`Dyeing`, `Knitting`, `Finishing`, `FFS`, `Buyer Wise data`.

## Setup
1. Create a Supabase project.
2. Open SQL Editor and run `supabase_setup.sql`.
3. In Supabase Authentication, create your authorized users.
4. Copy each user's UUID into `profiles` and set `role` to `admin` or `viewer`.
5. In Supabase Project Settings/API, copy the Project URL and anon/publishable key into `config.js`.
6. Create a GitHub repository, for example `textile-planning-dashboard`.
7. Upload `index.html` and `config.js` to the repository root. (`supabase_setup.sql` may also be stored there; it contains no secrets.)
8. In GitHub: Settings → Pages → Deploy from a branch → `main` / root.
9. Open the GitHub Pages URL and sign in.
10. Admin: Data Management → choose the Excel file → Upload & Publish. All authenticated users will see the same published data.

## Security
- Do not put a Supabase service-role/secret key in GitHub or browser code.
- The anon/publishable key is intended for client apps; access is enforced by Supabase Auth + RLS.
- Only Admin profiles can replace the shared dashboard data.

## Current data mapping
- Overview: combined trends from Dyeing, Knitting, Finishing, FFS plus Buyer Wise summary.
- Dyeing: production, RFT, capacity, loading, on-time.
- Knitting: overall production, subcontract, utilization, OTT.
- Finishing: heat-set, handed-over, MLT, machine utilization.
- Delivery: received, delivered, OTD, excess. Current source has blank `One Shot` values, so the KPI displays `—`.
- Buyer Analysis: delivered, received, dyeing/knitting production and excess data.
