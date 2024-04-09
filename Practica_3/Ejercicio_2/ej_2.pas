{
Definir un programa que genere un archivo con registros de longitud fija conteniendo
información de empleados de una empresa aseguradora. Se deberá almacenar:
código de empleado, nombre y apellido, dirección, telefono, D.N.I y fecha
nacimiento. Implementar un algoritmo que, a partir del archivo de datos generado,
elimine de forma lógica todo los empleados con DNI inferior a 5.000.000.
Para ello se podrá utilizar algún carácter especial delante de algún campo String a su
elección. Ejemplo: ‘*Juan’.
}

program ej2_p3;
uses crt, SysUtils;
const
	valoralto = 9999;
type
	empleado = record
		cod: integer;
		nombre: string[20];
		apellido: string[20];
		direccion: string[20];
		telefono: string[20];
		dni: string[8];
		fecha_nac: string[8];
	end;
	
	archivo = file of empleado;

procedure cargarArchivo(var arch: archivo);
	procedure leerEmpleado(var e: empleado);
	begin
		writeln('-----');
		write('Ingrese cod de empleado: ');
		readln(e.cod);
		if(e.cod <> -1) then begin
			write('Ingrese nombre: ');
			readln(e.nombre);
			write('Ingrese apellido: ');
			readln(e.apellido);
			write('Ingrese direccion: ');
			readln(e.direccion);
			write('Ingrese telefono: ');
			readln(e.telefono);
			write('Ingrese dni: ');
			readln(e.dni);
			write('Ingrese fecha de nacimiento: ');
			readln(e.fecha_nac);
		end;
		writeln('-----');
	end;
var
	e: empleado;
begin
	writeln('-- Cargando Archivo --');
	rewrite(arch);
	leerEmpleado(e);
	while(e.cod <> -1) do begin
		write(arch, e);
		leerEmpleado(e);
	end;
	close(arch);
	writeln('-----');
end;

procedure imprimirArchivo(var arch: archivo);
	procedure imprimirEmpleado(e: empleado);
	begin
		writeln('-----');
		writeln('-> Codigo: ', e.cod);
		writeln('-> Nombre: ', e.nombre);
		writeln('-> Apellido: ', e.apellido);
		writeln('-> Direccion: ', e.direccion);
		writeln('-> DNI: ', e.dni);
		writeln('-> Telefono: ', e.telefono);
		writeln('-> Fecha de nacimiento: ', e.fecha_nac);
		writeln('-----');
	end;
var
	e: empleado;
begin
	reset(arch);
	while(not eof(arch)) do begin
		read(arch, e);
		imprimirEmpleado(e);
	end;
	close(arch);
end;

procedure leer(var arch: archivo; var dato: empleado);
begin
	if not eof(arch) then
		read(arch, dato)
	else
		dato.cod := valoralto;
end;

procedure eliminar(var arch: archivo);
var
	e: empleado;
	aux: Longint;
	a: string;
begin
	reset(arch);
	leer(arch, e);
	while(e.cod <> valoralto) do begin
		aux := StrToInt(e.dni);
		if(aux < 5000000) then begin
			a := Concat('*', e.nombre);
			e.nombre:= a;
			seek(arch, filepos(arch) - 1);
			write(arch, e);
		end;
		leer(arch, e);
	end;
	close(arch);
end;

var
	arch: archivo;
BEGIN
	assign(arch, 'archivo.dat');
	//cargarArchivo(arch);
	eliminar(arch);
	imprimirArchivo(arch);
END.

