--06.05

--Tablas derivadas
select c.codcliente as CODIGO,
upper(concat(rtrim(ltrim(c.nombres)),' ',rtrim(ltrim(c.ape_paterno))+' ',rtrim(ltrim(c.ape_materno)))) as CLIENTE,
codzona as ZONA,
isnull(rt.total,0) AS N_TEL,
row_number() over(partition by c.codzona order by isnull(rt.total,0) asc) as R1,
rank() over(partition by c.codzona order by isnull(rt.total,0) asc) as R2,
dense_rank() over(partition by c.codzona order by isnull(rt.total,0) asc) as R3,
ntile(4) over(partition by c.codzona order by isnull(rt.total,0) asc) as R4
from Cliente c
left join
(
	select codcliente,count(*) as total
	from Telefono
	group by codcliente
) rt on c.codcliente=rt.codcliente
where tipo_cliente='P'
order by ZONA asc,N_TEL asc

--CTE
with CTE_RT as
(
	select codcliente,count(*) as total
	from Telefono
	group by codcliente
) 
select c.codcliente as CODIGO,
upper(concat(rtrim(ltrim(c.nombres)),' ',rtrim(ltrim(c.ape_paterno))+' ',rtrim(ltrim(c.ape_materno)))) as CLIENTE,
codzona as ZONA,
isnull(rt.total,0) AS N_TEL,
row_number() over(partition by c.codzona order by isnull(rt.total,0) asc) as R1,
rank() over(partition by c.codzona order by isnull(rt.total,0) asc) as R2,
dense_rank() over(partition by c.codzona order by isnull(rt.total,0) asc) as R3,
ntile(4) over(partition by c.codzona order by isnull(rt.total,0) asc) as R4
from Cliente c
left join CTE_RT rt on c.codcliente=rt.codcliente
where tipo_cliente='P'
order by ZONA asc,N_TEL asc

--06.07

--Tablas derivadas
select c.codcliente as #,upper(razon_social) as CLIENTE,codzona as ZONA,
       isnull(rc.total,0) as TOTAL,
	   --Es la posición irrepetible por zona. Considerar el total de contratos, de menor a mayor, para generar la posición
	   row_number()      over(partition by c.codzona order by isnull(rc.total,0) asc) as E1,
	   lag(razon_social,1,'SIN DATO') over(partition by c.codzona order by isnull(rc.total,0) asc) as E2,
	   lag(c.codcliente,1,0) over(partition by c.codzona order by isnull(rc.total,0) asc) as E2,
	   lead(razon_social,1,'SIN DATO') over(partition by c.codzona order by isnull(rc.total,0) asc) as E3,
	   lead(razon_social,2,'SIN DATO') over(partition by c.codzona order by isnull(rc.total,0) asc) as E3,
	   first_value(razon_social) over(partition by c.codzona order by isnull(rc.total,0) asc) as E4,
	   last_value(razon_social) over(partition by c.codzona order by isnull(rc.total,0) asc) as E5
from Cliente c
left join
(
	select codcliente,count(*) as total
	from   Contrato
	group by codcliente
) rc on c.codcliente=rc.codcliente
where tipo_cliente='E'
order by ZONA asc,TOTAL asc

--CTE
with CTE_RC as 
(
	select codcliente,count(*) as total
	from   Contrato
	group by codcliente
)
select c.codcliente as #,upper(razon_social) as CLIENTE,codzona as ZONA,
       isnull(rc.total,0) as TOTAL,
	   --Es la posición irrepetible por zona. Considerar el total de contratos, de menor a mayor, para generar la posición
	   row_number()      over(partition by c.codzona order by isnull(rc.total,0) asc) as E1,
	   lag(razon_social,1,'SIN DATO') over(partition by c.codzona order by isnull(rc.total,0) asc) as E2,
	   lag(c.codcliente,1,0) over(partition by c.codzona order by isnull(rc.total,0) asc) as E2,
	   lead(razon_social,1,'SIN DATO') over(partition by c.codzona order by isnull(rc.total,0) asc) as E3,
	   lead(razon_social,2,'SIN DATO') over(partition by c.codzona order by isnull(rc.total,0) asc) as E3,
	   first_value(razon_social) over(partition by c.codzona order by isnull(rc.total,0) asc) as E4,
	   last_value(razon_social) over(partition by c.codzona order by isnull(rc.total,0) asc) as E5
from Cliente c
left join CTE_RC rc on c.codcliente=rc.codcliente
where tipo_cliente='E'
order by ZONA asc,TOTAL asc

