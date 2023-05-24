-- Creacion de BD --

create database Proyecto_EBD2
use Proyecto_EBD2

create table Usuarios
(
Id int identity(1,1),
Nombres varchar(50),
ApellidoP varchar(50),
ApellidoM varchar(50),
Fecha date,
Usuario varchar(50),
Contraseña varbinary (max)
)

create table Imagenes
(
IdUsuario int,
Imagen image
)

-- POR EJECUTAR Registrar--
create procedure Registrar

@Nombres varchar(50),
@ApellidoP varchar(50),
@ApellidoM varchar(50),
@Fecha date,
@Usuario varchar(50),
@Contraseña varchar(100),
@Patron varchar(50),
@IdUsuario int, 
@Imagen image
as
begin
insert into Usuarios values(@Nombres, @ApellidoP, @ApellidoM, @Fecha, @Usuario, ENCRYPTBYPASSPHRASE(@Patron, @Contraseña));
set @IdUsuario=(select Id from Usuarios where Usuario=@Usuario);
insert into Imagenes values(@IdUsuario, @Imagen)
end

-- -- POR EJECUTAR Validar--

create procedure Validar

@Usuario varchar(50),
@Contraseña varchar(100),
@Patron varchar(50)
as
begin
select*from Usuarios where Usuario=@Usuario and Convert(varchar(100), DECRYPTBYPASSPHRASE(@Patron, Contraseña))=@Contraseña
end

-- POR EJECUTAR Perfil--

create procedure Perfil
@Id int
as
begin
select*from Usuarios where Id=@Id;
select* from Imagenes where IdUsuario=@Id
end

-- POR EJECUTAR Eliminar--

create procedure Eliminar
@Id int
as
begin
delete from Usuarios where Id=@Id;
delete from Imagenes where IdUsuario=@Id
end

-- POR EJECUTAR Cargar Imagen--

create procedure CargarImagen
@id int
as
begin
select Imagen from Imagenes where IdUsuario=@Id
end

-- POR EJECUTAR Cambiar Imagen--

create procedure CambiarImagen
@Id int,
@Imagen image
as
begin
update Imagenes set Imagen=@Imagen where IdUsuario=@Id
end

-- POR EJECUTAR ContarUsuario - Sirve para que los usuarios no se repitan --

create procedure ContarUsuario
@usuario varchar(50)
as
begin

select count(*) from Usuarios where Usuario=@usuario
end


--Fin de Creacion de BD ---

-- ************************************************************************************************ -- 


-- Consulta de BD --

select*from Usuarios
select*from Imagenes

--Fin de Consultas de BD ---

-- ************************************************************************************************ -- 




-- ******** Creacion de CURP, CIFRADO CESAR Y CIFRADO HILL ********** --

--Generar una CURP--

create procedure curp
 @Nombres varchar(50),
 @ApellidoP varchar(50),
 @ApellidoM varchar(50), 
 @estado varchar(50),
 @Fecha DATE,
 --@sexo varchar(10)
 
as 

declare @pnombre varchar(50)
declare @pconsonatenombre varchar(50)
declare @n_consonante varchar(10)
declare @contador3 int
declare @ini_paterno varchar(50)
declare @ap_vocal varchar(50)
declare @ap_consonante varchar(50)
declare @vocal varchar(10)
declare @consonante varchar(50)
declare    @contador1 int
declare @cont int
declare @am_consonante varchar(50)
declare @am_incial varchar(10)
DECLARE @am_pconsonate varchar(10)
declare @contador2 int
declare @clave_est varchar(10)
declare @año varchar(3)
declare @mes int 
declare @mmes varchar(20)
declare @dia int
declare @ddia varchar(5)
--declare @c_sexo varchar(2)

-- Generear Vocales --

set @ini_paterno=SUBSTRING(@ApellidoP,1,1)
set @contador1 = 1
 WHILE (@contador1 <LEN(@ApellidoP))
    BEGIN
