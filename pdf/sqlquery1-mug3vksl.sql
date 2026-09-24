/* ---------- 1. CREAR BASE DE DATOS SI NO EXISTE ---------- */
IF DB_ID('GradosYTitulos') IS NULL
    CREATE DATABASE GradosYTitulos;
GO

USE GradosYTitulos;
GO

/* ---------- 2. BORRAR TABLAS SI YA EXISTEN (orden inverso) ---------- */
/* OJO: esto elimina los datos que tengan esas tablas */
DROP TABLE IF EXISTS Evaluacion.Sustentacion;
DROP TABLE IF EXISTS Evaluacion.EvaluacionTrabajo;
DROP TABLE IF EXISTS Documento.Diploma;
DROP TABLE IF EXISTS Documento.Resolucion;
DROP TABLE IF EXISTS Tramite.ObservacionTramite;
DROP TABLE IF EXISTS Tramite.DesignacionJurado;
DROP TABLE IF EXISTS Tramite.Designacion;
DROP TABLE IF EXISTS Tramite.PlanTesis;
DROP TABLE IF EXISTS Tramite.TrabajoInvestigacion;
DROP TABLE IF EXISTS Tramite.Fotografia;
DROP TABLE IF EXISTS Tramite.Tramite;
DROP TABLE IF EXISTS Tramite.CoordinacionGT;
DROP TABLE IF EXISTS Academico.Docente;
DROP TABLE IF EXISTS Academico.Persona;
DROP TABLE IF EXISTS Academico.GradoTituloCatalogo;
DROP TABLE IF EXISTS Academico.ProgramaEstudios;
DROP TABLE IF EXISTS Academico.Facultad;
DROP TABLE IF EXISTS Catalogo.LineaInvestigacion;
DROP TABLE IF EXISTS Catalogo.EstadoTramite;
DROP TABLE IF EXISTS Catalogo.TipoTramite;
GO

/* ---------- 3. ESQUEMAS (solo si no existen) ---------- */
IF SCHEMA_ID('Catalogo')   IS NULL EXEC('CREATE SCHEMA Catalogo');
IF SCHEMA_ID('Academico')  IS NULL EXEC('CREATE SCHEMA Academico');
IF SCHEMA_ID('Tramite')    IS NULL EXEC('CREATE SCHEMA Tramite');
IF SCHEMA_ID('Documento')  IS NULL EXEC('CREATE SCHEMA Documento');
IF SCHEMA_ID('Evaluacion') IS NULL EXEC('CREATE SCHEMA Evaluacion');
GO

/* ---------- 4. CATALOGO ---------- */
CREATE TABLE Catalogo.TipoTramite (
    IdTipoTramite INT IDENTITY(1,1) PRIMARY KEY,
    Codigo        VARCHAR(10)  NOT NULL UNIQUE,
    Nombre        VARCHAR(100) NOT NULL,
    Descripcion   VARCHAR(255) NULL
);

CREATE TABLE Catalogo.EstadoTramite (
    IdEstadoTramite INT IDENTITY(1,1) PRIMARY KEY,
    Codigo          VARCHAR(10)  NOT NULL UNIQUE,
    Nombre          VARCHAR(100) NOT NULL,
    Descripcion     VARCHAR(255) NULL
);

CREATE TABLE Catalogo.LineaInvestigacion (
    IdLineaInvestigacion INT IDENTITY(1,1) PRIMARY KEY,
    Codigo               VARCHAR(10)  NOT NULL UNIQUE,
    Nombre               VARCHAR(100) NOT NULL,
    Activa               BIT NOT NULL DEFAULT (1)
);
GO

/* ---------- 5. ACADEMICO ---------- */
CREATE TABLE Academico.Facultad (
    IdFacultad INT IDENTITY(1,1) PRIMARY KEY,
    Codigo     VARCHAR(10)  NOT NULL UNIQUE,
    Nombre     VARCHAR(100) NOT NULL,
    Estado     BIT NOT NULL DEFAULT (1)
);