--Función Valor Tabla
create function uf_ReporteEmpresa() returns table as
return
	with CTE_RC as 
	(
		select codcliente,count(*) as total
		from   Contrato
		group by codcliente
	)
	select c.codcliente as #,upper(razon_social) as CLIENTE,codzona as ZONA,
		   isnull(rc.total,0) as TOTAL,
		   --Es la posición irrepetible por zona. Considerar el total de contratos, de menor a mayor, para generar la posición
		   row_number()      over(partition by c.codzona order by isnull(rc.total,0) asc) as E1,
		   lag(razon_social,1,'SIN DATO') over(partition by c.codzona order by isnull(rc.total,0) asc) as E2,
		   --lag(c.codcliente,1,0) over(partition by c.codzona order by isnull(rc.total,0) asc) as E2,
		   lead(razon_social,1,'SIN DATO') over(partition by c.codzona order by isnull(rc.total,0) asc) as E3,
		   --lead(razon_social,2,'SIN DATO') over(partition by c.codzona order by isnull(rc.total,0) asc) as E3,
		   first_value(razon_social) over(partition by c.codzona order by isnull(rc.total,0) asc) as E4,
		   last_value(razon_social) over(partition by c.codzona order by isnull(rc.total,0) asc) as E5
	from Cliente c
	left join CTE_RC rc on c.codcliente=rc.codcliente
	where tipo_cliente='E'

select * from uf_ReporteEmpresa()
order by ZONA asc,TOTAL asc

--06.09

--a
with cte_uc as
(
	select cod_dpto as CODIGO_DPTO,cod_prov as CODIGO_PROV,cod_dto as CODIGO_DTO
	from DEVWIFI_17ED.dbo.Ubigeo      --17
	union all
	select cod_dpto as CODIGO_DPTO,cod_prov as CODIGO_PROV,cod_dto as CODIGO_DTO
	from DevWifi2019.comercial.Ubigeo --24
	union all
	select '00' as CODIGO_DPTO,'00' as CODIGO_PROV,'00' as CODIGO_DTO
)
select top 10 * from cte_uc

create view vw_Ubigeos
as
	select cod_dpto as CODIGO_DPTO,cod_prov as CODIGO_PROV,cod_dto as CODIGO_DTO
	from DEVWIFI_17ED.dbo.Ubigeo
	union all
	select cod_dpto as CODIGO_DPTO,cod_prov as CODIGO_PROV,cod_dto as CODIGO_DTO
	from DevWifi2019.comercial.Ubigeo

select * from vw_Ubigeos

--b
create function uf_Ubigeos() returns table as
return
	select cod_dpto as CODIGO_DPTO,cod_prov as CODIGO_PROV,cod_dto as CODIGO_DTO
	from DEVWIFI_17ED.dbo.Ubigeo      --17
	union
	select cod_dpto as CODIGO_DPTO,cod_prov as CODIGO_PROV,cod_dto as CODIGO_DTO
	from DevWifi2019.comercial.Ubigeo --24

select * from uf_Ubigeos()

--06.11

select 'CARLOS','MORALES',30
intersect
select 'CARLOS','MORALES',29

--Consulta 1 Except consulta 2
select 'CARLOS','MORALES',30
except
select 'CARLOS','MORALES',29

--Consulta 2 Except consulta 1
select 'CARLOS','MORALES',29
except
select 'CARLOS','MORALES',30

--a
--Comprobar Intersect
select tipo,numero,codcliente,estado from DEVWIFI_17ED.dbo.Telefono
where tipo='LLA' and numero='945115765' and codcliente=11 and estado=0
intersect
select tipo,numero,codcliente,estado from DevWifi2019.comercial.Telefono
where tipo='LLA' and numero='945115765' and codcliente=11 and estado=0

--CTE
with cte_ti as
(
	select tipo,numero,codcliente,estado from DEVWIFI_17ED.dbo.Telefono
	intersect
	select tipo,numero,codcliente,estado from DevWifi2019.comercial.Telefono
)
select ti.*,
coalesce(c.razon_social,c.nombres+' '+c.ape_paterno+' '+c.ape_materno,'SIN INFO') as CLIENTE,
row_number() over(partition by ti.codcliente order by ti.numero asc) as POSICION
from cte_ti ti
left join Cliente c on ti.codcliente=c.codcliente
order by ti.codcliente, ti.numero asc

--b

--Teléfonos que se encuentran en el esquema 'dbo' pero no en 'comercial'
	
--select tipo,numero,codcliente,estado from DEVWIFI_17ED.dbo.Telefono 
--except
--select tipo,numero,codcliente,estado from DevWifi2019.comercial.Telefono

--Comprobación EXCEPT

select tipo,numero,codcliente,estado from DevWifi2019.comercial.Telefono
except
select tipo,numero,codcliente,estado from DEVWIFI_17ED.dbo.Telefono 

select tipo,numero,codcliente,estado from DevWifi2019.comercial.Telefono
where tipo='SMS' and numero='981214537' and codcliente=9 and estado=0

select tipo,numero,codcliente,estado from DEVWIFI_17ED.dbo.Telefono 
where tipo='SMS' and numero='981214537' and codcliente=9 and estado=0

--CTE
with cte_ti as
(
	--Teléfonos que se encuentran en el esquema 'comercial' pero no en 'dbo'
	select tipo,numero,codcliente,estado from DevWifi2019.comercial.Telefono
	except
	select tipo,numero,codcliente,estado from DEVWIFI_17ED.dbo.Telefono 
)
select ti.*,
coalesce(c.razon_social,c.nombres+' '+c.ape_paterno+' '+c.ape_materno,'SIN INFO') as CLIENTE,
row_number() over(partition by ti.codcliente order by ti.numero asc) as POSICION
from cte_ti ti
left join Cliente c on ti.codcliente=c.codcliente
order by ti.codcliente, ti.numero asc