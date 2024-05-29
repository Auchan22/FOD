program parcial_2017;
uses crt;
const
	valoralto = 999;
type
	log = record
		usr_num: integer;
		usr_nombre: string[20];
		nombre: string[20];
		apellido: string[20];
		cantMails: integer
	end;
	
	det = record
		usr_num: integer;
		destino: string[20];
		cuerpo: string[50];
	end;
	
	maestro = file of log;
	detalle = file of det;
	
procedure cargarMaestro(var m: maestro);
	procedure leerLog(var l: log);
	begin
		writeln('-----');
		write('Ingrese num usr: ');readln(l.usr_num);
		if(l.usr_num <> -1) then begin
			write('Ingrese nombre usr: ');readln(l.usr_nombre);
			write('Ingrese nombre: ');readln(l.nombre);
			write('Ingrese apellido: ');readln(l.apellido);
			write('Ingrese cantidad de mails enviados: ');readln(l.cantMails);
		end;
		writeln('-----');
	end;
var
	l: log;
begin
	writeln('-- Cargando archivo maestro --');
	rewrite(m);
	leerLog(l);
	while l.usr_num <> -1 do begin
		write(m, l);
		leerLog(l);
	end;
 	close(m);
	writeln('-----');
end;

procedure leer(var a: detalle; var d: det);
begin
	if not eof(a) then
		read(a, d)
	else
		d.usr_num:= valoralto;
end;

procedure actualizar(var m: maestro; var d: detalle);
var
	l: log;
	usrActual, cantActual: integer;
	min: det;
begin
	reset(m);
	reset(d);
	read(m, l);
	leer(d, min);
	while(min.usr_num <> valoralto) do begin
		usrActual:= min.usr_num;
		cantActual:= 0;
		while(min.usr_num = usrActual) do begin
			cantActual:= cantActual + 1;
			leer(d, min);
		end;

		while(usrActual <> l.usr_num) do
			read(m, l);
		seek(m, filepos(m)-1);
		l.cantMails:= l.cantMails + cantActual;
		write(m, l);
		
		if not eof(m) then
			read(m, l);
	end;
	close(m);
	close(d);
end;

procedure generarListado(var m: maestro; var d: detalle);
var
	txt: Text;
	l: log;
	de: det;
	usrActual, cantActual: integer;
begin
	assign(txt, 'listado.txt');
	rewrite(txt);
	reset(m);
	reset(d);
	writeln(txt, '| NRO USUARIO | NOMBRE USUARIO | CANT MENSAJES |');
	while(not eof(m)) do begin
		read(m, l);
		usrActual:= l.usr_num;
		cantActual:= 0;
		leer(d, de);
		while(de.usr_num = usrActual) and (de.usr_num <> valoralto) do begin
			cantActual += 1;
			leer(d, de);
		end;
		writeln(txt, '| ',usrActual:11,' | ',l.usr_nombre:14,' | ',cantActual:13,' |');
		//writeln(usrActual);
	end;
	close(txt);
	close(m);
	close(d);
end;

procedure cargarDetalle(var d: detalle);
	procedure leerDetalle(var de: det);
	begin
		writeln('-----');
		write('Ingrese num usr: ');readln(de.usr_num);
		if(de.usr_num <> -1) then begin
			write('Ingrese destinatario: ');readln(de.destino);
			write('Ingrese cuerpo: ');readln(de.cuerpo);
		end;
		writeln('-----');
	end;
var
	de: det;
begin
	writeln('-- Cargando detalle --');
	rewrite(d);
	leerDetalle(de);
	while de.usr_num <> -1 do begin
		write(d, de);
		leerDetalle(de);
	end;	
	close(d);
	writeln('-----');
end;

procedure imprimirMaestro(var m: maestro);
	procedure imprimirLog(l: log);
	begin
		writeln('-----');
		writeln('-> Usr Num: ', l.usr_num);
		writeln('-> Usr Nombre: ', l.usr_nombre);
		writeln('-> Nombre: ', l.nombre);
		writeln('-> Apellido: ', l.apellido);
		writeln('-> Cant Mails: ', l.cantMails);
		writeln('-----');
	end;
var
	l: log;
begin
	reset(m);
	while(not eof(m)) do begin
		read(m, l);
		imprimirLog(l);
	end;
	close(m);
end;

var
	m: maestro;
	d: detalle;
	i: integer;
BEGIN
	assign(m, 'logsmail.dat');
	assign(d, '6junio2017.dat');
	//cargarMaestro(m);
	//imprimirMaestro(m);
	//readln(i);
	//clrscr;
	//cargarDetalle(d);
	actualizar(m, d);
		imprimirMaestro(m);
	readln(i);
	clrscr;
	generarListado(m, d);
END.

