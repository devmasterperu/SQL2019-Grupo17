/*Ejecución de Campos en SELECT
select 40/3.753 as PRECIO_DOL,
case when PRECIO_DOL>=0 and PRECIO_DOL<20 then '[0,20>' else 'OTRO' as RANGO_SOL
end
go

select case when PRECIO_DOL>=0 and PRECIO_DOL<20 then '[0,20>' else 'OTRO' end as RANGO_SOL
from
(select  40/3.753 as PRECIO_DOL) tbPlanRef
*/

--02.12
select * from TipoDocumento --codtipo=1
select rtrim(ltrim('  DEV MASTER PERU  '))

update Cliente
set nombres='MARIANA ALBERTA'
where codcliente=402

select IIF(codtipo=1,'LE o DNI','OTRO') as TIPO_DOC,
       numdoc as NUM_DOC,
	   --nombres +' '+ null + ' '+ape_materno     as CLIENTE,
	   concat(rtrim(ltrim(nombres)),' ',rtrim(ltrim(ape_paterno)),' ',rtrim(ltrim(ape_materno))) as CLIENTE
	   --rtrim(ltrim(concat(nombres,' ',ape_paterno,' ',ape_materno))) as CLIENTE_2
from Cliente
where tipo_cliente='P'
--and rtrim(ltrim(nombres)) in ('ANA','AMADOR','ANGEL','ANASTASIA','ARTURO')
--and rtrim(ltrim(nombres)) LIKE 'A%' --a.	Nombre completo inicie en ‘A’ ('ANA','AMADOR',ANGEL')
--and concat(rtrim(ltrim(nombres)),' ',rtrim(ltrim(ape_paterno)),' ',rtrim(ltrim(ape_materno))) LIKE '%AMA%'--b.	Nombre completo contiene la secuencia ‘AMA’
--and concat(rtrim(ltrim(nombres)),' ',rtrim(ltrim(ape_paterno)),' ',rtrim(ltrim(ape_materno))) LIKE '%AN'--c.	Nombre completo finaliza en 'AN'.
--and concat(rtrim(ltrim(nombres)),' ',rtrim(ltrim(ape_paterno)),' ',rtrim(ltrim(ape_materno))) LIKE 'E%E'--d.	Nombre completo inicia y finaliza en ‘E’.
--and concat(rtrim(ltrim(nombres)),' ',rtrim(ltrim(ape_paterno)),' ',rtrim(ltrim(ape_materno))) LIKE 'E%'  
--and concat(rtrim(ltrim(nombres)),' ',rtrim(ltrim(ape_paterno)),' ',rtrim(ltrim(ape_materno))) LIKE '%E'
--and concat(rtrim(ltrim(nombres)),' ',rtrim(ltrim(ape_paterno)),' ',rtrim(ltrim(ape_materno))) LIKE '_ARI%'--e.	Nombre completo contenga la secuencia ‘ARI’ desde la 2° posición.
--and concat(rtrim(ltrim(nombres)),' ',rtrim(ltrim(ape_paterno)),' ',rtrim(ltrim(ape_materno))) LIKE '%M__'--f.	Nombre completo tenga como antepenúltimo carácter la ‘M’.
--and concat(rtrim(ltrim(nombres)),' ',rtrim(ltrim(ape_paterno)),' ',rtrim(ltrim(ape_materno))) LIKE '_I%I_'--g.	Nombre completo tenga como segundo y penúltimo carácter la ‘I’
--and concat(rtrim(ltrim(nombres)),' ',rtrim(ltrim(ape_paterno)),' ',rtrim(ltrim(ape_materno))) LIKE '[aeiou]%[aeiou]'--h.	Nombre completo inicie y finalice con una vocal.
--and concat(rtrim(ltrim(nombres)),' ',rtrim(ltrim(ape_paterno)),' ',rtrim(ltrim(ape_materno))) LIKE '[^aeiou]%[^aeiou]' --i.	Nombre completo inicie y finalice con una consonante.
--and concat(rtrim(ltrim(nombres)),' ',rtrim(ltrim(ape_paterno)),' ',rtrim(ltrim(ape_materno))) NOT LIKE '%*%' --Excluir nombres completos con caracteres especiales
--and concat(rtrim(ltrim(nombres)),' ',rtrim(ltrim(ape_paterno)),' ',rtrim(ltrim(ape_materno))) LIKE '[aeiou]%[^aeiou]'--j.	Nombre inicie con una vocal y finalice con una consonante.
and concat(rtrim(ltrim(nombres)),' ',rtrim(ltrim(ape_paterno)),' ',rtrim(ltrim(ape_materno))) LIKE '[abc]%'

--02.13

select codzona,estado,count(codcliente) as TOT_CLIENTES,min(fec_inicio) as MIN_FEC_INICIO,max(fec_inicio) as MAX_FEC_INICIO,
case when count(codcliente)>=0 and count(codcliente)<20 then 'TOTAL_INFERIOR'
	 when count(codcliente)>=20 and count(codcliente)<40 then 'TOTAL_MEDIO'
	 when count(codcliente)>=40 then 'TOTAL_SUPERIOR'
else 'SIN INFO' end as MENSAJE
from Cliente 
where tipo_cliente='E'
group by codzona,estado
having count(codcliente)>10
order by codzona,estado

SELECT CONVERT(VARCHAR(8), getdate(), 112)

--02.16
--NOTA_01
select TOP(6) codzona,estado,count(codcliente) as TOT_CLIENTES,min(fec_inicio) as MIN_FEC_INICIO,max(fec_inicio) as MAX_FEC_INICIO,
case when count(codcliente)>=0 and count(codcliente)<20 then 'TOTAL_INFERIOR'
	 when count(codcliente)>=20 and count(codcliente)<40 then 'TOTAL_MEDIO'
	 when count(codcliente)>=40 then 'TOTAL_SUPERIOR'
else 'SIN INFO' end as MENSAJE
from Cliente 
where tipo_cliente='E'
group by codzona,estado
order by TOT_CLIENTES desc

--NOTA_02
select 
TOP(6) PERCENT --TOP(1)=>0.06*12
codzona,estado,count(codcliente) as TOT_CLIENTES,min(fec_inicio) as MIN_FEC_INICIO,max(fec_inicio) as MAX_FEC_INICIO,
case when count(codcliente)>=0 and count(codcliente)<20 then 'TOTAL_INFERIOR'
	 when count(codcliente)>=20 and count(codcliente)<40 then 'TOTAL_MEDIO'
	 when count(codcliente)>=40 then 'TOTAL_SUPERIOR'
else 'SIN INFO' end as MENSAJE
from Cliente 
where tipo_cliente='E'
group by codzona,estado
order by TOT_CLIENTES desc

--NOTA_03
select TOP(6) with ties
codzona,estado,count(codcliente) as TOT_CLIENTES,min(fec_inicio) as MIN_FEC_INICIO,max(fec_inicio) as MAX_FEC_INICIO,
case when count(codcliente)>=0 and count(codcliente)<20 then 'TOTAL_INFERIOR'
	 when count(codcliente)>=20 and count(codcliente)<40 then 'TOTAL_MEDIO'
	 when count(codcliente)>=40 then 'TOTAL_SUPERIOR'
else 'SIN INFO' end as MENSAJE
from Cliente 
where tipo_cliente='E'
group by codzona,estado
order by TOT_CLIENTES desc

--NOTA_04
select TOP(54) PERCENT with ties -- TOP(54) PERCENT = TOP(7)
codzona,estado,count(codcliente) as TOT_CLIENTES,min(fec_inicio) as MIN_FEC_INICIO,max(fec_inicio) as MAX_FEC_INICIO,
case when count(codcliente)>=0 and count(codcliente)<20 then 'TOTAL_INFERIOR'
	 when count(codcliente)>=20 and count(codcliente)<40 then 'TOTAL_MEDIO'
	 when count(codcliente)>=40 then 'TOTAL_SUPERIOR'
else 'SIN INFO' end as MENSAJE
from Cliente 
where tipo_cliente='E'
group by codzona,estado
order by TOT_CLIENTES desc

--select * from Cliente where codzona=8 and estado=1
--update Cliente set codzona=10 where codcliente=2

--02.17

declare @t int=10,@n int=3

select codcliente,concat(rtrim(ltrim(nombres)),' ',rtrim(ltrim(ape_paterno)),' ',rtrim(ltrim(ape_materno))) as NOMBRE_COMPLETO
from Cliente
where tipo_cliente='P'
order by NOMBRE_COMPLETO asc
--a.Página 1 y tamaño de página 10 [Posición 1 – 10].
--offset 0 rows=10*(1-1)
--fetch next 10 rows only
--b.Página 2 y tamaño de página 10 [Posición 11-20].
--offset 10 rows=10*(2-1)
--fetch next 10 rows only
--c.Página 3 y tamaño de página 10 [Posición 21-30].
--offset 20 rows=10*(3-1)
--fetch next 10 rows only
--d.Página 'n' y tamaño de página 't'
offset @t*(@n-1) rows
fetch next @t rows only