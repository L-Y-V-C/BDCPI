-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 22, 2024 at 07:49 AM
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `assign_consumible_pago` (IN `id_cliente` INT, IN `id_pedidoconsumible` INT)   BEGIN
	DECLARE pago_new_com INT;
    SET pago_new_com = IDpagocom_get(id_cliente);
    CALL insert_pago('Efectivo',pago_new_com,id_pedidoconsumible);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `create_proveedor_ingrediente` (IN `in_nombre` VARCHAR(30), IN `in_correo` VARCHAR(50), IN `in_tipo` VARCHAR(30), IN `in_telefono` VARCHAR(9), IN `in_ing_nombre` VARCHAR(30), IN `in_cantidad` INT)   BEGIN
    DECLARE last_proveedor_id INT;
    
    CALL insert_proveedor(in_nombre, in_correo, in_tipo, in_telefono);
    
    SET last_proveedor_id = obtener_ultimo_proveedor();
    CALL insert_ingrediente(in_ing_nombre, in_cantidad, last_proveedor_id);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_all_ambientes` (IN `local_id` INT)   BEGIN
	SELECT * FROM ambiente WHERE ambiente.IDLocal=local_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_all_clientes` ()   BEGIN
	SELECT * FROM cliente;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_all_consumibles` ()   BEGIN
	SELECT * FROM consumible;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_all_equipamento_mantenimiento` ()   BEGIN 
    SELECT equi.IDEquipamiento, equi.Tipo,mat.Fecha, equi.Descripcion , mat.Descripción FROM mantenimiento AS mat 
    INNER JOIN equipamiento AS equi
    ON equi.IDMantenimiento=mat.IDMantenimiento
    WHERE equi.IDMantenimiento=mat.IDMantenimiento;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_all_locales` ()   BEGIN
	SELECT * FROM tlocal;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_all_mesabillar` ()   BEGIN
	SELECT IDMesaBillar,Tipo,Estado FROM mesabillar GROUP BY IDMesaBillar;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_all_mesabillar_mantenimiento` ()   BEGIN 
    SELECT mdb.IDMesaBillar, mdb.Tipo, mat.IDMantenimiento, mat.Fecha, mat.Descripción FROM mantenimiento AS mat 
    INNER JOIN  mesabillar AS mdb 
    ON mat.IDMantenimiento=mdb.IDMantenimiento 
    WHERE mdb.Estado='Mantenimiento';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_all_mesabillar_mantenimiento_by_id` (IN `local_id` INT)   BEGIN 
    SELECT mdb.IDMesaBillar, mdb.Tipo, mat.IDMantenimiento, mat.Fecha, mat.Descripción, am.IDAmbiente FROM mantenimiento AS mat 
    INNER JOIN  mesabillar AS mdb 
    ON mat.IDMantenimiento=mdb.IDMantenimiento 
    INNER JOIN ambiente AS am ON
    am.IDAmbiente=mdb.IDAmbiente
    INNER JOIN tlocal AS lal ON
    lal.IDLocal=am.IDLocal
    WHERE mdb.Estado='Mantenimiento' AND lal.IDLocal=local_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_all_pedido_completo` ()   BEGIN
	SELECT CONCAT(cl.Nombre,' ',cl.Apellidos) AS 'Nombre_Cliente',tl.IDLocal,con.Nombre,con.Precio,pedidocon.Cantidad FROM tlocal AS tl INNER JOIN local_consumible INNER JOIN consumible AS con INNER JOIN pedidoconsumible_consumible INNER JOIN pedidoconsumible AS pedidocon INNER JOIN cliente AS cl ON tl.IDLocal=local_consumible.IDLocal AND local_consumible.IDConsumible = con.IDConsumible AND con.IDConsumible=pedidoconsumible_consumible.IDConsumible AND pedidoconsumible_consumible.IDPedidoConsumible=pedidocon.IDPedidoConsumible AND pedidocon.IDCliente=cl.IDCliente;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_all_propietario_casillero` ()   BEGIN
	SELECT CONCAT(c.Nombre,' ',c.Apellidos) AS 'Nombre y Apellidos',ca.Numero AS 'Numero casillero' FROM cliente AS c INNER JOIN casillero AS ca ON c.IDCliente=ca.IDCasillero;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_all_proveedores` ()   BEGIN
    SELECT * FROM proveedor;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_all_stock` (IN `id` INT)   BEGIN
	SELECT consumible.Stock FROM consumible WHERE consumible.IDConsumible=id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_checkoutmesa_by_id` (IN `id_com` INTEGER)   BEGIN
    SELECT * FROM checkoutmesa
    WHERE checkoutmesa.IDPagoCOM = id_com;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_cliente_by_id` (IN `cliente_id` INTEGER)   BEGIN
    SELECT * FROM cliente
    WHERE cliente.IDCliente = cliente_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_consumibles_by_local_id` (IN `id` INT)   BEGIN 
    SELECT 
    	con.IDConsumible, con.Precio, con.Descripcion, con.Nombre, con.Stock
    FROM consumible AS con INNER JOIN local_consumible AS loc_con 
    ON con.IDConsumible = loc_con.IDConsumible AND loc_con.IDLocal = id;
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_ingredientes_by_consumible_id` (IN `id` INT)   BEGIN 
    SELECT
        ing.IDIngrediente, ing.Nombre, ing.Cantidad
    FROM ingrediente_consumible AS ing_con INNER JOIN ingrediente AS ing 
    ON ing_con.IDIngrediente = ing.IDIngrediente AND ing_con.IDConsumible = id;
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_mesa_comida_by_local_id` (IN `id` INT)   BEGIN
    SELECT 
    	mes.IdMesaComida,
        mes.Capacidad,
        mes.Numero,
        mes.IDAmbiente
    FROM 
        mesacomida AS mes
    INNER JOIN 
        ambiente AS amb 
        ON mes.IDAmbiente = amb.IDAmbiente
    INNER JOIN 
        tlocal AS loc 
        ON amb.IDLocal = loc.IDLocal
    WHERE 
        loc.IDLocal = id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_monto_consumibles` (IN `cliente_id` INT)   BEGIN
    SELECT 
        p.IDPago,
        pc.IDPedidoConsumible,
        c.IDConsumible,
        c.Nombre, 
        c.Precio
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
        c.IDCliente = cliente_id
    GROUP BY com.IDPagoCOM;
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
        c.IDCliente = cliente_id
    GROUP BY com.IDPagoCOM;

    SELECT 
        SUM(c.Precio) 
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_precio_promedio_consumibles` ()   BEGIN 
    SELECT 
    AVG(consumible.Precio) AS PrecioPromedio
    FROM
    	consumible;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_ambiente` (IN `NombreAmbiente` VARCHAR(30), IN `CapacidadAmbiente` INT, IN `IDLocalAmbiente` INT)   BEGIN
    INSERT INTO ambiente (Nombre, Capacidad, IDLocal) VALUES (NombreAmbiente, CapacidadAmbiente, IDLocalAmbiente);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_casillero` (IN `num` INT(11), IN `idCliente` INT(11))   BEGIN
	INSERT INTO casillero VALUES(NULL,num,idCliente);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_checkoutmesa` (IN `PrecioHora` DECIMAL(10,2), IN `HoraInicio` TIME, IN `HoraFin` TIME, IN `IDLocal` INT)   BEGIN
    INSERT INTO checkoutmesa VALUES (NULL, PrecioHora, HoraFin, HoraInicio, IDLocal);
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_mesabillar` (IN `tip` VARCHAR(20), IN `est` VARCHAR(20), IN `IdAmbiente` INT(11))   BEGIN
	INSERT INTO mesabillar VALUES(NULL,tip,est,NULL,NULL,IdAmbiente);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_mesacomida` (IN `CapacidadMesaComida` INT, IN `NumeroMesaComida` INT, IN `IDAmbienteMesaComida` INT)   BEGIN
    INSERT INTO mesacomida (Capacidad, Numero, IDAmbiente) VALUES (CapacidadMesaComida, NumeroMesaComida, IDAmbienteMesaComida);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_pago` (IN `MetodoPago` VARCHAR(15), IN `IDPedidoConsumiblePago` INT, IN `IDPagoCOM` INT)   BEGIN
    INSERT INTO pago VALUES (NULL,MetodoPago, IDPedidoConsumiblePago,IDPagoCOM);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_pedidoconsumible` (IN `IDClienteConsumible` INT, IN `IDLocalConsumible` INT)   BEGIN
    INSERT INTO pedidoconsumible ( IDCliente, IDLocal) VALUES (IDClienteConsumible, NULL);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_pedidoconsumible_consumible` (IN `IDConsumiblePedido` INT, IN `IDPedidoConsumibleConsumible` INT)   BEGIN
    INSERT INTO pedidoconsumible_consumible (IDConsumible, IDPedidoConsumible) VALUES (IDConsumiblePedido, IDPedidoConsumibleConsumible);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_proveedor` (IN `NombreProveedor` VARCHAR(30), IN `CorreoProveedor` VARCHAR(50), IN `TipoProveedor` VARCHAR(30), IN `TelefonoProveedor` VARCHAR(9))   BEGIN
    INSERT INTO proveedor (Nombre, CorreoElectronico, Tipo, Telefono) VALUES (NombreProveedor, CorreoProveedor, TipoProveedor, TelefonoProveedor);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proveedor_equipamiento` ()   BEGIN
	SELECT proveedor.Nombre,proveedor.CorreoElectronico,equipamiento.Tipo,equipamiento.Descripcion FROM proveedor INNER JOIN equipamiento ON proveedor.IDProveedor=equipamiento.IDProveedor;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proveedor_ingrediente` ()   BEGIN
	SELECT proveedor.Nombre,proveedor.CorreoElectronico,ingrediente.Nombre,ingrediente.Cantidad FROM proveedor INNER JOIN ingrediente ON proveedor.IDProveedor= ingrediente.IDIngrediente;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `resumen_distribucion_ambientes` ()   BEGIN
	SELECT tl.IDLocal,tl.Direccion,am.Nombre,mesab.IDMesaBillar,mesacom.IdMesaComida FROM tlocal AS tl INNER JOIN ambiente AS am INNER JOIN mesabillar AS mesab INNER JOIN mesacomida AS mesacom ON tl.IDLocal=am.IDLocal AND am.IDAmbiente=mesab.IDAmbiente AND am.IDAmbiente=mesacom.IDAmbiente GROUP BY tl.Direccion,am.Nombre;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SetNullIDCliente` (IN `in_IDCliente` INT)   BEGIN
    UPDATE casillero
    SET casillero.IDCliente = NULL
    WHERE casillero.IDCliente = in_IDCliente;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_cliente` (IN `cliente_id` INT, IN `Nombre` VARCHAR(30), IN `Apellido` VARCHAR(50), IN `Tipo` VARCHAR(10), IN `IDMesaBillar` INT, IN `IDPagoCOM` INT, IN `IDMesaComida` INT)   BEGIN
    UPDATE cliente c
    SET 
        c.Nombre = Nombre,
        c.Apellidos = Apellido,
        c.Tipo = Tipo,
        c.IDMesaBillar= IDMesaBillar,
        c.IDPagoCOM = IDPagoCOM,
        c.IDMesaComida = IDMesaComida
    WHERE c.IDCliente = cliente_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_empleado_by_id` (IN `dni` INTEGER, IN `telefono` INTEGER, IN `nombre` VARCHAR(30), IN `apellido` VARCHAR(50), IN `correo` VARCHAR(50), IN `cargo` VARCHAR(30), IN `id_local` INT)   BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_PagarMontoTotal` (IN `cliente_id` INT, IN `metodo_pago` VARCHAR(15))   BEGIN
	UPDATE pago p 
    INNER JOIN checkoutmesa com ON com.IDPagoCOM = p.IDPagoCOM
    INNER JOIN cliente c ON c.IDPagoCOM = com.IDPagoCOM
    SET p.Metodo = metodo_pago
    WHERE c.IDCliente = cliente_id;
    
    UPDATE pedidoconsumible pc
    SET pc.IDCliente = NULL
    WHERE pc.IDCliente = cliente_id;

	UPDATE mesabillar mb
    INNER JOIN checkoutmesa com ON com.IDPagoCOM = mb.IDPagoCOM
    INNER JOIN cliente c ON c.IDPagoCOM = com.IDPagoCOM
    SET mb.IDPagoCOM = NULL,
        mb.Estado = 'Disponible'
    WHERE c.IDCliente = cliente_id;
    
    UPDATE cliente c
    SET c.IDPagoCOM = NULL, c.IDMesaBillar = NULL, c.IDMesaComida = NULL
    WHERE c.IDCliente = cliente_id;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_Stock` (IN `id` INT)   BEGIN
	UPDATE consumible SET consumible.Stock=consumible.Stock - 1 WHERE consumible.IDConsumible=id;
END$$

--
-- Functions
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

CREATE DEFINER=`root`@`localhost` FUNCTION `get_ambiente_name_by_id` (`id` INT) RETURNS VARCHAR(30) CHARSET utf8mb4 COLLATE utf8mb4_general_ci DETERMINISTIC BEGIN
    DECLARE nombre VARCHAR(30);
    
    SELECT ambiente.Nombre INTO nombre
    FROM ambiente
    WHERE ambiente.IDAmbiente = id;

    RETURN nombre;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `get_last_checkoutmesa_id` () RETURNS INT(11) DETERMINISTIC BEGIN
    DECLARE last_id INT;
    
    SELECT IDPagoCOM INTO last_id
    FROM checkoutmesa
    ORDER BY IDPagoCOM DESC
    LIMIT 1;

    RETURN last_id;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `IDpagocom_get` (`IDclient` INT) RETURNS INT(11) DETERMINISTIC BEGIN
	DECLARE idpagocom INT;
    SELECT cliente.IDPagoCOM INTO idpagocom 
    FROM cliente 
    WHERE cliente.IDCliente = IDclient;
    RETURN idpagocom;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `obtener_ultimo_proveedor` () RETURNS INT(11) DETERMINISTIC BEGIN
    DECLARE ultimo_id INT;
    
    SELECT IDProveedor INTO ultimo_id
    FROM proveedor
    ORDER BY IDProveedor DESC
    LIMIT 1;

    RETURN ultimo_id;
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
(1, 7.00, '18:00:00', '15:45:00', 1),
(2, 7.00, '19:00:00', '16:00:00', 1),
(3, 6.00, '10:30:00', '08:00:00', 1),
(4, 8.00, '13:15:00', '11:30:00', 1),
(5, 0.00, '13:00:00', '10:00:00', 1),
(6, 7.00, '10:00:00', '08:00:00', 1),
(7, 7.00, '10:00:00', '08:00:00', 1),
(8, 7.00, '08:00:00', '07:00:00', 1),
(9, 7.00, '09:00:00', '08:00:00', 1),
(10, 7.00, '09:00:00', '08:00:00', 1),
(11, 7.00, '09:00:00', '08:00:00', 1),
(12, 7.00, '09:00:00', '08:00:00', 1),
(13, 7.00, '10:30:00', '09:00:00', 1),
(14, 7.00, '10:00:00', '08:00:00', 1),
(15, 7.00, '10:00:00', '08:00:00', 1),
(16, 7.00, '08:00:00', '09:00:00', 1),
(17, 7.00, '08:00:00', '08:00:00', 1),
(18, 7.00, '00:00:00', '00:00:00', 1),
(19, 7.00, NULL, NULL, 1),
(20, 7.00, '13:00:00', '14:00:00', 1),
(21, 7.00, '13:00:00', '15:00:00', 1),
(22, 7.00, '08:00:00', '10:00:00', 1),
(23, 7.00, '04:00:00', '05:00:00', 1),
(24, 7.00, '10:00:00', '08:00:00', 1),
(25, 7.00, '09:00:00', '08:00:00', 1),
(26, 7.00, '15:30:00', '14:00:00', 1);

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
(1, 'Juan', 'Perez', 'Regular', NULL, NULL, NULL),
(2, 'Maria', 'Lopez', 'Regular', 2, 13, NULL),
(3, 'Carlos', 'Garcia', 'Regular', NULL, NULL, NULL),
(4, 'Ana', 'Martinez', 'Regular', NULL, NULL, NULL),
(5, 'Luis', 'Gonzalez', 'Regular', NULL, NULL, NULL),
(6, 'Sofia', 'Rodriguez', 'Casillero', NULL, NULL, NULL),
(7, 'David', 'Hernandez', 'Casillero', NULL, NULL, NULL),
(8, 'Eva', 'Jimenez', 'Regular', NULL, NULL, NULL),
(9, 'Jorge', 'Perez', 'Regular', NULL, NULL, NULL),
(10, 'Patricia', 'Sanchez', 'Casillero', NULL, NULL, NULL),
(11, 'Werito', 'Malawero', 'Regular', NULL, NULL, NULL),
(12, 'www', 'wwww', 'Casillero', NULL, NULL, NULL),
(13, 'aaa', 'bbb', 'Regular', NULL, NULL, NULL);

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
(1, 15.00, 'Hamburguesa de Carne', 'Hamburguesa de Carne', 93),
(2, 12.00, 'Hamburguesa de Pollo', 'Hamburguesa de Pollo', 140),
(3, 10.00, 'Salchipapa', 'Salchipapa', 190),
(4, 8.00, 'Papa Rellena', 'Papa Rellena', 114),
(5, 7.00, 'Jugo de Platano', 'Jugo de Platano', 176),
(6, 7.00, 'Jugo de Papaya', 'Jugo de Papaya', 156),
(7, 12.00, 'Leche Asada', 'Leche Asada', 127),
(8, 5.00, 'Papas fritas', 'Papas fritas', 78),
(9, 9.00, 'Ensalada de Papa', 'Ensalada de Papa', 146),
(10, 11.00, 'Tacos', 'Tacos', 97);

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
(11111111, '987654321', 'pedrito', 'picapiedra', 'pp@wei.com', 'Casillero', 1),
(12345678, '987654321', 'Juan', 'Pérez', 'juan.perez@email.com', 'Administrador', 1),
(22222222, '123456789', 'manin', 'manin', 'manin@wei.com', 'Casillero', 3),
(23456789, '956789123', 'Carlos', 'Ramírez', 'carlos.ramirez@email.com', 'Atencion', 1),
(33333333, '489156489', 'werin', 'butwei', 'bw@wei.net', 'Casillero', 1),
(34567890, '934567890', 'Ana', 'Torres', 'ana.torres@email.com', 'Atencion', 1),
(87654321, '912345678', 'María', 'Gómez', 'maria.gomez@email.com', 'Atencion', 1),
(89123212, '983212491', 'José', 'Muchica', 'pepe@gmail.com', 'Regular', 2),
(89123214, '98931239', 'Jose Antonio', 'Muchica', 'jose@gmail.com', 'Regular', 2);

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
(1, '2024-11-10', 'Revisión de racks'),
(2, '2024-11-10', 'Limpieza de bolas'),
(3, '2024-11-10', 'Cambio de puntas de tacos'),
(4, '2024-11-10', 'Reparación de mesa de billar'),
(5, '2024-11-10', 'Reparación de mesa de billar');

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
(2, 'Normal', 'En uso', NULL, 13, 1),
(3, 'Normal', 'Mantenimiento', 4, NULL, 1),
(4, 'Snooker', 'Disponible', NULL, NULL, 1),
(5, 'Normal', 'Disponible', NULL, NULL, 2),
(6, 'Normal', 'Disponible', NULL, NULL, 2),
(7, 'Normal', 'Disponible', NULL, NULL, 2),
(8, 'Carambola', 'Disponible', NULL, NULL, 2),
(9, 'Normal', 'Mantenimiento', 5, NULL, 3),
(10, 'Normal', 'Disponible', NULL, NULL, 3),
(11, 'Normal', 'Disponible', NULL, NULL, 3),
(12, 'Snooker', 'Disponible', NULL, NULL, 3),
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
(72, 'Carambola', 'Disponible', NULL, NULL, 18),
(73, 'Snooker', 'Disponible', NULL, NULL, 3),
(74, 'Snooker', 'Disponible', NULL, NULL, 2),
(75, 'Snooker', 'Disponible', NULL, NULL, 2);

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
(36, 4, 2, 18),
(37, 8, 2, 2),
(38, 4, 4, 3);

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
(1, 'Efectivo', 1, 1),
(2, 'Efectivo', 2, 2),
(3, 'Tarjeta', 3, 3),
(4, 'Tarjeta', 4, 4),
(5, 'Efectivo', NULL, 5),
(6, 'Efectivo', NULL, 6),
(7, 'Efectivo', NULL, 7),
(8, 'Tarjeta', NULL, 8),
(9, 'Efectivo', NULL, 9),
(10, 'Efectivo', NULL, 10),
(11, 'Efectivo', NULL, 11),
(12, 'Tarjeta', NULL, 12),
(13, NULL, 5, NULL),
(14, NULL, 6, NULL),
(15, NULL, 7, NULL),
(16, NULL, 8, NULL),
(17, NULL, 9, NULL),
(18, NULL, 10, NULL),
(19, NULL, 11, NULL),
(20, NULL, 12, NULL),
(21, NULL, 13, NULL),
(22, 'Tarjeta', 3, 20),
(23, 'Tarjeta', 3, 21),
(24, 'Tarjeta', 3, 22),
(25, 'Tarjeta', 3, 23),
(26, NULL, NULL, 14),
(27, NULL, NULL, 15),
(28, NULL, NULL, 16),
(29, NULL, NULL, 17),
(30, NULL, NULL, 18),
(31, NULL, NULL, 19),
(32, NULL, NULL, 20),
(33, 'Efectivo', 20, 24),
(34, NULL, NULL, 21),
(35, NULL, NULL, 22),
(36, NULL, NULL, 23),
(37, 'Efectivo', 23, 25),
(38, NULL, NULL, 24),
(39, 'Efectivo', 24, 26),
(40, 'Efectivo', 25, NULL),
(42, 'Efectivo', 25, 28),
(43, 'Tarjeta', 26, NULL),
(44, 'Tarjeta', 26, 29);

-- --------------------------------------------------------

--
-- Table structure for table `pedidoconsumible`
--

CREATE TABLE `pedidoconsumible` (
  `IDPedidoConsumible` int(11) NOT NULL,
  `IDCliente` int(11) DEFAULT NULL,
  `IDLocal` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pedidoconsumible`
