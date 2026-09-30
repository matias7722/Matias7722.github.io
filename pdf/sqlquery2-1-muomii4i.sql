/* =========================================
   1. BASE DE DATOS
   ========================================= */
IF DB_ID('Editorial') IS NULL
    CREATE DATABASE Editorial;
GO

USE Editorial;
GO

/* =========================================
   2. ESQUEMA
   ========================================= */
IF SCHEMA_ID('Editorial') IS NULL
    EXEC('CREATE SCHEMA Editorial');
GO

/* =========================================
   3. BORRAR TABLAS SI EXISTEN (orden inverso)
   ========================================= */
DROP TABLE IF EXISTS Editorial.Ejemplar;
DROP TABLE IF EXISTS Editorial.SeccionFija;
DROP TABLE IF EXISTS Editorial.Articulo;
DROP TABLE IF EXISTS Editorial.SucursalRevista;
DROP TABLE IF EXISTS Editorial.Empleado;
DROP TABLE IF EXISTS Editorial.Periodista;
DROP TABLE IF EXISTS Editorial.Revista;
DROP TABLE IF EXISTS Editorial.Sucursal;
GO

/* =========================================
   4. TABLAS
   ========================================= */
CREATE TABLE Editorial.Sucursal (
    IdSucursal INT IDENTITY(1,1) PRIMARY KEY,
    Domicilio  NVARCHAR(100) NOT NULL,
    Telefono   NVARCHAR(20)  NULL,
    Codigo     VARCHAR(10)   NOT NULL UNIQUE
);
GO

CREATE TABLE Editorial.Empleado (
    IdEmpleado INT IDENTITY(1,1) PRIMARY KEY,
    IdSucursal INT NOT NULL,
    Nombre     NVARCHAR(100) NOT NULL,
    Apellidos  NVARCHAR(100) NOT NULL,
    NIF        VARCHAR(15)   NOT NULL UNIQUE,
    FOREIGN KEY (IdSucursal) REFERENCES Editorial.Sucursal(IdSucursal)
);
GO

CREATE TABLE Editorial.Revista (
    IdRevista    INT IDENTITY(1,1) PRIMARY KEY,
    Titulo       NVARCHAR(100) NOT NULL,
    NRegistro    VARCHAR(20)   NOT NULL UNIQUE,
    Periodicidad NVARCHAR(50)  NULL,
    Tipo         VARCHAR(20)   NULL
);
GO

CREATE TABLE Editorial.SucursalRevista (
    IdSucursal  INT NOT NULL,
    IdRevista   INT NOT NULL,
    FechaInicio DATE NOT NULL DEFAULT GETDATE(),
    Estado      BIT  NOT NULL DEFAULT 1,
    PRIMARY KEY (IdSucursal, IdRevista),
    FOREIGN KEY (IdSucursal) REFERENCES Editorial.Sucursal(IdSucursal),
    FOREIGN KEY (IdRevista)  REFERENCES Editorial.Revista(IdRevista)
);
GO

CREATE TABLE Editorial.Periodista (
    IdPeriodista INT IDENTITY(1,1) PRIMARY KEY,
    Nombre       NVARCHAR(100) NOT NULL,
    Apellidos    NVARCHAR(100) NOT NULL,
    NIF          VARCHAR(15)   NOT NULL UNIQUE,
    Especialidad NVARCHAR(100) NULL
);
GO

CREATE TABLE Editorial.Articulo (
    IdArticulo   INT IDENTITY(1,1) PRIMARY KEY,
    IdPeriodista INT NOT NULL,
    IdRevista    INT NOT NULL,
    Titulo       NVARCHAR(100) NOT NULL,
    Fecha        DATE NOT NULL,
    FOREIGN KEY (IdPeriodista) REFERENCES Editorial.Periodista(IdPeriodista),
    FOREIGN KEY (IdRevista)    REFERENCES Editorial.Revista(IdRevista)
);
GO

CREATE TABLE Editorial.SeccionFija (
    IdSeccion INT IDENTITY(1,1) PRIMARY KEY,
    IdRevista INT NOT NULL,
    Titulo    NVARCHAR(100) NOT NULL,
    Extension NVARCHAR(50)  NULL,
    FOREIGN KEY (IdRevista) REFERENCES Editorial.Revista(IdRevista)
);
GO

CREATE TABLE Editorial.Ejemplar (
    IdEjemplar INT IDENTITY(1,1) PRIMARY KEY,
    IdRevista  INT NOT NULL,
    Fecha      DATE NOT NULL,
    Paginas    INT  NOT NULL,
    Vendidos   INT  NOT NULL DEFAULT 0,
    FOREIGN KEY (IdRevista) REFERENCES Editorial.Revista(IdRevista)
);
GO

/* =========================================
   5. VERIFICAR
   ========================================= */