set @contador1=@contador1+1
SET @vocal= null
set @vocal= (select x = SUBSTRING(@ApellidoP,@contador1,1))
SET @ap_vocal = (CASE 
                    WHEN @vocal = 'a' THEN 'a'
                    WHEN @vocal = 'e' THEN 'e'
                    WHEN @vocal = 'o' THEN 'o'
                    WHEN @vocal = 'u' THEN 'u'
                    WHEN @vocal = 'i' THEN 'i'
                    ELSE ''
                END)
 if (@ap_vocal = 'a')
 BEGIN
 set @ap_vocal = 'a'
 BREAK
  END
  ELSE 
  IF (@ap_vocal = 'e')
  BEGIN
  break
 set @ap_vocal = 'e'
  END 
  ELSE 
  IF (@ap_vocal = 'i')
  BEGIN
  break
 set @ap_vocal = 'i'
  END
  ELSE 
  IF (@ap_vocal= 'o')
  BEGIN
  break
 set @ap_vocal = 'o'
  END
  ELSE 
  IF (@ap_vocal = 'u')
  BEGIN
  break
  set @ap_vocal = 'u'
  END 
  else 
  CONTINUE
  END

-- Fin para Crear una CURP --

-- ************************************************************************************************************** --


-- GENERAR CIFRADO O ENCRIPTACION CESAR Ver 1 --

-- Definir una función para encriptar un texto usando el cifrado César --
CREATE FUNCTION EncriptarCesar(@texto VARCHAR(MAX), @desplazamiento INT)
RETURNS VARCHAR(MAX)
AS
BEGIN
    DECLARE @resultado VARCHAR(MAX)

    SET @resultado = ''

    SELECT @resultado = @resultado + 
        CASE 
            WHEN ASCII(substring(@texto, n, 1)) BETWEEN 65 AND 90 THEN 
                CHAR((ASCII(substring(@texto, n, 1)) - 65 + @desplazamiento) % 26 + 65)
            WHEN ASCII(substring(@texto, n, 1)) BETWEEN 97 AND 122 THEN 
                CHAR((ASCII(substring(@texto, n, 1)) - 97 + @desplazamiento) % 26 + 97)
            ELSE 
                substring(@texto, n, 1)
        END
    FROM (VALUES (1), (2), (3), (4), (5), (6), (7), (8), (9), (10), (11), (12), (13), (14), (15), (16), (17), (18), (19), (20), (21), (22), (23), (24), (25), (26)) AS Numbers(n)
    WHERE n <= LEN(@texto)

    RETURN @resultado
END

-- Una vez creada la función EncriptarCesar, se puede encriptar un texto llamando la función dentro de una consulta SQL --
-- Encriptar un texto usando el cifrado César con un desplazamiento de 3 --
SELECT dbo.EncriptarCesar('Hola, mundo!', 3) AS TextoEncriptado

-- Resualtado esperado: Krñd, pxqgr!  --

-- FIN DE GENERAR UN CIFRADO O ENCRIPTACION CESAR Ver 1 --

-- ************************************************************* *********************************************************************--



-- GENERAR CIFRADO O ENCRIPTACION CESAR Ver 2 --

-- Creacion de un procedimiento almacenado para encriptar un texto usando cifrado César --
CREATE PROCEDURE EncriptarCesar
    @texto VARCHAR(MAX),
    @desplazamiento INT
AS
BEGIN
    DECLARE @resultado VARCHAR(MAX)

    SET @resultado = ''

    SELECT @resultado = @resultado + 
        CASE 
            WHEN ASCII(substring(@texto, n, 1)) BETWEEN 65 AND 90 THEN 
                CHAR((ASCII(substring(@texto, n, 1)) - 65 + @desplazamiento) % 26 + 65)
            WHEN ASCII(substring(@texto, n, 1)) BETWEEN 97 AND 122 THEN 
                CHAR((ASCII(substring(@texto, n, 1)) - 97 + @desplazamiento) % 26 + 97)
            ELSE 
                substring(@texto, n, 1)
        END
    FROM (VALUES (1), (2), (3), (4), (5), (6), (7), (8), (9), (10), (11), (12), (13), (14), (15), (16), (17), (18), (19), (20), (21), (22), (23), (24), (25), (26)) AS Numbers(n)
    WHERE n <= LEN(@texto)

    SELECT @resultado AS TextoEncriptado
