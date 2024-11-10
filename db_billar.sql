-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 10, 2024 at 08:29 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_billar`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_all_clientes` ()   BEGIN
	SELECT * FROM cliente;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_all_consumibles` ()   BEGIN
	SELECT * FROM consumible;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_all_distribucion_ambientes` ()   BEGIN
	SELECT am.Nombre,mesab.IDMesaBillar,mesacom.IdMesaComida FROM ambiente AS am INNER JOIN mesabillar AS mesab INNER JOIN mesacomida AS mesacom ON am.IDAmbiente=mesab.IDAmbiente AND am.IDAmbiente=mesacom.IDAmbiente;
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_mesa_by_id` (IN `id` INT)   BEGIN
	SELECT * FROM mesabillar WHERE mesabillar.IDMesaBillar=id;
END$$

CREATE DEFINER=`` PROCEDURE `get_monto_consumibles` (IN `cliente_id` INT)   BEGIN
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

CREATE DEFINER=`` PROCEDURE `get_monto_mesa` (IN `cliente_id` INT)   BEGIN
    SELECT 
        p.IDPago, 
        com.IDPagoCOM, 
        com.PrecioHora, 
        com.HoraInicio, 
        com.HoraFin, 
        ((EXTRACT(HOUR FROM com.HoraFin) - EXTRACT(HOUR FROM com.HoraInicio) 
        + EXTRACT(MINUTE FROM com.HoraFin)/60.0 
        - EXTRACT(MINUTE FROM com.HoraInicio)/60.0)) * com.PrecioHora AS MontoMesa
    FROM 
        pago p 
    INNER JOIN 
        checkoutmesa com ON p.IDPagoCOM = com.IDPagoCOM
    INNER JOIN
    	cliente c ON c.IDPagoCOM = com.IDPagoCOM
    WHERE 
        c.IDCliente = cliente_id;
END$$

CREATE DEFINER=`` PROCEDURE `get_monto_total_cliente` (IN `cliente_id` INT)   BEGIN
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

    SELECT MontoMesa, MontoTotalConsumibles, (MontoMesa + MontoTotalConsumibles) AS MontoTotal;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_ambiente` (IN `NombreAmbiente` VARCHAR(30), IN `CapacidadAmbiente` INT, IN `IDLocalAmbiente` INT)   BEGIN
    INSERT INTO ambiente (Nombre, Capacidad, IDLocal) VALUES (0,NombreAmbiente, CapacidadAmbiente, IDLocalAmbiente);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_casillero` (IN `num` INT(11), IN `idCliente` INT(11))   BEGIN
	INSERT INTO casillero VALUES(0,num,idCliente);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_checkoutmesa` (IN `PrecioHora` DECIMAL(10,2), IN `HoraInicio` TIME, IN `HoraFin` TIME, IN `IDLocal` INT)   BEGIN
    INSERT INTO checkoutmesa (PrecioHora, HoraInicio, HoraFin, IDLocal) VALUES (0,PrecioHora, HoraInicio, HoraFin, IDLocal);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_cliente` (IN `nom` VARCHAR(30), IN `ape` VARCHAR(50), IN `tip` VARCHAR(10), IN `IdMesa` INT, IN `IdPagocom` INT(11), IN `IdMesaComida` INT)   BEGIN
	INSERT INTO cliente VALUES(0,nom,ape,tip,IdMesa,IdPagocom,IdMesaComida);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_consumible` (IN `PrecioConsumible` DECIMAL(10,2), IN `DescripcionConsumible` VARCHAR(50), IN `NombreConsumible` VARCHAR(30), IN `StockConsumible` INT)   BEGIN
    INSERT INTO consumible (Precio, Descripcion, Nombre, Stock) VALUES (0,PrecioConsumible, DescripcionConsumible, NombreConsumible, StockConsumible);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_empleado` (IN `DNIEmpleado` INT, IN `TelefonoEmpleado` VARCHAR(9), IN `NombreEmpleado` VARCHAR(30), IN `ApellidoEmpleado` VARCHAR(50), IN `CorreoEmpleado` VARCHAR(50), IN `CargoEmpleado` VARCHAR(30), IN `IDLocalEmpleado` INT)   BEGIN
    INSERT INTO empleado (DNI, Telefono, Nombre, Apellido, CorreoElectronico, Cargo, IDLocal) VALUES (0,DNIEmpleado, TelefonoEmpleado, NombreEmpleado, ApellidoEmpleado, CorreoEmpleado, CargoEmpleado, IDLocalEmpleado);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_equipo` (IN `TipoEquipo` VARCHAR(30), IN `DescripcionEquipo` VARCHAR(50), IN `IDLocalEquipo` INT, IN `IDProveedorEquipo` INT, IN `IDMantenimientoEquipo` INT)   BEGIN
    INSERT INTO equipamiento (Tipo, Descripcion, IDLocal, IDProveedor, IDMantenimiento) VALUES (0,TipoEquipo, DescripcionEquipo, IDLocalEquipo, IDProveedorEquipo, IDMantenimientoEquipo);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_ingrediente` (IN `NombreIngrediente` VARCHAR(30), IN `CantidadIngrediente` INT, IN `IDProveedorIngrediente` INT)   BEGIN
    INSERT INTO ingrediente (Nombre, Cantidad, IDProveedor) VALUES (0,NombreIngrediente, CantidadIngrediente, IDProveedorIngrediente);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_ingrediente_consumible` (IN `IDIngredienteConsumible` INT, IN `IDConsumibleIngrediente` INT)   BEGIN
    INSERT INTO ingrediente_consumible (IDIngrediente, IDConsumible) VALUES (IDIngredienteConsumible, IDConsumibleIngrediente);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_local` (IN `DireccionLocal` VARCHAR(50), IN `HoraAperturaLocal` TIME, IN `HoraCierreLocal` TIME)   BEGIN
    INSERT INTO tlocal (Direccion, horaApertura, horaCierra) VALUES (0,DireccionLocal, HoraAperturaLocal, HoraCierreLocal);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_local_consumible` (IN `IDConsumibleLocal` INT, IN `IDLocalConsumible` INT)   BEGIN
    INSERT INTO local_consumible (IDConsumible, IDLocal) VALUES (IDConsumibleLocal, IDLocalConsumible);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_mantenimiento` (IN `FechaMantenimiento` DATE, IN `DescripcionMantenimiento` VARCHAR(50))   BEGIN
    INSERT INTO mantenimiento (Fecha, Descripción) VALUES (0,FechaMantenimiento, DescripcionMantenimiento);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_mesabillar` (IN `tip` VARCHAR(20), IN `est` VARCHAR(20), IN `IdMante` INT(11), IN `IdPagoCom` INT(11), IN `IdAmbiente` INT(11))   BEGIN
	INSERT INTO mesabillar VALUES(0,tip,est,IdMante,IdPagoCom,IdAmbiente);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_mesacomida` (IN `CapacidadMesaComida` INT, IN `NumeroMesaComida` INT, IN `IDAmbienteMesaComida` INT)   BEGIN
    INSERT INTO mesacomida (Capacidad, Numero, IDAmbiente) VALUES (0,CapacidadMesaComida, NumeroMesaComida, IDAmbienteMesaComida);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_pago` (IN `MetodoPago` VARCHAR(15), IN `IDPedidoConsumiblePago` INT, IN `IDPagoCOM` INT)   BEGIN
    INSERT INTO pago (Metodo, IDPedidoConsumible, IDPagoCOM) VALUES (0,MetodoPago, IDPedidoConsumiblePago, IDPagoCOM);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_pedidoconsumible` (IN `CantidadConsumible` INT, IN `IDClienteConsumible` INT, IN `IDLocalConsumible` INT)   BEGIN
    INSERT INTO pedidoconsumible (IDPedidoConsumible,Cantidad, IDCliente, IDLocal) VALUES (0,CantidadConsumible, IDClienteConsumible, NULL);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_pedidoconsumible_consumible` (IN `IDConsumiblePedido` INT, IN `IDPedidoConsumibleConsumible` INT)   BEGIN
    INSERT INTO pedidoconsumible_consumible (IDConsumible, IDPedidoConsumible) VALUES (IDConsumiblePedido, IDPedidoConsumibleConsumible);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_proveedor` (IN `NombreProveedor` VARCHAR(30), IN `CorreoProveedor` VARCHAR(50), IN `TipoProveedor` VARCHAR(30), IN `TelefonoProveedor` VARCHAR(9))   BEGIN
    INSERT INTO proveedor (Nombre, CorreoElectronico, Tipo, Telefono) VALUES (0,NombreProveedor, CorreoProveedor, TipoProveedor, TelefonoProveedor);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_mesabillar` (IN `id` INT, IN `Tip` VARCHAR(20), IN `Est` VARCHAR(20), IN `Idman` INT(11), IN `IdPago` INT(11), IN `IdAm` INT(11))   BEGIN 
	UPDATE mesabillar SET mesabillar.Tipo=tip,mesabillar.Estado=Est,mesabillar.IDMantenimiento=Idman,mesabillar.IDPagoCOM=IdPago,mesabillar.IDAmbiente=IdAm WHERE mesabillar.IDMesaBillar=id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_Stock` (IN `id` INT)   BEGIN
	UPDATE consumible SET consumible.Stock=consumible.Stock - 1 WHERE consumible.IDConsumible=id;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `ambiente`
--

CREATE TABLE `ambiente` (
  `IDAmbiente` int(11) NOT NULL,
  `Nombre` varchar(30) DEFAULT NULL,
  `Capacidad` int(11) DEFAULT NULL,
  `IDLocal` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `ambiente`
--

INSERT INTO `ambiente` (`IDAmbiente`, `Nombre`, `Capacidad`, `IDLocal`) VALUES
(1, 'Sala 1', 50, 1),
(2, 'Sala 2', 20, 1),
(3, 'Sala 3', 40, 2),
(4, 'Sala 4', 30, 2),
(5, 'Terraza', 60, 1),
(6, 'Salón VIP', 15, 2),
(7, 'Terraza', 60, 1),
(8, 'Salón VIP', 15, 2);

-- --------------------------------------------------------

--
-- Table structure for table `casillero`
--

CREATE TABLE `casillero` (
  `IDCasillero` int(11) NOT NULL,
  `Numero` int(11) DEFAULT NULL,
  `IDCliente` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `casillero`
--

INSERT INTO `casillero` (`IDCasillero`, `Numero`, `IDCliente`) VALUES
(1, 101, 1),
(2, 102, 2),
(3, 103, 3),
(4, 104, 4);

-- --------------------------------------------------------

--
-- Table structure for table `checkoutmesa`
--

CREATE TABLE `checkoutmesa` (
  `IDPagoCOM` int(11) NOT NULL,
  `PrecioHora` decimal(10,2) DEFAULT NULL,
  `HoraFin` time DEFAULT NULL,
  `HoraInicio` time DEFAULT NULL,
  `IDLocal` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `checkoutmesa`
--

INSERT INTO `checkoutmesa` (`IDPagoCOM`, `PrecioHora`, `HoraFin`, `HoraInicio`, `IDLocal`) VALUES
(1, 8.00, '12:30:00', '10:00:00', 1),
(2, 7.00, '14:00:00', '12:00:00', 1),
(3, 7.00, '16:00:00', '14:00:00', 2),
(4, 10.00, '12:00:00', '10:30:00', 1),
(5, 9.00, '14:00:00', '13:15:00', 2);

-- --------------------------------------------------------

--
-- Table structure for table `cliente`
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
-- Dumping data for table `cliente`
--

INSERT INTO `cliente` (`IDCliente`, `Nombre`, `Apellidos`, `Tipo`, `IDMesaBillar`, `IDPagoCOM`, `IdMesaComida`) VALUES
(1, 'Juan', 'Martínez', 'Regular', 1, 1, NULL),
(2, 'Ana', 'García', 'Casillero', NULL, 2, 1),
(3, 'Luis', 'López', 'Regular', 2, 3, NULL),
(4, 'Pedro', 'Hernández', 'Casillero', NULL, NULL, 2),
(5, 'Marta', 'Sánchez', 'Regular', 3, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `consumible`
--

CREATE TABLE `consumible` (
  `IDConsumible` int(11) NOT NULL,
  `Precio` decimal(10,2) DEFAULT NULL,
  `Descripcion` varchar(50) DEFAULT NULL,
  `Nombre` varchar(30) DEFAULT NULL,
  `Stock` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `consumible`
--

INSERT INTO `consumible` (`IDConsumible`, `Precio`, `Descripcion`, `Nombre`, `Stock`) VALUES
(1, 5.00, 'Refresco', 'Coca-Cola', 99),
(2, 3.50, 'Refresco', 'Sprite', 79),
(3, 4.00, 'Snack', 'Papas', 49),
(4, 2.00, 'Bebida energética', 'Red Bull', 68),
(5, 6.50, 'Sándwich', 'Jamón y Queso', 19),
(6, 2.00, 'Bebida energética', 'Red Bull', 62),
(7, 6.50, 'Sándwich', 'Jamón y Queso', 0);

-- --------------------------------------------------------

--
-- Table structure for table `empleado`
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
-- Dumping data for table `empleado`
--

INSERT INTO `empleado` (`DNI`, `Telefono`, `Nombre`, `Apellido`, `CorreoElectronico`, `Cargo`, `IDLocal`) VALUES
(12345678, '123456789', 'Carlos', 'Pérez', 'carlos.perez@example.com', 'Atencion', 1),
(23456789, '111222333', 'María', 'López', 'maria.lopez@example.com', 'Cajera', 1),
(34567890, '444555666', 'Diego', 'Ramírez', 'diego.ramirez@example.com', 'Mantenimiento', 2),
(87654321, '987654321', 'Laura', 'González', 'laura.gonzalez@example.com', 'Atencion', 2);

-- --------------------------------------------------------

--
-- Table structure for table `equipamiento`
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
-- Dumping data for table `equipamiento`
--

INSERT INTO `equipamiento` (`IDEquipamiento`, `Tipo`, `Descripcion`, `IDLocal`, `IDProveedor`, `IDMantenimiento`) VALUES
(1, 'Mesa de Billar', 'Mesa estándar', 1, 1, NULL),
(2, 'Mesa de Billar', 'Sillas VIP', 2, 2, NULL),
(3, 'Mesa de Comedor', 'Mesa redonda', 1, 1, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `ingrediente`
--

CREATE TABLE `ingrediente` (
  `IDIngrediente` int(11) NOT NULL,
  `Nombre` varchar(30) DEFAULT NULL,
  `Cantidad` int(11) DEFAULT NULL,
  `IDProveedor` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `ingrediente`
--

INSERT INTO `ingrediente` (`IDIngrediente`, `Nombre`, `Cantidad`, `IDProveedor`) VALUES
(1, 'Azúcar', 100, 1),
(2, 'Sal', 50, 2),
(3, 'Harina', 200, 1),
(4, 'Café', 300, 1),
(5, 'Cacao', 150, 2),
(6, 'Café', 300, 1),
(7, 'Cacao', 150, 2);

-- --------------------------------------------------------

--
-- Table structure for table `ingrediente_consumible`
--

CREATE TABLE `ingrediente_consumible` (
  `IDIngrediente` int(11) NOT NULL,
  `IDConsumible` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `ingrediente_consumible`
--

INSERT INTO `ingrediente_consumible` (`IDIngrediente`, `IDConsumible`) VALUES
(1, 1),
(1, 4),
(2, 2),
(2, 5),
(3, 3);

-- --------------------------------------------------------

--
-- Table structure for table `local_consumible`
--

CREATE TABLE `local_consumible` (
  `IDConsumible` int(11) NOT NULL,
  `IDLocal` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `local_consumible`
--

INSERT INTO `local_consumible` (`IDConsumible`, `IDLocal`) VALUES
(1, 1),
(2, 1),
(3, 2),
(4, 1),
(5, 2);

-- --------------------------------------------------------

--
-- Table structure for table `mantenimiento`
--

CREATE TABLE `mantenimiento` (
  `IDMantenimiento` int(11) NOT NULL,
  `Fecha` date DEFAULT NULL,
  `Descripción` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `mantenimiento`
--

INSERT INTO `mantenimiento` (`IDMantenimiento`, `Fecha`, `Descripción`) VALUES
(1, '2024-01-15', 'Cambio de paño de mesa de billar'),
(2, '2024-02-10', 'Revisión de luces'),
(3, '2024-03-20', 'Cambio de tacos'),
(4, '2024-04-15', 'Reparación de aire acondicionado'),
(5, '2024-05-05', 'Cambio de iluminación en salas');

-- --------------------------------------------------------

--
-- Table structure for table `mesabillar`
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
-- Dumping data for table `mesabillar`
--

INSERT INTO `mesabillar` (`IDMesaBillar`, `Tipo`, `Estado`, `IDMantenimiento`, `IDPagoCOM`, `IDAmbiente`) VALUES
(1, 'Normal', 'Disponible', NULL, NULL, 1),
(2, 'arroz', 'ocupado', 3, 2, 1),
(3, 'Carambola', 'Mantenimiento', 3, NULL, 2),
(4, 'Normal', 'Disponible', NULL, NULL, 1),
(5, 'Americana', 'Disponible', NULL, NULL, NULL),
(6, 'Snooker', 'Mantenimiento', NULL, NULL, NULL),
(7, 'Carambola', 'En uso', NULL, NULL, NULL),
(8, 'Pool', 'Reservada', NULL, NULL, NULL),
(9, 'Francés', 'Disponible', NULL, NULL, NULL),
(10, 'Inglés', 'En uso', NULL, NULL, NULL),
(11, 'Español', 'Disponible', NULL, NULL, NULL),
(12, 'Ruso', 'Mantenimiento', NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `mesacomida`
--

CREATE TABLE `mesacomida` (
  `IdMesaComida` int(11) NOT NULL,
  `Capacidad` int(11) DEFAULT NULL,
  `Numero` int(11) DEFAULT NULL,
  `IDAmbiente` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `mesacomida`
--

INSERT INTO `mesacomida` (`IdMesaComida`, `Capacidad`, `Numero`, `IDAmbiente`) VALUES
(1, 4, 1, 1),
(2, 6, 2, 1),
(3, 4, 3, 2),
(4, 8, 4, 2);

-- --------------------------------------------------------

--
-- Table structure for table `pago`
--

CREATE TABLE `pago` (
  `IDPago` int(11) NOT NULL,
  `Metodo` varchar(15) DEFAULT NULL,
  `IDPagoCOM` int(11) DEFAULT NULL,
  `IDPedidoConsumible` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pago`
