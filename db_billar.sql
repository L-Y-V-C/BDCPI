-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 18-11-2024 a las 04:41:40
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `db_billar`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `AssignCasilleroToCliente` (IN `in_IDCliente` INT)   BEGIN
    DECLARE freeCasillero INT;

    -- Llamar a la función para obtener el primer casillero libre
    SET freeCasillero = GetFirstNullCasillero();
    
    IF freeCasillero IS NOT NULL AND freeCasillero != -1 THEN
        -- Asignar el cliente al casillero libre
        UPDATE casillero
        SET IDCliente = in_IDCliente
        WHERE IDCasillero = freeCasillero;
    ELSE
        INSERT INTO casillero (IDCliente) VALUES (in_IDCliente);

        UPDATE casillero
        SET numero = LAST_INSERT_ID()
        WHERE IDCasillero = LAST_INSERT_ID();
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_all_clientes` ()   BEGIN
	SELECT * FROM cliente;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_all_consumibles` ()   BEGIN
	SELECT * FROM consumible;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_all_locales` ()   BEGIN
	SELECT * FROM tlocal;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_all_mesabillar` ()   BEGIN
	SELECT IDMesaBillar,Tipo,Estado FROM mesabillar GROUP BY IDMesaBillar;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_all_pedido_completo` ()   BEGIN
	SELECT CONCAT(cl.Nombre,' ',cl.Apellidos) AS 'Nombre_Cliente',tl.IDLocal,con.Nombre,con.Precio,pedidocon.Cantidad FROM tlocal AS tl INNER JOIN local_consumible INNER JOIN consumible AS con INNER JOIN pedidoconsumible_consumible INNER JOIN pedidoconsumible AS pedidocon INNER JOIN cliente AS cl ON tl.IDLocal=local_consumible.IDLocal AND local_consumible.IDConsumible = con.IDConsumible AND con.IDConsumible=pedidoconsumible_consumible.IDConsumible AND pedidoconsumible_consumible.IDPedidoConsumible=pedidocon.IDPedidoConsumible AND pedidocon.IDCliente=cl.IDCliente;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_all_propietario_casillero` ()   BEGIN
	SELECT CONCAT(c.Nombre,' ',c.Apellidos) AS 'Nombre y Apellidos',ca.Numero AS 'Numero casillero' FROM cliente AS c INNER JOIN casillero AS ca ON c.IDCliente=ca.IDCasillero;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_all_stock` (IN `id` INT)   BEGIN
	SELECT consumible.Stock FROM consumible WHERE consumible.IDConsumible=id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_cliente_by_id` (IN `cliente_id` INTEGER)   BEGIN
    SELECT * FROM cliente
    WHERE cliente.IDCliente = cliente_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_empleados_by_id` (IN `dni` INTEGER)   BEGIN
    SELECT * FROM empleado
    WHERE empleado.DNI = dni;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_empleados_by_local_id` (IN `local_id` INT)   BEGIN
    SELECT 
        emp.DNI,
        emp.Telefono,
        emp.Nombre,
        emp.Apellido,
        emp.CorreoElectronico,
        emp.Cargo,
        emp.IDLocal
    FROM 
        empleado AS emp
    INNER JOIN 
        tlocal AS loc 
        ON loc.IDLocal = emp.IDLocal
    WHERE 
        loc.IDLocal = local_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_mesabillar_by_local_id` (IN `local_id` INTEGER)   BEGIN
    SELECT 
        mes.IDMesaBillar, 
        mes.Tipo, 
        mes.Estado, 
        mes.IDMantenimiento, 
        mes.IDPagoCOM, 
        mes.IDAmbiente
    FROM 
        mesabillar AS mes
    INNER JOIN 
        ambiente AS amb 
        ON mes.IDAmbiente = amb.IDAmbiente
    INNER JOIN 
        tlocal AS loc 
        ON amb.IDLocal = loc.IDLocal
    WHERE 
        loc.IDLocal = local_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_mesa_by_id` (IN `id` INT)   BEGIN
	SELECT * FROM mesabillar WHERE mesabillar.IDMesaBillar=id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_monto_consumibles` (IN `cliente_id` INT)   BEGIN
    SELECT 
        p.IDPago,
        pc.IDPedidoConsumible,
        c.IDConsumible,
        c.Nombre, 
        c.Precio, 
        pc.Cantidad,
        (pc.Cantidad * c.Precio) AS MontoConsumible
    FROM 
        pago p 
    INNER JOIN 
        pedidoconsumible pc ON pc.IDPedidoConsumible = p.IDPedidoConsumible
    INNER JOIN 
        pedidoconsumible_consumible pcc ON pcc.IDPedidoConsumible = pc.IDPedidoConsumible
    INNER JOIN 
        consumible c ON c.IDConsumible = pcc.IDConsumible
    WHERE 
        pc.IDCliente = cliente_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_monto_mesa` (IN `cliente_id` INT)   BEGIN
    SELECT 
        p.IDPago,
        com.IDPagoCOM, 
        com.PrecioHora,
        com.HoraInicio, 
        com.HoraFin, 
        FORMAT((EXTRACT(HOUR FROM com.HoraFin) - EXTRACT(HOUR FROM com.HoraInicio) 
        + EXTRACT(MINUTE FROM com.HoraFin)/60.0 
        - EXTRACT(MINUTE FROM com.HoraInicio)/60.0),2) * com.PrecioHora AS MontoMesa
    FROM 
        pago p 
    INNER JOIN 
        checkoutmesa com ON p.IDPagoCOM = com.IDPagoCOM
    INNER JOIN
    	cliente c ON c.IDPagoCOM = com.IDPagoCOM
    WHERE 
        c.IDCliente = cliente_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_monto_total_cliente` (IN `cliente_id` INT)   BEGIN
    DECLARE MontoMesa DECIMAL(10, 2);
    DECLARE MontoTotalConsumibles DECIMAL(10, 2);
    SELECT 
        (EXTRACT(HOUR FROM com.HoraFin) - EXTRACT(HOUR FROM com.HoraInicio) 
        + EXTRACT(MINUTE FROM com.HoraFin)/60.0 
        - EXTRACT(MINUTE FROM com.HoraInicio)/60.0) * com.PrecioHora 
    INTO MontoMesa
    FROM 
        pago p 
    INNER JOIN 
        checkoutmesa com ON p.IDPagoCOM = com.IDPagoCOM
    INNER JOIN
    	cliente c ON c.IDPagoCOM = com.IDPagoCOM
    WHERE 
        c.IDCliente = cliente_id;

    SELECT 
        SUM(pc.Cantidad * c.Precio) 
    INTO 
        MontoTotalConsumibles
    FROM 
        pago p
    INNER JOIN 
        pedidoconsumible pc ON pc.IDPedidoConsumible = p.IDPedidoConsumible
    INNER JOIN 
        pedidoconsumible_consumible pcc ON pcc.IDPedidoConsumible = pc.IDPedidoConsumible
    INNER JOIN 
        consumible c ON c.IDConsumible = pcc.IDConsumible
    WHERE 
        pc.IDCliente = cliente_id;

    SELECT MontoMesa, IFNULL(MontoTotalConsumibles, 0), (MontoMesa + IFNULL(MontoTotalConsumibles,0)) AS MontoTotal;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_ambiente` (IN `NombreAmbiente` VARCHAR(30), IN `CapacidadAmbiente` INT, IN `IDLocalAmbiente` INT)   BEGIN
    INSERT INTO ambiente (Nombre, Capacidad, IDLocal) VALUES (NombreAmbiente, CapacidadAmbiente, IDLocalAmbiente);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_casillero` (IN `num` INT(11), IN `idCliente` INT(11))   BEGIN
	INSERT INTO casillero VALUES(NULL,num,idCliente);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_checkoutmesa` (IN `PrecioHora` DECIMAL(10,2), IN `HoraInicio` TIME, IN `HoraFin` TIME, IN `IDLocal` INT)   BEGIN
    INSERT INTO checkoutmesa (PrecioHora, HoraInicio, HoraFin, IDLocal) VALUES (PrecioHora, HoraInicio, HoraFin, IDLocal);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_cliente` (IN `nom` VARCHAR(30), IN `ape` VARCHAR(50), IN `tip` VARCHAR(10), IN `IdMesa` INT, IN `IdPagocom` INT(11), IN `IdMesaComida` INT)   BEGIN
	INSERT INTO cliente VALUES(NULL,nom,ape,tip,IdMesa,IdPagocom,IdMesaComida);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_consumible` (IN `PrecioConsumible` DECIMAL(10,2), IN `DescripcionConsumible` VARCHAR(50), IN `NombreConsumible` VARCHAR(30), IN `StockConsumible` INT)   BEGIN
    INSERT INTO consumible (Precio, Descripcion, Nombre, Stock) VALUES (PrecioConsumible, DescripcionConsumible, NombreConsumible, StockConsumible);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_empleado` (IN `DNIEmpleado` INT, IN `TelefonoEmpleado` VARCHAR(9), IN `NombreEmpleado` VARCHAR(30), IN `ApellidoEmpleado` VARCHAR(50), IN `CorreoEmpleado` VARCHAR(50), IN `CargoEmpleado` VARCHAR(30), IN `IDLocalEmpleado` INT)   BEGIN
    INSERT INTO empleado (DNI, Telefono, Nombre, Apellido, CorreoElectronico, Cargo, IDLocal) VALUES (DNIEmpleado, TelefonoEmpleado, NombreEmpleado, ApellidoEmpleado, CorreoEmpleado, CargoEmpleado, IDLocalEmpleado);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_equipo` (IN `TipoEquipo` VARCHAR(30), IN `DescripcionEquipo` VARCHAR(50), IN `IDLocalEquipo` INT, IN `IDProveedorEquipo` INT, IN `IDMantenimientoEquipo` INT)   BEGIN
    INSERT INTO equipamiento (Tipo, Descripcion, IDLocal, IDProveedor, IDMantenimiento) VALUES (TipoEquipo, DescripcionEquipo, IDLocalEquipo, IDProveedorEquipo, IDMantenimientoEquipo);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_ingrediente` (IN `NombreIngrediente` VARCHAR(30), IN `CantidadIngrediente` INT, IN `IDProveedorIngrediente` INT)   BEGIN
    INSERT INTO ingrediente (Nombre, Cantidad, IDProveedor) VALUES (NombreIngrediente, CantidadIngrediente, IDProveedorIngrediente);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_ingrediente_consumible` (IN `IDIngredienteConsumible` INT, IN `IDConsumibleIngrediente` INT)   BEGIN
    INSERT INTO ingrediente_consumible (IDIngrediente, IDConsumible) VALUES (IDIngredienteConsumible, IDConsumibleIngrediente);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_local` (IN `DireccionLocal` VARCHAR(50), IN `HoraAperturaLocal` TIME, IN `HoraCierreLocal` TIME)   BEGIN
    INSERT INTO tlocal (Direccion, horaApertura, horaCierra) VALUES (DireccionLocal, HoraAperturaLocal, HoraCierreLocal);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_local_consumible` (IN `IDConsumibleLocal` INT, IN `IDLocalConsumible` INT)   BEGIN
    INSERT INTO local_consumible (IDConsumible, IDLocal) VALUES (IDConsumibleLocal, IDLocalConsumible);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_mantenimiento` (IN `FechaMantenimiento` DATE, IN `DescripcionMantenimiento` VARCHAR(50))   BEGIN
    INSERT INTO mantenimiento (Fecha, Descripción) VALUES (FechaMantenimiento, DescripcionMantenimiento);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_mesabillar` (IN `tip` VARCHAR(20), IN `est` VARCHAR(20), IN `IdMante` INT(11), IN `IdPagoCom` INT(11), IN `IdAmbiente` INT(11))   BEGIN
	INSERT INTO mesabillar VALUES(NULL,tip,est,IdMante,IdPagoCom,IdAmbiente);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_mesacomida` (IN `CapacidadMesaComida` INT, IN `NumeroMesaComida` INT, IN `IDAmbienteMesaComida` INT)   BEGIN
    INSERT INTO mesacomida (Capacidad, Numero, IDAmbiente) VALUES (CapacidadMesaComida, NumeroMesaComida, IDAmbienteMesaComida);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_pago` (IN `MetodoPago` VARCHAR(15), IN `IDPedidoConsumiblePago` INT, IN `IDPagoCOM` INT)   BEGIN
    INSERT INTO pago (Metodo, IDPedidoConsumible, IDPagoCOM) VALUES (MetodoPago, IDPedidoConsumiblePago, IDPagoCOM);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_pedidoconsumible` (IN `CantidadConsumible` INT, IN `IDClienteConsumible` INT, IN `IDLocalConsumible` INT)   BEGIN
    INSERT INTO pedidoconsumible (IDPedidoConsumible,Cantidad, IDCliente, IDLocal) VALUES (NULL,CantidadConsumible, IDClienteConsumible, NULL);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_pedidoconsumible_consumible` (IN `IDConsumiblePedido` INT, IN `IDPedidoConsumibleConsumible` INT)   BEGIN
    INSERT INTO pedidoconsumible_consumible (IDConsumible, IDPedidoConsumible) VALUES (IDConsumiblePedido, IDPedidoConsumibleConsumible);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_proveedor` (IN `NombreProveedor` VARCHAR(30), IN `CorreoProveedor` VARCHAR(50), IN `TipoProveedor` VARCHAR(30), IN `TelefonoProveedor` VARCHAR(9))   BEGIN
    INSERT INTO proveedor (Nombre, CorreoElectronico, Tipo, Telefono) VALUES (NombreProveedor, CorreoProveedor, TipoProveedor, TelefonoProveedor);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `resumen_distribucion_ambientes` ()   BEGIN
	SELECT tl.IDLocal,tl.Direccion,am.Nombre,mesab.IDMesaBillar,mesacom.IdMesaComida FROM tlocal AS tl INNER JOIN ambiente AS am INNER JOIN mesabillar AS mesab INNER JOIN mesacomida AS mesacom ON tl.IDLocal=am.IDLocal AND am.IDAmbiente=mesab.IDAmbiente AND am.IDAmbiente=mesacom.IDAmbiente GROUP BY tl.Direccion,am.Nombre;
END$$

CREATE DEFINER=`` PROCEDURE `SetNullIDCliente` (IN `in_IDCliente` INT)   BEGIN
    UPDATE casillero
    SET casillero.IDCliente = NULL
    WHERE casillero.IDCliente = in_IDCliente;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_cliente` (IN `cliente_id` INTEGER, IN `Nombre` VARCHAR(30), IN `Apellido` VARCHAR(50), IN `Tipo` VARCHAR(10), IN `IDMesaBillar` INTEGER, IN `IDPagoCOM` INTEGER, IN `IDMesaComida` INTEGER)   BEGIN
    UPDATE cliente c
    SET 
        c.Nombre = Nombre,
        c.Apellidos = Apellido,
        c.Tipo = Tipo,
        c.IDMesaBillar= IDMesaBillar,
        c.IDPagoCOM = IDPagoCOM,
        c.IDPagoCOM = IDMesaComida
    WHERE c.IDCliente = cliente_id;
