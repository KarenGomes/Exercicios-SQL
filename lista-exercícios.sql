create table agencias 
(
  codagc number(3),
  nome varchar(20),
  endereco varchar(20),
  bairro varchar(20),
  cidade varchar(20),
  estado varchar(20),
  constraint agc_pk primary key(codagc)
);


create table clientes 
(
  codcli number(3), 
  nome  varchar(20),
  datnasc date,
  sex  char(1),
  renda  varchar(20),
  EstadoCivil  varchar(20), 
  endereco  varchar(20),
  bairro  varchar(20),
  cidade  varchar(20),
  estado  varchar(20),
  constraint cli_pk primary key(codcli),
  constraint sex check(sex = 'F' or sex = 'M'),
  constraint estadoCivil check( EstadoCivil = 'SOLTEIRO' or EstadoCivil = 'CASADO' or EstadoCivil = 'OUTROS')
);

create table contas
(
  numeroCC number(3),
  codcli number(3),
  codagc number(3), 
  DataAbertura date, 
  DataEncerramento date,
  saldoAtual number(6),
  tipoCC varchar(2),
  constraint cc_fk foreign key(codcli) references clientes(codcli),
  constraint cc_fk2 foreign key(codagc) references agencias(codagc),
  constraint cc_pk primary key(numeroCC, codcli, codagc),
  constraint tipo check(tipoCC = 'CC' or tipoCC = 'CP')
);


/*1) Atualize o Saldo de todas as contas para zero.*/

update contas set saldoatual = 0;

/*2)Exclua as contas com data menor que 01/01/1980.*/

delete from contas 
where dataAbertura < '01011980';

/*3) Atualize a agencia de código 500 para ter o nome de ‘Agencia UEZO’ e bairro ‘Campo 
Grande’.*/

update agencias set nome='Agencia UEZO', bairro = 'Campo Grande'
where codagc = 500;

/*4)Exclua as agencias do bairro ‘Campo Grande’ e com endereço nulo.*/

delete from agencias 
where bairro = 'Campo Grande' and endereco is null;

/*5)Após um comando de exclusão (sem confirmar a exclusão), você percebe que excluiu 
uma conta errada, qual comando você daria para desfazer a exclusão.*/
/*rollback*/

/*6)UM relatório que mostre o maior saldo, o menor saldo e a media dos saldos nas contas.*/

select max(saldoatual), min(saldoAtual), avg(saldoatual)
from contas;

/*7)Mostre quantos clientes cadastrados existem.*/

select count(*) clientes 
from clientes;

/*8)Um relatório contendo a quantidade de clientes agrupados por sexo.*/

select count(*) clientes, sex
from clientes 
group by sex;

/*9)Um relatório com o código e nome das agencias e o total de contas abertas nas mesmas. 
Somente deve aparecer no relatório agencias que possuem mais de 100 contas abertas.*/

select a.codagc, a.nome, count(c.numerocc)
from agencias a join contas c
on c.CODAGC = a.CODAGC
group by a.codagc, a.nome
having count(c.numerocc) > 100;


/*10)Um relatório com nome do cliente, o numero da conta e saldo.
*/

select c.nome, cc.numerocc, cc.saldoatual 
from clientes c join contas cc
on cc.CODCLI = c.CODCLI;

/*11)Um relatório contendo nome da agencia e numero de conta corrente.*/

select a.nome, count(c.tipocc)
from agencias a join contas c 
on c.CODAGC = a.CODAGC
where c.tipocc = 'CC'
group by a.nome;

/*12) Um relatório contendo nome da agencia, nome do cliente e saldo.*/

select a.nome, c.nome, cc.saldoatual saldo
from agencias a join contas cc 
on cc.CODAGC = a.CODAGC
join clientes c 
on cc.CODCLI = c.CODCLI;

/*13)Um relatório contendo nome da agencia, nome do cliente e tipo de conta para as contas 
com data de abertura a partir de 01/01/2000.*/

select a.nome, c.nome, cc.tipocc
from AGENCIAS a join contas cc 
on cc.CODAGC = a.CODAGC
join clientes c
on cc.CODCLI = c.CODCLI
where cc.DATAABERTURA > '01/01/2000';


/*14)Um relatório contendo todas as cidades cadastradas na tabela de agencias e de clientes 
ordenadas alfabeticamente (uma cidade que esta em um cadastro não necessariamente 
precisa estar no outro)*/

select cidade
from agencias 
union all 
select cidade 
from clientes
order by 1;

/*15)Um relatório contendo todas as cidades que estão no cadastro de agencias e que 
também estão no cadastro de clientes. Ordene alfabeticamente.
*/

select cidade 
from agencias 
intersect 
select cidade 
from clientes 
order by 1;


/*16)Um relatório contendo o nome do cliente com o maior saldo.
*/

select c.nome 
from clientes c join contas cc
on cc.codcli = c.codcli
where cc.saldoatual = (select max(saldoatual)
                       from contas);
                       

/*17)Um relatório contendo o nome dos clientes com saldo acima da media.*/

select c.nome 
from clientes c join contas cc 
on cc.CODCLI = c.CODCLI
where cc.SALDOATUAL > (select avg(saldoatual)
                        from contas);

/*18) Um relatório contendo o nome e sexo dos clientes cujo saldo seja maior que zero*/

select c.nome, c.sex
from clientes c join contas cc 
on cc.CODCLI = c.CODCLI
where cc.saldoatual > 0;
                  
/*19)Crie uma visão chamada V_POUP contendo o numero da conta, código da agencia e 
saldo para o tipo de conta poupança*/

create view V_POUP as 
select numerocc, codagc, saldoatual
from CONTAS
where tipocc = 'CP';

/*19) Relatório com nome e código de todos os clientes que possuem conta com saldo menor 
que o saldo médio de suas agencias.*/

select c.nome, c.codcli
from clientes c join contas cc 
on cc.CODCLI = c.CODCLI
where cc.SALDOATUAL < (select avg(saldoatual)
                        from contas 
                        where codagc = cc.codagc);


/*20) Relatório com código de todos os clientes que possuem agencia em seu bairro.
*/
select c.codcli
from clientes c join agencias a
on c.BAIRRO = a.BAIRRO;


/*21) Relatório com código de todos os clientes que possuem mais de uma agencia em seu 
bairro*/

select c.codcli
from clientes c join agencias a 
on c.BAIRRO = a.BAIRRO
where (select count(bairro)
      from agencias
      where bairro = a.bairro) >= 2;



