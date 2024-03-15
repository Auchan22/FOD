{
Una empresa posee un archivo con información de los ingresos percibidos por diferentes
empleados en concepto de comisión, de cada uno de ellos se conoce: código de empleado,
nombre y monto de la comisión. La información del archivo se encuentra ordenada por
código de empleado y cada empleado puede aparecer más de una vez en el archivo de
comisiones.
Realice un procedimiento que reciba el archivo anteriormente descripto y lo compacte. En
consecuencia, deberá generar un nuevo archivo en el cual, cada empleado aparezca una
única vez con el valor total de sus comisiones.
NOTA: No se conoce a priori la cantidad de empleados. Además, el archivo debe ser
recorrido una única vez.
}


program ej1_p2;
uses crt;
const
	valoralto = 999;
type
	empleado = record
		codigo: integer;
		nombre: string[20];
		monto: real;
	end;
	
	e_resumen = record
		codigo: integer;
		monto_total: real;
	end;
	
	maestro = file of empleado;
	detalle = file of e_resumen;
procedure leer(var arch: maestro; var e:empleado);
begin
	if(not eof(arch)) then
		read(arch, e)
	else
		e.codigo:= valoralto;
end;
procedure compactar(var arch: maestro;var arch_d: detalle);
var
	aux: empleado;
	e: e_resumen;
	cod: integer;
begin
	reset(arch);
	rewrite(arch_d);
	leer(arch, aux);
	while(aux.codigo <> valoralto) do begin
		cod := aux.codigo;
		e.monto_total:= 0;
		e.codigo:= aux.codigo;
		while(aux.codigo = cod) do begin
			e.monto_total:= e.monto_total + aux.monto;
			leer(arch, aux);
		end;
		write(arch_d, e);
	end;
	close(arch_d);
	close(arch);
end;
procedure ImprimirArchivo(var arch: maestro);
	procedure ImprimirEmpleado(e: empleado);
	begin
		writeln('-----');
		writeln('-> Codigo: ', e.codigo);
		writeln('-> Nombre: ', e.nombre);
		writeln('-> Monto: ', e.monto:0:2);
		writeln('-----');
	end;
var
	e: empleado;
begin
	reset(arch);
	while(not eof(arch)) do begin
		read(arch, e);
		writeln(e.nombre);
		ImprimirEmpleado(e);
	end;
	close(arch);
end;
procedure ImprimirCompacto(var arch: detalle);
	procedure ImprimirEmpleado(e: e_resumen);
	begin
		writeln('-----');
		writeln('-> Codigo: ', e.codigo);
		writeln('-> Monto Total: ', e.monto_total:0:2);
		writeln('-----');
	end;
var
	e: e_resumen;
begin
	reset(arch);
	while(not eof(arch)) do begin
		read(arch, e);
		ImprimirEmpleado(e);
	end;
	close(arch);
end;
procedure cargar(var arch: maestro);
	procedure LeerEmpleado(var e: empleado);
	begin
		writeln('');
		write('Ingrese código: ');
		readln(e.codigo);
		if(e.codigo <> -1) then begin
			write('Ingrese nombre: ');
			readln(e.nombre);
			write('Ingrese monto: ');
			readln(e.monto);
		end;
		writeln('');
	end;
var
	e: empleado;
begin
	rewrite(arch);
	LeerEmpleado(e);
	while(e.codigo <> -1) do begin
		write(arch, e);
		LeerEmpleado(e);
	end;
	close(arch);
end;
var
	arch_m: maestro;
	arch_d: detalle;
begin
	assign(arch_m, 'empleados');
	assign(arch_d, 'empleados_resumen');
	cargar(arch_m);
	write('Documento original:');
	ImprimirArchivo(arch_m);
	compactar(arch_m, arch_d);
	writeln('Documento Compacto:');
	ImprimirCompacto(arch_d);
end.
