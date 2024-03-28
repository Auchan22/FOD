{
Se desea modelar la información necesaria para un sistema de recuentos de casos de covid
para el ministerio de salud de la provincia de buenos aires.
Diariamente se reciben archivos provenientes de los distintos municipios, la información
contenida en los mismos es la siguiente: código de localidad, código cepa, cantidad de
casos activos, cantidad de casos nuevos, cantidad de casos recuperados, cantidad de casos
fallecidos.
El ministerio cuenta con un archivo maestro con la siguiente información: código localidad,
nombre localidad, código cepa, nombre cepa, cantidad de casos activos, cantidad de casos
nuevos, cantidad de recuperados y cantidad de fallecidos.
Se debe realizar el procedimiento que permita actualizar el maestro con los detalles
recibidos, se reciben 10 detalles. Todos los archivos están ordenados por código de
localidad y código de cepa.
Para la actualización se debe proceder de la siguiente manera:
1. Al número de fallecidos se le suman el valor de fallecidos recibido del detalle.
2. Idem anterior para los recuperados.
3. Los casos activos se actualizan con el valor recibido en el detalle.
4. Idem anterior para los casos nuevos hallados.
Realice las declaraciones necesarias, el programa principal y los procedimientos que
requiera para la actualización solicitada e informe cantidad de localidades con más de 50
casos activos (las localidades pueden o no haber sido actualizadas).
}

program ej7_p2_2024;
uses crt;
const
	n = 10;
	valoralto = 9999;
type
	reg_d = record
		cod_loc: integer;
		cod_cepa: integer;
		cant_act: integer;
		cant_nuevos: integer;
		cant_recu: integer;
		cant_fall: integer;
	end;
	
	reg_m = record
		cod_loc: integer;
		nombre_loc: string[20];
		cod_cepa: integer;
		nombre_cepa: string[20];
		cant_act: integer;
		cant_nuevos: integer;
		cant_recu: integer;
		cant_fall: integer;
	end;
	
	maestro = file of reg_m;
	detalle = file of reg_d;
	
	arr_det = array[1..n] of detalle;
	arr_reg = array[1..n] of reg_d;

procedure cargarMaestro(var arch: maestro);
	procedure leerRegistro(var r: reg_m);
	begin
		writeln('-----');
		write('Ingrese codigo de localidad: ');
		readln(r.cod_loc);
		if(r.cod_loc <> -1) then begin
			write('Ingrese nombre de localidad: ');
			readln(r.nombre_loc);
			write('Ingrese codigo de cepa: ');
			readln(r.cod_cepa);
			write('Ingrese nombre de cepa: ');
			readln(r.nombre_cepa);
			write('Ingrese cant de casos activos: ');
			readln(r.cant_act);
			write('Ingrese cant de casos nuevos: ');
			readln(r.cant_nuevos);
			write('Ingrese cant de casos recuperados: ');
			readln(r.cant_recu);
			write('Ingrese cant de casos fallecidos: ');
			readln(r.cant_fall);
		end;	
		writeln('-----');
	end;
var
	r: reg_m;
begin
	writeln('-- Carga maestro --');
	rewrite(arch);
	leerRegistro(r);
	while(r.cod_loc <> -1) do begin
		write(arch, r);
		leerRegistro(r);
	end;
	close(arch);
	writeln('-----');
end;

procedure asignarDetalles(var arr: arr_det);
var
	i: integer;
	aux: string;
begin
	for i:= 1 to n do begin
		str(i, aux);
		assign(arr[i], 'detalle_'+aux);
	end;
end;

procedure cargarDetalles(var arr: arr_det);
	procedure leerRegistro(var r: reg_d);
	begin
		writeln('-----');
		write('Ingrese codigo de localidad: ');
		readln(r.cod_loc);
		if(r.cod_loc <> -1) then begin
			write('Ingrese codigo de cepa: ');
			readln(r.cod_cepa);
			write('Ingrese cant de casos activos: ');
			readln(r.cant_act);
			write('Ingrese cant de casos nuevos: ');
			readln(r.cant_nuevos);
			write('Ingrese cant de casos recuperados: ');
			readln(r.cant_recu);
			write('Ingrese cant de casos fallecidos: ');
			readln(r.cant_fall);
		end;	
		writeln('-----');
	end;
var
	i: integer;
	r: reg_d;
begin
	for i:= 1 to n do begin
		writeln('-- Cargando detalle: ',i,' --');
		rewrite(arr[i]);
		leerRegistro(r);
		while(r.cod_loc <> -1) do begin
			write(arr[i], r);
			leerRegistro(r);
		end;
		close(arr[i]);
		writeln('-----');
		clrscr;
	end;
