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
create function uf_ReporteCliente(@codcliente int,@estado bit) returns table as
return
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
	where tipo_cliente='P' and c.codcliente=@codcliente

--order by [TOT-TE],[TOT-CO]

select * from uf_ReporteCliente(403,null)
order by [TOT-TE],[TOT-CO]

select * from uf_ReporteCliente(404,null)
order by [TOT-TE],[TOT-CO]

--Crear una función de valor tabla que basado en el codigo del plan de internet
--retorne su información.

--No dinámica

select codplan,nombre,precioref
from PlanInternet
where codplan=1

select codplan,nombre,precioref
from PlanInternet
where codplan=2

select codplan,nombre,precioref
from PlanInternet
where codplan=3

--Dinámica con variable

declare @codplan int=4

select codplan,nombre,precioref
from   PlanInternet
where  codplan=@codplan
go

--Dinámica con Función valor tabla

--create function uf_ReportePlan(@codplan int) returns table as
alter function uf_ReportePlan(@codplan int) returns table as
--declare @codplan int=3
return
	select codplan,nombre,precioref,@codplan as codplanv
	from PlanInternet
	where codplan=@codplan

select * from uf_ReportePlan(3)
select * from uf_ReportePlan(4)

--05.10

--TABLAS_DERIVADAS

/*teléfonos por cliente*/

select codcliente,count(*) as total
from  Telefono
group by codcliente

/*teléfonos por cliente del tipo LLA*/

select codcliente,count(*) as total
from  Telefono
where tipo='LLA'
group by codcliente

/*teléfonos por cliente del tipo SMS*/

select codcliente,count(*) as total
from  Telefono
where tipo='SMS'
group by codcliente

/*teléfonos por cliente del tipo WSP*/

select codcliente,count(*) as total
from  Telefono
where tipo='WSP'
group by codcliente

select c.codcliente as CODIGO,razon_social as EMPRESA,
	   isnull(rt.total,0)   as [TOT-TE],
	   isnull(rlla.total,0) as [TOT-LLA],
	   isnull(rsms.total,0) as [TOT-SMS],
	   isnull(rwsp.total,0) as [TOT-WSP]
from   Cliente c
left join
(	/*teléfonos por cliente*/
	select codcliente,count(*) as total
	from  Telefono
	group by codcliente
)   rt on c.codcliente=rt.codcliente
left join
(	/*teléfonos por cliente del tipo LLA*/
	select codcliente,count(*) as total
	from  Telefono
	where tipo='LLA'
	group by codcliente
)   rlla on c.codcliente=rlla.codcliente
left join
(
	/*teléfonos por cliente del tipo SMS*/
	select codcliente,count(*) as total
	from  Telefono
	where tipo='SMS'
	group by codcliente
)   rsms on c.codcliente=rsms.codcliente
left join
(
	/*teléfonos por cliente del tipo WSP*/
	select codcliente,count(*) as total
	from  Telefono
	where tipo='WSP'
	group by codcliente
)   rwsp on c.codcliente=rwsp.codcliente
where  tipo_cliente='E'
order by c.codcliente

--CTES

with cte_rt as
(	/*teléfonos por cliente*/
	select codcliente,count(*) as total
	from  Telefono
	group by codcliente
), cte_rlla as
(	/*teléfonos por cliente del tipo LLA*/
	select codcliente,count(*) as total
	from  Telefono
	where tipo='LLA'
	group by codcliente
), cte_sms as
(
	/*teléfonos por cliente del tipo SMS*/
	select codcliente,count(*) as total
	from  Telefono
	where tipo='SMS'
	group by codcliente
), cte_wsp as 
(
	/*teléfonos por cliente del tipo WSP*/
	select codcliente,count(*) as total
	from  Telefono
	where tipo='WSP'
	group by codcliente
) 
select c.codcliente as CODIGO,razon_social as EMPRESA,
	   isnull(rt.total,0)   as [TOT-TE],
	   isnull(rlla.total,0) as [TOT-LLA],
	   isnull(rsms.total,0) as [TOT-SMS],
	   isnull(rwsp.total,0) as [TOT-WSP]
from   Cliente c
left join cte_rt rt on c.codcliente=rt.codcliente
left join cte_rlla rlla on c.codcliente=rlla.codcliente
left join cte_sms rsms on c.codcliente=rsms.codcliente
left join cte_wsp rwsp on c.codcliente=rwsp.codcliente
where  tipo_cliente='E'
order by [TOT-TE] desc,[TOT-LLA] desc

