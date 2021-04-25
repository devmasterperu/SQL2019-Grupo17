/*Cálculos TSQL*/

declare @num1 int=11,@num2 int=5

select @num1+@num2,@num1-@num2,@num1*@num2,@num1/@num2,@num1%@num2

select @num1+@num2
select @num1-@num2
select @num1*@num2
select @num1/@num2
select @num1%@num2

--02.01

--POWER: select POWER(5,4)

declare @n1 int=5,@n2 int=7

select 'F(n1,n2)'=power(@n1,2)+10*@n1*@n2+power(@n2,2)

--ELEMENTOS_SELECT

--select codubigeo from Zona

--select codubigeo,count(codzona) as total
--from  Zona
--where estado=1
--group by codubigeo
--having count(codzona)>1
--order by total desc

--02.03

select nom_dpto from Ubigeo          --Seleccionar los departamentos de la tabla Ubigeo
select distinct nom_dpto from Ubigeo --Seleccionar los diferentes departamentos de la tabla Ubigeo

select codubigeo from Zona 
select distinct codubigeo from Zona 

select codubigeo,estado from Zona 
select distinct codubigeo,estado from Zona 

select nom_dpto,nom_prov from Ubigeo      
select distinct nom_dpto,nom_prov from Ubigeo 

--ALIAS_TABLAS_COLUMNAS

select codubigeo as [CODIGO UBIGEO],nom_dpto as NOMBRE_DPTO,nom_prov NOMBRE_PROV,'NOMBRE_DTO'=nom_dto 
from   Ubigeo   

select ubi.codubigeo as [CODIGO UBIGEO],ubi.nom_dpto as NOMBRE_DPTO,ubi.nom_prov NOMBRE_PROV,'NOMBRE_DTO'=ubi.nom_dto 
from   Ubigeo as ubi

select ubi.codubigeo as [CODIGO UBIGEO],ubi.nom_dpto as NOMBRE_DPTO,ubi.nom_prov NOMBRE_PROV,'NOMBRE_DTO'=ubi.nom_dto 
from   Ubigeo ubi

--02.04

select nombre as ZONA,codubigeo as 'CODIGO UBIGEO',estado as ESTADO,
case when estado=1 then 'Zona activa'
	 else 'Zona inactiva'
end as 'MENSAJE ESTADO'
from  Zona
where codubigeo=1

--02.05

select 'Curso '+'Base Datos desde CERO'
select '15'+'08'+'01'

select cod_dpto+cod_prov+cod_dto 
from   Ubigeo

--02.06

--select cast(round(13.287270794,3) as decimal(6,2))

declare @tcv decimal(6,3)=3.763

select nombre as [PLAN],precioref as [PRECIO_SOL],
--precioref/@tcv as PRECIO_DOL_0,
cast(round(precioref/@tcv,2) as decimal(6,2))  as PRECIO_DOL,
case when precioref>=0  and precioref<70  then '[0,70>'
	 when precioref>=70 and precioref<100 then '[70,100>'
	 when precioref>=100                  then '[100, +>'
else 'SIN ESPECIFICAR'
end as RANGO_SOL
from PlanInternet

--02.08

select codzona as CODZONA,nombre as ZONA,codubigeo as 'CODIGO UBIGEO',estado as ESTADO,
case when estado=1 then 'Zona activa'
	 else 'Zona inactiva'
end as 'MENSAJE ESTADO'
from  Zona
--where Estado=1 AND codubigeo=1 order by CODZONA desc   --a. Ordenados por codzona de mayor a menor
--where Estado=1 AND codubigeo=1 order by nombre desc    --b. Ordenados por nombre alfabéticamente Z-A
--where   estado=0 OR codubigeo=1 order by estado asc    --c. Ordenados por estado de menor a mayor
/*where   estado=0 OR codubigeo=1 
order by codubigeo desc,                                 --d. Ordenados por codubigeo de mayor a menor en 1° nivel y 
		 nombre asc		                           */	 --   nombre de manera alfabética A-Z en 2° nivel
--where NOT(estado=1 AND codubigeo=1)      
where NOT(estado=1) OR NOT(codubigeo=1)     
order by codzona asc                                     --e. Ordenados por codzona de menor a mayor.

--02.09

select * from Cliente

--02.10

select codtipo as TIPO_DOC,numdoc as NUM_DOC,razon_social as RAZON_SOCIAL,codzona as CODZONA,fec_inicio as FEC_INICIO,tipo_cliente
from Cliente
--where tipo_cliente='E' and (codzona=1 or codzona=3 or codzona=5 or codzona=7)
/*a.Tipo_cliente=’E’ [Y] codzona de valor 1,3,5 o 7 ordenados alfabéticamente Z-A por razón_social*/
--where tipo_cliente='E' and codzona in (1,3,5,7) 
/*b.Tipo_cliente=’E’ [Y] fec_inicio desde el ‘01/01/1998’ al ‘31/12/1998’ 
ordenados por fec_inicio del más reciente al más antiguo*/
where tipo_cliente='E' and fec_inicio between '1998-01-01' and '1998-12-31'
order by RAZON_SOCIAL desc