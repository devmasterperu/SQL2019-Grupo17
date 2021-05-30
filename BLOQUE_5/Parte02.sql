--05.07

--SUBCONSULTAS_SELECT

set statistics io on

Select nombre as 'PLAN',
(select count(*) from Contrato co where co.codplan=p.codplan)as [CO-TOTAL],
isnull((select avg(co.preciosol) from Contrato co where co.codplan=p.codplan),0.00) as [CO-PROM],
isnull((select min(co.fec_contrato) from Contrato co where co.codplan=p.codplan),'9999-12-31') as [CO-ANTIGUO],
isnull((select max(co.fec_contrato) from Contrato co where co.codplan=p.codplan),'9999-12-31') as [CO-RECIENTE]
from PlanInternet p
order by [CO-TOTAL] desc

--SUBCONSULTAS_FROM

--(select count(*) from Contrato co where co.codplan=p.codplan)as [CO-TOTAL],
--isnull((select avg(co.preciosol) from Contrato co where co.codplan=p.codplan),0.00) as [CO-PROM],
--isnull((select min(co.fec_contrato) from Contrato co where co.codplan=p.codplan),'9999-12-31') as [CO-ANTIGUO],
--isnull((select max(co.fec_contrato) from Contrato co where co.codplan=p.codplan),'9999-12-31') as [CO-RECIENTE]

Select nombre as 'PLAN',
	   isnull(rp.total,0) as [CO-TOTAL],
	   isnull(rp.prom,0.00) as [CO-PROM],
	   isnull(rp.antiguo,'9999-12-31') as [CO-ANTIGUO],
	   isnull(rp.reciente,'9999-12-31') as [CO-RECIENTE]
from PlanInternet p
left join
(
	select codplan,count(*) as total,avg(preciosol) as prom,min(fec_contrato) as antiguo,max(fec_contrato) as reciente
	from Contrato co
	group by codplan
) rp on p.codplan=rp.codplan
order by [CO-TOTAL] desc

--CTE
with cte_rp
as
(
	select codplan,count(*) as total,avg(preciosol) as prom,min(fec_contrato) as antiguo,max(fec_contrato) as reciente
	from Contrato co
	group by codplan
)
Select nombre as 'PLAN',
	   isnull(rp.total,0) as [CO-TOTAL],
	   isnull(rp.prom,0.00) as [CO-PROM],
	   isnull(rp.antiguo,'9999-12-31') as [CO-ANTIGUO],
	   isnull(rp.reciente,'9999-12-31') as [CO-RECIENTE],
	   (select count(*) from cte_rp) as TOTAL2
from PlanInternet p
left join cte_rp  rp on p.codplan=rp.codplan
order by [CO-TOTAL] desc

--05.09

--TABLAS_DERIVADAS

--Teléfonos activos por cliente

select codcliente,count(*) 
from   Telefono
where  estado=1
group by codcliente

--Contratos activos por cliente

select codcliente,count(*) 
from   Contrato
where  estado=1
group by codcliente

select c.codcliente as [COD-CLIENTE],
	   upper(rtrim(ltrim(c.nombres+' '+c.ape_paterno+' '+c.ape_materno))) as CLIENTE,
	   isnull(rt.total,0) as [TOT-TE],
	   isnull(rc.total,0) as [TOT-CO]
from Cliente c
left join
(
    --Teléfonos activos por cliente
	select codcliente,count(*) as total
	from   Telefono
	where  estado=1
	group by codcliente
) rt on c.codcliente=rt.codcliente
left join
(
	--Contratos activos por cliente
	select codcliente,count(*) as total
	from   Contrato
	where  estado=1
	group by codcliente
) rc on c.codcliente=rc.codcliente
where tipo_cliente='P'

--CTEs
with cte_rt as
(
    --Teléfonos activos por cliente
	select codcliente,count(*) as total
	from   Telefono
	where  estado=1
	group by codcliente
),
	cte_rc as
(
	--Contratos activos por cliente
	select codcliente,count(*) as total
	from   Contrato
	where  estado=1
	group by codcliente
)
select c.codcliente as [COD-CLIENTE],
	   upper(rtrim(ltrim(c.nombres+' '+c.ape_paterno+' '+c.ape_materno))) as CLIENTE,
	   isnull(rt.total,0) as [TOT-TE],
	   isnull(rc.total,0) as [TOT-CO]
from Cliente c
left join cte_rt rt on c.codcliente=rt.codcliente
left join cte_rc rc on c.codcliente=rc.codcliente
where tipo_cliente='P'
order by [TOT-TE],[TOT-CO]

--VISTAS
create view vw_ReporteCliente
as
with cte_rt as
(
    --Teléfonos activos por cliente
	select codcliente,count(*) as total
	from   Telefono
	where  estado=1
	group by codcliente
),
	cte_rc as
(
	--Contratos activos por cliente
	select codcliente,count(*) as total
	from   Contrato
	where  estado=1
	group by codcliente
)
select c.codcliente as [COD-CLIENTE],
	   upper(rtrim(ltrim(c.nombres+' '+c.ape_paterno+' '+c.ape_materno))) as CLIENTE,
	   isnull(rt.total,0) as [TOT-TE],
	   isnull(rc.total,0) as [TOT-CO]
from Cliente c
left join cte_rt rt on c.codcliente=rt.codcliente
left join cte_rc rc on c.codcliente=rc.codcliente
where tipo_cliente='P'

select * from vw_ReporteCliente
order by [TOT-TE],[TOT-CO]

go

create view vw_ReporteCliente_v2
as
select c.codcliente as [COD-CLIENTE],
	   upper(rtrim(ltrim(c.nombres+' '+c.ape_paterno+' '+c.ape_materno))) as CLIENTE,
	   isnull(rt.total,0) as [TOT-TE],
	   isnull(rc.total,0) as [TOT-CO]
from Cliente c
left join
(
    --Teléfonos activos por cliente
	select codcliente,count(*) as total
	from   Telefono
	where  estado=1
	group by codcliente
) rt on c.codcliente=rt.codcliente
left join
(
	--Contratos activos por cliente
	select codcliente,count(*) as total
	from   Contrato
	where  estado=1
	group by codcliente
) rc on c.codcliente=rc.codcliente
where tipo_cliente='P'

select * from vw_ReporteCliente_v2 
where CLIENTE LIKE '%MAN%'
order by [TOT-TE],[TOT-CO]

--FUNCION_VALOR_TABLA

with cte_rt as
(
    --Teléfonos activos por cliente
	select codcliente,count(*) as total
	from   Telefono
	where  estado=1
	group by codcliente
),
	cte_rc as
(
	--Contratos activos por cliente
	select codcliente,count(*) as total
	from   Contrato
	where  estado=1
	group by codcliente
)
select c.codcliente as [COD-CLIENTE],
	   upper(rtrim(ltrim(c.nombres+' '+c.ape_paterno+' '+c.ape_materno))) as CLIENTE,
	   isnull(rt.total,0) as [TOT-TE],
	   isnull(rc.total,0) as [TOT-CO]
from Cliente c
left join cte_rt rt on c.codcliente=rt.codcliente
left join cte_rc rc on c.codcliente=rc.codcliente
where tipo_cliente='P'
order by [TOT-TE],[TOT-CO]