END$$

CREATE DEFINER=`` PROCEDURE `update_empleado_by_id` (IN `dni` INTEGER, IN `telefono` INTEGER, IN `nombre` VARCHAR(30), IN `apellido` VARCHAR(50), IN `correo` VARCHAR(50), IN `cargo` VARCHAR(30), IN `id_local` INT)   BEGIN
    UPDATE empleado emp
    SET 
    	emp.Nombre = nombre,
        emp.Apellido = apellido,
        emp.Telefono = telefono,
        emp.CorreoElectronico = correo,
        emp.Cargo = cargo,
        emp.IDLocal = id_local
    WHERE emp.DNI = dni;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_mesabillar` (IN `id` INT, IN `Tip` VARCHAR(20), IN `Est` VARCHAR(20), IN `Idman` INT(11), IN `IdPago` INT(11), IN `IdAm` INT(11))   BEGIN 
	UPDATE mesabillar SET mesabillar.Tipo=tip,mesabillar.Estado=Est,mesabillar.IDMantenimiento=Idman,mesabillar.IDPagoCOM=IdPago,mesabillar.IDAmbiente=IdAm WHERE mesabillar.IDMesaBillar=id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_PagarMontoTotal` (IN `cliente_id` INT)   BEGIN
    UPDATE pedidoconsumible
    SET IDCliente = NULL
    WHERE IDCliente = cliente_id;

	UPDATE mesabillar mb
    INNER JOIN checkoutmesa com ON com.IDPagoCOM = mb.IDPagoCOM
    INNER JOIN cliente c ON c.IDPagoCOM = com.IDPagoCOM
    SET mb.IDPagoCOM = NULL
    WHERE c.IDCliente = cliente_id;
    
    UPDATE cliente
    SET IDPagoCOM = NULL, IDMesaBillar = NULL, IDMesaComida = NULL
    WHERE IDCliente = cliente_id;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_Stock` (IN `id` INT)   BEGIN
	UPDATE consumible SET consumible.Stock=consumible.Stock - 1 WHERE consumible.IDConsumible=id;
END$$

--
-- Funciones
--
CREATE DEFINER=`root`@`localhost` FUNCTION `GetFirstNullCasillero` () RETURNS INT(11) DETERMINISTIC BEGIN
    DECLARE firstCasillero INT DEFAULT -1;

    SELECT casillero.IDCasillero
    INTO firstCasillero
    FROM casillero
    WHERE casillero.IDCliente IS NULL
    ORDER BY casillero.IDCasillero
    LIMIT 1;

    RETURN firstCasillero;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ambiente`
