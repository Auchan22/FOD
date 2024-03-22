{
9. A partir de información sobre la alfabetización en la Argentina, se necesita actualizar un
archivo que contiene los siguientes datos: nombre de provincia, cantidad de personas
alfabetizadas y total de encuestados. Se reciben dos archivos detalle provenientes de dos
agencias de censo diferentes, dichos archivos contienen: nombre de la provincia, código de
localidad, cantidad de alfabetizados y cantidad de encuestados. Se pide realizar los módulos
necesarios para actualizar el archivo maestro a partir de los dos archivos detalle.
NOTA: Los archivos están ordenados por nombre de provincia y en los archivos detalle
pueden venir 0, 1 ó más registros por cada provincia.
}

program ej9_p2;
uses crt;
const
	valoralto = 'ZZZ';
	n = 2;
type
	TString = string[20];
	registro = record
		nombre: TString;
		cantAlf: integer;
		total: integer;
	end;
	
	registro_d = record
		nombre: TString;
		codLoc: integer;
		cantAlf: integer;
		total: integer;
	end;
	
	maestro = file of registro;
	detalle = file of registro_d;
	
	arr_reg = array[1..n] of registro_d;
	arr_det = array[1..n] of detalle;
	
procedure cargarMaestro(var arch: maestro);
	procedure leerRegistro(var r: registro);
	begin
		writeln('-----');
		write('Ingrese nombre de provincia: ');
		readln(r.nombre);
		if(r.nombre <> valoralto) then begin
			write('Ingrese cantidad de alfabetizados: ');
			readln(r.cantAlf);
			write('Ingrese cantidad de entrevistados: ');
			readln(r.total);
		end;
		writeln('-----');
	end;
var
	r: registro;
begin
	writeln('-- Iniciando carga --');
	rewrite(arch);
	leerRegistro(r);
	while(r.nombre <> valoralto) do begin
		write(arch, r);
		leerRegistro(r);
	end;
	close(arch);
	writeln('-----');
end;

procedure imprimirMaestro(var arch: maestro);
	procedure imprimirRegistro(r: registro);
	begin
		writeln('-----');
		writeln('-> Provincia: ', r.nombre);
		writeln('-> Cant Alfabetizados: ', r.cantAlf);
		writeln('-> Total entrevistados: ', r.total);
		writeln('-----');
	end;
var
	r: registro;
begin
	writeln('-- Imprimiendo maestro --');
	reset(arch);
	while(not eof(arch)) do begin
		read(arch, r);
		imprimirRegistro(r);
	end;
	close(arch);
	writeln('----');
end;

procedure asignarDetalles(var arr: arr_det);
var
	i: integer;
	aux: string;
begin
	for i:= 1 to n do begin
		Str(i, aux);
		Assign(arr[i], 'detalle'+aux);
	end;
end;

procedure cargarDetalles(var arr: arr_det);
	procedure leerDetalle(var r: registro_d);
	begin
		writeln('-----');
		write('Ingrese nombre de provincia: ');
		readln(r.nombre);
		if(r.nombre <> valoralto) then begin
			write('Ingrese codigo de localidad: ');
			readln(r.codLoc);
			write('Ingrese cantidad de alfabetizados: ');
			readln(r.cantAlf);
			write('Ingrese cantidad de entrevistados: ');
			readln(r.total);
		end;
		writeln('-----');
	end;
var
	i: integer;
	r: registro_d;
begin
	writeln('-----');
	for i:= 1 to n do begin
		writeln('-- Cargando archivo detalle: ', i);
		rewrite(arr[i]);
		leerDetalle(r);
		while(r.nombre <> valoralto) do begin
			write(arr[i], r);
			leerDetalle(r);
		end;
		close(arr[i]);
		writeln('---');
	end;
	writeln('-----');
end;

procedure imprimirDetalles(var arr: arr_det);
	procedure imprimirRegistro(r: registro_d);
	begin
		writeln('-----');
		writeln('-> Provincia: ', r.nombre);
		writeln('-> Cod Loc: ', r.codLoc);
		writeln('-> Cant Alfabetizados: ', r.cantAlf);
		writeln('-> Total entrevistados: ', r.total);
		writeln('-----');
	end;
var
	i: integer;
	r: registro_d;
begin
	for i:= 1 to n do begin
		writeln('-- Imprimiendo detalle: ', i, ' --');
		reset(arr[i]);
		while(not eof(arr[i])) do begin
			read(arr[i], r);
			imprimirRegistro(r);
		end;
		close(arr[i]);
		writeln('----');
	end;
end;

procedure leer(var arch_d: detalle; var dato: registro_d);
begin
	if(not eof(arch_d)) then
		read(arch_d, dato)
	else
		dato.nombre:= valoralto;
end;

procedure minimo(var arr_r: arr_reg; var arr_d: arr_det; var min: registro_d);
var
	i, iMin: integer;
begin
	iMin:= 0;
	min.nombre := valoralto;
	
	for i:= 1 to n do begin
		if(arr_r[i].nombre <> valoralto) then begin
			if(arr_r[i].nombre < min.nombre) then begin
				min:= arr_r[i];
				iMin:= i;
			end;
		end;
	end;
	
	if(iMin <> 0) then begin
		leer(arr_d[iMin], arr_r[iMin]);
	end;
end;

procedure actualizar(var arch: maestro; var arr_d: arr_det);
var
	i: integer;
	min: registro_d;
	provActual: TString;
	totAlf, tot: integer;
	arr_r: arr_reg;
	r: registro;
begin
	reset(arch);
	for i:= 1 to n do begin
		reset(arr_d[i]);
		leer(arr_d[i], arr_r[i]);
	end;
	read(arch, r);
	minimo(arr_r, arr_d, min);
	while(min.nombre <> valoralto) do begin
		provActual:= min.nombre;
		tot:= 0;
		totAlf:= 0;
		while(min.nombre = provActual) do begin
			tot:= tot + min.total;
			totAlf := totAlf + min.cantAlf;
			minimo(arr_r, arr_d, min);
		end;
		while(r.nombre <> provActual) do 
			read(arch, r);
		r.cantAlf:= r.cantAlf + totAlf;
		r.total:= r.total + tot;
		seek(arch, filepos(arch)-1);
		write(arch, r);
		if(not eof(arch)) then
			read(arch, r);
	end;
	for i:= 1 to n do
		close(arr_d[i]);
	close(arch);
end;

var
	arch_m: maestro;
	arr_d: arr_det;
BEGIN
	Assign(arch_m, 'maestro');
	asignarDetalles(arr_d);
	//cargarMaestro(arch_m);
	//imprimirMaestro(arch_m);
	//cargarDetalles(arr_d);
	imprimirDetalles(arr_d);
	actualizar(arch_m, arr_d);
	imprimirMaestro(arch_m);
END.