SELECT TABLE_SCHEMA, TABLE_NAME
FROM Editorial.INFORMATION_SCHEMA.TABLES
ORDER BY TABLE_NAME;
GO/* =========================================
   1. BASE DE DATOS
   ========================================= */
IF DB_ID('Editorial') IS NULL
    CREATE DATABASE Editorial;
GO

USE Editorial;
GO

/* =========================================
   2. ESQUEMA
   ========================================= */
IF SCHEMA_ID('Editorial') IS NULL
    EXEC('CREATE SCHEMA Editorial');
GO

/* =========================================
   3. BORRAR TABLAS SI EXISTEN (orden inverso)
   ========================================= */
DROP TABLE IF EXISTS Editorial.Ejemplar;
DROP TABLE IF EXISTS Editorial.SeccionFija;
DROP TABLE IF EXISTS Editorial.Articulo;
DROP TABLE IF EXISTS Editorial.SucursalRevista;
DROP TABLE IF EXISTS Editorial.Empleado;
DROP TABLE IF EXISTS Editorial.Periodista;
DROP TABLE IF EXISTS Editorial.Revista;
DROP TABLE IF EXISTS Editorial.Sucursal;
GO

/* =========================================
   4. TABLAS
   ========================================= */
CREATE TABLE Editorial.Sucursal (
    IdSucursal INT IDENTITY(1,1) PRIMARY KEY,
    Domicilio  NVARCHAR(100) NOT NULL,
    Telefono   NVARCHAR(20)  NULL,
    Codigo     VARCHAR(10)   NOT NULL UNIQUE
);
GO

CREATE TABLE Editorial.Empleado (
    IdEmpleado INT IDENTITY(1,1) PRIMARY KEY,
    IdSucursal INT NOT NULL,
    Nombre     NVARCHAR(100) NOT NULL,
    Apellidos  NVARCHAR(100) NOT NULL,
    NIF        VARCHAR(15)   NOT NULL UNIQUE,
    FOREIGN KEY (IdSucursal) REFERENCES Editorial.Sucursal(IdSucursal)
);
GO

CREATE TABLE Editorial.Revista (
    IdRevista    INT IDENTITY(1,1) PRIMARY KEY,
    Titulo       NVARCHAR(100) NOT NULL,
    NRegistro    VARCHAR(20)   NOT NULL UNIQUE,
    Periodicidad NVARCHAR(50)  NULL,
    Tipo         VARCHAR(20)   NULL
);
GO

CREATE TABLE Editorial.SucursalRevista (
    IdSucursal  INT NOT NULL,
    IdRevista   INT NOT NULL,
    FechaInicio DATE NOT NULL DEFAULT GETDATE(),
    Estado      BIT  NOT NULL DEFAULT 1,
    PRIMARY KEY (IdSucursal, IdRevista),
    FOREIGN KEY (IdSucursal) REFERENCES Editorial.Sucursal(IdSucursal),
    FOREIGN KEY (IdRevista)  REFERENCES Editorial.Revista(IdRevista)
);
GO

CREATE TABLE Editorial.Periodista (
    IdPeriodista INT IDENTITY(1,1) PRIMARY KEY,
    Nombre       NVARCHAR(100) NOT NULL,
    Apellidos    NVARCHAR(100) NOT NULL,
    NIF          VARCHAR(15)   NOT NULL UNIQUE,
    Especialidad NVARCHAR(100) NULL
);
GO

CREATE TABLE Editorial.Articulo (
    IdArticulo   INT IDENTITY(1,1) PRIMARY KEY,
    IdPeriodista INT NOT NULL,
    IdRevista    INT NOT NULL,
    Titulo       NVARCHAR(100) NOT NULL,
    Fecha        DATE NOT NULL,
    FOREIGN KEY (IdPeriodista) REFERENCES Editorial.Periodista(IdPeriodista),
    FOREIGN KEY (IdRevista)    REFERENCES Editorial.Revista(IdRevista)
);
GO

CREATE TABLE Editorial.SeccionFija (
    IdSeccion INT IDENTITY(1,1) PRIMARY KEY,
    IdRevista INT NOT NULL,
    Titulo    NVARCHAR(100) NOT NULL,
    Extension NVARCHAR(50)  NULL,
    FOREIGN KEY (IdRevista) REFERENCES Editorial.Revista(IdRevista)
);
GO

CREATE TABLE Editorial.Ejemplar (
    IdEjemplar INT IDENTITY(1,1) PRIMARY KEY,
    IdRevista  INT NOT NULL,
    Fecha      DATE NOT NULL,
    Paginas    INT  NOT NULL,
    Vendidos   INT  NOT NULL DEFAULT 0,
    FOREIGN KEY (IdRevista) REFERENCES Editorial.Revista(IdRevista)
);
GO

/* =========================================
   5. VERIFICAR
   ========================================= */
SELECT TABLE_SCHEMA, TABLE_NAME
FROM Editorial.INFORMATION_SCHEMA.TABLES
ORDER BY TABLE_NAME;
GO