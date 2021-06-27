--06.05

--Tablas derivadas
select c.codcliente as CODIGO,
upper(concat(rtrim(ltrim(c.nombres)),' ',rtrim(ltrim(c.ape_paterno))+' ',rtrim(ltrim(c.ape_materno)))) as CLIENTE,
codzona as ZONA,
isnull(rt.total,0) AS N_TEL,
row_number() over(partition by c.codzona order by isnull(rt.total,0) asc) as R1,
rank() over(partition by c.codzona order by isnull(rt.total,0) asc) as R2,
dense_rank() over(partition by c.codzona order by isnull(rt.total,0) asc) as R3,
ntile(4) over(partition by c.codzona order by isnull(rt.total,0) asc) as R4
from Cliente c
left join
(
	select codcliente,count(*) as total
	from Telefono
	group by codcliente
) rt on c.codcliente=rt.codcliente
where tipo_cliente='P'
order by ZONA asc,N_TEL asc

--CTE
with CTE_RT as
(
	select codcliente,count(*) as total
	from Telefono
	group by codcliente
) 
select c.codcliente as CODIGO,
upper(concat(rtrim(ltrim(c.nombres)),' ',rtrim(ltrim(c.ape_paterno))+' ',rtrim(ltrim(c.ape_materno)))) as CLIENTE,
codzona as ZONA,
isnull(rt.total,0) AS N_TEL,
row_number() over(partition by c.codzona order by isnull(rt.total,0) asc) as R1,
rank() over(partition by c.codzona order by isnull(rt.total,0) asc) as R2,
dense_rank() over(partition by c.codzona order by isnull(rt.total,0) asc) as R3,
ntile(4) over(partition by c.codzona order by isnull(rt.total,0) asc) as R4
from Cliente c
left join CTE_RT rt on c.codcliente=rt.codcliente
where tipo_cliente='P'
order by ZONA asc,N_TEL asc

--06.07

select c.codcliente as #,upper(razon_social) as CLIENTE,codzona as ZONA,
       isnull(rc.total,0) as TOTAL,
	   --Es la posición irrepetible por zona. Considerar el total de contratos, de menor a mayor, para generar la posición
	   row_number()      over(partition by c.codzona order by isnull(rc.total,0) asc) as E1,
	   lag(razon_social,1,'SIN DATO') over(partition by c.codzona order by isnull(rc.total,0) asc) as E2
from Cliente c
left join
(
	select codcliente,count(*) as total
	from   Contrato
	group by codcliente
) rc on c.codcliente=rc.codcliente
where tipo_cliente='E'
order by ZONA asc,TOTAL asc