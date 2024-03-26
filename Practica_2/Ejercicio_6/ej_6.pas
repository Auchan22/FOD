{
	Suponga que trabaja en una oficina donde está montada una LAN (red local). La misma fue
construida sobre una topología de red que conecta 5 máquinas entre sí y todas las
máquinas se conectan con un servidor central. Semanalmente cada máquina genera un
archivo de logs informando las sesiones abiertas por cada usuario en cada terminal y por
cuánto tiempo estuvo abierta. Cada archivo detalle contiene los siguientes campos:
cod_usuario, fecha, tiempo_sesion. Debe realizar un procedimiento que reciba los archivos
detalle y genere un archivo maestro con los siguientes datos: cod_usuario, fecha,
tiempo_total_de_sesiones_abiertas.
Notas:
● Cada archivo detalle está ordenado por cod_usuario y fecha.
● Un usuario puede iniciar más de una sesión el mismo día en la misma máquina, o
inclusive, en diferentes máquinas.
● El archivo maestro debe crearse en la siguiente ubicación física: /var/log.
}


program ej_6_2024;
uses crt;
const 
	n=5;
	valoralto = 999;
type
	Date = record
		dia: integer;
		mes: integer;
		anio: integer;
	end;

	reg_d = record
		cod: integer;
		fecha: Date;
		tiempo: real;
	end;
	
	reg_m = record
		cod: integer;
		tiempo_total: real;
		fecha: Date;
	end;
	
	maestro = file of reg_m;
	detalle = file of reg_d;
	
	arr_det = array[1..n] of detalle;
	arr_reg = array[1..n] of reg_d;
	
procedure cargarDetalles(var arr: arr_det);
	procedure leerFecha(var f: Date);
	begin
		write('Ingrese Dia: ');
		readln(f.dia);
		write('Ingrese Mes: ');
		readln(f.mes);
		write('Ingrese Anio: ');
		readln(f.anio);
	end;
	procedure leerRegistro(var r: reg_d);
	begin
		writeln('-----');
		write('Ingrese codigo de usuario: ');
		readln(r.cod);
		if(r.cod <> -1) then begin
			write('Ingrese Fecha: ');
			leerFecha(r.fecha);
			write('Ingrese tiempo de sesion: ');
			readln(r.tiempo);
		end;
		writeln('-----');
	end;
var
	i: integer;
	r: reg_d;
begin
	for i:= 1 to n do begin
		writeln('-- Cargando detalle: ',i);
		rewrite(arr[i]);
		leerRegistro(r);
		while(r.cod <> -1) do begin
			write(arr[i], r);
			leerRegistro(r);
		end;
		clrscr;
		close(arr[i]);
	end;
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

procedure leer(var arch: detalle; var dato: reg_d);
begin
	if(not eof(arch)) then
		read(arch, dato)
	else
		dato.cod := valoralto;
end;

procedure minimo(var reg: arr_reg; var det: arr_det; var min: reg_d);
var
	i, iMin: integer;
begin
	iMin:= 0;
	min.cod := valoralto;
	min.fecha.dia:= valoralto;
	min.fecha.mes:= valoralto;
	min.fecha.anio:= valoralto;
	for i:= 1 to n do begin
		if(reg[i].cod <> valoralto) then begin
			if (reg[i].cod < min.cod) or ((reg[i].fecha.dia < min.fecha.dia) and (reg[i].fecha.mes < min.fecha.mes) and (reg[i].fecha.anio < reg[i].fecha.anio)) then begin
				iMin:= i;
				min:= reg[i];
			end;
		end;
	end;
	if(iMin <> 0) then begin
		leer(det[iMin], reg[iMin]);
	end;
end;

	procedure imprimirFecha(f: Date);
	begin
		writeln('--> Dia: ',f.dia );
		writeln('--> Mes: ',f.mes );
		writeln('--> Anio: ',f.anio );
	end;

procedure imprimirRegistro(r: reg_m);
	begin
		writeln('-----');
		writeln('-> Codigo: ', r.cod);;
		imprimirFecha(r.fecha);
		writeln('-> Tiempo total: ', r.tiempo_total:0:2);
		writeln('-----');
	end;

procedure merge(var arch: maestro;var arr: arr_det);
var
	i: integer;
	min: reg_d;
	r: reg_m;
	reg: arr_reg;
begin
	rewrite(arch);
	for i:= 1 to n do begin
		reset(arr[i]);
		leer(arr[i], reg[i]);
	end;
	minimo(reg, arr, min);
	writeln(min.cod);
	while(min.cod <> valoralto) do begin
		r.cod:= min.cod;
		r.fecha.dia:= min.fecha.dia;
		r.fecha.mes:= min.fecha.mes;
		r.fecha.anio:= min.fecha.anio;
		r.tiempo_total:= 0;
		writeln(min.fecha.dia,min.fecha.mes,min.fecha.anio);
		writeln(r.fecha.dia,r.fecha.mes,r.fecha.anio);
		while((min.fecha.dia = r.fecha.dia) and (min.fecha.mes = r.fecha.mes) and (min.fecha.anio = r.fecha.anio)) and (min.cod = r.cod) do begin
			r.tiempo_total:= r.tiempo_total + min.tiempo;
			minimo(reg, arr, min);
			writeln(min.fecha.dia,min.fecha.mes,min.fecha.anio);
		end;
		imprimirRegistro(r);
		write(arch, r);	
	end;
	close(arch);
	for i:= 1 to n do
		close(arr[i]);
end;

procedure imprimirMaestro(var arch: maestro);	
var
	r: reg_m;
begin
	writeln('-----');
	reset(arch);
	while(not eof(arch)) do begin
		read(arch, r);
		imprimirRegistro(r);
	end;
	close(arch);
	writeln('-----');
end;

var
	arr: arr_det;
	arch: maestro;
BEGIN
	assign(arch, 'maestro');
	asignarDetalles(arr);
	//cargarDetalles(arr);
	merge(arch, arr);
	imprimirMaestro(arch);
END.

