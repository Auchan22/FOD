{}

program ej1_2_p3;

uses crt, sysutils;
const
	n = 5;
	valoralto = 999;
type
	producto = record
		cod: integer;
		nombre: string[20];
		precio: real;
		stockActual: integer;
		stockMinimo: integer;
	end;
	
	venta = record
		cod: integer;
		cantVendida: integer;
	end;
	
	maestro = file of producto;
	detalle = file of venta;
	
	arr_det = array[1..n] of detalle;
	arr_pos = array[1..n] of integer;

procedure cargarMaestro(var a: maestro);
	procedure leerProducto(var p: producto);
	begin
		writeln('-----');
		write('Ingrese codigo de producto: ');readln(p.cod);
		if(p.cod <> -1) then begin
			write('Ingrese Nombre de producto: ');readln(p.nombre);
			write('Ingrese precio de producto: ');readln(p.precio);
			write('Ingrese stockActual de producto: ');readln(p.stockActual);
			write('Ingrese stockMinimo de producto: ');readln(p.stockMinimo);
		end;
		writeln('-----');
	end;
var
	p: producto;
begin
	writeln('-----');
	rewrite(a);
	leerProducto(p);
	while(p.cod <> -1) do begin
		write(a, p);
		leerProducto(p);
	end;
	close(a);
	writeln('-----');
end;

procedure asignarDetalles(var a: arr_det);
var
	i: integer;
	aux: string;
begin
	for i:= 1 to n do begin
		Str(i,aux);
		assign(a[i], 'detalle_'+aux);
	end;
end;

procedure cargarDetalles(var a: arr_det);	
	procedure leerVenta(var v: venta);
	begin
		writeln('-----');
		write('Ingrese cod de producto: '); readln(v.cod);
		if(v.cod <> -1) then begin
			write('Ingrese cant vendida: '); readln(v.cantVendida);
		end;
		writeln('-----');
	end;
var
	v: venta;
	i: integer;
begin
	writeln('-----');
	for i:= 1 to n do begin
		rewrite(a[i]);
		writeln('-- Cargando detalle: ',i,' --');
		leerVenta(v);
		while(v.cod <> -1) do begin
			write(a[i], v);
			leerVenta(v);
		end;
		writeln('-----');
		clrscr;
		close(a[i]);
	end;
	writeln('-----');
end;

procedure imprimirMaestro(var a: maestro);
	procedure imprimirProducto(p: producto);
	begin
		writeln('-----');
		writeln('-> Codigo: ', p.cod);
		writeln('-> Nombre: ', p.nombre);
		writeln('-> Precio: ', p.precio:0:2);
		writeln('-> Stock Actual: ', p.stockActual);
		writeln('-> Stock Minimo: ', p.stockMinimo);
		writeln('-----');
	end;
var
	p: producto;
begin
	reset(a);
	while(not eof(a)) do begin
		read(a, p);
		imprimirProducto(p);
	end;
	close(a);
end;

procedure imprimirDetalles(var a: arr_det);
	procedure imprimirVenta(v: venta);
	begin
		writeln('-----');
		writeln('-> Codigo: ', v.cod);
		writeln('-> Cant Vendida: ', v.cantVendida);
		writeln('-----');
	end;
var
	v: venta;
	i: integer;
begin
	for i:=1 to n do begin
		writeln('Imprimiendo detalle: ',i);
		reset(a[i]);
		while(not eof(a[i])) do begin
			read(a[i], v);
			imprimirVenta(v);
		end;
		close(a[i]);
	end;
end;

procedure leerMaestro(var a: maestro; var d: producto);
begin
	if(not eof(a)) then
		read(a, d)
	else
		d.cod := valoralto;
end;

procedure leerDetalle(var a: detalle; var d: venta);
begin
	if(not eof(a)) then
		read(a, d)
	else
		d.cod := valoralto;
end;

procedure completarArray(var det: arr_det; var pos: arr_pos; c: integer);
var
	i: integer;
	ok: boolean;
	v: venta;
begin
	for i:= 1 to n do begin
		if(pos[i] <> valoralto) then begin // Si es valoralto, indica que ese archivo no tiene registros con ese codigo
			if(pos[i] <> 0) then begin
				seek(det[i], pos[i]+1) //Nos paramos en la ultima pos disponible
			end
			else
				seek(det[i], 0); //Esto en el caso que se pase de cod en maestro, se inicializa
			leerDetalle(det[i], v);
			ok:= false;
			while(v.cod <> valoralto) and (not ok) do begin
				if(v.cod = c) then begin
					ok:= true;
					pos[i] := filepos(det[i])-1;
				end
				else
					leerDetalle(det[i], v);
			end;
			if(not ok) then pos[i]:= valoralto;
		end;
	end;
end;

procedure actualizar(var m: maestro; var a: arr_det);
var
	i: integer;
	p: producto;
	pos: arr_pos;
	cantVendida: integer;
	aux: integer;
	v: venta;
begin
	for i:= 1 to n do begin
		pos[i]:= 0;
		reset(a[i]);
	end;
	reset(m);
	leerMaestro(m, p);
	// TODO: VER LA FORMA DE COMO IMPLEMENTAR LA ACT
	while p.cod <> valoralto do begin
		aux:= 0;
		cantVendida:= 0;
		i:= 1;
		while (i < (n+1)) do begin
			completarArray(a, pos, p.cod);
			if(pos[i] = valoralto) then
				aux += 1
			else begin
				seek(a[i], pos[i]);
				read(a[i], v);
				cantVendida:= cantVendida + v.cantVendida;
			end;
			if(aux <> n) then 
				aux:= 0
			else
				i:= i + 1;
		end;
		p.stockActual -= cantVendida;
		seek(m, filepos(m)-1);
		write(m, p);
		leerMaestro(m, p);
		for i:= 1 to n do
			pos[i] := 0;
	end;
	for i:= 1 to n do 
		close(a[i]);
	close(m);
end;

var
	m: maestro;
	a: arr_det;
BEGIN
	assign(m,'maestro');
	asignarDetalles(a);
	//cargarMaestro(m);
	//cargarDetalles(a);
	//imprimirMaestro(m);
	//imprimirDetalles(a);
	actualizar(m ,a);
	imprimirMaestro(m);
END.

