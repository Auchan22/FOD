{
7. Se necesita contabilizar los votos de las diferentes mesas electorales registradas por
provincia y localidad. Para ello, se posee un archivo con la siguiente información: código de
provincia, código de localidad, número de mesa y cantidad de votos en dicha mesa. Presentar
en pantalla un listado como se muestra a continuación:
Código de Provincia
Código de Localidad Total de Votos
................................ ......................
................................ ......................
Total de Votos Provincia: ____

Código de Provincia
Código de Localidad Total de Votos
................................ ......................
Total de Votos Provincia: ___
....................................................................
Total General de Votos: ___

NOTA: La información se encuentra ordenada por código de provincia y código de localidad.
}
program ej7_p2;
uses crt;
const
	valoralto = 999;
type
	mesa  = record
		prov: integer;
		loc: integer;
		nroMesa: integer;
		cantVotos: integer;
	end;
	archivo = file of mesa;

procedure leer(var arch: archivo; var dato: mesa);
begin
	if(not eof(arch)) then
		read(arch, dato)
	else
		dato.prov:= valoralto;
end;

procedure listado(var arch: archivo);
var
	m: mesa;
	provActual, locActual: integer;
	tot_prov, tot_loc, tot: integer;
begin
	reset(arch);
	leer(arch, m);
	tot:= 0;
	while (m.prov <> valoralto) do begin
		provActual:= m.prov;
		tot_prov := 0;
		writeln('COD PROVINCIA: ',provActual);
		writeln(' COD LOCALIDAD:  |TOTAL VOTOS: ');
		while(m.prov = provActual) do begin
			locActual:= m.loc;
			tot_loc:= 0;
			while(locActual = m.loc) and (provActual = m.prov) do begin
				tot_loc := tot_loc + m.cantVotos;
				leer(arch, m);
			end;
			writeln(' ',locActual, '       ', tot_loc);
			tot_prov := tot_prov + tot_loc;
		end;
		writeln(' TOTAL VOTOS PROVINCIA: ', tot_prov);
		writeln(' ');
		tot:= tot + tot_prov;
	end;
	writeln('...............');
	writeln(' TOTAL GENERAL DE VOTOS: ', tot);
	close(arch);
end;

procedure cargarMaestro(var arch: archivo);
	procedure leerMesa(var m: mesa);
	begin
		writeln('-----');
		write('Ingrese cod de provincia: ');
		readln(m.prov);
		if(m.prov <> -1) then begin
			write('Ingrese cod de localidad: ');
			readln(m.loc);
			write('Ingrese nro de mesa: ');
			readln(m.nroMesa);
			write('Ingrese cant de votos: ');
			readln(m.cantVotos);
		end;
		writeln('-----');
	end;
var
	m: mesa;
begin
	rewrite(arch);
	leerMesa(m);
	while(m.prov <> -1) do begin
		write(arch, m);
		leerMesa(m);
	end;
	close(arch);
end;

procedure imprimirMaestro(var arch: archivo);
	procedure imprimirMesa(m: mesa);
	begin
		writeln('-----');
		writeln('-> Cod Provincia: ', m.prov);
		writeln('-> Cod Localidad: ', m.loc);
		writeln('-> Nro Mesa: ', m.nroMesa);
		writeln('-> Cant Votos: ', m.cantVotos);
		writeln('-----');
	end;
var
	m: mesa;
begin
	reset(arch);
	while(not eof(arch)) do begin
		read(arch, m);
		imprimirMesa(m);
	end;
	close(arch);
end;

var
	arch: archivo;
BEGIN
	Assign(arch, 'maestro_agus');
	//cargarMaestro(arch);
	//imprimirMaestro(arch);
	listado(arch);
END.

