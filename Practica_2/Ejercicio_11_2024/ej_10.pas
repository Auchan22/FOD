{
10. La empresa de software ‘X’ posee un servidor web donde se encuentra alojado el sitio de la
organización. En dicho servidor, se almacenan en un archivo todos los accesos que se realizan al sitio.
La información que se almacena en el archivo es la siguiente: año, mes, dia, idUsuario y tiempo de acceso
al sitio de la organización. El archivo se encuentra ordenado por los siguientes criterios: año, mes, dia e
idUsuario.
Se debe realizar un procedimiento que genere un informe en pantalla, para ello se indicará el año
calendario sobre el cual debe realizar el informe. El mismo debe respetar el formato mostrado a
continuación:
}

program ej10_p2;
uses crt;
const
	valoralto = 9999;
type
	acceso = record
		anio: integer;
		mes: integer;
		dia: integer;
		idUsuario: integer;
		tiempo: real;
	end;
	
	archivo = file of acceso;
	
procedure cargarArchivo(var arch: archivo);
	procedure leerAcceso(var a: acceso);
	begin
		writeln('-----');
		write('Ingrese anio: ');
		readln(a.anio);
		if(a.anio <> -1) then begin
			write('Ingrese mes: ');
			readln(a.mes);
			write('Ingrese dia: ');
			readln(a.dia);
			write('Ingrese idUsuario: ');
			readln(a.idUsuario);
			write('Ingrese tiempo: ');
			readln(a.tiempo);
		end;
		writeln('-----');
	end;
var
	a: acceso;
begin
	writeln('-- Carga archivo --');
	rewrite(arch);
	leerAcceso(a);
	while a.anio <> -1 do begin
		write(arch, a);
		leerAcceso(a);
	end;
	close(arch);
	writeln('-----');
end;

procedure leer(var arch: archivo; var dato: acceso);
begin
	if(not eof(arch)) then
		read(arch, dato)
	else
		dato.anio := valoralto;
end;

procedure generarInforme(var arch: archivo);
var
	a: acceso;
	existe: boolean;
	anio, pos: integer;
	tot_dia, tot_mes, tot_usr, tot: real;
	anio_actual, mes_actual, dia_actual, usr_actual: integer;
begin
	writeln('-- Generar Informe --');
	writeln('');
	write('-> Ingrese anio a buscar: ');
	readln(anio);
	existe:= false;
	reset(arch);
	leer(arch, a);
	while(a.anio <> valoralto) and (not existe) do begin
		if(a.anio = anio) then begin
			existe:= true;
			pos:= filepos(arch) - 1;
		end
		else
			leer(arch, a);
	end;
	
	if(existe) then begin
		seek(arch, pos);
		leer(arch, a);
		writeln('Anio: ', a.anio);
		anio_actual := a.anio;
		tot:= 0;
		while(a.anio = anio_actual) do begin
			mes_actual:= a.mes;
			tot_mes:= 0;
			while(a.anio = anio_actual) and (a.mes = mes_actual) do begin
				writeln(' Mes: ', mes_actual);
				dia_actual:= a.dia;
				tot_dia:= 0;
				while(a.anio = anio_actual) and (a.mes = mes_actual) and (a.dia = dia_actual) do begin
					writeln('  Dia ', dia_actual);
					usr_actual:= a.idUsuario;
					tot_usr:= 0;
					while(a.anio = anio_actual) and (a.mes = mes_actual) and (a.dia = dia_actual)and (a.idUsuario = usr_actual) do begin
						tot_usr:= tot_usr + a.tiempo;
						leer(arch, a);
					end;
					writeln('   idUsuario: ', usr_actual, ' Tiempo total de acceso en el dia ', dia_actual, ' mes ',mes_actual, ': ', tot_usr:0:2);
					tot_dia:= tot_dia + tot_usr
				end;
				writeln('  Tiempo total acceso dia ', dia_actual, ' mes ', mes_actual, ': ', tot_dia:0:2);
				tot_mes:= tot_mes + tot_dia;
			end;
			writeln(' Total tiempo de acceso mes: ',mes_actual, ': ', tot_mes:0:2);
			tot:= tot + tot_mes;
		end;
		writeln('Total tiempo de acceso anio: ',anio_actual, ': ',tot:0:2);
	end
	else
		writeln('Anio no encontrado :(');
	close(arch);
end;

var
	arch: archivo;
BEGIN
	Assign(arch, 'archivo');
	//cargarArchivo(arch);
	generarInforme(arch);
END.

