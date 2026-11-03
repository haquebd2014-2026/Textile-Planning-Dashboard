-- Run this once in Supabase SQL Editor.
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text,
  role text not null default 'viewer' check (role in ('admin','viewer')),
  created_at timestamptz not null default now()
);

create table if not exists public.dashboard_data (
  id integer primary key default 1 check (id = 1),
  file_name text,
  data jsonb not null default '{}'::jsonb,
  uploaded_by uuid references auth.users(id),
  uploaded_at timestamptz not null default now()
);

alter table public.profiles enable row level security;
alter table public.dashboard_data enable row level security;

create or replace function public.is_admin()
returns boolean
language sql
security definer
set search_path = public
stable
as $$
  select exists (
    select 1 from public.profiles p
    where p.id = auth.uid() and p.role = 'admin'
  );
$$;

drop policy if exists "authenticated can read own profile" on public.profiles;
create policy "authenticated can read own profile"
on public.profiles for select
to authenticated
using (id = auth.uid());

drop policy if exists "authenticated can read dashboard" on public.dashboard_data;
create policy "authenticated can read dashboard"
on public.dashboard_data for select
to authenticated
using (true);

drop policy if exists "admins can insert dashboard" on public.dashboard_data;
create policy "admins can insert dashboard"
on public.dashboard_data for insert
to authenticated
with check (public.is_admin());

drop policy if exists "admins can update dashboard" on public.dashboard_data;
create policy "admins can update dashboard"
on public.dashboard_data for update
to authenticated
using (public.is_admin())
with check (public.is_admin());

drop policy if exists "admins can delete dashboard" on public.dashboard_data;
create policy "admins can delete dashboard"
on public.dashboard_data for delete
to authenticated
using (public.is_admin());

-- After creating users in Authentication > Users, add one profile row per user.
-- Replace UUIDs and names below with your real users:
-- insert into public.profiles (id, display_name, role) values
-- ('USER_UUID_HERE','Anwarul','admin'),
-- ('ANOTHER_USER_UUID','Viewer Name','viewer');