CREATE TABLE Academico.ProgramaEstudios (
    IdPrograma   INT IDENTITY(1,1) PRIMARY KEY,
    IdFacultad   INT NOT NULL,
    Codigo       VARCHAR(10)  NOT NULL UNIQUE,
    Nombre       VARCHAR(100) NOT NULL,
    NumSemestres INT NOT NULL,
    FOREIGN KEY (IdFacultad) REFERENCES Academico.Facultad(IdFacultad)
);

CREATE TABLE Academico.GradoTituloCatalogo (
    IdGradoTitulo INT IDENTITY(1,1) PRIMARY KEY,
    Codigo        VARCHAR(10)  NOT NULL UNIQUE,
    Nombre        VARCHAR(100) NOT NULL,
    Tipo          VARCHAR(50)  NOT NULL
);

CREATE TABLE Academico.Persona (
    IdPersona   INT IDENTITY(1,1) PRIMARY KEY,
    DNI         VARCHAR(20)  NOT NULL UNIQUE,
    Nombres     VARCHAR(100) NOT NULL,
    Apellidos   VARCHAR(100) NOT NULL,
    TipoPersona VARCHAR(20)  NOT NULL
);

CREATE TABLE Academico.Docente (
    IdDocente    INT IDENTITY(1,1) PRIMARY KEY,
    IdPersona    INT NOT NULL,
    Grado        VARCHAR(50) NULL,
    TipoContrato VARCHAR(50) NULL,
    FOREIGN KEY (IdPersona) REFERENCES Academico.Persona(IdPersona)
);
GO

/* ---------- 6. TRAMITE ---------- */
CREATE TABLE Tramite.CoordinacionGT (
    IdCoordinacion INT IDENTITY(1,1) PRIMARY KEY,
    IdFacultad     INT NOT NULL,
    IdResponsable  INT NULL,
    Estado         VARCHAR(20) NOT NULL,
    FOREIGN KEY (IdFacultad)    REFERENCES Academico.Facultad(IdFacultad),
    FOREIGN KEY (IdResponsable) REFERENCES Academico.Docente(IdDocente)
);

CREATE TABLE Tramite.Tramite (
    IdTramite       INT IDENTITY(1,1) PRIMARY KEY,
    IdPersona       INT NOT NULL,
    IdTipoTramite   INT NOT NULL,
    IdEstadoTramite INT NOT NULL,
    IdPrograma      INT NULL,
    IdGradoTitulo   INT NULL,
    FechaInicio     DATE NOT NULL DEFAULT (GETDATE()),
    FOREIGN KEY (IdPersona)       REFERENCES Academico.Persona(IdPersona),
    FOREIGN KEY (IdTipoTramite)   REFERENCES Catalogo.TipoTramite(IdTipoTramite),
    FOREIGN KEY (IdEstadoTramite) REFERENCES Catalogo.EstadoTramite(IdEstadoTramite),
    FOREIGN KEY (IdPrograma)      REFERENCES Academico.ProgramaEstudios(IdPrograma),
    FOREIGN KEY (IdGradoTitulo)   REFERENCES Academico.GradoTituloCatalogo(IdGradoTitulo)
);

CREATE TABLE Tramite.Fotografia (
    IdFotografia INT IDENTITY(1,1) PRIMARY KEY,
    IdTramite    INT NOT NULL,
    Archivo      VARBINARY(MAX) NOT NULL,
    Formato      VARCHAR(50) NULL,
    FOREIGN KEY (IdTramite) REFERENCES Tramite.Tramite(IdTramite)
);

CREATE TABLE Tramite.TrabajoInvestigacion (
    IdTrabajo      INT IDENTITY(1,1) PRIMARY KEY,
    IdTramite      INT NOT NULL,
    Tipo           VARCHAR(50) NOT NULL,
    ModalidadAutor VARCHAR(50) NULL,
    FOREIGN KEY (IdTramite) REFERENCES Tramite.Tramite(IdTramite)
);

