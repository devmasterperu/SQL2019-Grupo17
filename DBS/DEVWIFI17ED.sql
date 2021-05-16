--USE master --Seleccionar BD

--Create Database DEVWIFI_17ED --Crear una base datos

Use DEVWIFI_17ED 
go

--Comentario de linea
/*
Comentario
Multilínea
*/

--Comentario de linea

--Comentario
--Multilínea

/*
 * ER/Studio 8.0 SQL Code Generation
 * Company :      DEV MASTER PERU
 * Project :      DEV_WIFI_17ED.DM1
 * Author :       gmanriquev
 *
 * Date Created : Sunday, April 25, 2021 09:15:24
 * Target DBMS : Microsoft SQL Server 2008
 */

/* 
 * TABLE: Cliente 
 */

CREATE TABLE Cliente(
    codcliente        int             IDENTITY(1,1),
    codtipo           int             NOT NULL,
    numdoc            varchar(15)     NOT NULL,
    tipo_cliente      char(1)         NOT NULL,
    nombres           varchar(50)     NULL,
    ape_paterno       varchar(50)     NULL,
    ape_materno       varchar(50)     NULL,
    sexo              char(1)         NULL,
    fec_nacimiento    date            NULL,
    razon_social      varchar(100)    NULL,
    fec_inicio        date            NULL,
    direccion         varchar(200)    NOT NULL,
    email             varchar(320)    NULL,
    codzona           int             NOT NULL,
    estado            bit             NOT NULL,
    CONSTRAINT PK8 PRIMARY KEY NONCLUSTERED (codcliente)
)
go



IF OBJECT_ID('Cliente') IS NOT NULL
    PRINT '<<< CREATED TABLE Cliente >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE Cliente >>>'
go

/* 
 * TABLE: Contrato 
 */

CREATE TABLE Contrato(
    codcliente          int              NOT NULL,
    codplan             int              NOT NULL,
    fec_contrato        date             NOT NULL,
    fec_baja            date             NULL,
    periodo             char(1)          NOT NULL,
    preciosol           decimal(9, 2)    NULL,
    iprouter            varchar(15)      NULL,
    ssis_red_wifi       varchar(50)      NULL,
    fec_registro        datetime         NOT NULL,
    fec_ultactualiza    datetime         NULL,
    estado              varchar(2)       NOT NULL,
    CONSTRAINT PK11 PRIMARY KEY NONCLUSTERED (codcliente, codplan, fec_contrato)
)
go



IF OBJECT_ID('Contrato') IS NOT NULL
    PRINT '<<< CREATED TABLE Contrato >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE Contrato >>>'
go

/* 
 * TABLE: PlanInternet 
 */

CREATE TABLE PlanInternet(
    codplan        int              IDENTITY(1,1),
    nombre         varchar(50)      NOT NULL,
    precioref      decimal(9, 2)    NOT NULL,
    descripcion    varchar(100)     NULL,
    CONSTRAINT PK1 PRIMARY KEY NONCLUSTERED (codplan)
)
go



IF OBJECT_ID('PlanInternet') IS NOT NULL
    PRINT '<<< CREATED TABLE PlanInternet >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE PlanInternet >>>'
go

/* 
 * TABLE: Telefono 
 */

CREATE TABLE Telefono(
    tipo          varchar(4)     NOT NULL,
    numero        varchar(15)    NOT NULL,
    codcliente    int            NOT NULL,
    estado        bit            NOT NULL,
    CONSTRAINT PK9 PRIMARY KEY NONCLUSTERED (tipo, numero)
)
go



IF OBJECT_ID('Telefono') IS NOT NULL
    PRINT '<<< CREATED TABLE Telefono >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE Telefono >>>'
go

/* 
 * TABLE: TipoDocumento 
 */

CREATE TABLE TipoDocumento(
    codtipo       int            IDENTITY(1,1),
    tipo_sunat    char(2)        NOT NULL,
    desc_larga    varchar(50)    NOT NULL,
    desc_corta    varchar(20)    NOT NULL,
    CONSTRAINT PK3 PRIMARY KEY NONCLUSTERED (codtipo)
)
go



IF OBJECT_ID('TipoDocumento') IS NOT NULL
    PRINT '<<< CREATED TABLE TipoDocumento >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE TipoDocumento >>>'
go

/* 
 * TABLE: Ubigeo 
 */

CREATE TABLE Ubigeo(
    codubigeo    int            IDENTITY(1,1),
    cod_dpto     varchar(2)     NOT NULL,
    nom_dpto     varchar(50)    NOT NULL,
    cod_prov     varchar(2)     NOT NULL,
    nom_prov     varchar(50)    NOT NULL,
    cod_dto      varchar(2)     NOT NULL,
    nom_dto      varchar(50)    NOT NULL,
    CONSTRAINT PK2 PRIMARY KEY NONCLUSTERED (codubigeo)
)
go



IF OBJECT_ID('Ubigeo') IS NOT NULL
    PRINT '<<< CREATED TABLE Ubigeo >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE Ubigeo >>>'
go

/* 
 * TABLE: Zona 
 */

CREATE TABLE Zona(
    codzona      int            IDENTITY(1,1),
    nombre       varchar(70)    NOT NULL,
    estado       bit            NOT NULL,
    codubigeo    int            NOT NULL,
    CONSTRAINT PK4 PRIMARY KEY NONCLUSTERED (codzona)
)
go



IF OBJECT_ID('Zona') IS NOT NULL
    PRINT '<<< CREATED TABLE Zona >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE Zona >>>'
go

/* 
 * TABLE: Cliente 
 */

ALTER TABLE Cliente ADD CONSTRAINT RefZona3 
    FOREIGN KEY (codzona)
    REFERENCES Zona(codzona)
go

ALTER TABLE Cliente ADD CONSTRAINT RefTipoDocumento4 
    FOREIGN KEY (codtipo)
    REFERENCES TipoDocumento(codtipo)
go


/* 
 * TABLE: Contrato 
 */

ALTER TABLE Contrato ADD CONSTRAINT RefCliente8 
    FOREIGN KEY (codcliente)
    REFERENCES Cliente(codcliente)
go

ALTER TABLE Contrato ADD CONSTRAINT RefPlanInternet9 
    FOREIGN KEY (codplan)
    REFERENCES PlanInternet(codplan)
go


/* 
 * TABLE: Telefono 
 */

ALTER TABLE Telefono ADD CONSTRAINT RefCliente5 
    FOREIGN KEY (codcliente)
    REFERENCES Cliente(codcliente)
go


/* 
 * TABLE: Zona 
 */

ALTER TABLE Zona ADD CONSTRAINT RefUbigeo2 
    FOREIGN KEY (codubigeo)
    REFERENCES Ubigeo(codubigeo)
go


