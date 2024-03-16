{
Una empresa de electrodomésticos posee un archivo conteniendo información sobre los
productos que tiene a la venta. De cada producto se registra: código de producto,
descripción, precio, stock actual y stock mínimo. Diariamente se efectuan envios a cada uno
de las 4 sucursales que posee. Para esto, cada sucursal envía un archivo con los pedidos
de productos. Cada pedido contiene código de producto y cantidad pedida. Se pide realizar
el proceso de actualización del archivo maestro con los cuatro archivos detalle, obteniendo
un informe de aquellos productos que quedaron debajo del stock mínimo y de aquellos
pedidos que no pudieron satisfacerse totalmente por falta de elementos, informando: la
sucursal, el producto y la cantidad que no pudo ser enviada (diferencia entre lo que pidió y lo
que se tiene en stock) .
NOTA 1: Todos los archivos están ordenados por código de producto y el archivo maestro
debe ser recorrido sólo una vez y en forma simultánea con los detalle.
NOTA 2: En los archivos detalle puede no aparecer algún producto del maestro. Además,
tenga en cuenta que puede aparecer el mismo producto en varios detalles. Sin embargo, en
un mismo detalle cada producto aparece a lo sumo una vez.
}


program ej_3;

uses crt;
var i : byte;

BEGIN
	
	
END.