CREATE TABLE Tramite.PlanTesis (
    IdPlan          INT IDENTITY(1,1) PRIMARY KEY,
    IdTrabajo       INT NOT NULL,
    LineaInv        INT NULL,
    FechaAprobacion DATE NULL,
    Estado          VARCHAR(20) NOT NULL,
    FOREIGN KEY (IdTrabajo) REFERENCES Tramite.TrabajoInvestigacion(IdTrabajo),
    FOREIGN KEY (LineaInv)  REFERENCES Catalogo.LineaInvestigacion(IdLineaInvestigacion)
);

CREATE TABLE Tramite.Designacion (
    IdDesignacion INT IDENTITY(1,1) PRIMARY KEY,
    IdTrabajo     INT NOT NULL,
    IdDocente     INT NOT NULL,
    Fecha         DATE NOT NULL,
    FOREIGN KEY (IdTrabajo) REFERENCES Tramite.TrabajoInvestigacion(IdTrabajo),
    FOREIGN KEY (IdDocente) REFERENCES Academico.Docente(IdDocente)
);

CREATE TABLE Tramite.DesignacionJurado (
    IdControl      INT IDENTITY(1,1) PRIMARY KEY,
    IdTrabajo      INT NOT NULL,
    Titulo         VARCHAR(100) NULL,
    ModalidadAutor VARCHAR(50)  NULL,
    FOREIGN KEY (IdTrabajo) REFERENCES Tramite.TrabajoInvestigacion(IdTrabajo)
);

CREATE TABLE Tramite.ObservacionTramite (
    IdObservacion INT IDENTITY(1,1) PRIMARY KEY,
    IdTrabajo     INT NOT NULL,
    Fecha         DATE NOT NULL,
    Descripcion   VARCHAR(255) NULL,
    Estado        VARCHAR(20)  NOT NULL,
    FOREIGN KEY (IdTrabajo) REFERENCES Tramite.TrabajoInvestigacion(IdTrabajo)
);
GO

/* ---------- 7. DOCUMENTO ---------- */
CREATE TABLE Documento.Resolucion (
    IdResolucion   INT IDENTITY(1,1) PRIMARY KEY,
    IdTrabajo      INT NOT NULL,
    TipoResolucion VARCHAR(50) NOT NULL,
    Fecha          DATE NOT NULL,
    Observacion    VARCHAR(255) NULL,
    FOREIGN KEY (IdTrabajo) REFERENCES Tramite.TrabajoInvestigacion(IdTrabajo)
);

CREATE TABLE Documento.Diploma (
    IdDiploma INT IDENTITY(1,1) PRIMARY KEY,
    IdTramite INT NOT NULL,
    Numero    VARCHAR(50) NOT NULL,
    Fecha     DATE NOT NULL,
    NotaFinal DECIMAL(4,2) NULL,
    FOREIGN KEY (IdTramite) REFERENCES Tramite.Tramite(IdTramite)
);
GO

/* ---------- 8. EVALUACION ---------- */
CREATE TABLE Evaluacion.EvaluacionTrabajo (
    IdEvaluacion INT IDENTITY(1,1) PRIMARY KEY,
    IdTrabajo    INT NOT NULL,
    IdTramite    INT NOT NULL,
    Fecha        DATE NOT NULL,
    Nota         DECIMAL(4,2) NULL,
    FOREIGN KEY (IdTrabajo) REFERENCES Tramite.TrabajoInvestigacion(IdTrabajo),
    FOREIGN KEY (IdTramite) REFERENCES Tramite.Tramite(IdTramite)
);

CREATE TABLE Evaluacion.Sustentacion (
    IdSustentacion INT IDENTITY(1,1) PRIMARY KEY,
    IdTrabajo      INT NOT NULL,
    IdTramite      INT NOT NULL,
    Fecha          DATE NOT NULL,
    Nota           DECIMAL(4,2) NULL,
    FOREIGN KEY (IdTrabajo) REFERENCES Tramite.TrabajoInvestigacion(IdTrabajo),
    FOREIGN KEY (IdTramite) REFERENCES Tramite.Tramite(IdTramite)
);
GO