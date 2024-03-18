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
const
	valoralto = 9999;
	n=4;
type
	producto = record
		codigo: integer;
		nombre: string[20];
		descripcion: string[50];
		precio: real;
		stockActual: integer;
		stockMin: integer;
	end;
	
	pedido = record
		codigo: integer;
		cant: integer;
	end;
	
	maestro = file of producto;
	detalle =  file of pedido;
	
	arr_sucursales = array[1..n] of detalle;

procedure leer(var arch_d: detalle; var dato: pedido);
begin
	if(not eof(arch_d)) then
		read(arch_d, dato)
	else
		dato.codigo := valoralto;
end;

procedure existeProducto(var arch_m: maestro; cod: integer; var ok: boolean);
var
	p: producto;
	existe: boolean;
begin
	existe:= false;
	while not eof(arch_m) and not existe do begin
		read(arch_m, p);
		if(p.codigo = cod) then
			existe:= true;
	end;
	if(existe) then
		ok:= true
	else
		ok:= false;
end;

procedure cargarMaestro(var arch_m: maestro);
	procedure leerProducto(var p: producto);
	begin
		writeln('-----');
		write('Ingrese codigo de producto: ');
		readln(p.codigo);
		if(p.codigo <> -1) then begin
			write('Ingrese Nombre de producto: ');
			readln(p.nombre);
			write('Ingrese Descripcion de producto: ');
			readln(p.descripcion);
			write('Ingrese precio de producto: ');
			readln(p.precio);
			write('Ingrese stock actual de producto: ');
			readln(p.stockActual);
			write('Ingrese stock min. de producto: ');
			readln(p.stockMin);
		end;
		writeln('-----');
	end;
var
	p: producto;
	posActual: integer;
	ok: boolean;
begin
	rewrite(arch_m);
	leerProducto(p);
	ok:= false;
	while(p.codigo <> -1) do begin
		posActual:= filepos(arch_m);
		existeProducto(arch_m, p.codigo, ok);
		writeln(ok);
		seek(arch_m, posActual);
		if(not ok)then
			write(arch_m, p)
		else begin
			writeln('El codigo de producto ingresado ya se encuentra cargado');
			writeln('Ingrese otro codigo de producto');
		end;
		leerProducto(p);
	end;
	close(arch_m);
end;
var
	arch_m: maestro;
BEGIN
	Assign(arch_m, 'maestro.dat');
	cargarMaestro(arch_m);
END.

