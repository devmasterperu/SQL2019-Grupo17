--07.01

--Variables: F(N1,N2)=N12+10*N1*N2+N22

declare @N1 int=5,@N2 int=7

select 'F(N1,N2)'=power(@N1,2)+10*@N1*@N2+power(@N2,2)

--Procedimientos almacenados

create or alter procedure dbo.usp_Polinomio(@N1 int,@N2 int)
as
begin
	select 'F(N1,N2)'=power(@N1,2)+10*@N1*@N2+power(@N2,2)
end	

--create or alter procedure dbo.usp_Polinomio(@N1 int,@N2 int)
--as
--begin
--	if @N1>10
--	begin
--		select 'F(N1,N2)'=power(@N1,2)+10*@N1*@N2+power(@N2,2)
--	end
--	else 
--	begin
--		select 'F(N1,N2)'=power(@N1,2)+5*@N1*@N2+power(@N2,2)
--	end
--end	

--Ejecución de procedimientos
exec dbo.usp_Polinomio 5,7
execute dbo.usp_Polinomio 5,7
execute dbo.usp_Polinomio 7,5
execute dbo.usp_Polinomio @N2=7,@N1=5

--Función Escalar

create or alter function dbo.ufn_Polinomio(@N1 int,@N2 int) returns integer
as
begin
	declare @resultado int=(select power(@N1,2)+10*@N1*@N2+power(@N2,2))

	return  @resultado
end	

--create or alter function dbo.ufn_Polinomio(@N1 int,@N2 int) returns integer
--as
--begin
--	declare @resultado int=(select power(@N1,2)+10*@N1*@N2+power(@N2,2))

--	declare @totClientes int=(select count(*) from Cliente)

--	set     @resultado=@totClientes*@resultado+100

--	return  @resultado
--end	

select 'F(N1,N2)'=dbo.ufn_Polinomio(5,7)

--Funcion escalar sobre tabla
select codcliente,codtipo,'F(N1,N2)'=dbo.ufn_Polinomio(codcliente,codtipo) 
from   Cliente

--07.03

--Variables
declare @tipo varchar(4)='LLA',@mensaje varchar(500)='Hola cliente, no olvide realizar el pago de su servicio de Internet'

select *,@mensaje as MENSAJE
--'Hola, no olvide realizar el pago de su servicio de Internet' as MENSAJE,
--'Hola, muchas gracias por su preferencia. Tenemos excelentes promociones para usted' as MENSAJE,
--'Hola, hasta el 15/07 recibe un 20% de descuento en tu facturación' as MENSAJE
from Telefono
where estado=1 and tipo=@tipo

--Procedimientos almacenados

create or alter procedure dbo.USP_REPORTE_TEL(@tipo varchar(4),@mensaje varchar(500))
as
begin
	select *,@mensaje as MENSAJE
	from Telefono
	where estado=1 and tipo=@tipo
end

EXECUTE USP_REPORTE_TEL @tipo= 'LLA', @mensaje= 'Hola cliente, no olvide realizar el pago de su servicio de Internet'
EXECUTE USP_REPORTE_TEL @tipo= 'SMS', @mensaje= 'Buen día, muchas gracias por su preferencia. Tenemos excelentes promociones para usted'
EXECUTE USP_REPORTE_TEL @tipo= 'WSP', @mensaje= 'Como estás, hasta el 15/07 recibe un 20% de descuento en tu facturación'

--create or alter procedure dbo.USP_REPORTE_TEL_V2(@tipo varchar(4),@mensaje varchar(500))
--as
--begin
--	select t.tipo,t.numero,
--	coalesce(c.razon_social,c.nombres+' '+c.ape_paterno+' '+c.ape_materno,'Cliente')+' '+@mensaje as MENSAJE
--	from Telefono t
--	left join Cliente c on t.codcliente=c.codcliente
--	where t.estado=1 and tipo=@tipo
--end

--EXECUTE USP_REPORTE_TEL_V2 @tipo= 'LLA', @mensaje= 'No olvide realizar el pago de su servicio de Internet'