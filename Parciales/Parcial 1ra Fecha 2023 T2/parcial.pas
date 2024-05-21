{
1. Archivos Secuenciales
Suponga que tiene un archivo con información referente a los empleados que trabajan en
una multinacional. De cada empleado se conoce el dni (único), nombre, apellido, edad,
domicilio y fecha de nacimiento.
Se solicita hacer el mantenimiento de este archivo utilizando la técnica de reutilización de
espacio llamada lista invertida.
Declare las estructuras de datos necesarias e implemente los siguientes módulos:
Agregar empleado: solicita al usuario que ingrese los datos del empleado y lo agrega al
archivo sólo si el dni ingresado no existe. Suponga que existe una función llamada
existeEmpleado que recibe un dni y un archivo y devuelve verdadero si el dni existe en el
archivo o falso en caso contrario. La función existeEmpleado no debe implementarla. Si el
empleado ya existe, debe informarlo en pantalla.
Quitar empleado: solicita al usuario que ingrese un dni y lo elimina del archivo solo si este
dni existe. Debe utilizar la función existeEmpleado. En caso de que el empleado no exista
debe informarse en pantalla.
Nota: Los módulos que debe implementar deberán guardar en memoria secundaria todo
cambio que se produzca en el archivo.
}

program ej1_2023_T2;
uses crt;
const
	valoralto='ZZZ';
type
	TString = string[20];
	TDni = string[8];
	empleado = record
		dni: TDni;
		nombre: TString;
		apellido: TString;
		edad: integer;
		domicilio: TString;
		fechaNac: TString;
	end;
	archivo = file of empleado;
	
procedure leer(var a: archivo; var d: empleado);
begin
	if not eof(a) then
		read(a, d)
	else
		d.dni := valoralto;
end;
	
function existeEmpleado(var a: archivo; dni: TDni): boolean;
var
	aux: empleado;
begin
	leer(a, aux);
	while(aux.dni <> valoralto) and (aux.dni <> dni) do
		leer(a, aux);
	existeEmpleado:= aux.dni = dni;
end;
	
procedure agregarEmpleado(var a: archivo);
	procedure leerEmpleado(var e: empleado);
	begin
		write('Ingrese nombre: ');readln(e.nombre);
		write('Ingrese apellido: ');readln(e.apellido);
		write('Ingrese edad: ');readln(e.edad);
		write('Ingrese domicilio: ');readln(e.domicilio);
		write('Ingrese fecha de nacimiento: ');readln(e.fechaNac);
	end;
var
	e, cabecera, act: empleado;
	pos: integer;
begin
	writeln('-----');
	reset(a);
	write('Ingrese dni: ');readln(e.dni);
	if(e.dni <> valoralto) then begin
		if(existeEmpleado(a, e.dni)) then
			writeln('-- Ya existe empleado con el dni ingresado --')
		else
		begin
			leerEmpleado(e);
			seek(a, 0);
			read(a, cabecera);
			pos:= cabecera.edad * -1;
			if(pos > 0) then begin
				seek(a, pos);
				read(a, act);
				seek(a, filepos(a) - 1);
				cabecera:= act;
				write(a, e);
				seek(a, 0);
				write(a, cabecera);
			end
			else begin
				seek(a, filesize(a));
				write(a, e);
			end;
		end;
	end;
	close(a);
	writeln('-----');
end;

procedure bajaEmpleado(var a: archivo);
var
	pos: integer;
	dni: TDni;
	cabecera, act, aux: empleado;
begin
	writeln('-----');
	reset(a);
	read(a, cabecera);
	write('-> Ingrese DNI a eliminar: ');readln(dni);
	if(existeEmpleado(a, dni)) then begin
		leer(a, aux);
		while(aux.dni <> dni) do
			leer(a, aux);
		pos:= filepos(a) -1;
		seek(a, pos);
		read(a, act);
		seek(a, pos);
		act.edad := cabecera.edad;
		cabecera.edad := pos * -1;
		write(a, act);
		seek(a, 0);
		write(a, cabecera);
	end
	else
		writeln('-- El empleado ingresado no existe --');
	close(a);
	writeln('-----');
end;

var
	a: archivo;
BEGIN
	assign(a, 'maestro');
	agregarEmpleado(a);
	bajaEmpleado(a);
	
END.

