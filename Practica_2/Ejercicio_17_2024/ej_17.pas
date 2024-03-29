{
}


program ej_17_2024;
uses crt;
const
	valoralto = 999;
type
	reg = record
		cod_loc: integer;
		nombre_loc: string[20];
		cod_muni: integer;
		nombre_muni: string[20];
		cod_hosp: integer;
		nombre_hosp: string[20];
		fecha: string[20];
		cant_positivos: integer;
	end;
	
	maestro = file of reg;
	
procedure leer(var arch: maestro; var dato: reg);
begin
	if(not eof(arch)) then
		read(arch, dato)
	else
		dato.cod_loc:= valoralto;
end;

procedure imprimir(var arch: maestro);
var
	txt: Text;
	r: reg;
	locActual, muniActual, hospActual: integer;
	totLoc, totMuni, totHosp, totProv: integer;
	nomLoc, nomMuni, nomHosp: string;
begin
	assign(txt, 'reporte.txt');
	rewrite(txt);
	reset(arch);
	leer(arch, r);
	totProv:= 0;
	while(r.cod_loc <> valoralto) do begin
		locActual:= r.cod_loc;
		totLoc:= 0;
		writeln('NOMBRE: ',r.nombre_loc);
		while(r.cod_loc = locActual) do begin
			nomLoc:= r.nombre_loc;
			muniActual:= r.cod_muni;
			totMuni:= 0;
			writeln('  NOMBRE MUNICIPIO: ', r.nombre_muni);
			while(r.cod_loc = locActual) and (r.cod_muni = muniActual) do begin
				nomMuni:= r.nombre_muni;
				hospActual:= r.cod_hosp;
				totHosp:= 0;
				while(r.cod_loc = locActual) and (r.cod_muni = muniActual) and (r.cod_hosp = hospActual) do begin
					nomHosp:= r.nombre_hosp;
					totHosp+= r.cant_positivos;
					leer(arch, r);
				end;
				writeln('    NOMBRE HOSPITAL: ',nomHosp,' .................. CANTIDAD CASOS: ',totHosp);
				totMuni += totHosp;
			end;
			if(totMuni > 1400) then begin
				writeln(txt, totMuni, ' ',nomMuni);
				writeln(txt, nomLoc);
			end;
			totLoc += totMuni;
			writeln('  CANTIDAD DE CASOS MUNICIPIO: ',totMuni);
			writeln('  .....................................');
		end;
		writeln('CANTIDAD DE CASOS LOCALIDAD: ', totLoc);
		totProv += totLoc;
		writeln('____________________________________________');
	end;
	close(txt);
	close(arch);
	writeln('');
	writeln('CANTIDAD DE CASOS TOTALES EN LA PROVINCIA: ',totProv);
end;

procedure cargarMaestro(var arch: maestro);
	procedure leerRegistro(var r: reg);
	begin
		writeln('-----');
		write('Ingrese codigo de localidad: ');
		readln(r.cod_loc);
		if(r.cod_loc <> -1) then begin
			write('Ingrese nombre de localidad: ');
			readln(r.nombre_loc);
			write('Ingrese codigo de municipio: ');
			readln(r.cod_muni);
			write('Ingrese nombre de municipio: ');
			readln(r.nombre_muni);
			write('Ingrese codigo de hospital: ');
			readln(r.cod_hosp);
			write('Ingrese nombre de hospital: ');
			readln(r.nombre_hosp);
			write('Ingrese fecha: ');
			readln(r.fecha);
			write('Ingrese cantidad de positivos: ');
			readln(r.cant_positivos);
		end;
		writeln('-----');
	end;
var
	r: reg;
begin
	writeln('-- Cargar Maestro --');
	rewrite(arch);
	leerRegistro(r);
	while(r.cod_loc <> -1) do begin
		write(arch, r);
		leerRegistro(r);
	end;
	close(arch);
	writeln('-----');
end;

var
	arch: maestro;
BEGIN
	assign(arch, 'maestro');
	//cargarMaestro(arch);
	//clrscr;
	imprimir(arch);
END.