--

CREATE TABLE `ambiente` (
  `IDAmbiente` int(11) NOT NULL,
  `Nombre` varchar(30) DEFAULT NULL,
  `Capacidad` int(11) DEFAULT NULL,
  `IDLocal` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `ambiente`
--

INSERT INTO `ambiente` (`IDAmbiente`, `Nombre`, `Capacidad`, `IDLocal`) VALUES
(1, 'Ambiente 1', 20, 1),
(2, 'Ambiente 2', 15, 1),
(3, 'Ambiente 3', 25, 1),
(4, 'Ambiente 4', 20, 2),
(5, 'Ambiente 5', 15, 2),
(6, 'Ambiente 6', 25, 2),
(7, 'Ambiente 7', 20, 3),
(8, 'Ambiente 8', 15, 3),
(9, 'Ambiente 9', 25, 3),
(10, 'Ambiente 10', 20, 4),
(11, 'Ambiente 11', 15, 4),
(12, 'Ambiente 12', 25, 4),
(13, 'Ambiente 13', 20, 5),
(14, 'Ambiente 14', 15, 5),
(15, 'Ambiente 15', 25, 5),
(16, 'Ambiente 16', 20, 6),
(17, 'Ambiente 17', 15, 6),
(18, 'Ambiente 18', 25, 6);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `casillero`
--

CREATE TABLE `casillero` (
  `IDCasillero` int(11) NOT NULL,
  `Numero` int(11) DEFAULT NULL,
  `IDCliente` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `casillero`
--

INSERT INTO `casillero` (`IDCasillero`, `Numero`, `IDCliente`) VALUES
(1, 1, 6),
(2, 2, NULL),
(3, 3, NULL),
(4, 4, NULL),
(5, 5, NULL),
(6, 6, NULL),
(7, 7, 8),
(8, 8, NULL),
(9, 9, 10),
(10, 10, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `checkoutmesa`
--

CREATE TABLE `checkoutmesa` (
  `IDPagoCOM` int(11) NOT NULL,
  `PrecioHora` decimal(10,2) DEFAULT NULL,
  `HoraFin` time DEFAULT NULL,
  `HoraInicio` time DEFAULT NULL,
  `IDLocal` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `checkoutmesa`
--

INSERT INTO `checkoutmesa` (`IDPagoCOM`, `PrecioHora`, `HoraFin`, `HoraInicio`, `IDLocal`) VALUES
(1, 7.00, '18:00:00', '15:45:00', 1),
(2, 7.00, '19:00:00', '16:00:00', 1),
(3, 6.00, '10:30:00', '08:00:00', 1),
(4, 8.00, '13:15:00', '11:30:00', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cliente`
--

CREATE TABLE `cliente` (
  `IDCliente` int(11) NOT NULL,
  `Nombre` varchar(30) DEFAULT NULL,
  `Apellidos` varchar(50) DEFAULT NULL,
  `Tipo` varchar(10) DEFAULT NULL,
  `IDMesaBillar` int(11) DEFAULT NULL,
  `IDPagoCOM` int(11) DEFAULT NULL,
  `IdMesaComida` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `cliente`
--

INSERT INTO `cliente` (`IDCliente`, `Nombre`, `Apellidos`, `Tipo`, `IDMesaBillar`, `IDPagoCOM`, `IdMesaComida`) VALUES
(1, 'Juan', 'Perez', 'Regular', 1, 1, 1),
(2, 'Maria', 'Lopez', 'Regular', NULL, NULL, NULL),
(3, 'Carlos', 'Garcia', 'Regular', 8, 3, NULL),
(4, 'Ana', 'Martinez', 'Regular', NULL, NULL, NULL),
(5, 'Luis', 'Gonzalez', 'Regular', NULL, NULL, NULL),
(6, 'Sofia', 'Rodriguez', 'Casillero', NULL, NULL, NULL),
(7, 'David', 'Hernandez', 'Casillero', NULL, NULL, NULL),
(8, 'Eva', 'Jimenez', 'Regular', NULL, NULL, NULL),
(9, 'Jorge', 'Perez', 'Regular', NULL, NULL, NULL),
(10, 'Patricia', 'Sanchez', 'Casillero', NULL, NULL, NULL),
(11, 'Werito', 'Malawero', 'Regular', NULL, NULL, NULL),
(12, 'www', 'wwww', 'Casillero', NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `consumible`
--

CREATE TABLE `consumible` (
  `IDConsumible` int(11) NOT NULL,
  `Precio` decimal(10,2) DEFAULT NULL,
  `Descripcion` varchar(50) DEFAULT NULL,
  `Nombre` varchar(30) DEFAULT NULL,
  `Stock` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `consumible`
--

INSERT INTO `consumible` (`IDConsumible`, `Precio`, `Descripcion`, `Nombre`, `Stock`) VALUES
(1, 15.00, 'Hamburguesa de Carne', 'Hamburguesa de Carne', 97),
(2, 12.00, 'Hamburguesa de Pollo', 'Hamburguesa de Pollo', 147),
(3, 10.00, 'Salchipapa', 'Salchipapa', 195),
(4, 8.00, 'Papa Rellena', 'Papa Rellena', 118),
(5, 7.00, 'Jugo de Platano', 'Jugo de Platano', 178),
(6, 7.00, 'Jugo de Papaya', 'Jugo de Papaya', 158),
(7, 12.00, 'Leche Asada', 'Leche Asada', 129),
(8, 5.00, 'Papas fritas', 'Papas fritas', 79),
(9, 9.00, 'Ensalada de Papa', 'Ensalada de Papa', 149),
(10, 11.00, 'Tacos', 'Tacos', 99);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `empleado`
--

CREATE TABLE `empleado` (
  `DNI` int(11) NOT NULL,
  `Telefono` varchar(9) DEFAULT NULL,
  `Nombre` varchar(30) DEFAULT NULL,
  `Apellido` varchar(50) DEFAULT NULL,
  `CorreoElectronico` varchar(50) DEFAULT NULL,
  `Cargo` varchar(30) DEFAULT NULL,
  `IDLocal` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `empleado`
--

INSERT INTO `empleado` (`DNI`, `Telefono`, `Nombre`, `Apellido`, `CorreoElectronico`, `Cargo`, `IDLocal`) VALUES
(12345678, '987654321', 'Juan', 'Pérez', 'juan.perez@email.com', 'Administrador', 1),
(23456789, '956789123', 'Carlos', 'Ramírez', 'carlos.ramirez@email.com', 'Atencion', 1),
(34567890, '934567890', 'Ana', 'Torres', 'ana.torres@email.com', 'Atencion', 1),
(87654321, '912345678', 'María', 'Gómez', 'maria.gomez@email.com', 'Atencion', 1),
(89123212, '983212491', 'José', 'Muchica', 'pepe@gmail.com', 'Regular', 2),
(89123214, '98931239', 'Jose Antonio', 'Muchica', 'jose@gmail.com', 'Casillero', 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `equipamiento`
--

CREATE TABLE `equipamiento` (
  `IDEquipamiento` int(11) NOT NULL,
  `Tipo` varchar(30) DEFAULT NULL,
  `Descripcion` varchar(50) DEFAULT NULL,
  `IDLocal` int(11) DEFAULT NULL,
  `IDProveedor` int(11) DEFAULT NULL,
  `IDMantenimiento` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `equipamiento`
--

INSERT INTO `equipamiento` (`IDEquipamiento`, `Tipo`, `Descripcion`, `IDLocal`, `IDProveedor`, `IDMantenimiento`) VALUES
(25, 'Bolas de Billar', 'Conjunto completo de bolas', 1, 1, 2),
(26, 'Palos de Billar', 'Palo estándar', 1, 2, 3),
(27, 'Tiza', 'Tiza para billar', 1, 3, NULL),
(28, 'Racks de Billar', 'Conjunto de racks para billar', 1, 1, 1),
(29, 'Bolas de Billar', 'Conjunto completo de bolas', 2, 1, NULL),
(30, 'Palos de Billar', 'Palo estándar', 2, 2, NULL),
(31, 'Tiza', 'Tiza para billar', 2, 3, NULL),
(32, 'Racks de Billar', 'Conjunto de racks para billar', 2, 1, NULL),
(33, 'Bolas de Billar', 'Conjunto completo de bolas', 3, 1, NULL),
(34, 'Palos de Billar', 'Palo estándar', 3, 2, NULL),
(35, 'Tiza', 'Tiza para billar', 3, 3, NULL),
(36, 'Racks de Billar', 'Conjunto de racks para billar', 3, 1, NULL),
(37, 'Bolas de Billar', 'Conjunto completo de bolas', 4, 1, NULL),
(38, 'Palos de Billar', 'Palo estándar', 4, 2, NULL),
(39, 'Tiza', 'Tiza para billar', 4, 3, NULL),
(40, 'Racks de Billar', 'Conjunto de racks para billar', 4, 1, NULL),
(41, 'Bolas de Billar', 'Conjunto completo de bolas', 5, 1, NULL),
(42, 'Palos de Billar', 'Palo estándar', 5, 2, NULL),
(43, 'Tiza', 'Tiza para billar', 5, 3, NULL),
(44, 'Racks de Billar', 'Conjunto de racks para billar', 5, 1, NULL),
(45, 'Bolas de Billar', 'Conjunto completo de bolas', 6, 1, NULL),
(46, 'Palos de Billar', 'Palo estándar', 6, 2, NULL),
(47, 'Tiza', 'Tiza para billar', 6, 3, NULL),
(48, 'Racks de Billar', 'Conjunto de racks para billar', 6, 1, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ingrediente`
--

CREATE TABLE `ingrediente` (
  `IDIngrediente` int(11) NOT NULL,
  `Nombre` varchar(30) DEFAULT NULL,
  `Cantidad` int(11) DEFAULT NULL,
  `IDProveedor` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `ingrediente`
--

INSERT INTO `ingrediente` (`IDIngrediente`, `Nombre`, `Cantidad`, `IDProveedor`) VALUES
(1, 'Queso', 50, 4),
(2, 'Jamon', 30, 4),
(3, 'Pan', 100, 4),
(4, 'Papaya', 80, 5),
(5, 'Banana', 60, 5),
(6, 'Leche', 100, 5),
(7, 'Tomate', 40, 4),
(8, 'Lechuga', 50, 5),
(9, 'Aceite', 60, 4),
(10, 'Mayonesa', 70, 6),
(11, 'Carne molida', 50, 6),
(12, 'Pollo', 80, 5),
(13, 'Salchichón', 50, 4),
(14, 'Arroz', 30, 5),
(15, 'Papas', 100, 6),
(16, 'Aguacate', 50, 6),
(17, 'Mantequilla', 60, 6),
(18, 'Harina', 100, 5),
(19, 'Mostaza', 90, 5),
(20, 'Salsa', 60, 5);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ingrediente_consumible`
--

CREATE TABLE `ingrediente_consumible` (
  `IDIngrediente` int(11) NOT NULL,
  `IDConsumible` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `ingrediente_consumible`
--

INSERT INTO `ingrediente_consumible` (`IDIngrediente`, `IDConsumible`) VALUES
(1, 1),
(1, 2),
(2, 1),
(2, 2),
(2, 10),
(3, 1),
(3, 2),
(3, 4),
(3, 7),
(3, 10),
(4, 6),
(5, 5),
(6, 5),
(6, 6),
(6, 10),
(7, 9),
(8, 9),
(9, 3),
(9, 8),
(9, 9),
(10, 7),
(10, 10),
(11, 1),
(12, 2),
(13, 7),
(15, 3),
(15, 4),
(15, 8),
(16, 3),
(17, 4);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `local_consumible`
--

CREATE TABLE `local_consumible` (
  `IDConsumible` int(11) NOT NULL,
  `IDLocal` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `local_consumible`
--

INSERT INTO `local_consumible` (`IDConsumible`, `IDLocal`) VALUES
(1, 1),
(2, 1),
(3, 1),
(4, 1),
(5, 1),
(6, 1),
(7, 1),
(8, 1),
(9, 1),
(10, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `mantenimiento`
--

CREATE TABLE `mantenimiento` (
  `IDMantenimiento` int(11) NOT NULL,
  `Fecha` date DEFAULT NULL,
  `Descripción` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `mantenimiento`
--

INSERT INTO `mantenimiento` (`IDMantenimiento`, `Fecha`, `Descripción`) VALUES
(1, '2024-11-10', 'Revisión de racks'),
(2, '2024-11-10', 'Limpieza de bolas'),
(3, '2024-11-10', 'Cambio de puntas de tacos'),
(4, '2024-11-10', 'Reparación de mesa de billar'),
(5, '2024-11-10', 'Reparación de mesa de billar');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `mesabillar`
--

CREATE TABLE `mesabillar` (
  `IDMesaBillar` int(11) NOT NULL,
  `Tipo` varchar(20) DEFAULT NULL,
  `Estado` varchar(20) DEFAULT NULL,
  `IDMantenimiento` int(11) DEFAULT NULL,
  `IDPagoCOM` int(11) DEFAULT NULL,
  `IDAmbiente` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `mesabillar`
--

INSERT INTO `mesabillar` (`IDMesaBillar`, `Tipo`, `Estado`, `IDMantenimiento`, `IDPagoCOM`, `IDAmbiente`) VALUES
(1, 'Normal', 'En uso', NULL, 1, 1),
(2, 'Normal', 'En uso', NULL, NULL, 1),
(3, 'Normal', 'Mantenimiento', 4, NULL, 1),
(4, 'Snooker', 'Disponible', NULL, NULL, 1),
(5, 'Normal', 'Disponible', NULL, NULL, 2),
(6, 'Normal', 'Disponible', NULL, NULL, 2),
(7, 'Normal', 'Disponible', NULL, NULL, 2),
(8, 'Carambola', 'En uso', 2, 3, 2),
(9, 'Normal', 'Mantenimiento', 5, NULL, 3),
(10, 'Normal', 'Disponible', NULL, NULL, 3),
(11, 'Normal', 'Disponible', NULL, NULL, 3),
(12, 'Snooker', 'En uso', NULL, NULL, 3),
(13, 'Normal', 'Disponible', NULL, NULL, 4),
(14, 'Normal', 'Disponible', NULL, NULL, 4),
(15, 'Normal', 'Disponible', NULL, NULL, 4),
(16, 'Snooker', 'Disponible', NULL, NULL, 4),
(17, 'Normal', 'Disponible', NULL, NULL, 5),
(18, 'Normal', 'Disponible', NULL, NULL, 5),
(19, 'Normal', 'Disponible', NULL, NULL, 5),
(20, 'Snooker', 'Disponible', NULL, NULL, 5),
(21, 'Normal', 'Disponible', NULL, NULL, 6),
(22, 'Normal', 'Disponible', NULL, NULL, 6),
(23, 'Normal', 'Disponible', NULL, NULL, 6),
(24, 'Carambola', 'Disponible', NULL, NULL, 6),
(25, 'Normal', 'Disponible', NULL, NULL, 7),
(26, 'Normal', 'Disponible', NULL, NULL, 7),
(27, 'Normal', 'Disponible', NULL, NULL, 7),
(28, 'Snooker', 'Disponible', NULL, NULL, 7),
(29, 'Normal', 'Disponible', NULL, NULL, 8),
(30, 'Normal', 'Disponible', NULL, NULL, 8),
(31, 'Normal', 'Disponible', NULL, NULL, 8),
(32, 'Carambola', 'Disponible', NULL, NULL, 8),
(33, 'Normal', 'Disponible', NULL, NULL, 9),
(34, 'Normal', 'Disponible', NULL, NULL, 9),
(35, 'Normal', 'Disponible', NULL, NULL, 9),
(36, 'Snooker', 'Disponible', NULL, NULL, 9),
(37, 'Normal', 'Disponible', NULL, NULL, 10),
(38, 'Normal', 'Disponible', NULL, NULL, 10),
(39, 'Normal', 'Disponible', NULL, NULL, 10),
(40, 'Carambola', 'Disponible', NULL, NULL, 10),
(41, 'Normal', 'Disponible', NULL, NULL, 11),
(42, 'Normal', 'Disponible', NULL, NULL, 11),
(43, 'Normal', 'Disponible', NULL, NULL, 11),
(44, 'Snooker', 'Disponible', NULL, NULL, 11),
(45, 'Normal', 'Disponible', NULL, NULL, 12),
(46, 'Normal', 'Disponible', NULL, NULL, 12),
(47, 'Normal', 'Disponible', NULL, NULL, 12),
(48, 'Carambola', 'Disponible', NULL, NULL, 12),
(49, 'Normal', 'Disponible', NULL, NULL, 13),
(50, 'Normal', 'Disponible', NULL, NULL, 13),
(51, 'Normal', 'Disponible', NULL, NULL, 13),
(52, 'Snooker', 'Disponible', NULL, NULL, 13),
(53, 'Normal', 'Disponible', NULL, NULL, 14),
(54, 'Normal', 'Disponible', NULL, NULL, 14),
(55, 'Normal', 'Disponible', NULL, NULL, 14),
(56, 'Carambola', 'Disponible', NULL, NULL, 14),
(57, 'Normal', 'Disponible', NULL, NULL, 15),
(58, 'Normal', 'Disponible', NULL, NULL, 15),
(59, 'Normal', 'Disponible', NULL, NULL, 15),
(60, 'Snooker', 'Disponible', NULL, NULL, 15),
(61, 'Normal', 'Disponible', NULL, NULL, 16),
(62, 'Normal', 'Disponible', NULL, NULL, 16),
(63, 'Normal', 'Disponible', NULL, NULL, 16),
(64, 'Carambola', 'Disponible', NULL, NULL, 16),
(65, 'Normal', 'Disponible', NULL, NULL, 17),
(66, 'Normal', 'Disponible', NULL, NULL, 17),
(67, 'Normal', 'Disponible', NULL, NULL, 17),
(68, 'Snooker', 'Disponible', NULL, NULL, 17),
(69, 'Normal', 'Disponible', NULL, NULL, 18),
(70, 'Normal', 'Disponible', NULL, NULL, 18),
(71, 'Normal', 'Disponible', NULL, NULL, 18),
(72, 'Carambola', 'Disponible', NULL, NULL, 18);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `mesacomida`
--

CREATE TABLE `mesacomida` (
  `IdMesaComida` int(11) NOT NULL,
  `Capacidad` int(11) DEFAULT NULL,
  `Numero` int(11) DEFAULT NULL,
  `IDAmbiente` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `mesacomida`
--

INSERT INTO `mesacomida` (`IdMesaComida`, `Capacidad`, `Numero`, `IDAmbiente`) VALUES
(1, 4, 1, 1),
(2, 4, 2, 1),
(3, 4, 1, 2),
(4, 4, 2, 2),
(5, 4, 1, 3),
(6, 4, 2, 3),
(7, 4, 1, 4),
(8, 4, 2, 4),
(9, 4, 1, 5),
(10, 4, 2, 5),
(11, 4, 1, 6),
(12, 4, 2, 6),
(13, 4, 1, 7),
(14, 4, 2, 7),
(15, 4, 1, 8),
(16, 4, 2, 8),
(17, 4, 1, 9),
(18, 4, 2, 9),
(19, 4, 1, 10),
(20, 4, 2, 10),
(21, 4, 1, 11),
(22, 4, 2, 11),
(23, 4, 1, 12),
(24, 4, 2, 12),
(25, 4, 1, 13),
(26, 4, 2, 13),
(27, 4, 1, 14),
(28, 4, 2, 14),
(29, 4, 1, 15),
(30, 4, 2, 15),
(31, 4, 1, 16),
(32, 4, 2, 16),
(33, 4, 1, 17),
(34, 4, 2, 17),
(35, 4, 1, 18),
(36, 4, 2, 18);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pago`
--

CREATE TABLE `pago` (
  `IDPago` int(11) NOT NULL,
  `Metodo` varchar(15) DEFAULT NULL,
  `IDPagoCOM` int(11) DEFAULT NULL,
  `IDPedidoConsumible` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `pago`
--

INSERT INTO `pago` (`IDPago`, `Metodo`, `IDPagoCOM`, `IDPedidoConsumible`) VALUES
(1, 'Efectivo', 1, 1),
(2, 'Efectivo', 2, 2),
(3, 'Efectivo', 3, 3),
(4, 'Tarjeta', 4, 4),
(5, 'Efectivo', NULL, 5),
(6, 'Efectivo', NULL, 6),
(7, 'Efectivo', NULL, 7),
(8, 'Tarjeta', NULL, 8),
(9, 'Efectivo', NULL, 9),
(10, 'Efectivo', NULL, 10),
(11, 'Efectivo', NULL, 11),
(12, 'Tarjeta', NULL, 12);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pedidoconsumible`
--

CREATE TABLE `pedidoconsumible` (
  `IDPedidoConsumible` int(11) NOT NULL,
  `Cantidad` int(11) DEFAULT NULL,
  `IDCliente` int(11) DEFAULT NULL,
  `IDLocal` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `pedidoconsumible`
--

INSERT INTO `pedidoconsumible` (`IDPedidoConsumible`, `Cantidad`, `IDCliente`, `IDLocal`) VALUES
(1, 2, 1, 1),
(2, 3, 1, 1),
(3, 1, 1, 1),
(4, 2, NULL, 1),
(5, 1, NULL, 1),
(6, 3, NULL, 1),
(7, 3, 3, 1),
(8, 2, 3, 1),
(9, 2, 3, 1),
(10, 4, NULL, 1),
(11, 2, NULL, 1),
(12, 3, NULL, 1),
(13, 1, 4, NULL),
(14, 1, 4, NULL),
(15, 1, 4, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pedidoconsumible_consumible`
--

CREATE TABLE `pedidoconsumible_consumible` (
  `IDConsumible` int(11) NOT NULL,
  `IDPedidoConsumible` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `pedidoconsumible_consumible`
--

INSERT INTO `pedidoconsumible_consumible` (`IDConsumible`, `IDPedidoConsumible`) VALUES
(1, 2),
(1, 11),
(2, 2),
(3, 4),
(3, 6),
(3, 7),
(3, 12),
(3, 15),
(4, 3),
(4, 8),
(4, 15),
(7, 14),
(8, 5),
(8, 14),
(9, 9),
(9, 13),
(10, 10),
(10, 13);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proveedor`
--

CREATE TABLE `proveedor` (
  `IDProveedor` int(11) NOT NULL,
  `Nombre` varchar(30) DEFAULT NULL,
  `CorreoElectronico` varchar(50) DEFAULT NULL,
  `Tipo` varchar(30) DEFAULT NULL,
  `Telefono` varchar(9) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `proveedor`
--

INSERT INTO `proveedor` (`IDProveedor`, `Nombre`, `CorreoElectronico`, `Tipo`, `Telefono`) VALUES
(1, 'Proveedor 1', 'proveedor1@email.com', 'Equipamiento', '123456789'),
(2, 'Proveedor 2', 'proveedor2@email.com', 'Equipamiento', '987654321'),
(3, 'Proveedor 3', 'proveedor3@email.com', 'Equipamiento', '555666777'),
(4, 'Proveedor 4', 'proveedor4@email.com', 'Ingrediente', '123123123'),
(5, 'Proveedor 5', 'proveedor5@email.com', 'Ingrediente', '456456456'),
(6, 'Proveedor 6', 'proveedor6@email.com', 'Ingrediente', '789789789');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tlocal`
--

CREATE TABLE `tlocal` (
  `IDLocal` int(11) NOT NULL,
  `Direccion` varchar(50) DEFAULT NULL,
  `horaApertura` time DEFAULT NULL,
  `horaCierra` time DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tlocal`
--

INSERT INTO `tlocal` (`IDLocal`, `Direccion`, `horaApertura`, `horaCierra`) VALUES
(1, 'Calle 1, Local 1', '08:00:00', '22:00:00'),
(2, 'Calle 2, Local 2', '09:00:00', '23:00:00'),
(3, 'Calle 3, Local 3', '10:00:00', '22:30:00'),
(4, 'Calle 4, Local 4', '08:00:00', '20:00:00'),
(5, 'Calle 5, Local 5', '09:00:00', '21:00:00'),
(6, 'Calle 6, Local 6', '07:00:00', '22:00:00');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `ambiente`
--
ALTER TABLE `ambiente`
  ADD PRIMARY KEY (`IDAmbiente`),
  ADD KEY `IDLocal` (`IDLocal`);

--
-- Indices de la tabla `casillero`
--
ALTER TABLE `casillero`
  ADD PRIMARY KEY (`IDCasillero`),
  ADD KEY `IDCliente` (`IDCliente`);

--
-- Indices de la tabla `checkoutmesa`
--
ALTER TABLE `checkoutmesa`
  ADD PRIMARY KEY (`IDPagoCOM`),
  ADD KEY `IDLocal` (`IDLocal`);

--
-- Indices de la tabla `cliente`
--
ALTER TABLE `cliente`
  ADD PRIMARY KEY (`IDCliente`),
  ADD KEY `IDMesaBillar` (`IDMesaBillar`),
  ADD KEY `IDPagoCOM` (`IDPagoCOM`),
  ADD KEY `IdMesaComida` (`IdMesaComida`);

--
-- Indices de la tabla `consumible`
--
ALTER TABLE `consumible`
  ADD PRIMARY KEY (`IDConsumible`);

--
-- Indices de la tabla `empleado`
--
ALTER TABLE `empleado`
  ADD PRIMARY KEY (`DNI`),
  ADD KEY `IDLocal` (`IDLocal`);

--
-- Indices de la tabla `equipamiento`
--
ALTER TABLE `equipamiento`
  ADD PRIMARY KEY (`IDEquipamiento`),
  ADD KEY `IDLocal` (`IDLocal`),
  ADD KEY `IDProveedor` (`IDProveedor`),
  ADD KEY `IDMantenimiento` (`IDMantenimiento`);

--
-- Indices de la tabla `ingrediente`
--
ALTER TABLE `ingrediente`
  ADD PRIMARY KEY (`IDIngrediente`),
  ADD KEY `IDProveedor` (`IDProveedor`);

--
-- Indices de la tabla `ingrediente_consumible`
--
ALTER TABLE `ingrediente_consumible`
  ADD PRIMARY KEY (`IDIngrediente`,`IDConsumible`),
  ADD KEY `IDConsumible` (`IDConsumible`);

--
-- Indices de la tabla `local_consumible`
--
ALTER TABLE `local_consumible`
  ADD PRIMARY KEY (`IDConsumible`,`IDLocal`),
  ADD KEY `IDLocal` (`IDLocal`);

--
-- Indices de la tabla `mantenimiento`
--
ALTER TABLE `mantenimiento`
  ADD PRIMARY KEY (`IDMantenimiento`);

--
-- Indices de la tabla `mesabillar`
--
ALTER TABLE `mesabillar`
  ADD PRIMARY KEY (`IDMesaBillar`),
  ADD KEY `IDMantenimiento` (`IDMantenimiento`),
  ADD KEY `IDPagoCOM` (`IDPagoCOM`),
  ADD KEY `IDAmbiente` (`IDAmbiente`);

--
-- Indices de la tabla `mesacomida`
--
ALTER TABLE `mesacomida`
  ADD PRIMARY KEY (`IdMesaComida`),
  ADD KEY `IDAmbiente` (`IDAmbiente`);

--
-- Indices de la tabla `pago`
--
ALTER TABLE `pago`
  ADD PRIMARY KEY (`IDPago`),
  ADD KEY `IDPagoCOM` (`IDPagoCOM`),
  ADD KEY `IDPedidoConsumible` (`IDPedidoConsumible`);

--
-- Indices de la tabla `pedidoconsumible`
--
ALTER TABLE `pedidoconsumible`
  ADD PRIMARY KEY (`IDPedidoConsumible`),
  ADD KEY `IDCliente` (`IDCliente`),
  ADD KEY `IDLocal` (`IDLocal`);

--
-- Indices de la tabla `pedidoconsumible_consumible`
--
ALTER TABLE `pedidoconsumible_consumible`
  ADD PRIMARY KEY (`IDConsumible`,`IDPedidoConsumible`),
  ADD KEY `IDPedidoConsumible` (`IDPedidoConsumible`);

--
-- Indices de la tabla `proveedor`
--
ALTER TABLE `proveedor`
  ADD PRIMARY KEY (`IDProveedor`);

--
-- Indices de la tabla `tlocal`
--
ALTER TABLE `tlocal`
  ADD PRIMARY KEY (`IDLocal`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `ambiente`
--
ALTER TABLE `ambiente`
  MODIFY `IDAmbiente` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT de la tabla `casillero`
--
ALTER TABLE `casillero`
  MODIFY `IDCasillero` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `checkoutmesa`
--
ALTER TABLE `checkoutmesa`
  MODIFY `IDPagoCOM` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `cliente`
--
ALTER TABLE `cliente`
  MODIFY `IDCliente` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `consumible`
--
ALTER TABLE `consumible`
  MODIFY `IDConsumible` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `equipamiento`
--
ALTER TABLE `equipamiento`
  MODIFY `IDEquipamiento` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=49;

--
-- AUTO_INCREMENT de la tabla `ingrediente`
--
ALTER TABLE `ingrediente`
  MODIFY `IDIngrediente` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT de la tabla `mantenimiento`
--
ALTER TABLE `mantenimiento`
  MODIFY `IDMantenimiento` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `mesabillar`
--
ALTER TABLE `mesabillar`
  MODIFY `IDMesaBillar` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=73;

--
-- AUTO_INCREMENT de la tabla `mesacomida`
--
ALTER TABLE `mesacomida`
  MODIFY `IdMesaComida` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT de la tabla `pago`
--
ALTER TABLE `pago`
  MODIFY `IDPago` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `pedidoconsumible`
--
ALTER TABLE `pedidoconsumible`
  MODIFY `IDPedidoConsumible` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT de la tabla `proveedor`
--
ALTER TABLE `proveedor`
  MODIFY `IDProveedor` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `tlocal`
--
ALTER TABLE `tlocal`
  MODIFY `IDLocal` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `ambiente`
--
ALTER TABLE `ambiente`
  ADD CONSTRAINT `ambiente_ibfk_1` FOREIGN KEY (`IDLocal`) REFERENCES `tlocal` (`IDLocal`);

--
-- Filtros para la tabla `casillero`
--
ALTER TABLE `casillero`
  ADD CONSTRAINT `casillero_ibfk_1` FOREIGN KEY (`IDCliente`) REFERENCES `cliente` (`IDCliente`);

--
-- Filtros para la tabla `checkoutmesa`
--
ALTER TABLE `checkoutmesa`
  ADD CONSTRAINT `checkoutmesa_ibfk_1` FOREIGN KEY (`IDLocal`) REFERENCES `tlocal` (`IDLocal`);

--
-- Filtros para la tabla `cliente`
--
ALTER TABLE `cliente`
  ADD CONSTRAINT `cliente_ibfk_1` FOREIGN KEY (`IDMesaBillar`) REFERENCES `mesabillar` (`IDMesaBillar`),
  ADD CONSTRAINT `cliente_ibfk_2` FOREIGN KEY (`IDPagoCOM`) REFERENCES `checkoutmesa` (`IDPagoCOM`),
  ADD CONSTRAINT `cliente_ibfk_3` FOREIGN KEY (`IdMesaComida`) REFERENCES `mesacomida` (`IdMesaComida`);

--
-- Filtros para la tabla `empleado`
--
ALTER TABLE `empleado`
  ADD CONSTRAINT `empleado_ibfk_1` FOREIGN KEY (`IDLocal`) REFERENCES `tlocal` (`IDLocal`);

--
-- Filtros para la tabla `equipamiento`
--
ALTER TABLE `equipamiento`
  ADD CONSTRAINT `equipamiento_ibfk_1` FOREIGN KEY (`IDLocal`) REFERENCES `tlocal` (`IDLocal`),
  ADD CONSTRAINT `equipamiento_ibfk_2` FOREIGN KEY (`IDProveedor`) REFERENCES `proveedor` (`IDProveedor`),
  ADD CONSTRAINT `equipamiento_ibfk_3` FOREIGN KEY (`IDMantenimiento`) REFERENCES `mantenimiento` (`IDMantenimiento`);

--
-- Filtros para la tabla `ingrediente`
--
ALTER TABLE `ingrediente`
  ADD CONSTRAINT `ingrediente_ibfk_1` FOREIGN KEY (`IDProveedor`) REFERENCES `proveedor` (`IDProveedor`);

--
-- Filtros para la tabla `ingrediente_consumible`
--
ALTER TABLE `ingrediente_consumible`
  ADD CONSTRAINT `ingrediente_consumible_ibfk_1` FOREIGN KEY (`IDIngrediente`) REFERENCES `ingrediente` (`IDIngrediente`),
  ADD CONSTRAINT `ingrediente_consumible_ibfk_2` FOREIGN KEY (`IDConsumible`) REFERENCES `consumible` (`IDConsumible`);

--
-- Filtros para la tabla `local_consumible`
--
ALTER TABLE `local_consumible`
  ADD CONSTRAINT `local_consumible_ibfk_1` FOREIGN KEY (`IDConsumible`) REFERENCES `consumible` (`IDConsumible`),
  ADD CONSTRAINT `local_consumible_ibfk_2` FOREIGN KEY (`IDLocal`) REFERENCES `tlocal` (`IDLocal`);

--
-- Filtros para la tabla `mesabillar`
--
ALTER TABLE `mesabillar`
  ADD CONSTRAINT `mesabillar_ibfk_1` FOREIGN KEY (`IDMantenimiento`) REFERENCES `mantenimiento` (`IDMantenimiento`),
  ADD CONSTRAINT `mesabillar_ibfk_2` FOREIGN KEY (`IDPagoCOM`) REFERENCES `checkoutmesa` (`IDPagoCOM`),
  ADD CONSTRAINT `mesabillar_ibfk_3` FOREIGN KEY (`IDAmbiente`) REFERENCES `ambiente` (`IDAmbiente`);

--
-- Filtros para la tabla `mesacomida`
--
ALTER TABLE `mesacomida`
  ADD CONSTRAINT `mesacomida_ibfk_1` FOREIGN KEY (`IDAmbiente`) REFERENCES `ambiente` (`IDAmbiente`);

--
-- Filtros para la tabla `pago`
--
ALTER TABLE `pago`
  ADD CONSTRAINT `pago_ibfk_1` FOREIGN KEY (`IDPagoCOM`) REFERENCES `checkoutmesa` (`IDPagoCOM`),
  ADD CONSTRAINT `pago_ibfk_2` FOREIGN KEY (`IDPedidoConsumible`) REFERENCES `pedidoconsumible` (`IDPedidoConsumible`);

--
-- Filtros para la tabla `pedidoconsumible`
--
ALTER TABLE `pedidoconsumible`
  ADD CONSTRAINT `pedidoconsumible_ibfk_1` FOREIGN KEY (`IDCliente`) REFERENCES `cliente` (`IDCliente`),
  ADD CONSTRAINT `pedidoconsumible_ibfk_2` FOREIGN KEY (`IDLocal`) REFERENCES `tlocal` (`IDLocal`);

--
-- Filtros para la tabla `pedidoconsumible_consumible`
--
ALTER TABLE `pedidoconsumible_consumible`
  ADD CONSTRAINT `pedidoconsumible_consumible_ibfk_1` FOREIGN KEY (`IDConsumible`) REFERENCES `consumible` (`IDConsumible`),
  ADD CONSTRAINT `pedidoconsumible_consumible_ibfk_2` FOREIGN KEY (`IDPedidoConsumible`) REFERENCES `pedidoconsumible` (`IDPedidoConsumible`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
