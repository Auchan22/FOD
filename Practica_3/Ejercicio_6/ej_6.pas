{
6. Una cadena de tiendas de indumentaria posee un archivo maestro no ordenado
con la información correspondiente a las prendas que se encuentran a la venta. De
cada prenda se registra: cod_prenda, descripción, colores, tipo_prenda, stock y
precio_unitario. Ante un eventual cambio de temporada, se deben actualizar las prendas
a la venta. Para ello reciben un archivo conteniendo: cod_prenda de las prendas que
quedarán obsoletas. Deberá implementar un procedimiento que reciba ambos archivos
y realice la baja lógica de las prendas, para ello deberá modificar el stock de la prenda
correspondiente a valor negativo.
Por último, una vez finalizadas las bajas lógicas, deberá efectivizar las mismas
compactando el archivo. Para ello no podrá utilizar ninguna estructura auxiliar, debe
resolverlo dentro del mismo archivo. Solo deben quedar en el archivo las prendas que no
fueron borradas, una vez realizadas todas las bajas físicas.
}


program ej6_p3;
uses crt;
const
	valoralto = 9999;
type
	prenda = record
		cod_prenda: integer;
		descripcion: string[100];
		colores: string[20];
		tipo_prenda: string[20];
		stock: integer;
		precio_unitario: real;
	end;
	
	maestro = file of prenda;
	detalle = file of integer;
	
procedure crearMaestro(var arch: maestro);
	procedure leerPrenda(var p: prenda);
	begin
		writeln('-----');
		write('Ingrese codigo de prenda: ');readln(p.cod_prenda);
		if(p.cod_prenda <> -1) then begin
			write('Ingrese descripcion de prenda: ');readln(p.descripcion);
			write('Ingrese colores de prenda: ');readln(p.colores);
			write('Ingrese tipo de prenda: ');readln(p.tipo_prenda);
			write('Ingrese stock de prenda: ');readln(p.stock);
			write('Ingrese precio de prenda: ');readln(p.precio_unitario);
		end;
		writeln('-----');
	end;
var
	p: prenda;
begin
	rewrite(arch);
	leerPrenda(p);
	while p.cod_prenda <> -1 do begin
		write(arch, p);
		leerPrenda(p);
	end;
	close(arch);
end;

procedure crearDetalle(var arch: detalle);
	procedure leerCodigo(var c: integer);
	begin
		writeln('-----');
		write('Ingrese codigo de prenda: ');readln(c);
		writeln('-----');
	end;
var
	c: integer;
begin
	rewrite(arch);
	leerCodigo(c);
	while c <> -1 do begin
		write(arch, c);
		leerCodigo(c);
	end;
	close(arch);
end;

procedure leerDetalle(var a: detalle; var d: integer);
begin
	if not eof(a) then
		read(a, d)
	else
		d:= valoralto;
end;

procedure leerMaestro(var a: maestro; var d: prenda);
begin
	if not eof(a) then
		read(a, d)
	else
		d.cod_prenda := valoralto;
end;

procedure actualizar(var m: maestro; var d: detalle);
var
	p: prenda;
	c: integer;
begin
	reset(m);
	reset(d);
	leerDetalle(d, c);
	while c <> valoralto do begin
		seek(m, 0);
		leerMaestro(m, p);
		while p.cod_prenda <> valoralto do begin
			if(p.cod_prenda = c) then begin
				p.stock:= -1;
				seek(m, filepos(m)-1);
				write(m, p);
			end;
			leerMaestro(m, p);
		end;
		leerDetalle(d, c);
	end;
	close(m);
	close(d);
end;

procedure compactar(var arch, nuevo: maestro);
var
	p: prenda;
begin
	reset(arch);
	rewrite(nuevo);
	leerMaestro(arch, p);
	while p.cod_prenda <> valoralto do begin
		if(p.stock > 0) then begin
			write(nuevo, p);
		end;
		leerMaestro(arch, p);
	end;
	close(arch);
	close(nuevo);
	erase(arch);
	rename(nuevo, 'maestro');
end;

procedure ImprimirMaestro(var arch: maestro);
	procedure ImprimirPrenda(p: prenda);
	begin
		writeln('-----');
		writeln('-> Codigo: ', p.cod_prenda);
		writeln('-> Descripcion: ', p.descripcion);
		writeln('-> Colores: ', p.colores);
		writeln('-> Tipo prenda: ', p.tipo_prenda);
		writeln('-> Stock: ', p.stock);
		writeln('-> Precio Unitario: ', p.precio_unitario:0:2);
		writeln('-----');
	end;
var
	p: prenda;
begin
	reset(arch);
	while(not eof(arch)) do begin
		read(arch, p);
		ImprimirPrenda(p);
	end;
	close(arch);
end;

procedure ImprimirDetalle(var arch: detalle);
var
	c: integer;
begin
	reset(arch);
	while not eof(arch) do begin
		read(arch,c);
		writeln('-> Codigo: ', c);
	end;
	close(arch);
end;

var
	m, nuevo: maestro;
	d: detalle;
	n: integer;
BEGIN
	assign(m, 'maestro');
	assign(nuevo, 'maestro_nuevo');
	assign(d, 'detalle');
	crearMaestro(m);
	crearDetalle(d);
	clrscr;
	ImprimirMaestro(m);
	readln(n);
	clrscr;
	ImprimirDetalle(d);
	readln(n);
	clrscr;
	actualizar(m, d);
	ImprimirMaestro(m);
	readln(n);
	clrscr;
	compactar(m, nuevo);
	ImprimirMaestro(nuevo);
END.

