{
13. Una compañía aérea dispone de un archivo maestro donde guarda información sobre sus
próximos vuelos. En dicho archivo se tiene almacenado el destino, fecha, hora de salida y la
cantidad de asientos disponibles. La empresa recibe todos los días dos archivos detalles
para actualizar el archivo maestro. En dichos archivos se tiene destino, fecha, hora de salida
y cantidad de asientos comprados. Se sabe que los archivos están ordenados por destino
más fecha y hora de salida, y que en los detalles pueden venir 0, 1 ó más registros por cada
uno del maestro. Se pide realizar los módulos necesarios para:
a. Actualizar el archivo maestro sabiendo que no se registró ninguna venta de pasaje
sin asiento disponible.
b. Generar una lista con aquellos vuelos (destino y fecha y hora de salida) que
tengan menos de una cantidad específica de asientos disponibles. La misma debe
ser ingresada por teclado.
NOTA: El archivo maestro y los archivos detalles sólo pueden recorrerse una vez.
}

program ej_13_2024;
uses crt;
const
	valoralto = 'ZZZ';
type
	
	reg_m = record
		destino: string[50];
		fecha: string;
		hora_salida: real;
		cant_asientos_d: integer;
	end;
	
	reg_d = record
		destino: string[50];
		fecha: string;
		hora_salida: real;
		cant_asientos_c: integer;
	end;
	
	maestro = file of reg_m;
	detalle = file of reg_d;
	
	lista = ^nodo;
	nodo = record
		dato: reg_m;
		sig: lista;
	end;

procedure cargarMaestro(var arch: maestro);
	procedure leerRegistro(var r: reg_m);
	begin
		writeln('-----');
		write('Ingrese destino: ');
		readln(r.destino);
		if(r.destino <> valoralto) then begin
			write('Ingrese fecha: ');
			readln(r.fecha);
			write('Ingrese hora de salida: ');
			readln(r.hora_salida);
			write('Ingrese cantidad de asientos disponibles: ');
			readln(r.cant_asientos_d);
		end;
		writeln('-----');
	end;
var
	r: reg_m;
begin
	writeln('-- Carga Maestro --');
	rewrite(arch);
	leerRegistro(r);
	while(r.destino <> valoralto) do begin
		write(arch, r);
		leerRegistro(r);
	end;
	close(arch);
	writeln('-----');
end;

procedure cargarDetalle(var arch: detalle);
	procedure leerRegistro(var r: reg_d);
	begin
		writeln('-----');
		write('Ingrese destino: ');
		readln(r.destino);
		if(r.destino <> valoralto) then begin
			write('Ingrese fecha: ');
			readln(r.fecha);
			write('Ingrese hora de salida: ');
			readln(r.hora_salida);
			write('Ingrese cantidad de asientos comprados: ');
			readln(r.cant_asientos_c);
		end;
		writeln('-----');
	end;
var
	r: reg_d;
begin
	writeln('-- Carga Detalle --');
	rewrite(arch);
	leerRegistro(r);
	while(r.destino <> valoralto) do begin
		write(arch, r);
		leerRegistro(r);
	end;
	close(arch);
	writeln('-----');
end;

	procedure imprimirRegistro(r: reg_m);
	begin
		writeln('-----');
		writeln('-> Destino: ', r.destino);
		writeln('-> Fecha: ', r.fecha);
		writeln('-> Hora salida: ', r.hora_salida:0:2);
		writeln('-> Cant Asientos Disponibles: ', r.cant_asientos_d);
		writeln('-----');
	end;

procedure imprimirMaestro(var arch: maestro);
var
	r: reg_m;
begin
	reset(arch);
	while(not eof(arch)) do begin
		read(arch, r);
		imprimirRegistro(r);
	end;
	close(arch);
end;

procedure leer(var d: detalle; var dato: reg_d);
begin
	if(not eof(d)) then
		read(d, dato)
	else
		dato.destino := valoralto;
end;

procedure minimo(var r1, r2: reg_d; var d1, d2: detalle; var min: reg_d);
begin
	if (r1.destino < r2.destino) or ((r1.destino = r2.destino) and (r1.fecha < r2.fecha)) or ((r1.destino = r2.destino) and (r1.fecha = r2.fecha) and (r1.hora_salida < r2.hora_salida)) then begin
       min := r1;
       leer(d1,r1);
    end
    else begin
		min:= r2;
		leer(d2, r2);
	end;
end;

procedure actualizar(var m: maestro; var d1, d2: detalle);
var
	rm: reg_m;
	min, r1, r2: reg_d;
	totalAsientos: integer;
	desActual, fechaActual: string;
	horaActual: real;
begin
	reset(m);
	reset(d1);
	reset(d2);
	read(m, rm);
	leer(d1, r1);
	leer(d2, r2);
	minimo(r1, r2, d1, d2, min);
	while (min.destino <> valoralto) do begin
		writeln(min.destino);
		desActual:= min.destino;
		while(min.destino = desActual) do begin
			fechaActual:= min.fecha;
			while (min.destino = desActual) and (min.fecha = fechaActual) do begin
				horaActual:= min.hora_salida;
				totalAsientos:= 0;
				while(min.destino = desActual) and (min.fecha = fechaActual) and (min.hora_salida = horaActual) do begin
					totalAsientos += min.cant_asientos_c;
					minimo(r1, r2, d1, d2, min);
				end;

				while(rm.destino <> desActual) or (rm.fecha <> fechaActual) or (rm.hora_salida <> horaActual) do
					read(m, rm);
					
				//if(rm.cant_asientos_d >= totalAsientos) then begin
					seek(m, filepos(m)-1);
					rm.cant_asientos_d -= totalAsientos;
					write(m, rm);
				{end
				else begin
					writeln('No se puede actualizar el registro: ', rm.destino,' | ',rm.fecha,' | ',rm.hora_salida:0:2,' ya que no cuenta con asientos disponibles');
					writeln('Disponibles: ',rm.cant_asientos_d, ' | Solicitados: ', totalAsientos);
				end;}
			end;
		end;
	end;
	close(m);
	close(d1);
	close(d2);
end;

procedure agregarFinal(var l, ult: lista; r: reg_m);
var
	nue: lista;
begin
	new(nue);
	nue^.sig:= nil;
	nue^.dato:= r;
	if(l = nil) then
		l:= nue
	else
		ult^.sig:= nue;
	ult:= nue;
end;

procedure generarLista(var l: lista; var arch: maestro);
var
	r: reg_m;
	ult: lista;
	n: integer;
begin
	clrscr;
	writeln('-----');
	write('Ingrese nro de asientos disponibles a enlistar: ');
	readln(n);
	reset(arch);
	while(not eof(arch)) do begin
		read(arch, r);
		if(r.cant_asientos_d <= n) then
			agregarFinal(l, ult, r);
	end;
	close(arch);
	writeln('-----');
end;

procedure imprimirLista(l: lista);
begin
	while(l <> nil) do begin
		imprimirRegistro(l^.dato);
		l:= l^.sig;
	end;
end;

var
	m: maestro;
	d1, d2: detalle;
	l: lista;
BEGIN
	l:= nil;
	assign(m, 'maestro');
	assign(d1, 'detalle_1');
	assign(d2, 'detalle_2');
	//cargarMaestro(m);
	//cargarDetalle(d1);
	//cargarDetalle(d2);
	//imprimirMaestro(m);
	//actualizar(m, d1, d2);
	//imprimirMaestro(m);
	generarLista(l, m);
	imprimirLista(l);
END.

