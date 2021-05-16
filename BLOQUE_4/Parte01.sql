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
--nombre|precioref|descripcion
output inserted.codplan,inserted.nombre --Opcional
values 
(190.00,'Solicitado por comité junio 2020','STAR I')