END

-- Al crear la funcion EncriptarCesar, se puede encriptar un texto llamando la función dentro de la consulta SQL --
-- Llamada al procedimiento almacenado para encriptar un texto usando el cifrado César con un desplazamiento de 3  --

EXEC EncriptarCesar 'Hola, mundo!', 3

-- Resualtado esperado: Krñd, pxqgr!  --


-- FIN DE GENERAR UN CIFRADO O ENCRIPTACION CESAR Ver 2 --



-- ******************************************************************************************************************************************** --



-- GENERAR CIFRADO O ENCRIPTACION HILL Ver 1 --

-- Creacion del procedimiento almacenado para encriptar un texto usando el cifrado Hill
CREATE PROCEDURE EncriptarHill
    @texto VARCHAR(MAX),
    @clave VARCHAR(MAX)
AS
BEGIN
    DECLARE @resultado VARCHAR(MAX)
    DECLARE @length INT

    -- Normalizar el texto y la clave
    SET @texto = REPLACE(LOWER(@texto), ' ', '')
    SET @clave = REPLACE(LOWER(@clave), ' ', '')
    SET @length = LEN(@texto)

    -- Obtener la dimensión de la matriz clave
    DECLARE @dimension INT
    SET @dimension = CAST(SQRT(LEN(@clave)) AS INT)

    -- Verificar que la longitud del texto sea múltiplo de la dimensión
    IF @length % @dimension <> 0
    BEGIN
        RAISERROR('La longitud del texto debe ser múltiplo de la dimensión de la matriz clave.', 16, 1)
        RETURN
    END

    -- Crear la matriz clave
    DECLARE @matrizClave TABLE (fila INT, columna INT, valor INT)
    DECLARE @indice INT
    SET @indice = 1

    WHILE @indice <= LEN(@clave)
    BEGIN
        INSERT INTO @matrizClave (fila, columna, valor)
        SELECT (@indice - 1) / @dimension + 1, (@indice - 1) % @dimension + 1, ASCII(SUBSTRING(@clave, @indice, 1)) - 97
        SET @indice = @indice + 1
    END

    -- Encripta el texto
    SET @resultado = ''

    WHILE @length > 0
    BEGIN
        DECLARE @bloqueOriginal TABLE (fila INT, valor INT)
        DECLARE @bloqueEncriptado TABLE (fila INT, valor INT)

        -- Crea el bloque original
        INSERT INTO @bloqueOriginal (fila, valor)
        SELECT (@length - 1) / @dimension + 1, ASCII(SUBSTRING(@texto, @length, 1)) - 97
        SET @length = @length - 1

        -- Multiplica el bloque original por la matriz clave
        INSERT INTO @bloqueEncriptado (fila, valor)
        SELECT bo.fila, SUM(bo.valor * mc.valor) % 26
        FROM @bloqueOriginal bo
        JOIN @matrizClave mc ON bo.fila = mc.columna
        GROUP BY bo.fila

        -- Agrega los valores encriptados al resultado
        SET @resultado = CHAR((SELECT valor FROM @bloqueEncriptado) + 97) + @resultado
    END

    SELECT @resultado AS TextoEncriptado
END

-- Al crear la funcion EncriptarHill, se puede encriptar un texto llamando la función dentro de la consulta SQL --
-- Llamar al procedimiento almacenado para encriptar un texto usando el cifrado Hill con una clave de "key"
EXEC EncriptarHill 'holamundo', 'key'

-- Resualtado esperado: omrczcqzp  --


-- FIN DE GENERAR UN CIFRADO O ENCRIPTACION HILL Ver 1 --



-- ************************************************************************************************************************************************ --