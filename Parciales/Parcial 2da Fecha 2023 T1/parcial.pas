program parcial;
uses crt;
const
	valoralto = 9999;
type
	equipo = record
		cod: integer;
		nombre: string[20];
		anio: integer;
		cod_torneo: integer;
		cod_rival: integer;
		gol_favor: integer;
		gol_contra: integer;
		puntos: integer;
	end;
	
	archivo = file of equipo;
	
procedure cargarArchivo(var a: archivo);
	procedure leerEquipo(var e: equipo);
	begin
		writeln('-----');
		write('Ingrese cod de equipo: '); readln(e.cod);
		if(e.cod <> -1) then begin
			write('Ingrese nombre de equipo: '); readln(e.nombre);
			write('Ingrese anio de equipo: '); readln(e.anio);
			write('Ingrese cod de torneo: '); readln(e.cod_torneo);
			write('Ingrese cod_rival: '); readln(e.cod_rival);
			write('Ingrese cant. gol-favor: '); readln(e.gol_favor);
			write('Ingrese cant. gol-contra: '); readln(e.gol_contra);
			write('Ingrese puntos obtenidos: '); readln(e.puntos);
		end;
		writeln('-----');
	end;
var
	e: equipo;
begin
	writeln('-- Cargando Maestro --');
	rewrite(a);
	leerEquipo(e);
	while e.cod <> -1 do begin
		write(a, e);
		leerEquipo(e);
	end;
	close(a);
	writeln('-----');
end;

procedure leer(var a: archivo; var d: equipo);
begin
	if not eof(a) then
		read(a, d)
	else
		d.anio:= valoralto;
end;

procedure maximo(nA: string; var nM: string; pA: integer; var pM: integer);
begin
	if(pA > pM) then begin
		pM:= pA;
		nM:= nA;
	end;
end;

procedure imprimir(var a: archivo);
var
	e: equipo;
	anioActual, torneoActual, codActual, puntosTotal, g, p, em, fav, con: integer;
	nombreMax, nombreActual: string;
	puntosMax: integer;
begin
	writeln('-- Imprimiendo archivo --');
	reset(a);
	leer(a, e);
	while e.anio <> valoralto do begin
		anioActual:= e.anio;
		writeln('ANIO: ',anioActual);
		while(e.anio = anioActual) do begin
			torneoActual:= e.cod_torneo;
			nombreMax:= 'X';
			puntosMax:= -1;
			writeln(' COD TORNEO: ',torneoActual);
			while(e.anio = anioActual) and (e.cod_torneo = torneoActual) do begin
				codActual:= e.cod;
				nombreActual:= e.nombre;
				writeln('  COD EQUIPO: ',codActual,' NOMBRE: ',nombreActual);
				puntosTotal:= 0;
				g:= 0;
				p:= 0;
				em:= 0;
				fav:= 0;
				con:= 0;
				while (e.anio = anioActual) and (e.cod_torneo = torneoActual) and (e.cod = codActual) do begin
					puntosTotal += e.puntos;
					case e.puntos of
						0: p+=1;
						1: em+=1;
						3: g+=1;
					end;
					fav+=e.gol_favor;
					con+=e.gol_contra;
					leer(a, e);
				end;
				writeln('   TOTAL GOLES FAVOR EQUIPO ',codActual,': ',fav);
				writeln('   TOTAL GOLES CONTRA EQUIPO ',codActual,': ',con);
				writeln('   DIFERENCIA GOLES EQUIPO ',codActual,': ',fav - con);
				writeln('   PARTIDOS GANADOS EQUIPO ',codActual,': ',g);
				writeln('   PARTIDOS PERDIDOS EQUIPO ',codActual,': ',p);
				writeln('   PARTIDOS EMPATADOS EQUIPO ',codActual,': ',em);
				writeln('   TOTAL PUNTOS EQUIPO ',codActual,': ',puntosTotal);
				maximo(nombreActual, nombreMax, puntosTotal, puntosMax);
			end;
			writeln(' EL EQUIPO: ',nombreMax,' fue campeon del torneo COD: ',torneoActual,' ANIO: ',anioActual);
			writeln('----------------------');
		end;
	end;
	close(a);
	writeln('-----');
end;

var
	a: archivo;
BEGIN
	assign(a, 'maestro');
	cargarArchivo(a);
	imprimir(a);
END.

