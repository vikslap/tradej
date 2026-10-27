-- Trade Log database setup. Paste into Supabase → SQL Editor → Run. Safe to run again.
-- Every row belongs to the signed-in user; row-level security means no one else can read or change it.

create table if not exists public.trades (
  user_id     uuid not null default auth.uid() references auth.users (id) on delete cascade,
  id          text not null,
  data        jsonb not null,
  updated_at  timestamptz not null default now(),
  primary key (user_id, id)
);

-- Raw Zerodha executions, one row per symbol, so re-imports never double-count.
create table if not exists public.fills (
  user_id  uuid not null default auth.uid() references auth.users (id) on delete cascade,
  key      text not null,
  data     jsonb not null,
  primary key (user_id, key)
);

create table if not exists public.settings (
  user_id  uuid primary key default auth.uid() references auth.users (id) on delete cascade,
  rates    jsonb not null default '{}'::jsonb
);

alter table public.trades   enable row level security;
alter table public.fills    enable row level security;
alter table public.settings enable row level security;

drop policy if exists "own rows" on public.trades;
create policy "own rows" on public.trades for all
  using (user_id = auth.uid()) with check (user_id = auth.uid());
drop policy if exists "own rows" on public.fills;
create policy "own rows" on public.fills for all
  using (user_id = auth.uid()) with check (user_id = auth.uid());
drop policy if exists "own rows" on public.settings;
create policy "own rows" on public.settings for all
  using (user_id = auth.uid()) with check (user_id = auth.uid());

-- Private bucket for chart screenshots. Files live under <user id>/<trade id>/...
insert into storage.buckets (id, name, public)
values ('screenshots', 'screenshots', false)
on conflict (id) do nothing;

drop policy if exists "own screenshots read" on storage.objects;
create policy "own screenshots read" on storage.objects for select
  using (bucket_id = 'screenshots' and (storage.foldername(name))[1] = auth.uid()::text);
drop policy if exists "own screenshots write" on storage.objects;
create policy "own screenshots write" on storage.objects for insert
  with check (bucket_id = 'screenshots' and (storage.foldername(name))[1] = auth.uid()::text);
drop policy if exists "own screenshots delete" on storage.objects;
create policy "own screenshots delete" on storage.objects for delete
  using (bucket_id = 'screenshots' and (storage.foldername(name))[1] = auth.uid()::text);
