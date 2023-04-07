-- справочник тарифов доставки вендора по договору 

drop table if exists public.shipping_agreement;

create table public.shipping_agreement (
agreement_id bigint primary key,
agreement_number text,
agreement_rate numeric(14,2),
agreement_commission numeric(14,3)
);

insert into shipping_agreement(agreement_id, agreement_number, agreement_rate, agreement_commission)
(
select distinct description[1]::bigint as agreement_id,
description[2] as agreement_number,
description[3]::numeric(14,2) as agreement_rate,
description[4]::numeric(14,3) as agreement_commission
from (select regexp_split_to_array(vendor_agreement_description, ':') as description  from public.shipping) as d
)