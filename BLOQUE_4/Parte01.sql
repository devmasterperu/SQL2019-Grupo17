--04.01

--(I)
insert into dbo.PlanInternet 
--nombre|precioref|descripcion
output inserted.codplan --Opcional
values ('GOLD IV',110.00,'Solicitado por comité junio 2020 - Responsable Comercial: Felix Manrique')

--(SSMS)

--(II)
insert into dbo.PlanInternet 
--nombre|precioref|descripcion
output inserted.codplan,inserted.nombre --Opcional
values 
('PREMIUM II',140.00,'Solicitado por comité junio 2020 - Responsable Comercial: SOFÍA VALENTÍN'),
('PREMIUM III',160.00,'Solicitado por comité junio 2020 - Responsable Comercial: LUIS ULLOA'),
('PREMIUM IV',180.00,'Solicitado por comité junio 2020 - Responsable Comercial: MARÍA MORALES')

--(III)
insert into dbo.PlanInternet(precioref,descripcion,nombre)
output inserted.codplan,inserted.nombre --Opcional
values 
(190.00,'Solicitado por comité junio 2020','STAR I')

--(IV)
/*Registrar un valor por defecto aún cuando no sea indicado*/
alter table dbo.PlanInternet add fechoraregistro datetime default getdate()

insert into dbo.PlanInternet(precioref,descripcion,nombre)
output inserted.codplan,inserted.nombre,inserted.fechoraregistro --Opcional
values 
(200.00,'Solicitado por comité junio 2020','STAR II')

select * from dbo.PlanInternet

/*Registrar un valor por defecto aún cuando no sea indicado*/
alter table dbo.PlanInternet add estado bit default 0

insert into dbo.PlanInternet(precioref,descripcion,nombre,fechoraregistro)
output inserted.codplan,inserted.nombre,inserted.fechoraregistro --Opcional
values 
(210.00,'Solicitado por comité junio 2020','STAR III','2021-05-16 13:17:00.000')

--04.02

--(a)-(V)
--Destino: Zona(codzona|nombre|estado|codubigeo)
insert into Zona(nombre,estado,codubigeo)
output inserted.codzona,inserted.nombre
--Origen:  Zona_Carga
select nombre,1 as estado, u.codubigeo
from   Zona_Carga zc
join   Ubigeo u 
on     zc.departamento=u.nom_dpto and 
       zc.provincia=u.nom_prov    and 
	   zc.distrito=u.nom_dto
where  estado='ACTIVO'

select top 1 * from Zona
select * from Zona_Carga where estado='ACTIVO'

--(b)-(VI)
--Destino: Zona(codzona|nombre|estado|codubigeo)
insert into Zona(nombre,estado,codubigeo)
--Origen:  Zona_Carga
execute usp_SelZonaCarga

--create procedure usp_SelZonaCarga
alter procedure usp_SelZonaCarga
as
select nombre,0 as estado, u.codubigeo
from   Zona_Carga zc
join   Ubigeo u 
on     zc.departamento=u.nom_dpto and 
       zc.provincia=u.nom_prov    and 
	   zc.distrito=u.nom_dto
where  estado='INACTIVO'

--Validación
select * from Zona_Carga

--(c)-(VI)
alter procedure usp_SelZonaCarga
as
select nombre,0 as estado, u.codubigeo
from   Zona_Carga zc
join   Ubigeo u 
on     zc.departamento=u.nom_dpto and 
       zc.provincia=u.nom_prov    and 
	   zc.distrito=u.nom_dto
where  estado is NULL

execute usp_SelZonaCarga

--Destino: Zona(codzona|nombre|estado|codubigeo)
insert into Zona(nombre,estado,codubigeo)
--Origen:  Zona_Carga
execute usp_SelZonaCarga

--(c) - Procedure Optimizado
alter procedure usp_SelZonaCargaV2 (@estado varchar(10))
as
if @estado is null
begin
	select nombre,
		   case 
		   when estado='ACTIVO'   then 1 
		   when estado='INACTIVO' then 0
		   else 0 end as estado, 
		   u.codubigeo
	from   Zona_Carga zc
	join   Ubigeo u 
	on     zc.departamento=u.nom_dpto and 
		   zc.provincia=u.nom_prov    and 
		   zc.distrito=u.nom_dto
	where  estado is null

end
else
begin 
	select nombre,
		   case 
		   when estado='ACTIVO'   then 1 
		   when estado='INACTIVO' then 0
		   else 0 end as estado, 
		   u.codubigeo
	from   Zona_Carga zc
	join   Ubigeo u 
	on     zc.departamento=u.nom_dpto and 
		   zc.provincia=u.nom_prov    and 
		   zc.distrito=u.nom_dto
	where  estado=@estado
end

execute usp_SelZonaCargaV2 NULL

select nombre,0 as estado, u.codubigeo
from   Zona_Carga zc
join   Ubigeo u 
on     zc.departamento=u.nom_dpto and 
       zc.provincia=u.nom_prov    and 
	   zc.distrito=u.nom_dto
where  estado is NULL

--04.03
