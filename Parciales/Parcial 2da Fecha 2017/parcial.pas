program parcia2017_b;
uses crt;
const
	valoralto = 'ZZZ';
type
	reg = record
		nombre_sistema_operativo: string[20];
		cantidad_instalaciones: integer;
		es_de_codigo_abierto: byte;
		tipo_licencia: string[4];
	end;
	
	archivo = file of reg;

procedure leerRegistro(var r: reg);
begin
	writeln('-----');
	write('Ingrese nombre s.o: ');readln(r.nombre_sistema_operativo);
	if(r.nombre_sistema_operativo <> 'ZZZ') then begin
		write('Ingrese cant. instalaciones: ');readln(r.cantidad_instalaciones);
		write('Ingrese 1 si es de codigo abierto: ');readln(r.es_de_codigo_abierto);
		write('Ingrese tipo de licencia: ');readln(r.tipo_licencia);
	end;
	writeln('-----');
end;

procedure cargarMaestro(var a: archivo);
var
	r: reg;
begin
	writeln('-- Carga Maestro --');
	rewrite(a);
	r.cantidad_instalaciones:= 0;
	write(a,r);
	leerRegistro(r);
	while(r.nombre_sistema_operativo <> valoralto) do begin
		write(a, r);
		leerRegistro(r);
	end; 
	close(a);
	writeln('-----');
end;

procedure imprimirArchivo(var a: archivo);
	procedure imprimirRegistro(r: reg);
	begin
		writeln('-----');
		writeln('-> Nombre S.O: ', r.nombre_sistema_operativo);
		writeln('-> Cantidad de instalaciones: ', r.cantidad_instalaciones);
		writeln('-> Codigo abierto: ', r.es_de_codigo_abierto);
		writeln('-> Tipo Licencia: ', r.tipo_licencia);
		writeln('-----');
	end;
var
	r: reg;
begin
	writeln('-- Imprimiendo archivo --');
	reset(a);
	while(not eof(a)) do begin
		read(a, r);
		if(r.cantidad_instalaciones > 0) then
			imprimirRegistro(r);
	end;
	close(a);
	writeln('-----');
end;

procedure leer(var a: archivo; var d: reg);
begin
	if not eof(a) then
		read(a, d)
	else
		d.nombre_sistema_operativo:= valoralto;
end;

procedure AltaSistema(var a: archivo; r: reg);
var
	cabecera, act: reg;
	pos: integer;
begin
	writeln('-- Alta Registro --');
	reset(a);
	read(a, cabecera);
	pos:= cabecera.cantidad_instalaciones * -1;
	if(pos = 0) then begin
		seek(a, filesize(a));
		write(a, r);
	end
	else begin
		seek(a, pos);
		read(a, act);
		seek(a, filepos(a)-1);
		write(a, r);
		cabecera := act;
		seek(a, 0);
		write(a, cabecera);
	end;
	writeln('-- Registro agregado --');
	close(a);
	writeln('-----');
end;

procedure BajaSistema(var a: archivo; r: reg);
var
	ok: boolean;
	act, cabecera: reg;
	pos: integer;
begin
	writeln('-- Baja Registro --');
	reset(a);
	ok:= false;
	leer(a, act);
	while (act.nombre_sistema_operativo <> valoralto) and (not ok) do begin
		if(act.nombre_sistema_operativo = r.nombre_sistema_operativo) then
			ok:= true
		else
			leer(a, act);
	end;
	if(ok) then begin
		pos:= filepos(a) - 1;
		seek(a, 0);
		read(a, cabecera);
		seek(a, pos);
		act.cantidad_instalaciones := cabecera.cantidad_instalaciones;
		cabecera.cantidad_instalaciones := pos * -1;
		write(a, act);
		seek(a, 0);
		write(a, cabecera);
		writeln('-- Se dio de baja el registro con nombre: ',r.nombre_sistema_operativo,' --');
	end
	else
		writeln('-- El sistema operativo ingresado no se encuentra cargado --');
	close(a);
	writeln('-----');
end;

var
	a: archivo;
	i: integer;
	r: reg;
BEGIN
	assign(a, 'maestro.dat');
	//cargarMaestro(a);
	//clrscr;
	imprimirArchivo(a);
	readln(i);
	clrscr;
	{leerRegistro(r);
	while r.nombre_sistema_operativo <> valoralto do begin
		BajaSistema(a, r);
		leerRegistro(r);
	end;
	clrscr;
	imprimirArchivo(a);
	readln(i);}
	{leerRegistro(r);
	while r.nombre_sistema_operativo <> valoralto do begin
		AltaSistema(a, r);
		leerRegistro(r);
	end;
	clrscr;}
	//imprimirArchivo(a);
END.

