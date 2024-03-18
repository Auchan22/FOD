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
	reset(arch_m);
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

procedure cargarDetalles(var arr: arr_sucursales);
	procedure leerPedido(var p: pedido);
	begin
		writeln('-----');
		write('Ingrese codigo de producto: ');
		readln(p.codigo);
		if(p.codigo <> -1) then begin
			write('Ingrese cantidad vendida: ');
			readln(p.cant);
		end;
		writeln('-----');
	end;
var
	p: pedido;
	i: integer;
	aux: string;
begin
	for i:= 1 to n do begin
		Str(i, aux);
		Assign(arr[i], 'detalle'+aux);
		rewrite(arr[i]);
		writeln('-> Cargando detalle: detalle'+aux);
		leerPedido(p);
		while(p.codigo <> -1) do begin
			write(arr[i], p);
			leerPedido(p);
		end;
		close(arr[i]);
	end;
	
end;

procedure imprimirMaestro(var arch_m: maestro);
	procedure imprimirProducto(p: producto);
	begin
		writeln('-----');
		writeln('-> Codigo: ', p.codigo);
		writeln('-> Nombre: ', p.nombre);
		writeln('-> Descripcion: ', p.descripcion);
		writeln('-> Precio: ', p.precio:0:2);
		writeln('-> Stock Actual: ', p.stockActual);
		writeln('-> Stock Minimo: ', p.stockMin);
		writeln('-----');
	end;
var
	p: producto;
begin
	reset(arch_m);
		while(not eof(arch_m)) do begin
			read(arch_m, p);
			imprimirProducto(p);
		end;
	close(arch_m);
end;

procedure imprimirDetalles(var arr: arr_sucursales);
	procedure imprimirPedido(p: pedido);
	begin
		writeln('-----');
		writeln('-> Codigo: ', p.codigo);
		writeln('-> Cantidad Venidad: ', p.cant);
		writeln('-----');
	end;
var
	p: pedido;
	i: integer;
	aux: string;
begin
	for i:= 1 to n do begin
		writeln('');
		str(i, aux);
		writeln('Imprimiendo datos de: detalle'+aux);
		Assign(arr[i], 'detalle'+aux);
		reset(arr[i]);
		while(not eof(arr[i])) do begin
			read(arr[i], p);
			imprimirPedido(p);
		end;
		close(arr[i]);
	end;
end;

procedure minimo(var arr: arr_sucursales; var min: pedido);
var
	i, iMin: integer;
	aux: pedido;
begin
	iMin:= 0;
	min.codigo:= valoralto;
	for i:= 1 to n do begin
		leer(arr[i], aux);
		if(aux.codigo <> valoralto) then
			if(aux.codigo < min.codigo) then begin
				min:= aux;
				iMin:= i;
			end;
	end;
	if(iMin <> 0) then begin
		leer(arr[iMin], min);
	end;
end;

procedure actualizar(var arch_m: maestro; var arr: arr_sucursales);
var
	i: integer;
	auxI: string;
	p: producto;
	min: pedido;
	cantVendida: integer;
	codActual: integer;
begin
	reset(arch_m);
	for i:= 1 to n do begin
		Str(i, auxI);
		Assign(arr[i], 'detalle'+auxI);
		reset(arr[i]);
	end;
	minimo(arr, min);
	while(min.codigo <> valoralto) do begin
		codActual:= min.codigo;
		cantVendida:= 0;
		writeln(min.cant,' ',min.codigo);
		while(min.codigo = codActual) do begin
			cantVendida:= cantVendida + min.cant;
			minimo(arr, min);
			writeln(min.cant,' ',min.codigo);
		end;
		read(arch_m, p);
		while(p.codigo <> codActual) do
			read(arch_m, p);
		seek(arch_m, filepos(arch_m)-1);
		p.stockActual:= p.stockActual - cantVendida;
		write(arch_m, p);
	end;
	for i:=1 to n do
		close (arr[i]);
	close(arch_m);
end;

procedure ShowMenu(var arch_m: maestro);
var
	opc: char;
	arr: arr_sucursales;
begin
	writeln('------');
	writeln('');
	writeln('[a] Crear archivo maestro');
	writeln('[b] Crear archivos detalles');
	writeln('[c] Listar maestro');
	writeln('[d] Listar detalles');
	writeln('[e] Actualizar maestro');
	writeln('[f] Generar archivo de texto');
	writeln('');
	readln(opc);
	writeln('OPCION ELEGIDA -->  ', opc);
	writeln('------');
	
	case opc of
		'a':
		begin
			cargarMaestro(arch_m);
		end;
		'b':
		begin
			cargarDetalles(arr);
		end;
		'c':
		begin
			imprimirMaestro(arch_m);
		end;
		'd':
		begin
			imprimirDetalles(arr);
		end;
		'e': 
		begin
			actualizar(arch_m, arr);
		end;
		'f':
		begin
		end;
		else writeln('No se encuentra la opción...');
	end;
end;
var
	arch_m: maestro;
	loop: boolean;
	letra: char;
BEGIN
	Assign(arch_m, 'maestro.dat');
	loop:= true;
	ShowMenu(arch_m);
	while (loop) do begin
		write ('SI INGRESA CUALQUIER CARACTER SE DESPLEGARA NUEVAMENTE EL MENU. SI INGRESA "Z" SE CERRARA LA CONSOLA: '); readln (letra);
		if (letra = 'Z') or (letra = 'z') then
			loop:= false
		else begin
			clrscr;
			ShowMenu(arch_m);
		end;
	end;
END.

