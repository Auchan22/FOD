{
4. Suponga que trabaja en un oficina donde está montada una LAN (red local). La misma fue
construida sobre una topología de red que conecta 5 máquinas entre sí y todas las máquinas
se conectan con un servidor central. Semanalmente cada máquina genera un archivo de logs
informando las sesiones abiertas por cada usuario en cada terminal y por cuánto tiempo estuvo
abierta. Cada archivo detalle contiene los siguientes campos: cod_usuario, fecha,
tiempo_sesion. Debe realizar un procedimiento que reciba los archivos detalle y genere un
archivo maestro con los siguientes datos: cod_usuario, fecha,
tiempo_total_de_sesiones_abiertas.
Notas:
- Cada archivo detalle está ordenado por cod_usuario y fecha.
- Un usuario puede iniciar más de una sesión el mismo dia en la misma o en diferentes
máquinas.
- El archivo maestro debe crearse en la siguiente ubicación física: /var/log.
}

program ej4_p2;
uses crt;
const
	n = 5;
	valoralto = 9999;
type
	fecha = record
		dia: 1..31;
		mes: 1..12;
		anio: 2000..2024;
	end;
	
	reg = record
		cod: integer;
		fecha: fecha;
		tiempo: real;
	end;
	
	maestro = file of reg;
	detalle = file of reg;
	maquinas = array[1..n] of detalle;
	registros = array[1..n] of reg;

procedure cargarDetalles(var arr: maquinas);
	procedure leerFecha(var f: fecha);
	begin
		write('-->Ingrese día: ');
		readln(f.dia);
		write('-->Ingrese mes: ');
		readln(f.mes);
		write('-->Ingrese anio: ');
		readln(f.anio);
	end;

	procedure leerRegistro(var r: reg);
	begin
		writeln('-----');
		write('Ingrese codigo de usuario: ');
		readln(r.cod);
		if(r.cod <> -1) then begin
			writeln('Ingrese fecha: ');
			leerFecha(r.fecha);
			write('Ingrese tiempo de sesion: ');
			readln(r.tiempo);
		end;
		writeln('-----');
	end;
var
	r: reg;
	i: integer;
	aux: string;
begin
	for i:= 1 to n do begin
		Str(i, aux);
		Assign(arr[i], 'detalle'+aux);
		rewrite(arr[i]);
		writeln('-> Cargando detalle: detalle'+aux);
		leerRegistro(r);
		while(r.cod <> -1) do begin
			write(arr[i], r);
			leerRegistro(r);
		end;
		close(arr[i]);
	end;
end;
	
	procedure imprimirRegistro(r: reg);
			procedure imprimirFecha(f: fecha);
			begin
				writeln('--> Dia: ', f.dia);
				writeln('--> Mes: ', f.mes);
				writeln('--> Anio: ', f.anio);
			end;
	begin
		writeln('-----');
		writeln('-> Codigo de Usuario: ', r.cod);
		writeln('-> Fecha: ');
		imprimirFecha(r.fecha);
		writeln('-> Tiempo de uso: ', r.tiempo:0:2);
		writeln('-----');
	end;

procedure imprimirDetalles(var arr: maquinas);
var
	i: integer;
	aux: string;
	r: reg;
begin
	for i:= 1 to n do begin
		Str(i, aux);
		Assign(arr[i], 'detalle'+aux);
		reset(arr[i]);
		writeln('> Imprimiendo detalle: detalle'+aux);
		while(not eof(arr[i])) do begin
			read(arr[i], r);
			imprimirRegistro(r);
		end;
		close(arr[i]);
	end;
end;

procedure leer(var arch_d: detalle; var dato: reg);
begin
	if(not eof(arch_d)) then
		read(arch_d, dato)
	else
		dato.cod := valoralto;
end;

procedure minimo(var reg: registros; var arch: maquinas; var min: reg);
var
	i, iMin: integer;
begin
	i:= 0;
	min.cod := valoralto;
	for i:= 1 to n do begin
		if(reg[i].cod <> valoralto) then
			if(reg[i].cod < min.cod) or ((reg[i].cod = min.cod) and (reg[i].fecha.dia < min.fecha.dia) and (reg[i].fecha.mes < min.fecha.mes) and (reg[i].fecha.anio < min.fecha.anio)) then begin
				min:= reg[i];
				iMin:= i;
			end;
	end;
	
	if(iMin <> 0) then
		leer(arch[iMin], reg[iMin]);
end;

procedure merge(var arch_m: maestro; var arr: maquinas);
var
	min: reg;
	i: integer;
	regs: registros;
	actual: reg;
	auxI: string;
begin
	rewrite(arch_m);
	for i:= 1 to n do begin
		Str(i, auxI);
		Assign(arr[i], 'detalle'+auxI);
		reset(arr[i]);
		leer(arr[i], regs[i]);
	end;
	minimo(regs, arr, min);
	//writeln(min.cod, ' ', min.tiempo:0:2);
	while(min.cod <> valoralto) do begin
		actual.cod := min.cod;
		while(actual.cod = min.cod) do begin
			actual.fecha:= min.fecha;
			actual.tiempo:= 0;
			while (min.cod = actual.cod) 
			//and ((min.fecha.dia = actual.fecha.dia) and (min.fecha.mes = actual.fecha.mes) and (min.fecha.anio = actual.fecha.anio))
			 do begin
				actual.tiempo += min.tiempo;
				minimo(regs,arr,min);
				//writeln(min.cod, min.tiempo:0:2);
			end;
			write(arch_m,actual);
		end;
	end;
	for i:= 1 to n do
		close(arr[i]);
	close(arch_m);
end;

procedure AsignarDetalles(var arr: maquinas);
var
	i: integer;
	aux: string;
begin
	for i:= 1 to n do begin
		str(i, aux);
		Assign(arr[i], 'detalle'+aux);
	end;
end;

procedure imprimirMaestro(var arch_m: maestro);
var
	r: reg;
begin
	reset(arch_m);
	while(not eof(arch_m)) do begin
		read(arch_m, r);
		imprimirRegistro(r);
	end;
	close(arch_m);
end;
var
	arch_m: maestro;
	arr: maquinas;
BEGIN
	Assign(arch_m, 'registros.dat');
	AsignarDetalles(arr);
	//cargarDetalles(arr);
	//imprimirDetalles(arr);
	merge(arch_m, arr);
	writeln('maestro');
	imprimirMaestro(arch_m);
END.

