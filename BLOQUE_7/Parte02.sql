--07.05

--Tabla Configuración

create table dbo.Configuracion
(
codigo    int identity(1,1) primary key,
parametro varchar(1000) not null,
valor     varchar(max)  not null
)

truncate table dbo.Configuracion

insert into dbo.Configuracion
values ('RAZON_SOCIAL_DEVWIFI','DEV MASTER PERU SAC')

insert into dbo.Configuracion
values ('RUC_DEVWIFI','20602275320')

insert into dbo.Configuracion
values ('FEC_INICIO','20170701')

--Parámetros

select valor 
from   dbo.Configuracion
where  parametro='RAZON_SOCIAL_DEVWIFI'

select valor 
from   dbo.Configuracion
where  parametro='RUC_DEVWIFI'

--Variables

declare @codcliente int=100

/*No existe algún cliente de la tabla Cliente con codcliente=@codcliente*/
if not exists(select codcliente from Cliente where codcliente=@codcliente)
begin
	select 'El cliente no ha sido encontrado en la Base de Datos'
end
else
begin
	select 'Razon Social:'=
			(select valor from   dbo.Configuracion where  parametro='RAZON_SOCIAL_DEVWIFI'),--DEV MASTER PERU SAC
			'RUC:'=
			(select valor from   dbo.Configuracion where  parametro='RUC_DEVWIFI'),--20602275320
		    'Consulta al:'=getdate(),
	        'Cliente:'=coalesce(c.razon_social,concat(c.nombres,' ',c.ape_paterno,' ',c.ape_materno),'SIN DETALLE'),
	        'Dirección:'=c.direccion,
		    'Zona:'=z.nombre
	from     Cliente c
	left join Zona z on c.codzona=z.codzona
	where  codcliente=@codcliente
end

--Procedimiento almacenado

create procedure USP_SELCLIENTE(@codcliente int)
as
begin

	if not exists(select codcliente from Cliente where codcliente=@codcliente)
	begin
		select 'El cliente no ha sido encontrado en la Base de Datos'
	end
	else
	begin
		select 'Razon Social:'=
				(select valor from   dbo.Configuracion where  parametro='RAZON_SOCIAL_DEVWIFI'),
				'RUC:'=
				(select valor from   dbo.Configuracion where  parametro='RUC_DEVWIFI'),
				'Consulta al:'=getdate(),
				'Cliente:'=coalesce(c.razon_social,concat(c.nombres,' ',c.ape_paterno,' ',c.ape_materno),'SIN DETALLE'),
				'Dirección:'=c.direccion,
				'Zona:'=z.nombre
		from     Cliente c
		left join Zona z on c.codzona=z.codzona
		where  codcliente=@codcliente
	end

end

execute USP_SELCLIENTE @codcliente=900

--07.06

--Variables

declare @cod_dpto varchar(2)='99',
	    @nom_dpto varchar(50)='DUMMY',
		@cod_prov varchar(2)='99',
		@nom_prov varchar(50)='DUMMY',
		@cod_dto varchar(2)='98',
		@nom_dto varchar(50)='DUMMY'

if not exists(select codubigeo from Ubigeo where cod_dpto=@cod_dpto and cod_prov=@cod_prov and cod_dto=@cod_dto)
begin 
	
	insert into Ubigeo(cod_dpto,nom_dpto,cod_prov,nom_prov,cod_dto,nom_dto)
	values (@cod_dpto,@nom_dpto,@cod_prov,@nom_prov,@cod_dto,@nom_dto)

	select 'Ubigeo insertado' as mensaje,IDENT_CURRENT('dbo.Ubigeo') as codubigeo
end
else
begin

	select 'Ubigeo existente' as mensaje,0 as codubigeo
end

select cod_dpto,nom_dpto,cod_prov,nom_prov,cod_dto,nom_dto
from   Ubigeo
where  cod_dpto='99'

--Procedimiento almacenado

create procedure USP_INSUBIGEO
(
@cod_dpto varchar(2),
@nom_dpto varchar(50),
@cod_prov varchar(2),
@nom_prov varchar(50),
@cod_dto varchar(2),
@nom_dto varchar(50)
)
as
begin

	if not exists(select codubigeo from Ubigeo where cod_dpto=@cod_dpto and cod_prov=@cod_prov and cod_dto=@cod_dto)
	begin 
	
		insert into Ubigeo(cod_dpto,nom_dpto,cod_prov,nom_prov,cod_dto,nom_dto)
		values (@cod_dpto,@nom_dpto,@cod_prov,@nom_prov,@cod_dto,@nom_dto)

		select 'Ubigeo insertado' as mensaje,IDENT_CURRENT('dbo.Ubigeo') as codubigeo
	end
	else
	begin

		select 'Ubigeo existente' as mensaje,0 as codubigeo
	end

end

execute USP_INSUBIGEO @cod_dpto='99',@nom_dpto='DUMMY',@cod_prov='99',@nom_prov='DUMMY',@cod_dto='97',@nom_dto='DUMMY'

