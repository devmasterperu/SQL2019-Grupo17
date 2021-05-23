--04.03

--NOCHECK CONSTRAINT HABILITADO

--select * from Zona
--where codubigeo=18

SET IDENTITY_INSERT Zona ON --Habilitar inserción sobre columna IDENTITY indep. NOCHECK HAB.

insert into Zona(codzona,nombre,estado,codubigeo)
values
(12,'CAJATAMBO-A',1,18),
(13,'CAJATAMBO-B',1,18),
(14,'CAJATAMBO-C',1,18)

SET IDENTITY_INSERT Zona OFF--Deshabilitar inserción sobre columna IDENTITY indep. NOCHECK HAB.

--04.05

/*
BEGIN TRAN --COLOCAR SIEMPRE
	Delete from Cliente
	output deleted.codcliente
	where codcliente=1
ROLLBACK   --COLOCAR SIEMPRE


BEGIN TRAN
	Update c
	set  estado=0
	from Cliente c
	where codcliente>1
ROLLBACK
*/
--select * from Cliente

--Validar info
select * from Telefono
where codcliente=18 and tipo<>'LLA'

BEGIN TRAN
	delete t
	output deleted.tipo,deleted.numero
	from Telefono t
	where codcliente=18 and tipo<>'LLA'
ROLLBACK

--04.07

select co.* from Contrato co
inner join Cliente c on co.codcliente=c.codcliente and c.tipo_cliente='P' and c.estado=0
inner join Zona z on c.codzona=z.codzona
inner join Ubigeo u on z.codubigeo=u.codubigeo and u.cod_dpto='15' and u.cod_prov='08' and u.cod_dto='01'

BEGIN TRAN
	delete co
	output deleted.codcliente,deleted.codplan
	from  Contrato co
	inner join Cliente c on co.codcliente=c.codcliente and c.tipo_cliente='P' and c.estado=0
	inner join Zona z on c.codzona=z.codzona
	inner join Ubigeo u on z.codubigeo=u.codubigeo and u.cod_dpto='15' and u.cod_prov='08' and u.cod_dto='01'
ROLLBACK

--04.09

select numdoc,nombres,ape_paterno,ape_materno,fec_nacimiento,sexo,email,direccion 
from   Cliente
where  codcliente=500

BEGIN TRAN
	--BEGIN TRAN
		update c
		set    numdoc='46173399',nombres='DOMITILA CAMILA',ape_paterno='MANRIQUE',ape_materno='MORALES',
			   fec_nacimiento='1980-01-09',sexo='F',email='DOMITILA_LOPEZ@GMAIL.COM',direccion='URB. LOS CIPRESES M-24' 
		output deleted.numdoc,inserted.numdoc,deleted.ape_paterno,inserted.ape_paterno
		from   Cliente c
		where  codcliente=500
	--COMMIT
ROLLBACK

--04.11

select * from Contrato

alter table Contrato add precionuevosol decimal(6,2) /*El nuevo precio calculado debe ser almacenado en la tabla contrato*/

select * from Contrato
where periodo='Q' and codplan in (1,2,3,4,5,8) --0.95*precioref

select * from Contrato
where periodo='M' and codplan in (1,2,3,4,5,8) --0.90*precioref

											   --0.98*precioref

select co.*,p.precioref,
case 
	when co.periodo='Q' and co.codplan in (1,2,3,4,5,8) then 0.95*p.precioref
	when co.periodo='M' and co.codplan in (1,2,3,4,5,8) then 0.90*p.precioref
	else 0.98*p.precioref
end as precionuevosol,
co.precionuevosol
from Contrato co
join PlanInternet p on co.codplan=p.codplan

BEGIN TRAN

	Update co
	set  precionuevosol= case 
							when co.periodo='Q' and co.codplan in (1,2,3,4,5,8) then 0.95*p.precioref
							when co.periodo='M' and co.codplan in (1,2,3,4,5,8) then 0.90*p.precioref
							else 0.98*p.precioref
						 end
	output deleted.precionuevosol,inserted.precionuevosol
	from Contrato co
	join PlanInternet p on co.codplan=p.codplan

ROLLBACK

--Quiénes son los clientes a los cuales no les conviene este nuevo precio
select codcliente,codplan,preciosol,precionuevosol
from Contrato
where precionuevosol>preciosol

--Quiénes son los clientes detectados con un diferencial de S/50.00 a más entre el nuevo precio y el precio actual?
select codcliente,codplan,preciosol,precionuevosol,precionuevosol-preciosol as diferencial
from   Contrato
where  precionuevosol-preciosol>=50

select codcliente,codplan,preciosol,precionuevosol,diferencial
from
(
	select codcliente,codplan,preciosol,precionuevosol,precionuevosol-preciosol as diferencial
	from   Contrato
) rc
where diferencial>=50