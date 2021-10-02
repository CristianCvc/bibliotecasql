DROP TABLE IF EXISTS prestamo;
DROP TABLE IF EXISTS info_libros;
DROP TABLE IF EXISTS socios;
DROP TABLE IF EXISTS libros;
DROP TABLE IF EXISTS autor;

CREATE TABLE autor (
codigo INT,
nombre_autor VARCHAR(10),
apellido_autor VARCHAR(10),
año_nacimiento INT,
año_muerte INT,
tipo VARCHAR(9),
PRIMARY KEY (codigo)
);

CREATE TABLE libros (
isbn VARCHAR(15),
titulo VARCHAR,
n_de_paginas INT,
dias_prestamo INT,
stock INT CHECK (stock >= 0.00),
PRIMARY KEY (isbn)
);
-- se crea el elemento 'stock' con INT CHECK para que si se pide un libro ya pedido (stock=0)
-- el sistema muestre un mensaje de error y solo se pueda pedir un libro

CREATE TABLE socios (
id INT,
rut VARCHAR(9),
nombre VARCHAR(10),
apellido VARCHAR(10),
direccion VARCHAR,
telefono INT,
libro_prestado INT CHECK (libro_prestado < 2.00),
PRIMARY KEY (id)
);
-- se crea el elemento 'libro_prestado' con INT CHECK para que un socio no pueda pedir más de 1 solo libro
-- en caso contrario el sistema mostrará un mensaje de error

CREATE TABLE info_libros (
id_registro INT,
codigo_autor INT,
isbn_libro VARCHAR(15),
PRIMARY KEY (id_registro),
FOREIGN KEY (codigo_autor) REFERENCES autor (codigo),
FOREIGN KEY (isbn_libro) REFERENCES libros (isbn)
);

CREATE TABLE prestamo (
id_socio INT,
fecha_prestamo DATE,
fecha_estimada_devolucion DATE,
fecha_real_devolucion DATE,
registro_prestamo INT,
FOREIGN KEY (id_socio) REFERENCES socios (id),
FOREIGN KEY (registro_prestamo) REFERENCES info_libros (id_registro)
);

INSERT INTO autor (codigo, nombre_autor, apellido_autor, año_nacimiento, año_muerte, tipo)
VALUES (3, 'JOSE', 'SALGADO', 1968, 2020, 'PRINCIPAL');

INSERT INTO autor (codigo, nombre_autor, apellido_autor, año_nacimiento, tipo)
VALUES (4, 'ANA', 'SALGADO', 1972, 'COAUTOR');

INSERT INTO autor (codigo, nombre_autor, apellido_autor, año_nacimiento, tipo)
VALUES (1, 'ANDRES', 'ULLOA', 1982, 'PRINCIPAL');

INSERT INTO autor (codigo, nombre_autor, apellido_autor, año_nacimiento, año_muerte, tipo)
VALUES (2, 'SERGIO', 'MARDONES', 1950, 2012, 'PRINCIPAL');

INSERT INTO autor (codigo, nombre_autor, apellido_autor, año_nacimiento, tipo)
VALUES (5, 'MARTIN', 'PORTA', 1976, 'PRINCIPAL');

INSERT INTO libros (isbn, titulo, n_de_paginas, dias_prestamo, stock)
VALUES ('111-1111111-111', 'CUENTOS DE TERROR', 344, 7, 1);

INSERT INTO libros (isbn, titulo, n_de_paginas, dias_prestamo, stock)
VALUES ('222-2222222-222', 'POESÍAS CONTEMPORANEAS', 167, 7, 1);

INSERT INTO libros (isbn, titulo, n_de_paginas, dias_prestamo, stock)
VALUES ('333-3333333-333', 'HISTORIA DE ASIA', 511, 14, 1);

INSERT INTO libros (isbn, titulo, n_de_paginas, dias_prestamo, stock)
VALUES ('444-4444444-444', 'MANUAL DE MECÁNICA', 298, 14, 1);

INSERT INTO socios (id, rut, nombre, apellido, direccion, telefono, libro_prestado)
VALUES (1, '1111111-1', 'JUAN', 'SOTO', 'AVENIDA 1, SANTIAGO', 911111111, 0);

INSERT INTO socios (id, rut, nombre, apellido, direccion, telefono, libro_prestado)
VALUES (2, '2222222-2', 'ANA', 'PÉREZ', 'PASAJE 2, SANTIAGO', 922222222, 0);

INSERT INTO socios (id, rut, nombre, apellido, direccion, telefono, libro_prestado)
VALUES (3, '3333333-3', 'SANDRA', 'AGUILAR', 'AVENIDA 2, SANTIAGO', 933333333, 0);