--

INSERT INTO `pedidoconsumible` (`IDPedidoConsumible`, `IDCliente`, `IDLocal`) VALUES
(1, NULL, 1),
(2, NULL, 1),
(3, NULL, 1),
(4, NULL, 1),
(5, NULL, 1),
(6, NULL, 1),
(7, NULL, 1),
(8, NULL, 1),
(9, NULL, 1),
(10, NULL, 1),
(11, NULL, 1),
(12, NULL, 1),
(13, 4, NULL),
(14, 4, NULL),
(15, 4, NULL),
(16, NULL, NULL),
(17, NULL, NULL),
(18, NULL, NULL),
(19, NULL, NULL),
(20, NULL, NULL),
(21, NULL, NULL),
(22, NULL, NULL),
(23, NULL, NULL),
(24, NULL, NULL),
(25, NULL, NULL),
(26, NULL, NULL),
(27, NULL, NULL),
(28, NULL, NULL),
(29, NULL, NULL);

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
(1, 11),
(1, 17),
(1, 18),
(1, 23),
(2, 1),
(2, 17),
(2, 18),
(2, 20),
(2, 23),
(2, 28),
(3, 4),
(3, 6),
(3, 7),
(3, 12),
(3, 15),
(3, 20),
(3, 22),
(3, 28),
(4, 3),
(4, 8),
(4, 15),
(4, 20),
(4, 22),
(4, 26),
(4, 29),
(5, 26),
(5, 29),
(6, 24),
(6, 26),
(7, 14),
(7, 24),
(7, 25),
(8, 5),
(8, 14),
(8, 25),
(9, 9),
(9, 13),
(9, 16),
(9, 21),
(9, 29),
(10, 21);

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
(1, 'Proveedor 1', 'proveedor1@email.com', 'Equipamiento', '123456789'),
(2, 'Proveedor 2', 'proveedor2@email.com', 'Equipamiento', '987654321'),
(3, 'Proveedor 3', 'proveedor3@email.com', 'Equipamiento', '555666777'),
(4, 'Proveedor 4', 'proveedor4@email.com', 'Ingrediente', '123123123'),
(5, 'Proveedor 5', 'proveedor5@email.com', 'Ingrediente', '456456456'),
(6, 'Proveedor 6', 'proveedor6@email.com', 'Ingrediente', '789789789'),
(7, 'Jose', 'jose@gmail.com', 'Ingrediente', '123321123');

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
(1, 'Calle 1, Local 1', '08:00:00', '22:00:00'),
(2, 'Calle 2, Local 2', '09:00:00', '23:00:00'),
(3, 'Calle 3, Local 3', '10:00:00', '22:30:00'),
(4, 'Calle 4, Local 4', '08:00:00', '20:00:00'),
(5, 'Calle 5, Local 5', '09:00:00', '21:00:00'),
(6, 'Calle 6, Local 6', '07:00:00', '22:00:00');

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
  MODIFY `IDAmbiente` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `casillero`
