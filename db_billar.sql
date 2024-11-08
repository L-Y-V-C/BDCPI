-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 09-11-2024 a las 04:25:42
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_pedidoConsumible` (IN `CantidadConsumible` INT, IN `IDClienteConsumible` INT, IN `IDLocalConsumible` INT)   BEGIN
    INSERT INTO pedidoconsumible (Cantidad, IDCliente, IDLocal) VALUES (0,CantidadConsumible, IDClienteConsumible, IDLocalConsumible);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_pedidoconsumible_consumible` (IN `IDConsumiblePedido` INT, IN `IDPedidoConsumibleConsumible` INT)   BEGIN
    INSERT INTO pedidoconsumible_consumible (IDConsumible, IDPedidoConsumible) VALUES (IDConsumiblePedido, IDPedidoConsumibleConsumible);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_proveedor` (IN `NombreProveedor` VARCHAR(30), IN `CorreoProveedor` VARCHAR(50), IN `TipoProveedor` VARCHAR(30), IN `TelefonoProveedor` VARCHAR(9))   BEGIN
    INSERT INTO proveedor (Nombre, CorreoElectronico, Tipo, Telefono) VALUES (0,NombreProveedor, CorreoProveedor, TipoProveedor, TelefonoProveedor);
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
(1, 101, 1),
(2, 102, 2),
(3, 103, 3),
(4, 104, 4);

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
(1, 8.00, NULL, '10:00:00', 1),
(2, 7.00, NULL, '12:00:00', 1),
(3, 7.00, '16:00:00', '14:00:00', 2),
(4, 10.00, '12:00:00', '18:00:00', 1),
(5, 9.00, '14:00:00', '20:00:00', 2);

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
(1, 'Juan', 'Martínez', 'Regular', 1, 1, NULL),
(2, 'Ana', 'García', 'Casillero', NULL, 2, 1),
(3, 'Luis', 'López', 'Regular', 2, NULL, NULL),
(4, 'Pedro', 'Hernández', 'Casillero', NULL, NULL, 2),
(5, 'Marta', 'Sánchez', 'Regular', 3, NULL, NULL);

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
(1, 5.00, 'Refresco', 'Coca-Cola', 100),
(2, 3.50, 'Refresco', 'Sprite', 80),
(3, 4.00, 'Snack', 'Papas', 50),
(4, 2.00, 'Bebida energética', 'Red Bull', 75),
(5, 6.50, 'Sándwich', 'Jamón y Queso', 30),
(6, 2.00, 'Bebida energética', 'Red Bull', 75),
(7, 6.50, 'Sándwich', 'Jamón y Queso', 30);

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
(12345678, '123456789', 'Carlos', 'Pérez', 'carlos.perez@example.com', 'Atencion', 1),
(23456789, '111222333', 'María', 'López', 'maria.lopez@example.com', 'Cajera', 1),
(34567890, '444555666', 'Diego', 'Ramírez', 'diego.ramirez@example.com', 'Mantenimiento', 2),
(87654321, '987654321', 'Laura', 'González', 'laura.gonzalez@example.com', 'Atencion', 2);

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
(1, 'Mesa de Billar', 'Mesa estándar', 1, 1, NULL),
(2, 'Mesa de Billar', 'Sillas VIP', 2, 2, NULL),
(3, 'Mesa de Comedor', 'Mesa redonda', 1, 1, NULL);

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
(1, 'Azúcar', 100, 1),
(2, 'Sal', 50, 2),
(3, 'Harina', 200, 1),
(4, 'Café', 300, 1),
(5, 'Cacao', 150, 2),
(6, 'Café', 300, 1),
(7, 'Cacao', 150, 2);

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
(1, 4),
(2, 2),
(2, 5),
(3, 3);

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
(3, 2),
(4, 1),
(5, 2);

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
(1, '2024-01-15', 'Cambio de paño de mesa de billar'),
(2, '2024-02-10', 'Revisión de luces'),
(3, '2024-03-20', 'Cambio de tacos'),
(4, '2024-04-15', 'Reparación de aire acondicionado'),
(5, '2024-05-05', 'Cambio de iluminación en salas');

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
(1, 'Normal', 'Disponible', NULL, NULL, 1),
(2, 'Normal', 'En uso', NULL, 1, 1),
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
(2, 6, 2, 1),
(3, 4, 3, 2),
(4, 8, 4, 2);

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
(1, 'Tarjeta', 1, NULL),
(2, 'Efectivo', 2, 2),
(3, 'Tarjeta', 3, 3);

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
(1, 3, 1, 1),
(2, 2, 2, 1),
(3, 5, 3, 2);

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
(1, 1),
(2, 1),
(3, 2);

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
(1, 'Distribuidora XYZ', 'contacto@xyz.com', 'Bebidas', '123456789'),
(2, 'Alimentos ABC', 'ventas@abc.com', 'Snacks', '987654321'),
(3, 'Bebidas Internacionales', 'info@bebidasint.com', 'Bebidas', '112233445'),
(4, 'Productos Gourmet', 'contacto@gourmet.com', 'Alimentos', '554433221'),
(5, 'Bebidas Internacionales', 'info@bebidasint.com', 'Bebidas', '112233445'),
(6, 'Productos Gourmet', 'contacto@gourmet.com', 'Alimentos', '554433221');

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
(1, 'Av. Principal 123', '09:00:00', '21:00:00'),
(2, 'Calle Secundaria 456', '10:00:00', '22:00:00'),
(3, 'Avenida del Sol 789', '08:00:00', '20:00:00'),
(4, 'Calle Luna 101', '09:30:00', '19:30:00'),
(5, 'Avenida del Sol 789', '08:00:00', '20:00:00'),
(6, 'Calle Luna 101', '09:30:00', '19:30:00');

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
  MODIFY `IDAmbiente` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `casillero`
--
ALTER TABLE `casillero`
  MODIFY `IDCasillero` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `checkoutmesa`
--
ALTER TABLE `checkoutmesa`
  MODIFY `IDPagoCOM` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `cliente`
--
ALTER TABLE `cliente`
  MODIFY `IDCliente` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `consumible`
--
ALTER TABLE `consumible`
  MODIFY `IDConsumible` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `equipamiento`
--
ALTER TABLE `equipamiento`
  MODIFY `IDEquipamiento` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `ingrediente`
--
ALTER TABLE `ingrediente`
  MODIFY `IDIngrediente` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `mantenimiento`
--
ALTER TABLE `mantenimiento`
  MODIFY `IDMantenimiento` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `mesabillar`
--
ALTER TABLE `mesabillar`
  MODIFY `IDMesaBillar` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `mesacomida`
--
ALTER TABLE `mesacomida`
  MODIFY `IdMesaComida` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `pago`
--
ALTER TABLE `pago`
  MODIFY `IDPago` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `pedidoconsumible`
--
ALTER TABLE `pedidoconsumible`
  MODIFY `IDPedidoConsumible` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

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
