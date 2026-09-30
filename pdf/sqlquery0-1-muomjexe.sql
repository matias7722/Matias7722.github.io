/* =========================================
   1. BASE DE DATOS
   ========================================= */
IF DB_ID('EmpresaDB') IS NULL
    CREATE DATABASE EmpresaDB;
GO

USE EmpresaDB;
GO

/* =========================================
   2. ESQUEMA
   ========================================= */
IF SCHEMA_ID('Empresa') IS NULL
    EXEC('CREATE SCHEMA Empresa');
GO

/* =========================================
   3. BORRAR TABLAS SI EXISTEN (orden inverso)
   ========================================= */
DROP TABLE IF EXISTS Empresa.DetalleCompra;
DROP TABLE IF EXISTS Empresa.Compra;
DROP TABLE IF EXISTS Empresa.EquipoComponente;
DROP TABLE IF EXISTS Empresa.Componente;
DROP TABLE IF EXISTS Empresa.Equipo;
DROP TABLE IF EXISTS Empresa.Cliente;
DROP TABLE IF EXISTS Empresa.Empleado;
DROP TABLE IF EXISTS Empresa.Seccion;
GO

/* =========================================
   4. TABLAS
   ========================================= */

/* Seccion 1 --- tiene --- N Empleado */
CREATE TABLE Empresa.Seccion (
    IdSeccion   INT IDENTITY(1,1) PRIMARY KEY,
    Nombre      VARCHAR(100) NOT NULL,
    Descripcion VARCHAR(255) NULL
);
GO

CREATE TABLE Empresa.Empleado (
    IdEmpleado INT IDENTITY(1,1) PRIMARY KEY,
    IdSeccion  INT NOT NULL,
    Nombre     VARCHAR(100) NOT NULL,
    Apellidos  VARCHAR(100) NOT NULL,
    NIF        VARCHAR(20)  NOT NULL UNIQUE,
    CONSTRAINT FK_Empleado_Seccion
        FOREIGN KEY (IdSeccion) REFERENCES Empresa.Seccion(IdSeccion)
);
GO

/* Empleado 1 --- atiende --- N Cliente */
CREATE TABLE Empresa.Cliente (
    IdCliente  INT IDENTITY(1,1) PRIMARY KEY,
    IdEmpleado INT NULL,
    Nombre     VARCHAR(100) NOT NULL,
    Direccion  VARCHAR(200) NULL,
    Telefono   VARCHAR(20)  NULL,
    NIF        VARCHAR(20)  NOT NULL UNIQUE,
    CONSTRAINT FK_Cliente_Empleado
        FOREIGN KEY (IdEmpleado) REFERENCES Empresa.Empleado(IdEmpleado)
);
GO

/* Empleado 1 --- pertenece a --- N Equipo */
CREATE TABLE Empresa.Equipo (
    IdEquipo    INT IDENTITY(1,1) PRIMARY KEY,
    IdEmpleado  INT NULL,
    Descripcion VARCHAR(255) NOT NULL,
    Precio      DECIMAL(10,2) NOT NULL,
    Stock       INT NOT NULL DEFAULT 0,
    CONSTRAINT FK_Equipo_Empleado
        FOREIGN KEY (IdEmpleado) REFERENCES Empresa.Empleado(IdEmpleado)
);
GO

CREATE TABLE Empresa.Componente (
    IdComponente INT IDENTITY(1,1) PRIMARY KEY,
    Descripcion  VARCHAR(255) NOT NULL,
    Precio       DECIMAL(10,2) NOT NULL,
    Stock        INT NOT NULL DEFAULT 0
);
GO

/* Equipo <--- forma parte de / tiene ---> Componente (N a N) */
CREATE TABLE Empresa.EquipoComponente (
    IdEquipo     INT NOT NULL,
    IdComponente INT NOT NULL,
    Cantidad     INT NOT NULL DEFAULT 1,
    CONSTRAINT PK_EquipoComponente PRIMARY KEY (IdEquipo, IdComponente),
    CONSTRAINT FK_EquipoComponente_Equipo
        FOREIGN KEY (IdEquipo) REFERENCES Empresa.Equipo(IdEquipo),
    CONSTRAINT FK_EquipoComponente_Componente
        FOREIGN KEY (IdComponente) REFERENCES Empresa.Componente(IdComponente)
);
GO

/* Cliente 1 --- realiza --- N Compra */
CREATE TABLE Empresa.Compra (
    IdCompra    INT IDENTITY(1,1) PRIMARY KEY,
    IdCliente   INT NOT NULL,
    FechaCompra DATE NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Compra_Cliente
        FOREIGN KEY (IdCliente) REFERENCES Empresa.Cliente(IdCliente)
);
GO

/* Compra 1 --- se detalla en --- N DetalleCompra
   EquipoComponente 1 --- incluye --- N DetalleCompra (clave compuesta) */
CREATE TABLE Empresa.DetalleCompra (
    IdDetalle    INT IDENTITY(1,1) PRIMARY KEY,
    IdCompra     INT NOT NULL,
    IdEquipo     INT NOT NULL,
    IdComponente INT NOT NULL,
    Cantidad     INT NOT NULL DEFAULT 1,
    Precio       DECIMAL(10,2) NOT NULL,
    CONSTRAINT FK_DetalleCompra_Compra
        FOREIGN KEY (IdCompra) REFERENCES Empresa.Compra(IdCompra),
    CONSTRAINT FK_DetalleCompra_EquipoComponente
        FOREIGN KEY (IdEquipo, IdComponente)
        REFERENCES Empresa.EquipoComponente(IdEquipo, IdComponente)
);
GO

/* =========================================
   5. VERIFICAR: lista de todas las relaciones
   ========================================= */
SELECT fk.name AS Relacion,
       OBJECT_SCHEMA_NAME(fk.parent_object_id) + '.' + OBJECT_NAME(fk.parent_object_id) AS TablaHija,
       OBJECT_SCHEMA_NAME(fk.referenced_object_id) + '.' + OBJECT_NAME(fk.referenced_object_id) AS TablaPadre
FROM sys.foreign_keys fk
ORDER BY TablaHija;
GO