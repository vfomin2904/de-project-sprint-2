create or replace view public.shipping_datamart as
(
select si.shipping_id,
si.vendor_id,
st.transfer_type,
date_part('day', age(ss.shipping_end_fact_datetime, ss.shipping_start_fact_datetime)) as full_day_at_shipping,
ss.shipping_end_fact_datetime  > si.shipping_plan_datetime  as is_delay,
ss.status = 'finished' as is_shipping_finish,
case 
	when ss.shipping_end_fact_datetime > si.shipping_plan_datetime  then 
	date_part('day', age(ss.shipping_end_fact_datetime, si.shipping_plan_datetime))
	else 0
end as delay_day_at_shipping ,
si.payment_amount,
si.payment_amount * (scr.shipping_country_base_rate + sa.agreement_rate + st.shipping_transfer_rate) as vat,
si.payment_amount * sa.agreement_commission as profit 
from public.shipping_info si 
join public.shipping_transfer st on si.shipping_transfer_id = st.id 
join public.shipping_country_rates scr on si.shipping_country_rate_id = scr.id 
join public.shipping_agreement sa on si.shipping_agreement_id = sa.agreement_id
join public.shipping_status ss on si.shipping_id = ss.shipping_id 
);

select * from public.shipping_datamart limit 10;