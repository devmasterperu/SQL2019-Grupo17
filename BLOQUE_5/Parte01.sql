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
	   (select count(*) from Contrato co) as TOTAL_0,
       (select count(*) from Contrato co where co.codplan=p.codplan) as TOTAL,
	   case 
		when (select count(*) from Contrato co where co.codplan=p.codplan) between 0  and  99 then 'Plan de baja demanda'
		when (select count(*) from Contrato co where co.codplan=p.codplan) between 100 and 199 then 'Plan de mediana demanda'
		when (select count(*) from Contrato co where co.codplan=p.codplan)>200 then 'Plan de alta demanda'
		else 'No es posible el mensaje'
		end as MENSAJE
from   PlanInternet p