--VISTAS
create view vw_ReporteTelefono 
as
	with cte_rt as
	(	/*teléfonos por cliente*/
		select codcliente,count(*) as total
		from  Telefono
		group by codcliente
	), cte_rlla as
	(	/*teléfonos por cliente del tipo LLA*/
		select codcliente,count(*) as total
		from  Telefono
		where tipo='LLA'
		group by codcliente
	), cte_sms as
	(
		/*teléfonos por cliente del tipo SMS*/
		select codcliente,count(*) as total
		from  Telefono
		where tipo='SMS'
		group by codcliente
	), cte_wsp as 
	(
		/*teléfonos por cliente del tipo WSP*/
		select codcliente,count(*) as total
		from  Telefono
		where tipo='WSP'
		group by codcliente
	) 
	select c.codcliente as CODIGO,razon_social as EMPRESA,
		   isnull(rt.total,0)   as [TOT-TE],
		   isnull(rlla.total,0) as [TOT-LLA],
		   isnull(rsms.total,0) as [TOT-SMS],
		   isnull(rwsp.total,0) as [TOT-WSP]
	from   Cliente c
	left join cte_rt rt on c.codcliente=rt.codcliente
	left join cte_rlla rlla on c.codcliente=rlla.codcliente
	left join cte_sms rsms on c.codcliente=rsms.codcliente
	left join cte_wsp rwsp on c.codcliente=rwsp.codcliente
	where  tipo_cliente='E'

select * from vw_ReporteTelefono
where CODIGO>100
order by [TOT-TE] desc,[TOT-LLA] desc

--FUNCION_VALOR_TABLA (TAREA)

--05.12

--Precio promedio contratos activos

select avg(preciosol) 
from   Contrato
where  estado=1 --74.262208

--Los contratos con precio actual mayor al precio promedio de los contratos activos

select EOMONTH('2021-06-02',-1)

select coalesce(c.nombres+' '+c.ape_paterno+' '+c.ape_materno,c.razon_social,'SIN DATO') as CLIENTE,
      isnull(p.nombre,'SIN DATO')          as [PLAN],
	  isnull(co.fec_contrato,'9999-12-31') as [FECHA],
	  isnull(co.preciosol,0.00)            as PRECIO,
	  cast(round((select avg(preciosol) from Contrato where  estado=1),2) as decimal(8,2)) as PROMEDIO,
	  EOMONTH(getdate()) as F_CIERRE
from Contrato co
left join Cliente c on co.codcliente=c.codcliente
left join PlanInternet p on co.codplan=p.codplan
where preciosol>(
					select avg(preciosol) 
					from   Contrato
					where  estado=1
				)

--VISTAS

create view vw_ReporteContrato 
as
select coalesce(c.nombres+' '+c.ape_paterno+' '+c.ape_materno,c.razon_social,'SIN DATO') as CLIENTE,
      isnull(p.nombre,'SIN DATO')          as [PLAN],
	  isnull(co.fec_contrato,'9999-12-31') as [FECHA],
	  isnull(co.preciosol,0.00)            as PRECIO,
	  cast(round((select avg(preciosol) from Contrato where  estado=1),2) as decimal(8,2)) as PROMEDIO,
	  EOMONTH(getdate()) as F_CIERRE
from Contrato co
left join Cliente c on co.codcliente=c.codcliente
left join PlanInternet p on co.codplan=p.codplan
where preciosol>(
					select avg(preciosol) 
					from   Contrato
					where  estado=1
				)

select * from vw_ReporteContrato

--FUNCION_VALOR_TABLA
create function uf_ReporteContrato() returns table as
return
	select coalesce(c.nombres+' '+c.ape_paterno+' '+c.ape_materno,c.razon_social,'SIN DATO') as CLIENTE,
		  isnull(p.nombre,'SIN DATO')          as [PLAN],
		  isnull(co.fec_contrato,'9999-12-31') as [FECHA],
		  isnull(co.preciosol,0.00)            as PRECIO,
		  cast(round((select avg(preciosol) from Contrato where  estado=1),2) as decimal(8,2)) as PROMEDIO,
		  EOMONTH(getdate()) as F_CIERRE
	from Contrato co
	left join Cliente c on co.codcliente=c.codcliente
	left join PlanInternet p on co.codplan=p.codplan
	where preciosol>(
						select avg(preciosol) 
						from   Contrato
						where  estado=1
					)

select * from uf_ReporteContrato()
order by PRECIO desc

--Cual es el promedio: 

select avg(precioref) from PlanInternet

--Cuales son los planes de Internet con precioref menor al promedio
select * from PlanInternet
where precioref<(select avg(precioref) from PlanInternet)