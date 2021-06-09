--06.01

--TABLAS_DERIVADAS
select co.codplan, codcliente,preciosol,
	   rc.PRE_SUM,
	   rc.PRE_PROM,
	   rc.PRE_TOT,
	   rc.PRE_MIN,
	   rc.PRE_MAX
from Contrato co
left join
(
	select codplan,sum(preciosol) as PRE_SUM,avg(preciosol) as PRE_PROM,
	count(*) as PRE_TOT,min(preciosol) as PRE_MIN,max(preciosol) as PRE_MAX
	from Contrato
	group by codplan
) rc on co.codplan=rc.codplan
order by co.codplan, preciosol

--OVER+FUNCIONES_AGRUPAMIENTO

select co.codplan, codcliente,preciosol,
	   sum(preciosol) over(partition by codplan) as PRE_SUM,
	   avg(preciosol) over(partition by codplan) as PRE_PROM,
	   count(*) over(partition by codplan) as PRE_TOT,
	   min(preciosol) over(partition by codplan) as PRE_MIN,
	   max(preciosol) over(partition by codplan) as PRE_MAX
from Contrato co
order by co.codplan, preciosol

--VISTAS
create view vw_ResContrato 
as
select co.codplan, codcliente,preciosol,
	   sum(preciosol) over(partition by codplan) as PRE_SUM,
	   avg(preciosol) over(partition by codplan) as PRE_PROM,
	   count(*) over(partition by codplan) as PRE_TOT,
	   min(preciosol) over(partition by codplan) as PRE_MIN,
	   max(preciosol) over(partition by codplan) as PRE_MAX
from Contrato co

select * from vw_ResContrato
order by codplan, preciosol

--06.03

select codcliente,razon_social,fec_inicio,
row_number() OVER(order by fec_inicio asc) as RN,
rank() OVER(order by fec_inicio asc) as RK,
dense_rank() OVER(order by fec_inicio asc) as DRK,
NTILE(5) OVER(order by fec_inicio asc) as N5
from Cliente
where tipo_cliente='E'
order by fec_inicio asc

--FUNCIONES_VALOR_TABLA

create function uf_rkClienteE() returns table
as return
	select codcliente,razon_social,fec_inicio,
	row_number() OVER(order by fec_inicio asc) as RN,
	rank() OVER(order by fec_inicio asc) as RK,
	dense_rank() OVER(order by fec_inicio asc) as DRK,
	NTILE(5) OVER(order by fec_inicio asc) as N5
	from Cliente
	where tipo_cliente='E'

select * from uf_rkClienteE()
order by fec_inicio asc