--07.08

select * from Cliente where codcliente=1

/*
codcliente  codtipo     numdoc          tipo_cliente nombres                                            ape_paterno                                        ape_materno                                        sexo fec_nacimiento razon_social                                                                                         fec_inicio direccion                                                                                                                                                                                                email                                                                                                                                                                                                                                                            codzona     estado
----------- ----------- --------------- ------------ -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- ---- -------------- ---------------------------------------------------------------------------------------------------- ---------- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ----------- ------
1           3           79918073966     E            NULL                                               NULL                                               NULL                                               NULL NULL           EMPRESA 1                                                                                            2010-09-26 URB. LOS CIPRESES M-25                                                                                                                                                                                   CONTACTO@EMPRESA1.PE                                                                                                                                                                                                                                             10          0

codcliente  codtipo     numdoc          tipo_cliente nombres                                            ape_paterno                                        ape_materno                                        sexo fec_nacimiento razon_social                                                                                         fec_inicio direccion                                                                                                                                                                                                email                                                                                                                                                                                                                                                            codzona     estado
----------- ----------- --------------- ------------ -------------------------------------------------- -------------------------------------------------- -------------------------------------------------- ---- -------------- ---------------------------------------------------------------------------------------------------- ---------- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ----------- ------
1           3           89918073966     E            NULL                                               NULL                                               NULL                                               NULL NULL           PANADERÍA CHARITO EIRL                                                                               2021-09-26 URB. LOS CIPRESES Z-100                                                                                                                                                                                  info@charito.pe                                                                                                                                                                                                                                                  1           1
*/

--Variables

/*Variables de identificación*/
declare @codcliente int=100,
/*Nuevos valores a actualizar*/
		@codtipo int=3,
		@numdoc varchar(15)='89918073966',
		@razon_social varchar(100)='PANADERÍA CHARITO EIRL',
		@fec_inicio date='2021-09-26',
		@email varchar(320)='info@charito.pe',
		@direccion varchar(200)='URB. LOS CIPRESES Z-100',
		@codzona int=1,
		@estado bit=1

if exists(select codcliente from Cliente c where codcliente=@codcliente and c.tipo_cliente='E')
begin
	update c
	set    c.codtipo=@codtipo,
		   c.numdoc=@numdoc,
		   c.razon_social=@razon_social,
		   c.fec_inicio=@fec_inicio,
		   c.email=@email ,
		   c.direccion=@direccion ,
		   c.codzona=@codzona,
		   c.estado=@estado
	from   Cliente c
	where  codcliente=@codcliente and c.tipo_cliente='E'

	select 'Cliente empresa actualizado' as mensaje,@codcliente as codcliente
end
else
begin
	select 'No es posible identificar al cliente empresa a actualizar' as mensaje,@codcliente as codcliente
end

select * from Cliente where codcliente=100

create procedure USP_UPDClienteEmpresa
(
@codcliente int,
@codtipo int=3,
@numdoc varchar(15),
@razon_social varchar(100),
@fec_inicio date,
@email varchar(320),
@direccion varchar(200),
@codzona int=1,
@estado bit=1
)
as
begin
	
	if exists(select codcliente from Cliente c where codcliente=@codcliente and c.tipo_cliente='E')
	begin
		
		update c
		set    c.codtipo=@codtipo,
			   c.numdoc=@numdoc,
			   c.razon_social=@razon_social,
			   c.fec_inicio=@fec_inicio,
			   c.email=@email ,
			   c.direccion=@direccion ,
			   c.codzona=@codzona,
			   c.estado=@estado
		from   Cliente c
		where  codcliente=@codcliente and c.tipo_cliente='E'
		
		select 'Cliente empresa actualizado' as mensaje,@codcliente as codcliente
	end
	else
	begin
		select 'No es posible identificar al cliente empresa a actualizar' as mensaje,@codcliente as codcliente
	end

end

execute USP_UPDClienteEmpresa
        @codcliente=800,
	    @codtipo=3,
		@numdoc='99918073966',
		@razon_social='PANADERÍA MARVIN EIRL',
		@fec_inicio='2021-09-26',
		@email='info@marvin.pe',
		@direccion='URB. LOS CIPRESES A-5',
		@codzona=2,
		@estado=1

select * from Cliente where codcliente=100

--07.10

create procedure USP_DELTELEFONO (@tipo varchar(4),@numero varchar(15))
as
begin
	if exists(select numero from Telefono where tipo=@tipo and numero=@numero)
	begin
		delete from Telefono
		where tipo=@tipo and numero=@numero

		select 'Teléfono eliminado' as mensaje, @tipo as tipo, @numero as numero
	end
	else
	begin
		select 'No es posible identificar al teléfono a eliminar' as mensaje,'TTT' as tipo,
		       '999999999' as numero
	end

end

exec USP_DELTELEFONO 'LLA','915703551'

exec USP_DELTELEFONO 'SMS','900670335'

select top 10 * from Telefono