{
Realizar un programa que permita:
	a. Crear un archivo binario a partir de la información almacenada en un archivo de texto.
	El nombre del archivo de texto es: “novelas.txt”
	b. Abrir el archivo binario y permitir la actualización del mismo. Se debe poder agregar
	una novela y modificar una existente. Las búsquedas se realizan por código de novela.

	NOTA: La información en el archivo de texto consiste en: código de novela,
	nombre,género y precio de diferentes novelas argentinas. De cada novela se almacena la
	información en dos líneas en el archivo de texto. La primera línea contendrá la siguiente
	información: código novela, precio, y género, y la segunda línea almacenará el nombre
	de la novela.
}


program ej7_p1;
uses crt;
TYPE
	Novela = record
		nombre: string[100];
		genero: string[20];
		codigo: integer;
		precio: real;
	end;
	
	Archivo = File of Novela;
procedure CrearArchivo(var arch_log: Archivo);
var
	n: Novela;
	txt: Text;
begin
	writeln('-- Iniciando carga de archivo --');
	Assign(txt, 'novelas.txt');
	reset(txt);
	rewrite(arch_log);
	while not eof(txt) do begin
		readln(txt, n.codigo, n.precio, n.genero);
		readln(txt, n.nombre);
		write(arch_log, n);
		writeln('.');
	end;
	close(arch_log);
	close(txt);
	writeln('-- Fin carga de archivo --');
end;
procedure MostrarArchivo(var arch_log: Archivo);
	procedure ImprimirNovela(n: Novela);
	begin
		writeln('-----');
		writeln('-> Codigo: ',n.codigo,' -> Precio: ', n.precio:0:2, ' -> Genero: ', n.genero);
		writeln('-> Nombre: ', n.nombre);
		writeln('-----');
	end;
var
	n: Novela;
begin
	writeln('-- Imprimiendo Archivo --');
	reset(arch_log);
	while not eof(arch_log) do begin
		read(arch_log, n);
		ImprimirNovela(n);
	end;
	writeln('-----');
	close(arch_log);
end;
procedure LeerNovela(var n: Novela);
begin
	writeln('-----');
	write('Ingrese codigo de novela: ');
	readln(n.codigo);
	if n.codigo <> -1 then begin
		write('Ingrese precio: ');
		readln(n.precio);
		write('Ingrese genero: ');
		readln(n.genero);
		write('Ingrese Nombre: ');
		readln(n.nombre);
	end;
	writeln('-----');
end;
procedure AgregarNovela(var arch_log: Archivo);
var
	n: Novela;
begin
	reset(arch_log);
	seek(arch_log, filesize(arch_log));
	writeln('-- Agregar Novelas --');
	LeerNovela(n);
	while n.codigo <> -1 do begin
		write(arch_log, n);
		LeerNovela(n);
	end;
	close(arch_log);
	writeln('-- Fin carga --');
end;
procedure ModificarNovela(var arch_log: Archivo);
	procedure modificar (var n:Novela);
	var
		opcion:integer;
	begin
		writeln ('SELECCIONE QUE DESEA MODIFICAR');
		writeln ('');
		writeln ('1) PRECIO');
		writeln ('');
		writeln ('2) GENERO');
		writeln ('');
		writeln ('3) NOMBRE');
		writeln ('');
		write ('OPCION ELEGIDA --> ');
		readln (opcion);
		writeln ('');
		case opcion of 
		1: 
			begin
				write ('INGRESE NUEVO PRECIO: '); readln (n.precio);
			end;
		2:
			begin
				write ('INGRESE NUEVO GENERO: '); readln (n.genero);
			end;
		3: 	
			begin
				write ('INGRESE NUEVO NOMBRE: '); readln (n.nombre);
			end
		else 
			writeln ('NO ES UNA OPCION VALIDA');
		end;
		writeln ('');
	end;

var
	codigo:integer;
	ok: boolean;
	n:Novela;
begin
	reset (arch_log);
	ok:= false;
	write ('INGRESE CODIGO DE LA NOVELA QUE DESEA MODIFICAR: '); readln (codigo);
	writeln ('');
	while not eof (arch_log) and not(ok) do begin
		read (arch_log,n);
		if (codigo = n.codigo) then begin
			ok:= true;
			modificar(n);
			seek (arch_log,FilePos(arch_log)-1);
			write (arch_log,n);		
		end;
	end;
	if (ok) then 
		writeln ('NOVELA MODIFICADA CON EXITO')
	else
		writeln ('NO SE ENCONTRO NOVELA');
	close(arch_log);
end;
procedure ShowMenu(var arch_log: Archivo; nombre: string);
var
	opc: byte;
begin
	writeln('------');
	writeln('Ingrese por teclado la opción a efectuar: ', nombre);
	writeln('');
	writeln('[1] Crear archivo');
	writeln('[2] Mostrar Archivo');
	writeln('[3] Agregar Novela');
	writeln('[4] Modificar Novela');
	writeln('');
	readln(opc);
	writeln('OPCION ELEGIDA -->  ', opc);
	writeln('------');
	
	case opc of
		1:
		begin
			CrearArchivo(arch_log);
		end;
		2:
		begin
			MostrarArchivo(arch_log);
		end;
		3: 
		begin
			AgregarNovela(arch_log);
		end;
		4:
		begin
			ModificarNovela(arch_log);
		end;
		else writeln('No se encuentra la opción...');
	end;
end;
VAR
	arch_log: Archivo;
	nombre: string[20];
	loop: boolean;
	letra: char;
BEGIN
	loop:= true;
	write('Ingrese el nombre del archivo: ');
	readln(nombre);
	Assign(arch_log, nombre);
	ShowMenu(arch_log, nombre);
	while (loop) do begin
		write ('SI INGRESA CUALQUIER CARACTER SE DESPLEGARA NUEVAMENTE EL MENU. SI INGRESA "Z" SE CERRARA LA CONSOLA: '); readln (letra);
		if (letra = 'Z') or (letra = 'z') then
			loop:= false
		else begin
			clrscr;
			ShowMenu(arch_log, nombre);
		end;
	end;
END.

