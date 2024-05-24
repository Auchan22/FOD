{

}


program ej1_parcial_2918;
uses crt;
const 
	valoralto = 999;
type
	registro = record
		anio: integer;
		mes: integer;
		dia: integer;
		idUsuario: integer;
		tiempoAcceso: integer;
	end;
	
	archivo = file of registro;
	
procedure cargarArchivo(var a: archivo);
var
	r: registro;
	txt: Text;
begin
	assign(txt, 'registros.txt');
	rewrite(a);
	reset(txt);
	writeln('-- Cargando archivo --');
	while(not eof(txt)) do begin
		readln(txt, r.anio, r.mes, r.dia, r.idUsuario, r.tiempoAcceso);
		writeln('.');
		write(a, r);
	end;
	writeln('-----');
	close(a);
	close(txt);
end;

procedure leer(var a: archivo; var d: registro);
begin
	if(not eof(a)) then
		read(a, d)
	else
		d.anio:= valoralto;
end;

procedure informe(var a: archivo);
	procedure leerAnio(var a: integer);
	begin
		write('-> Ingrese anio a buscar: ');readln(a);
	end;
	
	function existeAnio(var a: archivo; anio: integer): integer;
	var
		ok: boolean;
		pos: integer;
		r: registro;
	begin
		pos:= -1;
		ok:= false;
		leer(a, r);
		while(r.anio <> valoralto) and (not ok) do begin
			if(r.anio = anio) then begin
				ok:= true;
				pos:= filepos(a) -1;
			end
			else
				leer(a, r);
		end;
		existeAnio:=pos;
	end;
var
	anio: integer;
	r: registro;
	pos: integer;
	anio_actual, mes_actual, dia_actual, usr_actual: integer;
	tot, tot_mes, tot_dia, tot_usr: integer;
begin
	reset(a);
	writeln('-- Generar Informe --');
	writeln('');
	leerAnio(anio);
	pos:= existeAnio(a, anio);
	if(pos > -1) then begin
		seek(a, pos);
		leer(a, r);
		writeln('ANIO: ',r.anio);
		anio_actual:= r.anio;
		tot:= 0;
		while(anio_actual = r.anio) do begin
			mes_actual:= r.mes;
			tot_mes:= 0;
			writeln(' MES: ', r.mes);
			while(anio_actual = r.anio) and (mes_actual = r.mes) do begin
				dia_actual:= r.dia;
				tot_dia:= 0;
				writeln('  DIA: ', r.dia);
				while(anio_actual = r.anio) and (mes_actual = r.mes) and (dia_actual = r.dia) do begin
					usr_actual:= r.idUsuario;
					tot_usr:= 0;
					while(anio_actual = r.anio) and (mes_actual = r.mes) and (dia_actual = r.dia) and (usr_actual = r.idUsuario) do begin
						tot_usr:= tot_usr + r.tiempoAcceso;
						leer(a, r);
					end;
					writeln('   ID USUARIO ',usr_actual,' TOTAL TIEMPO DE ACCESO DIA ',dia_actual,' MES ',mes_actual,': ',tot_usr);
					writeln('   -------');
					tot_dia := tot_dia + tot_usr;
				end;
				writeln('  TOTAL TIEMPO DE ACCESO DIA ',dia_actual,' MES ',mes_actual,': ',tot_dia);
				writeln('  -------');
				tot_mes:= tot_mes + tot_dia;
			end;
			writeln(' TOTAL TIEMPO DE ACCESO MES ',mes_actual,': ',tot_mes);
			writeln(' -------');
			tot:= tot + tot_mes;
		end;
		writeln('TOTAL TIEMPO DE ACCESO ANIO: ', tot);
	end
	else
		writeln('El anio ingresado no existe.');
	writeln('-----');
	close(a);
end;

var
	a: archivo;
BEGIN
	assign(a, 'archivo');
	//cargarArchivo(a);
	informe(a);
END.

