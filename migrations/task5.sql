-- справочник статусов

drop table if exists public.shipping_status;

create table public.shipping_status(
shipping_id bigint,
status text,
state text,
shipping_start_fact_datetime timestamp,
shipping_end_fact_datetime timestamp
);

insert into public.shipping_status(shipping_id, status, state, shipping_start_fact_datetime, shipping_end_fact_datetime)
with partitioned_shipping as (
select shippingId, state, status, row_number() over(partition by shippingId order by state_datetime desc) 
as row_num from public.shipping
),
start_shipping as (
select shippingId, state_datetime as shipping_start_fact_datetime from public.shipping where state  = 'booked'
),
end_shipping as (
select shippingId, state_datetime as shipping_end_fact_datetime  from public.shipping where state  = 'recieved'
)
select ps.shippingId as shipping_id,
ps.status,
ps.state,
ss.shipping_start_fact_datetime,
es.shipping_end_fact_datetime
from partitioned_shipping ps 
left join start_shipping ss on ss.shippingId = ps.shippingId
left join end_shipping es on es.shippingId = ps.shippingId
where ps.row_num = 1;