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

select * from Telefono t
inner join Cliente c on t.codcliente=c.codcliente --and t.estado=1 and c.tipo_cliente='E'
where t.estado=1 and c.tipo_cliente='E'