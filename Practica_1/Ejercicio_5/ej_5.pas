{
Realizar un programa para una tienda de celulares, que presente un menú con
opciones para:
	a. Crear un archivo de registros no ordenados de celulares y cargarlo con datos
	ingresados desde un archivo de texto denominado “celulares.txt”. Los registros
	correspondientes a los celulares, deben contener: código de celular, el nombre,
	descripcion, marca, precio, stock mínimo y el stock disponible.
	b. Listar en pantalla los datos de aquellos celulares que tengan un stock menor al
	stock mínimo.
	c. Listar en pantalla los celulares del archivo cuya descripción contenga una
	cadena de caracteres proporcionada por el usuario.
	d. Exportar el archivo creado en el inciso a) a un archivo de texto denominado
	“celulares.txt” con todos los celulares del mismo.
	
	NOTA 1: El nombre del archivo binario de celulares debe ser proporcionado por el usuario
	una única vez.
	NOTA 2: El archivo de carga debe editarse de manera que cada celular se especifique en
	tres líneas consecutivas: en la primera se especifica: código de celular, el precio y
	marca, en la segunda el stock disponible, stock mínimo y la descripción y en la tercera
	nombre en ese orden. Cada celular se carga leyendo tres líneas del archivo
	“celulares.txt”.
}


program ej5_p1;
uses crt;
TYPE
	TString = string[8];
	Celular = record
		codigo: integer;
		nombre: TString;
		descripcion: string[100];
		marca: TString;
		precio: real;
		stockMinimo: integer;
		stockDisponible: integer;
	end;
	Archivo = File of Celular;
	
procedure CrearArchivo(var arch_log: Archivo);
var
	c: Celular;
	txt: Text;
begin
	writeln('-- Iniciando carga de archivo --');
	Assign(txt, 'celulares.txt');
	reset(txt);
	rewrite(arch_log);
	while not eof(txt) do begin
		readln(txt, c.codigo, c.precio, c.marca);
		readln(txt, c.stockDisponible, c.stockMinimo, c.descripcion);
		readln(txt, c.nombre);
		write(arch_log, c);
		writeln('.');
	end;
	close(arch_log);
	close(txt);
	writeln('-- Fin carga de archivo --');
end;
procedure MostrarCelular(c: Celular);
begin
	writeln('-----');
	writeln('-> Codigo: ', c.codigo);
	writeln('-> Nombre: ', c.nombre);
	writeln('-> Descripcion: ', c.descripcion);
	writeln('-> Marca: ', c.marca);
	writeln('-> Precio: ', c.precio:0:2);
	writeln('-> Stock Minimo: ', c.stockMinimo);
	writeln('-> Stock Disponible: ', c.stockDisponible);
	writeln('-----');
end;
procedure ListarMenor(var arch_log: Archivo);
var
	c: Celular;
begin
	reset(arch_log);
	while not eof(arch_log) do begin
		read(arch_log, c);
		if(c.stockDisponible < c.stockMinimo) then
			MostrarCelular(c);
	end;
	close(arch_log);
end;
procedure ListarDescripcion(var arch_log: Archivo);
var
	c: Celular;
	desc: string[100];
begin
	writeln('');
	write('Ingrese una descripcion a buscar: ');
	readln(desc);
	reset(arch_log);
	while not eof(arch_log) do begin
		read(arch_log, c);
		if(c.descripcion = Concat(' ', desc)) then
			MostrarCelular(c);
	end;
	close(arch_log);
end;
procedure ExportarATexto(var arch_log: Archivo);
var
	c: Celular;
	txt: Text;
begin
	writeln('-- Iniciando exportación a "celulares_nuevo.txt" --');
	Assign(txt, 'celulares_nuevo.txt');
	rewrite(txt);
	reset(arch_log);
	while not eof(arch_log) do begin
		read(arch_log, c);
		writeln(txt, c.codigo:10, c.precio:10:2, c.marca:10);
		writeln(txt, c.stockDisponible:10, c.stockMinimo:10, c.descripcion:10);
		writeln(txt, c.nombre:10);
	end;
	close(arch_log);
	close(txt);
	writeln('-- Fin Exportación --');
end;

procedure ShowMenu(var arch_log: Archivo; nombre: string);
var
	opc: char;
begin
	writeln('------');
	writeln('Ingrese por teclado la opción a efectuar: ', nombre);
	writeln('');
	writeln('[a] Crear archivo');
	writeln('[b] Listar celulares con stock disponible menor a stock minimo');
	writeln('[c] Listar celulares cuya descripcion coincida con una ingresada');
	writeln('[d] Exportar archivo a "celulares_nuevo.txt"');
	writeln('');
	readln(opc);
	writeln('OPCION ELEGIDA -->  ', opc);
	writeln('------');
	
	case opc of
		'a':
		begin
			CrearArchivo(arch_log);
		end;
		'b':
		begin
			ListarMenor(arch_log);
		end;
		'c': 
		begin
			ListarDescripcion(arch_log);
		end;
		'd':
		begin
			ExportarATexto(arch_log);
		end;
		else writeln('No se encuentra la opción...');
	end;
end;
VAR
	arch_log: Archivo;
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
