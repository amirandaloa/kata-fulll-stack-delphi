
USE [KATA_FULLSTACK_DELPHI]
GO

/****** Object:  Table [canal_cafetero].[CAFICULTORES]     Script Date: 14/6/2025 19:48:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [canal_cafetero].[CAFICULTORES](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [varchar](100) NULL,
	[identificacion] [varchar](20) NULL,
	[ciudad] [varchar](50) NULL,
	[tipo_producto] [varchar](50) NULL,
PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


-- Para ABONOS_MONEDERO
CREATE TABLE [canal_cafetero].[ABONOS_MONEDERO](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[id_caficultor] [int] NULL,
	[valor] [decimal](18, 2) NULL,
	[fecha] [datetime] default GETDATE(),
PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [canal_cafetero].[ABONOS_MONEDERO] WITH CHECK ADD FOREIGN KEY([id_caficultor])
REFERENCES [canal_cafetero].[CAFICULTORES] ([id])
GO

CREATE TABLE [canal_cafetero].[PRODUCTOS_CLIENTE] (
    [id] [int] IDENTITY(1,1) PRIMARY KEY,
    [id_caficultor] [int] NOT NULL,
    [tipo_producto] VARCHAR(50) NOT NULL CHECK (tipo_producto IN ('Ahorros', 'Corriente', 'Crédito', 'Inversión')),
    [numero_cuenta] VARCHAR(50) UNIQUE NOT NULL,
    FOREIGN KEY (id_caficultor) REFERENCES [canal_cafetero].CAFICULTORES(id)
);
GO

USE [KATA_FULLSTACK_DELPHI]
GO

/****** Object:  StoredProcedure [canal_cafetero].[SP_RegistrarAbonoMonedero]    Script Date: 15/6/2025 15:45:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- Registrar Abono a Monedero
CREATE OR ALTER   PROCEDURE [canal_cafetero].[SP_RegistrarAbonoMonedero]
    @IdCaficultor INT,
    @Valor DECIMAL(18, 2)
AS
BEGIN
    SET NOCOUNT ON;
    -- Solo permite abonos a caficultores registrados
    IF NOT EXISTS (SELECT 1 FROM canal_cafetero.CAFICULTORES WHERE id = @IdCaficultor)
    BEGIN
        RAISERROR('El ID de caficultor especificado no existe.', 16, 1);
        RETURN;
    END;

    -- No se permiten abonos negativos o cero
    IF @Valor <= 0
    BEGIN
        RAISERROR('El valor del abono debe ser positivo.', 16, 1);
        RETURN;
    END;

    INSERT INTO canal_cafetero.ABONOS_MONEDERO (id_caficultor, valor)
    VALUES (@IdCaficultor, @Valor);
END;
GO

USE [KATA_FULLSTACK_DELPHI]
GO

/****** Object:  StoredProcedure [canal_cafetero].[SP_RegistrarCaficultor]    Script Date: 15/6/2025 15:50:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- Registrar Caficultor
CREATE   PROCEDURE [canal_cafetero].[SP_RegistrarCaficultor]
    @Nombre VARCHAR(100),
    @Identificacion VARCHAR(20),
    @Ciudad VARCHAR(50),
    @TipoProducto VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO canal_cafetero.CAFICULTORES (nombre, identificacion, ciudad, tipo_producto)
    VALUES (@Nombre, @Identificacion, @Ciudad, @TipoProducto);
END;
GO

USE [KATA_FULLSTACK_DELPHI]
GO

/****** Object:  StoredProcedure [canal_cafetero].[SP_GetProductosBancariosCliente]    Script Date: 15/6/2025 15:50:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- SP para Consultar Productos Bancarios del cliente
CREATE   PROCEDURE [canal_cafetero].[SP_GetProductosBancariosCliente]
    @IdCaficultor INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        id,
        tipo_producto,
        numero_cuenta
    FROM
        canal_cafetero.PRODUCTOS_CLIENTE
    WHERE
        id_caficultor = @IdCaficultor;
END;
GO

USE [KATA_FULLSTACK_DELPHI]
GO

/****** Object:  StoredProcedure [canal_cafetero].[SP_ConsultarSaldoMonedero]    Script Date: 15/6/2025 15:50:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--  Consultar Saldo del Monedero
-- devolver el saldo 
CREATE   PROCEDURE [canal_cafetero].[SP_ConsultarSaldoMonedero]
    @IdCaficultor INT,
    @Saldo DECIMAL(18, 2) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT @Saldo = ISNULL(SUM(valor), 0)
    FROM canal_cafetero.ABONOS_MONEDERO
    WHERE id_caficultor = @IdCaficultor;
END;
GO