end;

procedure imprimirMaestro(var arch: maestro);
	procedure imprimirRegistro(r: reg_m);
	begin
		writeln('-----');
		writeln('-> Codigo localidad: ', r.cod_loc);
		writeln('-> Codigo cepa: ', r.cod_cepa);
		writeln('-> Cant casos activos: ', r.cant_act);
		writeln('-> Cant casos nuevos: ', r.cant_nuevos);
		writeln('-> Cant casos recuperados: ', r.cant_recu);
		writeln('-> Cant casos fallecidos: ', r.cant_fall);
		writeln('-----');
	end;
var
	r: reg_m;
begin
	writeln('-- Imprimiendo maestro --');
	reset(arch);
	while(not eof(arch)) do begin
		read(arch, r);
		imprimirRegistro(r);
	end;
	close(arch);
end;

procedure leer(var arch: detalle; var dato: reg_d);
begin
	if(not eof(arch))then
		read(arch, dato)
	else
		dato.cod_loc := valoralto;
end;

procedure minimo(var reg: arr_reg; var det: arr_det; var min: reg_d);
var
	i, iMin: integer;
begin
	iMin:= 0;
	min.cod_loc:= valoralto;
	min.cod_cepa:= valoralto;
	for i:= 1 to n do begin
		if(reg[i].cod_loc <> valoralto) then begin
			if(reg[i].cod_loc < min.cod_loc) or ((reg[i].cod_loc = min.cod_loc) and (reg[i].cod_cepa < min.cod_cepa)) then begin
				iMin:= i;
				min:= reg[i];
			end;
		end;
	end;
	
	if(iMin <> 0) then
		leer(det[iMin], reg[iMin]);
end;

procedure actualizar(var arch: maestro; var arr: arr_det);
var
	min: reg_d;
	r: reg_m;
	cepaActual, locActual: integer;
	cantRecu, cantFall, cantNue, cantAct: integer;
	i: integer;
	reg: arr_reg;
begin
	for i:= 1 to n do begin
		reset(arr[i]);
		leer(arr[i], reg[i]);
	end;
	reset(arch);
	read(arch, r);
	minimo(reg, arr, min);
	while(min.cod_loc <> valoralto) do begin
		locActual:= min.cod_loc;
		while(locActual = min.cod_loc) do begin
			cepaActual:= min.cod_cepa;
			cantRecu:= 0;
			cantFall:= 0;
			cantNue:= 0;
			cantAct:= 0;
			while (locActual = min.cod_loc) and (cepaActual = min.cod_cepa) do begin
				cantFall:= cantFall + min.cant_fall;
				cantRecu := cantRecu + min.cant_recu;
				cantNue:= min.cant_nuevos;
				cantAct:= min.cant_act;
				minimo(reg, arr, min);
			end;
			while(r.cod_loc <> locActual) or (r.cod_cepa <> cepaActual) do
				read(arch, r);
			r.cant_fall := r.cant_fall + cantFall;
			r.cant_recu := r.cant_recu + cantRecu;
			r.cant_nuevos := cantNue;
			r.cant_act:= cantAct;
			
			seek(arch, filepos(arch) -1);
			write(arch, r);
		end;	
	end;
	for i:= 1 to n do
		close(arr[i]);
	close(arch);
end;

procedure leerMaestro(var arch: maestro; var dato: reg_m);
begin
	if(not eof(arch)) then
		read(arch, dato)
	else
		dato.cod_loc:= valoralto;
end;	
	
procedure contarCasos(var arch: maestro);
var
	cant, totAct, locActual: integer;
	r: reg_m;
begin
	reset(arch);
	cant := 0;
	leerMaestro(arch, r);
	while(r.cod_loc <> valoralto) do begin
		totAct:= 0;
		locActual := r.cod_loc;
		while(r.cod_loc = locActual) do begin
			totAct:= totAct + r.cant_act;
			leerMaestro(arch, r);
		end;
		if(totAct > 50) then
			cant:= cant + 1;
	end;
	close(arch);
	writeln('-- Hay un total de : ',cant,' localidades con mas de 50 casos activos');
end;

var
	arch: maestro;
	arr: arr_det;
BEGIN
	assign(arch, 'maestro');
	asignarDetalles(arr);
	//cargarMaestro(arch);
	//cargarDetalles(arr);
	//imprimirMaestro(arch);
	actualizar(arch, arr);
	imprimirMaestro(arch);
	//contarCasos(arch);
END.

