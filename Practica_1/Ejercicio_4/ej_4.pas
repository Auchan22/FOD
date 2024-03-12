{
Agregar al menú del programa del ejercicio 3, opciones para:
	a. Añadir una o más empleados al final del archivo con sus datos ingresados por
	teclado.
	b. Modificar edad a una o más empleados.
	c. Exportar el contenido del archivo a un archivo de texto llamado
	“todos_empleados.txt”.
	d. Exportar a un archivo de texto llamado: “faltaDNIEmpleado.txt”, los empleados
	que no tengan cargado el DNI (DNI en 00).

	NOTA: Las búsquedas deben realizarse por número de empleado.
}


program ej4_p1;
uses crt;
TYPE
	TString = string[20];
	empleado = record
		nro: longint;
		apellido: TString;
		nombre: TString;
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
	e, aux: empleado;
	ok: boolean;
begin
	rewrite(arch_log);
	writeln('');
	writeln('-- Iniciando carga --');
	LeerEmpleado(e);
	while(e.apellido <> 'fin') do begin
		ok:= true;
		while not eof(arch_log) and ok do begin
			read(arch_log, aux);
			if(aux.nro = e.nro) then
				ok:= false;
		end;
		if(ok) then begin
			seek(arch_log, filesize(arch_log));
			write(arch_log, e);
			end
		else
			writeln('El empleado con el nro ingresado ya existe, cargue otro');
		seek(arch_log, 0);
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

procedure AbrirArchivo(var arch_log: archivo);
var
	opc: char;
begin
	writeln('------');
	writeln('Ingrese por teclado la opción a imprimir sobre el archivo: ');
	writeln('');
	writeln('[a] Imprimir por nombre o apellido');
	writeln('[b] Imprimir todos por linea');
	writeln('[c] Imprimir prontos a jubilarse');
	writeln('');
	readln(opc);
	writeln('OPCION ELEGIDA -->  ', opc);
	writeln('------');
	
		case opc of
		'a':
		begin
			ImprimirArchivoA(arch_log);
		end;
		'b':
		begin
			ImprimirArchivoB(arch_log);
		end;
		'c': 
		begin
			ImprimirArchivoC(arch_log);
		end;
		else writeln('No se encuentra la opción...');
	end;
end;
function ExisteEmpleado(var arch_log: archivo; e:empleado): boolean;
var
	aux: empleado;
	ok: boolean;
begin
	ok:= true;
	while not eof(arch_log) and ok do begin
				read(arch_log, aux);
				if(aux.nro = e.nro) then
					ok:= false;
			end;
	ExisteEmpleado:= ok;
end;
procedure AgregarEmpleado(var arch_log: archivo);
var
	e, aux: empleado;
	ok: boolean;
begin
	reset(arch_log);
	{seek(arch_log, filesize(arch_log));} //Esta linea no va, ya que nos posiciona sobre el final
	writeln('-- Iniciando carga --');
	LeerEmpleado(e);
	while(e.apellido <> 'fin') do begin
		ok:= true;
		while not eof(arch_log) and ok do begin
			read(arch_log, aux);
			if(aux.nro = e.nro) then
				ok:= false;
		end;
		if(ok) then begin
			seek(arch_log, filesize(arch_log)); // Si no existe, lo posicionamos al final y agregamos
			write(arch_log, e);
		end
		else
			writeln('El empleado con el nro ingresado ya existe, registre otro');
		seek(arch_log, 0); //Ponemos el puntero en el inicio para que la profima carga, evalua desde la primer pos
		LeerEmpleado(e);
		writeln('');
	end;
	writeln('-- Finalizando carga --');
	close(arch_log);
end;
procedure ModificarEmpleado(var arch_log: archivo);
	procedure EncontrarEmpleado(var ef: empleado; var pos: integer; var arch_log: archivo; nro: integer; var existe: boolean);
	var
		ok: boolean;
		e: empleado;
	begin
		ok:= false;
		reset(arch_log);
		while not eof(arch_log) and (not ok) do begin
			read(arch_log, e);
			if(e.nro = nro) then begin
				ok:= true;
				pos:= filepos(arch_log)-1;
				ef:= e;
				existe:= true;
			end
			else
				existe:= false;
		end;
		close(arch_log);
	end;

