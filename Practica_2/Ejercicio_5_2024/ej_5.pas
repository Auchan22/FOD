{
	Se cuenta con un archivo de productos de una cadena de venta de alimentos congelados.
De cada producto se almacena: código del producto, nombre, descripción, stock disponible,
stock mínimo y precio del producto.
Se recibe diariamente un archivo detalle de cada una de las 30 sucursales de la cadena. Se
debe realizar el procedimiento que recibe los 30 detalles y actualiza el stock del archivo
maestro. La información que se recibe en los detalles es: código de producto y cantidad
vendida. Además, se deberá informar en un archivo de texto: nombre de producto,
descripción, stock disponible y precio de aquellos productos que tengan stock disponible por
debajo del stock mínimo. Pensar alternativas sobre realizar el informe en el mismo
procedimiento de actualización, o realizarlo en un procedimiento separado (analizar
ventajas/desventajas en cada caso).
Nota: todos los archivos se encuentran ordenados por código de productos. En cada detalle
puede venir 0 o N registros de un determinado producto.
}
program ej_5_2024;
uses crt;
const
	n= 30;
	valoralto = 999;
type
	producto = record
		cod: integer;
		nombre: string[20];
		desc: string[50];
		stockMin: integer;
		stockDis: integer;
		precio: real;
	end;
	
	venta = record
		cod: integer;
		cant: integer;
	end;
	
	maestro = file of producto;
	detalle = file of venta;

	arr_det = array[1..n] of detalle;
	arr_ven = array[1..n] of venta;
	
procedure cargarMaestro(var arch: maestro);
	procedure leerProducto(var p: producto);
	begin
		writeln('-----');
		write('Ingrese cod de producto: ');
		readln(p.cod);
		if(p.cod <> -1) then begin
			write('Ingrese nombre de producto: ');
			readln(p.nombre);
			write('Ingrese descripcion de producto: ');
			readln(p.desc);
			write('Ingrese Stock Disponible: ');
			readln(p.stockDis);
			write('Ingrese Stock Minimo: ');
			readln(p.stockMin);
			write('Ingrese precio: ');
			readln(p.precio);
		end;
		writeln('-----');
	end;
var
	p: producto;
begin
	writeln('-- Carga Maestro --');
	rewrite(arch);
	leerProducto(p);
	while p.cod <> -1 do begin
		write(arch, p);
		leerProducto(p);
	end;
	close(arch);
	writeln('-----');
end;

procedure cargarDetalles(var arr: arr_det);
	procedure leerVenta(var v: venta);
	begin
		writeln('-----');
		write('Ingrese cod de producto: ');
		readln(v.cod);
		if(v.cod <> -1) then begin
			write('Ingrese cantidad vendida: ');
			readln(v.cant);
		end;
		writeln('-----');
	end;
var
	i: integer;
	v: venta;
begin
	writeln('-- Carga Detalles --');
	for i:= 1 to n do begin
		rewrite(arr[i]);
		writeln('-> Cargando detalle: ', i);
		leerVenta(v);
		while(v.cod <> -1) do begin
			write(arr[i], v);
			leerVenta(v);
		end;
		writeln('');
		clrscr;
		close(arr[i]);
	end;
	writeln('------');
end;

procedure asignarDetalles(var arr: arr_det);
var
	i: integer;
	aux: string;
begin
	for i:= 1 to n do begin
		str(i, aux);
		assign(arr[i], 'detalle_'+aux);
	end;
end;

procedure leer(var arch: detalle; var dato: venta);
begin
	if(not eof(arch)) then
		read(arch, dato)
	else
		dato.cod := valoralto;
end;

procedure minimo(var reg: arr_ven; var det: arr_det; var min: venta);
var
	i, iMin: integer;
begin
	iMin:= 0;
	min.cod:= valoralto;
	for i:= 1 to n do begin
		if(reg[i].cod <> valoralto) then begin
			if(reg[i].cod < min.cod) then begin
				min:= reg[i];
				iMin:= i;
			end;
		end;
	end;
	
	if(iMin <> 0) then begin
		leer(det[iMin], reg[iMin]);
	end;
end;

procedure actualizar(var arch: maestro; var arr: arr_det);
var
	i: integer;
	min: venta;
	p: producto;
	codActual: integer;
	cantActual: integer;
	reg: arr_ven;
begin
	for i:= 1 to n do begin
		reset(arr[i]);
		leer(arr[i], reg[i]);
	end;
	reset(arch);
	read(arch, p);
	minimo(reg, arr, min);
	while(min.cod <> valoralto) do begin
		codActual:= min.cod;
		cantActual:= 0;
		while(min.cod = codActual) do begin
			cantActual:= cantActual + min.cant;
			minimo(reg, arr, min);
		end;
		while(p.cod <> codActual) do
			read(arch, p);
		seek(arch, filepos(arch)-1);
		p.stockDis:= p.stockDis - cantActual;
		write(arch, p);
		if(not eof(arch)) then
			read(arch, p);
	end;
	for i:= 1 to n do
		close(arr[i]);
	close(arch);
end;

procedure imprimirMaestro(var arch: maestro);
	procedure imprimirProducto(p: producto);
	begin
		writeln('-----');
		writeln('-> Codigo: ', p.cod);
		writeln('-> Nombre: ', p.nombre);
		writeln('-> Descripcion: ', p.desc);
		writeln('-> Stock Disponible: ', p.stockDis);
		writeln('-> Stock Minimo: ', p.stockMin);
		writeln('-> Precio: ', p.precio:0:2);
		writeln('-----');
	end;
var
	p: producto;
begin
	reset(arch);
	while (not eof(arch)) do begin
		read(arch, p);
		imprimirProducto(p);
	end;
	close(arch);
end;

procedure imprimirDetalles(var arr: arr_det);
	procedure imprimirVenta(v: venta);
	begin
		writeln('-----');
		writeln('-> Codigo: ', v.cod);
		writeln('-> Cant Vendida: ', v.cant);
		writeln('-----');
	end;
var
	v: venta;
	i: integer;
begin
	for i:= 1 to n do begin
		writeln('-> Detalle: ',i);
		reset(arr[i]);
		while (not eof(arr[i])) do begin
			read(arr[i], v);
			imprimirVenta(v);
		end;
		close(arr[i]);
	end;
end;

procedure generarInforme(var arch: maestro);
var
	txt: Text;
	p: producto;
begin
	assign(txt, 'stock_menor.txt');
	rewrite(txt);
	reset(arch);
	writeln(txt, '| NOMBRE |    DESCRIPCION    | STOCK DISPONIBLE | PRECIO |');
	while not eof(arch) do begin
		read(arch, p);
		if(p.stockDis < p.stockMin) then
			writeln(txt, '| ',p.nombre:6,' | ',p.desc:17,' | ',p.stockDis:16,' | ',p.precio:6:2, ' |');
	end;
	close(txt);
	close(arch);
end;

var
	arch: maestro;
	arr: arr_det;
BEGIN
	assign(arch, 'maestro');
	asignarDetalles(arr);
	//cargarMaestro(arch);
	//cargarDetalles(arr);
	//imprimirMaestro(arch);
	//imprimirDetalles(arr);
	//actualizar(arch, arr);
	//imprimirMaestro(arch);
	generarInforme(arch);
END.

