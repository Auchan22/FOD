program parcial;
uses crt;
type
	producto = record
		cod: integer;
		nombre: string[20];
		descripcion: string[50];
		precioCompra: real;
		precioVenta: real;
		ubicacion: integer;
	end;
	
	archivo = file of producto;
	
function existeProducto(cod: integer; var a: archivo): boolean;
var
	existe: boolean;
	p: producto;
begin
	existe:= false;
	while (not eof(a)) and not existe do begin
		read(a, p);
		if(p.cod = cod) then
			existe:= true;
	end;
	existeProducto:= existe;
end;

procedure informarProducto(p: producto);
begin
	writeln('-----');
	writeln('-> Codigo: ', p.cod);
	writeln('-> Nombre: ', p.nombre);
	writeln('-> Descripcion: ', p.descripcion);
	writeln('-> Precio compra: ', p.precioCompra:2:0);
	writeln('-> Precio Venta: ', p.precioVenta:2:0);
	writeln('-> Ubicacion: ', p.ubicacion);
	writeln('-----');
end;

procedure leerProducto(var p: producto);
begin
	writeln('-----');
	write('Ingrese codigo: ');readln(p.cod);
	if p.cod <> -1 then begin
		write('Ingrese Nombre: '); readln(p.nombre);
		write('Ingrese Descripcion: '); readln(p.descripcion);
		write('Ingrese Precio compra: '); readln(p.precioCompra);
		write('Ingrese Precio Venta: '); readln(p.precioVenta);
		write('Ingrese Ubicacion: '); readln(p.ubicacion);
	end;
	writeln('-----');
end;
	
procedure crearMaestro(var a: archivo);
var
	p: producto;
begin
	writeln('-- Cargando maestro --');
	rewrite(a);
	leerProducto(p);
	while p.cod <> -1 do begin
		if(existeProducto(p.cod, a)) then
			informarProducto(p)
		else
			write(a, p);
		leerProducto(p);
	end;
	close(a);
	writeln('-----');
end;

procedure agregarProducto(var a: archivo);
var
	act, cabecera: producto;
	p: producto;
	pos: integer;
begin
	reset(a);
	writeln('-- Agregar Producto --');
	writeln('');
	leerProducto(p);
	if(existeProducto(p.cod, a)) then
		informarProducto(p)
	else begin
		seek(a, 0);
		read(a, cabecera);
		pos:= cabecera.cod * -1;
		if(pos > 0) then begin
			seek(a, pos);
			read(a, act);
			seek(a, pos);
			write(a, p);
			cabecera:= act;
			seek(a, 0);
			write(a, cabecera);
		end
		else begin
			seek(a, filesize(a));
			write(a, p);
		end;
		writeln('- Se agrego el producto -');
	end;
	close(a);
	writeln('-----');
end;

procedure quitarProducto(var a: archivo);
var
	cod, pos: integer;
	cabecera, act: producto;
begin
	writeln('-- Quitar Producto --');
	writeln('');
	write('-> Ingrese codigo a eliminar: ');readln(cod);
	reset(a);
	read(a, cabecera);
	if(existeProducto(cod, a)) then begin
		pos:= filepos(a)-1;
		seek(a, pos);
		read(a, act);
		act.cod := cabecera.cod;
		cabecera.cod:= pos * -1;
		seek(a, pos);
		write(a, act);
		seek(a, 0);
		write(a, cabecera);
	end
	else
		writeln('- El codigo ingresado no existe -');
	close(a);
	writeln('-----');
end;

procedure imprimirArchivo(var a: archivo);
var
	p: producto;
begin
	writeln('-- Imprimiendo archivo --');
	reset(a);
	while not eof(a) do begin
		read(a, p);
		if(p.cod > 0) then
			informarProducto(p);
	end;
	close(a);
	writeln('-----');
end;

var
	a: archivo;
BEGIN
	assign(a, 'maestro');
	//crearMaestro(a);
	//imprimirArchivo(a);
	//agregarProducto(a);
	imprimirArchivo(a);
	//quitarProducto(a);
	//quitarProducto(a);
	agregarProducto(a);
	agregarProducto(a);
	imprimirArchivo(a);
END.