INSERT INTO socios (id, rut, nombre, apellido, direccion, telefono, libro_prestado)
VALUES (4, '4444444-4', 'ESTEBAN', 'JEREZ', 'AVENIDA 3, SANTIAGO', 944444444, 0);

INSERT INTO socios (id, rut, nombre, apellido, direccion, telefono, libro_prestado)
VALUES (5, '5555555-5', 'SILVANA', 'MUÑOZ', 'PASAJE 3, SANTIAGO', 955555555, 0);

INSERT INTO info_libros (id_registro, codigo_autor, isbn_libro)
VALUES (1, 3, '111-1111111-111');

INSERT INTO info_libros (id_registro, codigo_autor, isbn_libro)
VALUES (2, 4, '111-1111111-111');

INSERT INTO info_libros (id_registro, codigo_autor, isbn_libro)
VALUES (3, 1, '222-2222222-222');

INSERT INTO info_libros (id_registro, codigo_autor, isbn_libro)
VALUES (4, 2, '333-3333333-333');

INSERT INTO info_libros (id_registro, codigo_autor, isbn_libro)
VALUES (5, 5, '444-4444444-444');

INSERT INTO prestamo (id_socio, fecha_prestamo, fecha_estimada_devolucion, fecha_real_devolucion, registro_prestamo)
VALUES (1, '2020-01-20', '2020-01-27', '2020-01-27', 1);
-- en la fecha del ingreso además de dejar registro del prestamo se hace la transaccion del libro en el sistema.
BEGIN;
UPDATE libros SET stock = stock -1 WHERE isbn = '111-1111111-111';
UPDATE socios SET libro_prestado = libro_prestado +1 WHERE id = 1;
COMMIT;
-- se usa comando select para verificar la transacion exitosa
SELECT stock, titulo FROM libros;
SELECT nombre, apellido, libro_prestado FROM socios;
-- el dia de entrega se hace la transacción de devolución del libro
BEGIN;
UPDATE libros SET stock = stock +1 WHERE isbn = '111-1111111-111';
UPDATE socios SET libro_prestado = libro_prestado -1 WHERE id = 1;
COMMIT;
-- se usa comando select para verificar la transacion exitosa
SELECT stock, titulo FROM libros;
SELECT nombre, apellido, libro_prestado FROM socios;

INSERT INTO prestamo (id_socio, fecha_prestamo, fecha_estimada_devolucion, fecha_real_devolucion, registro_prestamo)
VALUES (5, '2020-01-20', '2020-01-27', '2020-01-30', 3);

BEGIN;
UPDATE libros SET stock = stock -1 WHERE isbn = '222-2222222-222';
UPDATE socios SET libro_prestado = libro_prestado +1 WHERE id = 5;
COMMIT;

SELECT stock, titulo FROM libros;
SELECT nombre, apellido, libro_prestado FROM socios;

BEGIN;
UPDATE libros SET stock = stock +1 WHERE isbn = '222-2222222-222';
UPDATE socios SET libro_prestado = libro_prestado -1 WHERE id = 5;
COMMIT;

SELECT stock, titulo FROM libros;
SELECT nombre, apellido, libro_prestado FROM socios;

INSERT INTO prestamo (id_socio, fecha_prestamo, fecha_estimada_devolucion, fecha_real_devolucion, registro_prestamo)
VALUES (3, '2020-01-22', '2020-02-05', '2020-01-30', 4);

BEGIN;
UPDATE libros SET stock = stock -1 WHERE isbn = '333-3333333-333';
UPDATE socios SET libro_prestado = libro_prestado +1 WHERE id = 3;
COMMIT;

SELECT stock, titulo FROM libros;
SELECT nombre, apellido, libro_prestado FROM socios;

BEGIN;
UPDATE libros SET stock = stock +1 WHERE isbn = '333-3333333-333';
UPDATE socios SET libro_prestado = libro_prestado -1 WHERE id = 3;
COMMIT;

SELECT stock, titulo FROM libros;
SELECT nombre, apellido, libro_prestado FROM socios;

INSERT INTO prestamo (id_socio, fecha_prestamo, fecha_estimada_devolucion, fecha_real_devolucion, registro_prestamo)
VALUES (4, '2020-01-23', '2020-02-06', '2020-01-30', 5);

BEGIN;
UPDATE libros SET stock = stock -1 WHERE isbn = '444-4444444-444';
UPDATE socios SET libro_prestado = libro_prestado +1 WHERE id = 4;
COMMIT;

SELECT stock, titulo FROM libros;
SELECT nombre, apellido, libro_prestado FROM socios;

