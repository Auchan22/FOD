{
5. El encargado de ventas de un negocio de productos de limpieza desea administrar el stock
de los productos que vende. Para ello, genera un archivo maestro donde figuran todos los
productos que comercializa. De cada producto se maneja la siguiente información: código de
producto, nombre comercial, precio de venta, stock actual y stock mínimo. Diariamente se
genera un archivo detalle donde se registran todas las ventas de productos realizadas. De cada
venta se registra: código de producto y cantidad de unidades vendidas. Se pide realizar un
programa con opciones para:
a. Crear el archivo maestro a partir de un archivo de texto llamado “productos.txt”.
b. Listar el contenido del archivo maestro en un archivo de texto llamado “reporte.txt”,
listando de a un producto por línea.
c. Crear un archivo detalle de ventas a partir de en un archivo de texto llamado
“ventas.txt”.
d. Listar en pantalla el contenido del archivo detalle de ventas.
e. Actualizar el archivo maestro con el archivo detalle, sabiendo que:
● Ambos archivos están ordenados por código de producto.
● Cada registro del maestro puede ser actualizado por 0, 1 ó más registros del
archivo detalle.
● El archivo detalle sólo contiene registros que están en el archivo maestro.
f. Listar en un archivo de texto llamado “stock_minimo.txt” aquellos productos cuyo
stock actual esté por debajo del stock mínimo permitido.
}

program ej5_p2;
uses crt;
const
	valoralto = 9999;
type
	producto = record
		codigo: integer;
		nombre: string[20];
		precio: real;
		stockActual: integer;
		stockMin: integer;
	end;
	
	venta = record
		codigo: integer;
		cant: integer;
	end;
	
	maestro = file of producto;
	detalle = file of venta;
	
procedure crearMaestro(var arch_m: maestro);
var
	txt: Text;
	p: producto;
begin
	Assign(txt, 'productos.txt');
	reset(txt);
	rewrite(arch_m);
	writeln('-- Creando Maestro --');
	while(not eof(txt)) do begin
		readln(txt, p.codigo, p.precio, p.stockActual, p.stockMin, p.nombre);
		writeln('.');
		write(arch_m, p);
	end;
	writeln('-- Fin Creación');
	close(arch_m);
	close(txt);
end;

procedure crearDetalle(var arch_d: detalle);
var
	txt: Text;
	p: venta;
begin
	Assign(txt, 'ventas.txt');
	reset(txt);
	rewrite(arch_d);
	writeln('-- Creando Detalle --');
	while(not eof(txt)) do begin
		readln(txt, p.codigo, p.cant);
		writeln('.');
		write(arch_d, p);
	end;
	writeln('-- Fin Creación');
	close(arch_d);
	close(txt);
end;

procedure listarMaestro(var arch_m: maestro);
var
	txt: Text;
	p: producto;
begin
	Assign(txt, 'reportes.txt');
	rewrite(txt);
	reset(arch_m);
	writeln('-- Generando reporte --');
	while(not eof(arch_m)) do begin
		read(arch_m, p);
		writeln(txt, p.codigo,' ', p.precio:2:2,' ', p.stockActual:2,' ', p.stockMin:2, p.nombre);
		writeln('.');
	end;
	writeln('-- Reporte generado --');
	close(txt);
	close(arch_m);
end;

procedure imprimirDetalle(var arch_d: detalle);
	procedure imprimirVenta(v: venta);	
	begin
		writeln('-----');
		writeln('-> Codigo: ', v.codigo);
		writeln('-> Cant. vendida: ', v.cant);
		writeln('-----');
	end;
var
	v: venta;
begin
	reset(arch_d);
	writeln('-- Imprimiendo detalle --');
	while not eof(arch_d) do begin
		read(arch_d, v);
		imprimirVenta(v);
	end;
	writeln('-----');
	close(arch_d);
end;

procedure leer(var arch_d: detalle; var dato: venta);
begin
	if(not eof(arch_d)) then
		read(arch_d, dato)
	else
		dato.codigo := valoralto;
end;

procedure actualizar(var arch_m: maestro; var arch_d: detalle);
var
	tot_vendido: integer;
	codActual: integer;
	reg_m: producto;
	reg_d: venta;
begin
	reset(arch_m);
	reset(arch_d);
	read(arch_m, reg_m);
	leer(arch_d, reg_d);
	while(reg_d.codigo <> valoralto) do begin
		codActual:= reg_d.codigo;
		tot_vendido:= 0;
		while(reg_d.codigo = codActual) do begin
			tot_vendido := tot_vendido + reg_d.cant;
			leer(arch_d, reg_d);
		end;
		while(reg_m.codigo <> codActual) do 
			read(arch_m, reg_m);
		reg_m.stockActual:=reg_m.stockActual - tot_vendido;
		seek(arch_m, filepos(arch_m)-1);
		write(arch_m, reg_m);
		
		if(not eof(arch_m)) then
			read(arch_m, reg_m);
	end;
	close(arch_m);
	close(arch_d);
end;

procedure generarTxt(var arch_m: maestro);
var
	p: producto;
	txt: Text;
begin
	reset(arch_m);
	Assign(txt, 'stock_minimo.txt');
	rewrite(txt);
	while(not eof(arch_m)) do begin
		read(arch_m, p);
		if(p.stockActual < p.stockMin) then
			writeln(txt, p.codigo, ' ',p.precio:0:2,' ',p.stockActual,' ',p.stockMin,' ',p.nombre);
	end;
	close(arch_m);
	close(txt);
end;

procedure ShowMenu(var arch_m: maestro; var arch_d: detalle);
var
	opc: char;
begin
	writeln('------');
	writeln('');
	writeln('[a] Crear archivo maestro en base a "productos.txt"');
	writeln('[b] Crear archivo detalle en base a "ventas.txt"');
	writeln('[c] Listar maestro en "reporte.txt"');
	writeln('[d] Listar detalle');
	writeln('[e] Actualizar maestro');
	writeln('[f] Generar archivo de texto "stock_minimo.txt"');
	writeln('');
	readln(opc);
	writeln('OPCION ELEGIDA -->  ', opc);
	writeln('------');
	
	case opc of
		'a':
		begin
			crearMaestro(arch_m);
		end;
		'b':
		begin
			crearDetalle(arch_d);
		end;
		'c':
		begin
			listarMaestro(arch_m);
		end;
		'd':
		begin
			imprimirDetalle(arch_d);
		end;
		'e': 
		begin
			actualizar(arch_m, arch_d);
		end;
		'f':
		begin
			generarTxt(arch_m);
		end;
		else writeln('No se encuentra la opción...');
	end;
end;

var
	arch_m: maestro;
	arch_d: detalle;
	loop: boolean;
	letra: char;
BEGIN
	Assign(arch_m, 'productos.dat');
	Assign(arch_d, 'ventas.dat');
	loop:= true;
	ShowMenu(arch_m, arch_d);
	while (loop) do begin
		write ('SI INGRESA CUALQUIER CARACTER SE DESPLEGARA NUEVAMENTE EL MENU. SI INGRESA "Z" SE CERRARA LA CONSOLA: '); readln (letra);
		if (letra = 'Z') or (letra = 'z') then
			loop:= false
		else begin
			clrscr;
			ShowMenu(arch_m, arch_d);
		end;
	end;
END.

