-- Optional: persisted RFID counts per client (one row per client_id).
-- Destinations in the app always come from clients.destination; this table only stores counts.

create extension if not exists "pgcrypto";

create table if not exists public.rfid_data (
  id uuid primary key default gen_random_uuid(),
  client_id bigint not null references public.clients (id) on delete cascade,
  destination text not null default '',

  going_to_autosweep_class2 integer not null default 0,
  going_to_autosweep_class3 integer not null default 0,
  going_back_autosweep_class2 integer not null default 0,
  going_back_autosweep_class3 integer not null default 0,

  going_to_easytrip_class2 integer not null default 0,
  going_to_easytrip_class3 integer not null default 0,
  going_back_easytrip_class2 integer not null default 0,
  going_back_easytrip_class3 integer not null default 0,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  constraint rfid_data_client_id_key unique (client_id)
);

create or replace function public.set_rfid_data_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at := now();
  return new;
end;
$$;

drop trigger if exists trg_rfid_data_set_updated_at on public.rfid_data;
create trigger trg_rfid_data_set_updated_at
before update on public.rfid_data
for each row
execute procedure public.set_rfid_data_updated_at();
