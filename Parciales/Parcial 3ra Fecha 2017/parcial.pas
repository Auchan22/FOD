program parcial_2017;
uses crt;
const
	n = 3;
	valoralto = 999;
type
	alumno = record
		dni_alumno: integer;
		codigo_carrera: integer;
		monto_total_pagado: real;
	end;
	pago = record
		dni_alumno: integer;
		codigo_carrera: integer;
		monto_cuota: real;
	end;
	
	maestro = file of alumno;
	detalle = file of pago;
	
	pagos = array[1..n] of pago;
	sucursales = array[1..n] of detalle;
	
procedure asignarDetalles(var a: sucursales);
var
	i: integer;
	aux: string;
begin
	for i:= 1 to n do begin
		str(i, aux);
		assign(a[i],'detalle_'+aux);
	end;
end;

procedure cargarMaestro(var a: maestro);
	procedure leerAlumno(var al: alumno);
	begin
		writeln('-----');
		write('Ingrese dni del alumno: ');readln(al.dni_alumno);
		if(al.dni_alumno <> -1) then begin
			write('Ingrese codigo de carrera: ');readln(al.codigo_carrera);
			write('Ingrese monto pagado: ');readln(al.monto_total_pagado);
		end;
		writeln('-----');
	end;
var
	al: alumno;
begin
	writeln('-- Cargando maestro --');
	rewrite(a);
	leerAlumno(al);
	while(al.dni_alumno <> -1) do begin
		write(a, al);
		leerAlumno(al);
	end;
	close(a);
	writeln('-----');
end;

procedure cargarDetalles(var a: sucursales);
	procedure leerPago(var p: pago);
	begin
		writeln('-----');
		write('Ingrese dni del alumno: ');readln(p.dni_alumno);
		if(p.dni_alumno <> -1) then begin
			write('Ingrese codigo de carrera: ');readln(p.codigo_carrera);
			write('Ingrese monto de la cuota: ');readln(p.monto_cuota);
		end;
		writeln('-----');
	end;

var
	i: integer;
	p: pago;
begin
	for i:= 1 to n do begin
		writeln('-- Cargando detalle: ', i, ' --');
		rewrite(a[i]);
		leerPago(p);
		while(p.dni_alumno <> -1) do begin
			write(a[i], p);
			leerPago(p);
		end;
		close(a[i]);
		writeln('-----');
	end;
end;

procedure leer(var a: detalle; var d: pago);
begin
	if(not eof(a)) then
		read(a, d)
	else
		d.dni_alumno := valoralto;
end;

procedure leerMaestro(var a: maestro; var d: alumno);
begin
	if(not eof(a)) then
		read(a, d)
	else
		d.dni_alumno := valoralto;
end;

procedure minimo(var suc: sucursales; var reg: pagos; var min: pago);
var
	i, iMin: integer;
begin
	iMin:= 0;
	min.dni_alumno:= valoralto;
	min.codigo_carrera:= valoralto;
	for i:= 1 to n do begin
		if(reg[i].dni_alumno < min.dni_alumno) or ((reg[i].dni_alumno = min.dni_alumno) and (reg[i].codigo_carrera < min.codigo_carrera)) then begin
			iMin:= i;
			min:= reg[i];
		end;
	end;
	if(iMin <> 0) then
		leer(suc[iMin], reg[iMin]);
end;

procedure actualizar(var a: maestro; var d: sucursales);
var
	al: alumno;
	min: pago;
	reg: pagos;
	dniActual, carreraActual, i: integer;
	montoTotal: real;
begin
	for i:= 1 to n do begin
		reset(d[i]);
		leer(d[i], reg[i]);
	end;
	reset(a);
	read(a, al);
	minimo(d, reg, min);
	while(min.dni_alumno <> valoralto) do begin
		dniActual:= min.dni_alumno;
		while(min.dni_alumno = dniActual) do begin
			carreraActual:= min.codigo_carrera;
			montoTotal:= 0;
			while(min.dni_alumno = dniActual) and (min.codigo_carrera = carreraActual) do begin
				montoTotal:= montoTotal + min.monto_cuota;
				minimo(d, reg, min);
			end;
		end;
		while(al.dni_alumno <> dniActual) or (al.codigo_carrera <> carreraActual) do
			read(a, al);
		al.monto_total_pagado += montoTotal;
		seek(a, filepos(a)-1);
		write(a, al);
	end;
	for i:= 1 to n do
		close(d[i]);
	close(a);
end;

procedure generarInforme(var a: maestro);
var
	al: alumno;
	txt: Text;
begin
	writeln('-- Generando Informe --');
	assign(txt, 'informe.txt');
	rewrite(txt);
	reset(a);
	leerMaestro(a, al);
	while (al.dni_alumno <> valoralto) do begin
		if(al.monto_total_pagado = 0) then
			writeln(txt, al.dni_alumno,' ',al.codigo_carrera,'  alumno moroso');
		leerMaestro(a, al);
	end;	
	close(txt);
	close(a);
	writeln('-----');
end;

procedure imprimirMaestro(var a: maestro);
	procedure imprimirAlumno(al: alumno);
	begin
		writeln('-----');
		writeln('-> Dni: ', al.dni_alumno);
		writeln('-> Codigo carrera: ', al.codigo_carrera);
		writeln('-> Monto total pagado: ', al.monto_total_pagado:0:0);
		writeln('-----');
	end;
var
	al: alumno;
begin
	reset(a);
	while not eof(a) do begin
		read(a, al);
		imprimirAlumno(al);
	end;
	close(a);
end;

var
	m: maestro;
	d: sucursales;
	i: integer;
BEGIN
	assign(m, 'maestro');
	asignarDetalles(d);
	//cargarMaestro(m);
	//cargarDetalles(d);
	//imprimirMaestro(m);
	//readln(i);
	//clrscr;
	//actualizar(m, d);
	//imprimirMaestro(m);
	//readln(i);
	//clrscr;
	generarInforme(m);
END.

