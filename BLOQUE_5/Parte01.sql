--05.01

select count(*)               --Consulta_01 (El total de contratos)
from   Contrato 

select count(*)               --Consulta_02 (El total de contratos pertenecientes a clientes empresa)
from   Contrato co 
join   Cliente c on co.codcliente=c.codcliente
where  c.tipo_cliente='E'    

select count(*)               --Consulta_03 (El total de contratos pertenecientes a clientes persona)
from   Contrato co 
join   Cliente c on co.codcliente=c.codcliente
where  c.tipo_cliente='P'    

select count(*)               --Consulta_04 (El total de contratos pertenecientes a clientes de tipo desconocido)
from   Contrato co 
left join Cliente c on co.codcliente=c.codcliente
where  c.tipo_cliente is NULL

/*SUBCONSULTA_SELECT*/

select count(*) as TOT_C,             --Consulta_01 (El total de contratos)
	   (select count(*)               --Consulta_02 (El total de contratos pertenecientes a clientes empresa)
		from   Contrato co 
		join   Cliente c on co.codcliente=c.codcliente
		where  c.tipo_cliente='E') as TOT_C_E,
	   (select count(*)               --Consulta_03 (El total de contratos pertenecientes a clientes persona)
		from   Contrato co 
		join   Cliente c on co.codcliente=c.codcliente
		where  c.tipo_cliente='P') as TOT_C_P,
	    (select count(*)               --Consulta_04 (El total de contratos pertenecientes a clientes de tipo desconocido)
		from   Contrato co 
		left join Cliente c on co.codcliente=c.codcliente
		where  c.tipo_cliente is NULL) as TOT_C_O	
from   Contrato 

select count(*) as TOT_C,             --Consulta_01 (El total de contratos)
		(select count(*)              --Consulta_04 (El total de contratos pertenecientes a clientes de tipo desconocido)
		from   Contrato co 
		left join Cliente c on co.codcliente=c.codcliente
		where  c.tipo_cliente is NULL) as TOT_C_O,	
	   (select count(*)               --Consulta_02 (El total de contratos pertenecientes a clientes empresa)
		from   Contrato co 
		join   Cliente c on co.codcliente=c.codcliente
		where  c.tipo_cliente='E') as TOT_C_E,
	   (select count(*)               --Consulta_03 (El total de contratos pertenecientes a clientes persona)
		from   Contrato co 
		join   Cliente c on co.codcliente=c.codcliente
		where  c.tipo_cliente='P') as TOT_C_P
from   Contrato 

--05.03

select replace(upper(nombre),' ','_') as [PLAN],p.codplan,
	   (select count(*) from Contrato co) as TOTAL_0,                         --CI
       (select count(*) from Contrato co where co.codplan=p.codplan) as TOTAL,--CI
	   case 
		when (select count(*) from Contrato co where co.codplan=p.codplan) between 0  and  99 then 'Plan de baja demanda'
		when (select count(*) from Contrato co where co.codplan=p.codplan) between 100 and 199 then 'Plan de mediana demanda'
		when (select count(*) from Contrato co where co.codplan=p.codplan)>=200 then 'Plan de alta demanda'
		else 'No es posible el mensaje'
		end as MENSAJE--CI
from   PlanInternet p --CE

--05.05

select cast(round(8*1.00/3,2) as decimal(6,2))

select replace(upper(nombre),' ','_') as [PLAN],p.codplan,
       (select count(*) from Contrato co where co.codplan=p.codplan) as TOTAL_P, --CI
	   (select count(*) from Contrato co) as TOTAL,                              --CI
	   cast(
		   round(
			   (select count(*) from Contrato co where co.codplan=p.codplan)*100.00/
			   (select count(*) from Contrato co),
			   2)
		   as decimal(6,2)
	   )
	   as PORCENTAJE
from   PlanInternet p --CE

--05.06

select desc_larga as TIPO_DOCUMENTO,320,899,cast(round(320*100.00/899,2) as decimal(6,2))
from TipoDocumento