--

INSERT INTO `pago` (`IDPago`, `Metodo`, `IDPagoCOM`, `IDPedidoConsumible`) VALUES
(1, 'Tarjeta', 1, 1),
(2, 'Efectivo', 2, 2),
(3, 'Tarjeta', 3, 3);

-- --------------------------------------------------------

--
-- Table structure for table `pedidoconsumible`
--

CREATE TABLE `pedidoconsumible` (
  `IDPedidoConsumible` int(11) NOT NULL,
  `Cantidad` int(11) DEFAULT NULL,
  `IDCliente` int(11) DEFAULT NULL,
  `IDLocal` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pedidoconsumible`
--

INSERT INTO `pedidoconsumible` (`IDPedidoConsumible`, `Cantidad`, `IDCliente`, `IDLocal`) VALUES
(1, 3, 1, 1),
(2, 2, 2, 1),
(3, 5, 3, 2),
(5, 1, 3, 1),
(6, 1, 3, 1),
(7, 1, 3, 1),
(8, 1, 1, 1),
(9, 1, 1, NULL),
(10, 1, 1, NULL),
(11, 1, 2, NULL),
(12, 1, 2, NULL),
(13, 1, 2, NULL),
(14, 1, 2, NULL),
(15, 1, 5, NULL),
(16, 1, 5, NULL),
(17, 1, 5, NULL),
(18, 1, 5, NULL),
(19, 1, 5, NULL),
(20, 1, 5, NULL),
(21, 1, 2, NULL),
(22, 1, 3, NULL),
(23, 1, 4, NULL),
(24, 1, 2, NULL),
(25, 1, 5, NULL),
(26, 1, 1, NULL),
(27, 1, 1, NULL),
(28, 1, 1, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `pedidoconsumible_consumible`
--

CREATE TABLE `pedidoconsumible_consumible` (
  `IDConsumible` int(11) NOT NULL,
  `IDPedidoConsumible` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pedidoconsumible_consumible`
--

INSERT INTO `pedidoconsumible_consumible` (`IDConsumible`, `IDPedidoConsumible`) VALUES
(1, 1),
(1, 2),
(1, 6),
(1, 7),
(1, 8),
(1, 9),
(1, 13),
(2, 1),
(2, 5),
(2, 6),
(2, 7),
(2, 8),
(2, 9),
(2, 13),
(3, 2),
(3, 7),
(3, 8),
(3, 12),
(4, 7),
(4, 8),
(4, 10),
(4, 11),
(4, 12),
(4, 21),
(4, 22),
(4, 23),
(5, 10),
(5, 11),
(5, 12),
(5, 21),
(5, 22),
(5, 23),
(5, 26),
(5, 28),
(6, 10),
(6, 18),
(6, 21),
(6, 22),
(6, 23),
(6, 25),
(6, 26),
(6, 27),
(6, 28),
(7, 14),
(7, 15),
(7, 16),
(7, 17),
(7, 19),
(7, 20),
(7, 24);

-- --------------------------------------------------------

--
-- Table structure for table `proveedor`
--

CREATE TABLE `proveedor` (
  `IDProveedor` int(11) NOT NULL,
  `Nombre` varchar(30) DEFAULT NULL,
  `CorreoElectronico` varchar(50) DEFAULT NULL,
  `Tipo` varchar(30) DEFAULT NULL,
  `Telefono` varchar(9) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `proveedor`
--

INSERT INTO `proveedor` (`IDProveedor`, `Nombre`, `CorreoElectronico`, `Tipo`, `Telefono`) VALUES
(1, 'Distribuidora XYZ', 'contacto@xyz.com', 'Bebidas', '123456789'),
(2, 'Alimentos ABC', 'ventas@abc.com', 'Snacks', '987654321'),
(3, 'Bebidas Internacionales', 'info@bebidasint.com', 'Bebidas', '112233445'),
(4, 'Productos Gourmet', 'contacto@gourmet.com', 'Alimentos', '554433221'),
(5, 'Bebidas Internacionales', 'info@bebidasint.com', 'Bebidas', '112233445'),
(6, 'Productos Gourmet', 'contacto@gourmet.com', 'Alimentos', '554433221');

-- --------------------------------------------------------

--
-- Table structure for table `tlocal`
--

CREATE TABLE `tlocal` (
  `IDLocal` int(11) NOT NULL,
  `Direccion` varchar(50) DEFAULT NULL,
  `horaApertura` time DEFAULT NULL,
  `horaCierra` time DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tlocal`
--

INSERT INTO `tlocal` (`IDLocal`, `Direccion`, `horaApertura`, `horaCierra`) VALUES
(1, 'Av. Principal 123', '09:00:00', '21:00:00'),
(2, 'Calle Secundaria 456', '10:00:00', '22:00:00'),
(3, 'Avenida del Sol 789', '08:00:00', '20:00:00'),
(4, 'Calle Luna 101', '09:30:00', '19:30:00'),
(5, 'Avenida del Sol 789', '08:00:00', '20:00:00'),
(6, 'Calle Luna 101', '09:30:00', '19:30:00');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `ambiente`
--
ALTER TABLE `ambiente`
  ADD PRIMARY KEY (`IDAmbiente`),
  ADD KEY `IDLocal` (`IDLocal`);

--
-- Indexes for table `casillero`
--
ALTER TABLE `casillero`
  ADD PRIMARY KEY (`IDCasillero`),
  ADD KEY `IDCliente` (`IDCliente`);

--
-- Indexes for table `checkoutmesa`
--
ALTER TABLE `checkoutmesa`
  ADD PRIMARY KEY (`IDPagoCOM`),
  ADD KEY `IDLocal` (`IDLocal`);

--
-- Indexes for table `cliente`
--
ALTER TABLE `cliente`
  ADD PRIMARY KEY (`IDCliente`),
  ADD KEY `IDMesaBillar` (`IDMesaBillar`),
  ADD KEY `IDPagoCOM` (`IDPagoCOM`),
  ADD KEY `IdMesaComida` (`IdMesaComida`);

--
-- Indexes for table `consumible`
--
ALTER TABLE `consumible`
  ADD PRIMARY KEY (`IDConsumible`);

--
-- Indexes for table `empleado`
--
ALTER TABLE `empleado`
  ADD PRIMARY KEY (`DNI`),
  ADD KEY `IDLocal` (`IDLocal`);

--
-- Indexes for table `equipamiento`
--
ALTER TABLE `equipamiento`
  ADD PRIMARY KEY (`IDEquipamiento`),
  ADD KEY `IDLocal` (`IDLocal`),
  ADD KEY `IDProveedor` (`IDProveedor`),
  ADD KEY `IDMantenimiento` (`IDMantenimiento`);

--
-- Indexes for table `ingrediente`
--
ALTER TABLE `ingrediente`
  ADD PRIMARY KEY (`IDIngrediente`),
  ADD KEY `IDProveedor` (`IDProveedor`);

--
-- Indexes for table `ingrediente_consumible`
--
ALTER TABLE `ingrediente_consumible`
  ADD PRIMARY KEY (`IDIngrediente`,`IDConsumible`),
  ADD KEY `IDConsumible` (`IDConsumible`);

--
-- Indexes for table `local_consumible`
--
ALTER TABLE `local_consumible`
  ADD PRIMARY KEY (`IDConsumible`,`IDLocal`),
  ADD KEY `IDLocal` (`IDLocal`);

--
-- Indexes for table `mantenimiento`
--
ALTER TABLE `mantenimiento`
  ADD PRIMARY KEY (`IDMantenimiento`);

--
-- Indexes for table `mesabillar`
--
ALTER TABLE `mesabillar`
  ADD PRIMARY KEY (`IDMesaBillar`),
  ADD KEY `IDMantenimiento` (`IDMantenimiento`),
  ADD KEY `IDPagoCOM` (`IDPagoCOM`),
  ADD KEY `IDAmbiente` (`IDAmbiente`);

--
-- Indexes for table `mesacomida`
--
ALTER TABLE `mesacomida`
  ADD PRIMARY KEY (`IdMesaComida`),
  ADD KEY `IDAmbiente` (`IDAmbiente`);

--
-- Indexes for table `pago`
--
ALTER TABLE `pago`
  ADD PRIMARY KEY (`IDPago`),
  ADD KEY `IDPagoCOM` (`IDPagoCOM`),
  ADD KEY `IDPedidoConsumible` (`IDPedidoConsumible`);

--
-- Indexes for table `pedidoconsumible`
--
ALTER TABLE `pedidoconsumible`
  ADD PRIMARY KEY (`IDPedidoConsumible`),
  ADD KEY `IDCliente` (`IDCliente`),
  ADD KEY `IDLocal` (`IDLocal`);

--
-- Indexes for table `pedidoconsumible_consumible`
--
ALTER TABLE `pedidoconsumible_consumible`
  ADD PRIMARY KEY (`IDConsumible`,`IDPedidoConsumible`),
  ADD KEY `IDPedidoConsumible` (`IDPedidoConsumible`);

--
-- Indexes for table `proveedor`
--
ALTER TABLE `proveedor`
  ADD PRIMARY KEY (`IDProveedor`);

--
-- Indexes for table `tlocal`
--
ALTER TABLE `tlocal`
  ADD PRIMARY KEY (`IDLocal`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `ambiente`
--
ALTER TABLE `ambiente`
  MODIFY `IDAmbiente` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `casillero`
--
ALTER TABLE `casillero`
  MODIFY `IDCasillero` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `checkoutmesa`
--
ALTER TABLE `checkoutmesa`
  MODIFY `IDPagoCOM` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `cliente`
--
ALTER TABLE `cliente`
  MODIFY `IDCliente` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `consumible`
--
ALTER TABLE `consumible`
  MODIFY `IDConsumible` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `equipamiento`
--
ALTER TABLE `equipamiento`
  MODIFY `IDEquipamiento` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `ingrediente`
--
ALTER TABLE `ingrediente`
  MODIFY `IDIngrediente` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `mantenimiento`
--
ALTER TABLE `mantenimiento`
  MODIFY `IDMantenimiento` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `mesabillar`
--
ALTER TABLE `mesabillar`
  MODIFY `IDMesaBillar` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `mesacomida`
--
ALTER TABLE `mesacomida`
  MODIFY `IdMesaComida` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `pago`
--
ALTER TABLE `pago`
  MODIFY `IDPago` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `pedidoconsumible`
--
ALTER TABLE `pedidoconsumible`
  MODIFY `IDPedidoConsumible` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `proveedor`
--
ALTER TABLE `proveedor`
  MODIFY `IDProveedor` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `tlocal`
--
ALTER TABLE `tlocal`
  MODIFY `IDLocal` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `ambiente`
--
ALTER TABLE `ambiente`
  ADD CONSTRAINT `ambiente_ibfk_1` FOREIGN KEY (`IDLocal`) REFERENCES `tlocal` (`IDLocal`);

--
-- Constraints for table `casillero`
--
ALTER TABLE `casillero`
  ADD CONSTRAINT `casillero_ibfk_1` FOREIGN KEY (`IDCliente`) REFERENCES `cliente` (`IDCliente`);

--
-- Constraints for table `checkoutmesa`
--
ALTER TABLE `checkoutmesa`
  ADD CONSTRAINT `checkoutmesa_ibfk_1` FOREIGN KEY (`IDLocal`) REFERENCES `tlocal` (`IDLocal`);

--
-- Constraints for table `cliente`
--
ALTER TABLE `cliente`
  ADD CONSTRAINT `cliente_ibfk_1` FOREIGN KEY (`IDMesaBillar`) REFERENCES `mesabillar` (`IDMesaBillar`),
  ADD CONSTRAINT `cliente_ibfk_2` FOREIGN KEY (`IDPagoCOM`) REFERENCES `checkoutmesa` (`IDPagoCOM`),
  ADD CONSTRAINT `cliente_ibfk_3` FOREIGN KEY (`IdMesaComida`) REFERENCES `mesacomida` (`IdMesaComida`);

--
-- Constraints for table `empleado`
--
ALTER TABLE `empleado`
  ADD CONSTRAINT `empleado_ibfk_1` FOREIGN KEY (`IDLocal`) REFERENCES `tlocal` (`IDLocal`);

--
-- Constraints for table `equipamiento`
--
ALTER TABLE `equipamiento`
  ADD CONSTRAINT `equipamiento_ibfk_1` FOREIGN KEY (`IDLocal`) REFERENCES `tlocal` (`IDLocal`),
  ADD CONSTRAINT `equipamiento_ibfk_2` FOREIGN KEY (`IDProveedor`) REFERENCES `proveedor` (`IDProveedor`),
  ADD CONSTRAINT `equipamiento_ibfk_3` FOREIGN KEY (`IDMantenimiento`) REFERENCES `mantenimiento` (`IDMantenimiento`);

--
-- Constraints for table `ingrediente`
--
ALTER TABLE `ingrediente`
  ADD CONSTRAINT `ingrediente_ibfk_1` FOREIGN KEY (`IDProveedor`) REFERENCES `proveedor` (`IDProveedor`);

--
-- Constraints for table `ingrediente_consumible`
--
ALTER TABLE `ingrediente_consumible`
  ADD CONSTRAINT `ingrediente_consumible_ibfk_1` FOREIGN KEY (`IDIngrediente`) REFERENCES `ingrediente` (`IDIngrediente`),
  ADD CONSTRAINT `ingrediente_consumible_ibfk_2` FOREIGN KEY (`IDConsumible`) REFERENCES `consumible` (`IDConsumible`);

--
-- Constraints for table `local_consumible`
--
ALTER TABLE `local_consumible`
  ADD CONSTRAINT `local_consumible_ibfk_1` FOREIGN KEY (`IDConsumible`) REFERENCES `consumible` (`IDConsumible`),
  ADD CONSTRAINT `local_consumible_ibfk_2` FOREIGN KEY (`IDLocal`) REFERENCES `tlocal` (`IDLocal`);

--
-- Constraints for table `mesabillar`
--
ALTER TABLE `mesabillar`
  ADD CONSTRAINT `mesabillar_ibfk_1` FOREIGN KEY (`IDMantenimiento`) REFERENCES `mantenimiento` (`IDMantenimiento`),
  ADD CONSTRAINT `mesabillar_ibfk_2` FOREIGN KEY (`IDPagoCOM`) REFERENCES `checkoutmesa` (`IDPagoCOM`),
  ADD CONSTRAINT `mesabillar_ibfk_3` FOREIGN KEY (`IDAmbiente`) REFERENCES `ambiente` (`IDAmbiente`);

--
-- Constraints for table `mesacomida`
--
ALTER TABLE `mesacomida`
  ADD CONSTRAINT `mesacomida_ibfk_1` FOREIGN KEY (`IDAmbiente`) REFERENCES `ambiente` (`IDAmbiente`);

--
-- Constraints for table `pago`
--
ALTER TABLE `pago`
  ADD CONSTRAINT `pago_ibfk_1` FOREIGN KEY (`IDPagoCOM`) REFERENCES `checkoutmesa` (`IDPagoCOM`),
  ADD CONSTRAINT `pago_ibfk_2` FOREIGN KEY (`IDPedidoConsumible`) REFERENCES `pedidoconsumible` (`IDPedidoConsumible`);

--
-- Constraints for table `pedidoconsumible`
--
ALTER TABLE `pedidoconsumible`
  ADD CONSTRAINT `pedidoconsumible_ibfk_1` FOREIGN KEY (`IDCliente`) REFERENCES `cliente` (`IDCliente`),
  ADD CONSTRAINT `pedidoconsumible_ibfk_2` FOREIGN KEY (`IDLocal`) REFERENCES `tlocal` (`IDLocal`);

--
-- Constraints for table `pedidoconsumible_consumible`
--
ALTER TABLE `pedidoconsumible_consumible`
  ADD CONSTRAINT `pedidoconsumible_consumible_ibfk_1` FOREIGN KEY (`IDConsumible`) REFERENCES `consumible` (`IDConsumible`),
  ADD CONSTRAINT `pedidoconsumible_consumible_ibfk_2` FOREIGN KEY (`IDPedidoConsumible`) REFERENCES `pedidoconsumible` (`IDPedidoConsumible`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