var
	e: empleado;
	nro, pos, edad: integer;
	ok, existe: boolean;
begin
	pos:= -1;
	ok:= true;
	existe:= false;
	writeln('-----');
	write('Ingrese nro de empleado a buscar: ');
	readln(nro);
	while(nro <> -1) and (ok) do begin
		EncontrarEmpleado(e, pos, arch_log, nro, existe);
		ok:= false;
		if(not existe) then begin
			ok:= false;
			writeln('NO EXISTE EL EMPLEADO CON NRO: ', nro);
		end
		else begin
			reset(arch_log);
			writeln('Edad actual: ', e.edad);
			write('Ingrese edad nueva: ');
			readln(edad);
			e.edad:= edad;
			seek(arch_log, pos);
			write(arch_log, e);
			close(arch_log);
		end;
	end;
	writeln('-----');
end;
procedure exportar(opc: byte; var arch_log: archivo);
	function faltaDNI(e: empleado): boolean;
	begin
		faltaDNI:= e.dni = '00';
	end;
	procedure exportarEmpleado(e: empleado; var txt: Text);
	begin
		writeln(txt, 
		'-> Apellido: ',e.apellido,
		'-> Nombre: ', e.nombre,
		'-> Nro: ', e.nro,
		'-> Edad: ', e.edad,
		'-> DNI: ', e.dni
		);
	end;
var
	txt: Text;
	e: empleado;
begin
	if(opc = 1) then
		Assign(txt, 'todo_empleados.txt')
	else
		Assign(txt, 'faltaDNIEmpleado.txt');
	reset(arch_log);
	rewrite(txt);
	while not eof(arch_log) do begin
		read(arch_log, e);
		if(opc = 1) then
			exportarEmpleado(e, txt)
		else begin
			if(faltaDNI(e)) then 
				exportarEmpleado(e, txt);
		end;
	end;
	close(arch_log);
	close(txt);
end;

procedure ShowMenu(var arch_log: archivo; nombre: string);
var
	opc: byte;
begin
	writeln('------');
	writeln('Ingrese por teclado la opción a efectuar sobre el archivo: ', nombre);
	writeln('');
	writeln('[0] Cargar el archivo');
	writeln('[1] Abrir el archivo');
	writeln('[2] Agregar Empleado');
	writeln('[3] Modificar edad');
	writeln('[4] Exportar archivo a "todo_empleados.txt"');
	writeln('[5] Exportar archivo a "faltaDNIEmpleado.txt"');
	writeln('');
	readln(opc);
	writeln('OPCION ELEGIDA -->  ', opc);
	writeln('------');
	
	case opc of
		0:
		begin
			CargarArchivo(arch_log);
		end;
		1:
		begin
			AbrirArchivo(arch_log);
		end;
		2: 
		begin
			AgregarEmpleado(arch_log);
		end;
		3:
		begin
			ModificarEmpleado(arch_log);
		end;
		4:
		begin
			exportar(1, arch_log);
		end;
		5:
		begin
			exportar(2, arch_log);
		end;
		else writeln('No se encuentra la opción...');
	end;
end;

VAR
	arch_log: archivo;
	nombre: TString;
	loop: boolean;
	letra: char;
BEGIN
	loop:= true;
	write('Ingrese el nombre del archivo: ');
	readln(nombre);
	Assign(arch_log, nombre);
	ShowMenu(arch_log, nombre);
	while (loop) do begin
		write ('SI INGRESA CUALQUIER CARACTER SE DESPLEGARA NUEVAMENTE EL MENU. SI INGRESA E SE CERRARA LA CONSOLA: '); readln (letra);
		if (letra = 'E') or (letra = 'e') then
			loop:= false
		else begin
			clrscr;
			ShowMenu(arch_log, nombre);
		end;
	end;
END.