BEGIN;
UPDATE libros SET stock = stock +1 WHERE isbn = '444-4444444-444';
UPDATE socios SET libro_prestado = libro_prestado -1 WHERE id = 4;
COMMIT;

SELECT stock, titulo FROM libros;
SELECT nombre, apellido, libro_prestado FROM socios;

INSERT INTO prestamo (id_socio, fecha_prestamo, fecha_estimada_devolucion, fecha_real_devolucion, registro_prestamo)
VALUES (2, '2020-01-27', '2020-02-10', '2020-02-04', 1);

BEGIN;
UPDATE libros SET stock = stock -1 WHERE isbn = '111-1111111-111';
UPDATE socios SET libro_prestado = libro_prestado +1 WHERE id = 2;
COMMIT;

SELECT stock, titulo FROM libros;
SELECT nombre, apellido, libro_prestado FROM socios;

BEGIN;
UPDATE libros SET stock = stock +1 WHERE isbn = '111-1111111-111';
UPDATE socios SET libro_prestado = libro_prestado -1 WHERE id = 2;
COMMIT;

SELECT stock, titulo FROM libros;
SELECT nombre, apellido, libro_prestado FROM socios;

INSERT INTO prestamo (id_socio, fecha_prestamo, fecha_estimada_devolucion, fecha_real_devolucion, registro_prestamo)
VALUES (1, '2020-01-31', '2020-02-14', '2020-02-12', 5);

BEGIN;
UPDATE libros SET stock = stock -1 WHERE isbn = '444-4444444-444';
UPDATE socios SET libro_prestado = libro_prestado +1 WHERE id = 1;
COMMIT;

SELECT stock, titulo FROM libros;
SELECT nombre, apellido, libro_prestado FROM socios;

BEGIN;
UPDATE libros SET stock = stock +1 WHERE isbn = '444-4444444-444';
UPDATE socios SET libro_prestado = libro_prestado -1 WHERE id = 1;
COMMIT;

SELECT stock, titulo FROM libros;
SELECT nombre, apellido, libro_prestado FROM socios;

INSERT INTO prestamo (id_socio, fecha_prestamo, fecha_estimada_devolucion, fecha_real_devolucion, registro_prestamo)
VALUES (3, '2020-01-31', '2020-02-07', '2020-02-12', 3);

BEGIN;
UPDATE libros SET stock = stock -1 WHERE isbn = '222-2222222-222';
UPDATE socios SET libro_prestado = libro_prestado +1 WHERE id = 3;
COMMIT;

SELECT stock, titulo FROM libros;
SELECT nombre, apellido, libro_prestado FROM socios;

BEGIN;
UPDATE libros SET stock = stock +1 WHERE isbn = '222-2222222-222';
UPDATE socios SET libro_prestado = libro_prestado -1 WHERE id = 3;
COMMIT;

SELECT stock, titulo FROM libros;
SELECT nombre, apellido, libro_prestado FROM socios;

-- Mostrar todos los libros que posean menos de 300 paginas
SELECT titulo FROM libros WHERE n_de_paginas<300;
-- resultado: 
--titulo         
--------------------------
-- POESÍAS CONTEMPORANEAS
-- MANUAL DE MECÁNICA
--(2 filas)

-- Mostrar todos los autores que hayan nacido después del 01-01-1970
SELECT nombre_autor, apellido_autor FROM autor WHERE año_nacimiento>1970;
-- resultado:
--nombre_autor | apellido_autor 
----------------+----------------
-- ANA          | SALGADO
-- ANDRES       | ULLOA
-- MARTIN       | PORTA
--(3 filas)

--NO SE ME FUNCIONO LA CONSULTA DEL LIBRO MÁS PEDIDO :'(

-- Mostrar cuánto debería pagar cada usuario que entregue el préstamo después de 7 días
-- se muestran todos los datos de los socios para contactarlos y cobrarle la multa XD
SELECT id, rut, nombre, apellido, telefono, direccion, fecha_real_devolucion - fecha_estimada_devolucion
AS dias_retraso_entrega, (fecha_real_devolucion - fecha_estimada_devolucion)*100 AS multa
FROM socios JOIN prestamo ON id_socio=socios.id 
WHERE (fecha_real_devolucion - fecha_estimada_devolucion) > 0;
-- resultado:
--id |    rut    | nombre  | apellido | telefono  |      direccion      | dias_retraso_entrega | multa 
------+-----------+---------+----------+-----------+---------------------+----------------------+-------
--  5 | 5555555-5 | SILVANA | MUÑOZ    | 955555555 | PASAJE 3, SANTIAGO  |                    3 |   300
--  3 | 3333333-3 | SANDRA  | AGUILAR  | 933333333 | AVENIDA 2, SANTIAGO |                    5 |   500
--(2 filas)
