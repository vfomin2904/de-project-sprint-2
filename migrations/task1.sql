-- справочник стоимости доставки в страны 

drop table if exists public.shipping_country_rates;

create table public.shipping_country_rates (
id serial primary key,
shipping_country text unique,
shipping_country_base_rate numeric(14,3)
);

insert into public.shipping_country_rates (shipping_country, shipping_country_base_rate)
(select distinct shipping_country, shipping_country_base_rate
from public.shipping);