--
ALTER TABLE `casillero`
  MODIFY `IDCasillero` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `checkoutmesa`
--
ALTER TABLE `checkoutmesa`
  MODIFY `IDPagoCOM` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `cliente`
--
ALTER TABLE `cliente`
  MODIFY `IDCliente` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `consumible`
--
ALTER TABLE `consumible`
  MODIFY `IDConsumible` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `equipamiento`
--
ALTER TABLE `equipamiento`
  MODIFY `IDEquipamiento` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=49;

--
-- AUTO_INCREMENT for table `ingrediente`
--
ALTER TABLE `ingrediente`
  MODIFY `IDIngrediente` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `mantenimiento`
--
ALTER TABLE `mantenimiento`
  MODIFY `IDMantenimiento` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `mesabillar`
--
ALTER TABLE `mesabillar`
  MODIFY `IDMesaBillar` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=76;

--
-- AUTO_INCREMENT for table `mesacomida`
--
ALTER TABLE `mesacomida`
  MODIFY `IdMesaComida` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;

--
-- AUTO_INCREMENT for table `pago`
--
ALTER TABLE `pago`
  MODIFY `IDPago` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=45;

--
-- AUTO_INCREMENT for table `pedidoconsumible`
--
ALTER TABLE `pedidoconsumible`
  MODIFY `IDPedidoConsumible` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT for table `proveedor`
--
ALTER TABLE `proveedor`
  MODIFY `IDProveedor` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

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
