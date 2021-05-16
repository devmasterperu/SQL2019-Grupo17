--03.01

--a
select codcliente from Cliente --1000
select codplan    from PlanInternet --5

select codcliente,codplan
from   Cliente
cross join PlanInternet

--b
select codcliente from Cliente where tipo_cliente='E'--400
select codplan    from PlanInternet --5

select codcliente,codplan
from   Cliente
cross join PlanInternet
where tipo_cliente='E'

--c. Códigos de clientes y códigos de planes (Clientes persona y planes cuyo nombre contiene ‘OLD’).

select codcliente from Cliente where tipo_cliente='P'--600
select codplan    from PlanInternet where nombre like '%OLD%'--3

select codcliente,nombre
from Cliente cross join PlanInternet
where tipo_cliente='P' and nombre like '%OLD%'

--03.02

select codzona as CODZONA,
nombre as ZONA,
estado as ESTADO,
Ubigeo.cod_dpto+Ubigeo.cod_prov+Ubigeo.cod_dto as UBIGEO,
--La Zona HUACHO-I del ubigeo 150801 se encuentra ACTIVA.
'La Zona '+ nombre +' del ubigeo '+ Ubigeo.cod_dpto+Ubigeo.cod_prov+Ubigeo.cod_dto+ ' se encuentra '+ IIF(estado=0,'ACTIVA','INACTIVA') as MENSAJE,
Zona.codubigeo,
Ubigeo.codubigeo
from Zona inner join Ubigeo 
on Zona.codubigeo=Ubigeo.codubigeo

select 
'Z'+cast(codzona as varchar(100)) as CODZONA,
nombre as ZONA,
estado as ESTADO,
u.cod_dpto+u.cod_prov+u.cod_dto as UBIGEO,
'La Zona '+ nombre +' del ubigeo '+ u.cod_dpto+u.cod_prov+u.cod_dto+ ' se encuentra '+ IIF(estado=1,'ACTIVA','INACTIVA') as MENSAJE,
z.codubigeo,
u.codubigeo
from Zona z inner join Ubigeo u
on z.codubigeo=u.codubigeo

--03.04

select top(100)
t.desc_corta as TIPO_DOC,numdoc as NUM_DOC,
concat(rtrim(ltrim(nombres)),' ',rtrim(ltrim(ape_paterno)),' ',rtrim(ltrim(ape_materno))) as [NOMBRE COMPLETO],
fec_nacimiento as FECHA_NAC,
direccion as DIRECCION,
z.nombre as ZONA
from Cliente c 
inner join TipoDocumento t on c.codtipo=t.codtipo
inner join Zona z on c.codzona=z.codzona
where c.tipo_cliente='P' and c.estado=1
order by  [NOMBRE COMPLETO] asc

select 
t.desc_corta as TIPO_DOC,numdoc as NUM_DOC,
concat(rtrim(ltrim(nombres)),' ',rtrim(ltrim(ape_paterno)),' ',rtrim(ltrim(ape_materno))) as [NOMBRE COMPLETO],
fec_nacimiento as FECHA_NAC,
direccion as DIRECCION,
z.nombre as ZONA
from Cliente c,TipoDocumento t,Zona z
where c.tipo_cliente='P' and c.estado=1 and c.codtipo=t.codtipo and c.codzona=z.codzona

select * from Contrato co
inner join Cliente c on co.codcliente=c.codcliente
inner join Zona z on c.codzona=z.codzona

--03.06

--select case 
--when z.codzona=1 then 'HUACHO-I'
--when z.codzona=2 then 'HUACHO-II'
--end
--from Zona z

select t.tipo as TIPO,t.numero as NUMERO,t.codcliente as COD_CLIENTE,c.codcliente as COD_CLIENTE,
c.razon_social as EMPRESA,z.nombre as ZONA
from Telefono t
inner join Cliente c on t.codcliente=c.codcliente --and t.estado=1 and c.tipo_cliente='E'
inner join Zona z on c.codzona=z.codzona
where t.estado=1      --Teléfonos en estado activo
and c.tipo_cliente='E'--Clientes empresa
order by c.codcliente asc

--03.08

select t.tipo as TIPO,t.numero as NUMERO,
	  case 
	  when c.tipo_cliente='P' then concat(rtrim(ltrim(c.nombres)),' ',rtrim(ltrim(c.ape_paterno)),' ',rtrim(ltrim(c.ape_materno)))
	  when c.tipo_cliente='E' then c.razon_social
	  else 'SIN DETALLE' 
	  end as CLIENTE,
	  isnull(c.email,'SIN DETALLE') as EMAIL,
	  convert(varchar(8),getdate(),112) as FEC_CONSULTA,--Formato ISO
	  convert(varchar(8),getdate(),110) as FEC_CONSULTA--Formato ISO
from Telefono t
left join Cliente c on t.codcliente=c.codcliente --and t.estado=1
where t.estado=1 

--03.10

--LEFT JOIN
select co.codcliente as 'CODIGO CLIENTE',isnull(p.nombre,'SIN DATO') as 'NOMBRE PLAN',
isnull(p.precioref,0.00) as 'PRECIO PLAN',
co.preciosol as 'PRECIO CONTRATO',co.fec_contrato as 'FECHA CONTRATO'
from Contrato co
left join PlanInternet p on co.codplan=p.codplan
order by p.nombre asc

--RIGHT JOIN
select co.codcliente as 'CODIGO CLIENTE',isnull(p.nombre,'SIN DATO') as 'NOMBRE PLAN',
isnull(p.precioref,0.00) as 'PRECIO PLAN',
co.preciosol as 'PRECIO CONTRATO',co.fec_contrato as 'FECHA CONTRATO'
from PlanInternet p 
right join Contrato co on co.codplan=p.codplan
order by p.nombre asc

--03.12

select isnull(c.codcliente,0) as 'CLIENTE_CODCLIENTE',
	  case 
	  when c.tipo_cliente='P' then concat(rtrim(ltrim(c.nombres)),' ',rtrim(ltrim(c.ape_paterno)),' ',rtrim(ltrim(c.ape_materno)))
	  when c.tipo_cliente='E' then c.razon_social
	  else 'SIN DATO' 
	  end as 'CLIENTE NOMBRE',
	  lower(isnull(c.email,'SIN DATO')) as 'CLIENTE CORREO',
	  isnull(co.codcliente,0) as 'CONTRATO CODLCLIENTE',
	  isnull(p.nombre,'SIN DATO') as 'CONTRATO PLAN',
	  isnull(co.fec_contrato,'9999-12-31') as 'CONTRATO FECHA'
/*mostrarse los clientes independientemente de contar o no con contratos relacionados y los contratos,
independientemente de contar o no con clientes relacionados*/
from Contrato co
full join Cliente c on co.codcliente=c.codcliente 
/*contratos independientemente de contar con plan de internet relacionado*/
left join PlanInternet p on co.codplan=p.codplan
order by isnull(co.codcliente,0) asc


--SELF_JOIN
USE TSQL
go

--ALTER TABLE [HR].[Employees]  WITH CHECK ADD  CONSTRAINT [FK_Employees_Employees] FOREIGN KEY([mgrid])
--REFERENCES [HR].[Employees] ([empid])
--GO

--Relación de empleados y jefes

select emp1.empid,emp1.lastname,emp1.firstname,emp1.title,emp2.lastname,emp2.firstname,emp2.title
from HR.Employees emp1
left join HR.Employees emp2 on emp1.mgrid=emp2.empid