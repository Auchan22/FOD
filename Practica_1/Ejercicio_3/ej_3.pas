{
Realizar un programa que presente un menú con opciones para:
	a. Crear un archivo de registros no ordenados de empleados y completarlo con
	datos ingresados desde teclado. De cada empleado se registra: número de
	empleado, apellido, nombre, edad y DNI. Algunos empleados se ingresan con
	DNI 00. La carga finaliza cuando se ingresa el String ‘fin’ como apellido.
	b. Abrir el archivo anteriormente generado y
		i. Listar en pantalla los datos de empleados que tengan un nombre o apellido
		determinado.
		ii. Listar en pantalla los empleados de a uno por línea.
		iii. Listar en pantalla empleados mayores de 70 años, próximos a jubilarse.
	
	NOTA: El nombre del archivo a crear o utilizar debe ser proporcionado por el usuario una
	única vez.
}


program ej3_p1;
TYPE
	empleado = record
		nro: longint;
		apellido: string[20];
		nombre: string[20];
		edad: integer;
		dni: string[8];
	end;
	archivo = file of empleado;
	
procedure LeerEmpleado(var e: empleado);
begin;
	writeln('-------');
	write('Ingrese apellido: ');
	readln(e.apellido);
	if(e.apellido <> 'fin') then begin
		write('Ingrese nombre: ');
		readln(e.nombre);
		write('Ingrese nro de empleado: ');
		readln(e.nro);
		write('Ingrese edad: ');
		readln(e.edad);
		write('Ingrese dni: ');
		readln(e.dni);
	end;
	writeln('-------');
end;
procedure CargarArchivo(var arch_log: archivo);
var
	e: empleado;
begin
	rewrite(arch_log);
	writeln('');
	writeln('-- Iniciando carga --');
	LeerEmpleado(e);
	while(e.apellido <> 'fin') do begin
		write(arch_log, e);
		LeerEmpleado(e);
		writeln('');
	end;
	writeln('-- Finalizando carga --');
	close(arch_log);
end;
procedure ImprimirEmpleado(e: empleado);
begin
	writeln('-----');
	writeln('-> Apellido: ', e.apellido);
	writeln('-> Nombre: ', e.nombre);
	writeln('-> Nro de empleado: ', e.nro);
	writeln('-> Edad: ', e.edad);
	writeln('-> DNI: ', e.dni);
	writeln('-----');
end;
procedure ImprimirArchivoA(var arch_log: archivo);
var
	e: empleado;
	opc: string[20];
begin
	writeln('');
	write('Ingrese nombre o apellido a buscar: ');
	readln(opc);
	reset(arch_log);
	while not eof(arch_log) do begin
		read(arch_log, e);
		if(e.apellido = opc) or (e.nombre = opc) then
			ImprimirEmpleado(e);
	end;
	writeln('');
end;
procedure ImprimirArchivoB(var arch_log: archivo);
var
	e: empleado;
begin
	writeln('');
	reset(arch_log);
	while not eof(arch_log) do begin
		read(arch_log, e);
		write('Apellido: ', e.apellido, ' ');
		write('Nombre: ', e.nombre, ' ');
		write('Nro de empleado: ', e.nro, ' ');
		write('Edad: ', e.edad, ' ');
		writeln('DNI: ', e.dni);
	end;
	writeln('');
end;
function jubilarse(edad: integer): boolean;
begin
	jubilarse:= edad >= 70;
end;
procedure ImprimirArchivoC(var arch_log: archivo);
var
	e:empleado;
begin
	writeln('');
		reset(arch_log);
		while not eof(arch_log) do begin
			read(arch_log, e);
			if(jubilarse(e.edad)) then
				ImprimirEmpleado(e);
		end;
		writeln('');
end;

VAR
	arch_log: archivo;
	nombre: string[20];
BEGIN
	write('Ingrese el nombre del archivo: ');
	readln(nombre);
	Assign(arch_log, nombre);
	CargarArchivo(arch_log);
	{ImprimirArchivoA(arch_log);}
	{ImprimirArchivoB(arch_log);}
	ImprimirArchivoC(arch_log);
END.

