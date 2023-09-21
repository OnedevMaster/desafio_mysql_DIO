-- Criação de banco de dados para o cenário de E-commerce da Digital inovation onne.
create database if not exists ecommerce;
use ecommerce;

create table clients(
    idClient int  primary key auto_increment not null,
    Fname varchar(10) not null,
    Minit char(3),
    Lname varchar(10) not null,
    CPF char(11) not null unique,
    Address varchar(30)
);

create table product(
    idProduct int primary key auto_increment,
    Pname varchar(10),
    classification_kids bool default false,
    category enum('Eletrônico', 'Vestimenta', 'Brinquedos', 'Alimento', 'Móveis') not null,
    avaliação float default 0,
    size varchar(10)    
);

create table pedido(
    idOrder int not null unique primary key,
    idOrderClient int,
    orderStatus enum('Cancelado', 'Confirmado', 'Em processamento') not null,
    orderDescription varchar(255),
	sendValue float default 10,
    paymentCash bool default false,
    constraint fk_orders_client foreign key (idOrder) references clients(idClient)
);

create table payments(
    idPaymant int unique not null primary key,
    idPayment int,
    typePayment enum('Boleto', 'Cartão', 'Dois Cartões', 'Pix'),
    limitAvailable float,
    status_pagamento enum('Falhou','Concluido','Processando') not null,
    metodo_pagamento enum('Pix','Credito','Debito','Boleto'),
    idClient int not null,
    constraint fk_payment_of_client foreign key (idPayment) references clients(idClient)
    
);

create table productStorage(
	idProdStorage int not null auto_increment primary key,
    storageLocation varchar(255),
    quantity int default 0
);

create table supplier(
    idSupplier int not null auto_increment primary key,
    SocialName varchar(255) not null,
    Address varchar(30) not null,
    contatct char(11) not null,
    email varchar(30) not null,
    CNPJ char(15) not null,
    constraint unique_supplier unique (CNPJ)
);

create table transportadora(
     id_transportadora int not null primary key,
     nome_transportadora varchar(80) not null unique,
     email varchar(60) not null,
     endereco varchar(80) not null,
     telefone char(12) not null,
     CNPJ char(18) not null unique
);


create table entrega(
    codigo_rastreio varchar(18) not null unique primary key,
    id_transportadora int not null,
    status_entrega enum('Entregue ao destinatario', 'Falhou ao entregar para o destinatario', 'Saiu para a entrega  ao destinatario', 'Objeto em transito, por favor aguarde', 'Objeto postado, por favor aguarde','Processando') default 'Processando',
    data_prevista datetime not null,
    data_entrega datetime not null,

    constraint fk_id_transpotadora_entrega foreign key (id_transportadora) references transportadora(id_transportadora)
);

create table fonecimento_produto(
    id_fornecedor int not null,
    id_produto int not null,
    constraint fk_produto_fornecido foreign key (id_produto) references product(idProduct),
    constraint fk_fornecedor_produto foreign key (id_fornecedor) references supplier(idSupplier)
);

create table estoque_tem_produto(
    id_produto int not null,
    id_estoque int not null,
    quantidade_produto int not null,
    constraint fk_produto_no_estoque foreign key (id_produto) references product(idProduct),
    constraint fk_estoque_de_produto foreign key (id_estoque) references productStorage(idProdStorage)
);

create table pedido_contem_produto(
    id_pedido int not null,
    id_produto int not null,
    preco_produto float not null,
    quantidade_produto tinyint not null default 1,
    constraint fk_pedido_has_prod_id_pedido foreign key(id_pedido) references pedido(idOrder),
    constraint fk_pedido_has_prod_id_produto foreign key(id_produto) references product(idProduct)

);

alter table pedido_contem_produto add constraint fk_id_do_pedido foreign key (id_pedido) references pedido(idOrder);
alter table pedido_contem_produto add constraint fk_id_do_produto_pedido foreign key (id_produto) references product(idProduct);

alter table pedido add constraint fk_id_cliente_pedido foreign key (idOrder) references clients(idClient);
alter table pedido add constraint fk_id_pagamento foreign key (idOrder) references payments(idPayment);

alter table pedido add constraint fk_id_pagamento_id_cliente foreign key (idOrder) references payments(idPayment);
alter table pedido add constraint fk_id_transportadora_leva_produto foreign key (idOrder) references transportadora (id_transportadora);
