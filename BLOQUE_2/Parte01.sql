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

