-- справочник о типах доставки

drop table if exists public.shipping_transfer;

create table public.shipping_transfer (
id serial primary key,
transfer_type text,
transfer_model text,
shipping_transfer_rate numeric(14,3)
);

insert into public.shipping_transfer(transfer_type, transfer_model, shipping_transfer_rate)
(
select distinct t_desc[1] as transfer_type,
t_desc[2] as transfer_model,
shipping_transfer_rate
from (select regexp_split_to_array(shipping_transfer_description, ':') as t_desc,
shipping_transfer_rate from public.shipping) as transfer
)