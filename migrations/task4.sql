-- справочник комиссий по странам

drop table if exists public.shipping_info;

create table public.shipping_info(
	shipping_id bigint primary key,
	shipping_country_rate_id bigint references public.shipping_country_rates(id),
	shipping_agreement_id bigint references public.shipping_agreement(agreement_id),
	shipping_transfer_id bigint references public.shipping_transfer(id),
	shipping_plan_datetime timestamp,
	payment_amount numeric(14,2),
	vendor_id bigint
);

insert into public.shipping_info (shipping_id, shipping_country_rate_id, shipping_agreement_id, shipping_transfer_id,
shipping_plan_datetime, payment_amount, vendor_id)
(
select distinct
shippingId as shipping_id, 
scr.id as shipping_country_rate_id,
sa.agreement_id as shipping_agreement_id,
st.id  as shipping_transfer_id,
shipping_plan_datetime,
payment_amount,
vendorId as vendor_id
from public.shipping s
join public.shipping_agreement sa on sa.agreement_id = (regexp_split_to_array(s.vendor_agreement_description, ':'))[1]::bigint
join public.shipping_country_rates scr on scr.shipping_country = s.shipping_country
join public.shipping_transfer st on st.transfer_type = (regexp_split_to_array(s.shipping_transfer_description, ':'))[1] 
and st.transfer_model = (regexp_split_to_array(s.shipping_transfer_description, ':'))[2]
);