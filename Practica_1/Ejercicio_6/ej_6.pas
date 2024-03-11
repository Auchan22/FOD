{
Agregar al menú del programa del ejercicio 5, opciones para:
	a. Añadir uno o más celulares al final del archivo con sus datos ingresados por
	teclado.
	b. Modificar el stock de un celular dado.
	c. Exportar el contenido del archivo binario a un archivo de texto denominado:
	”SinStock.txt”, con aquellos celulares que tengan stock 0.
	
	NOTA: Las búsquedas deben realizarse por nombre de celular.
}


program ej6_p1;
uses crt, sysutils;
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
		c.descripcion := Trim(c.descripcion);
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
		if(c.descripcion = desc) then
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
procedure AgregarCelular(var arch_log: Archivo);

	procedure LeerCelular(var c: Celular);
	begin
		writeln('-----');
		write('Ingrese codigo: ');
		readln(c.codigo);
		if(c.codigo <> -1) then begin
			write('Ingrese precio: ');
			readln(c.precio);
			write('Ingrese marca: ');
			readln(c.marca);
			write('Ingrese stock minimo: ');
			readln(c.stockMinimo);
			write('Ingrese stock disponible: ');
			readln(c.stockDisponible);
			write('Ingrese descripcion: ');
			readln(c.descripcion);
			write('Ingrese nombre: ');
			readln(c.nombre);
		end;
		writeln('-----');
	end;
var
	c: Celular;
begin
	reset(arch_log);
	seek(arch_log, filesize(arch_log));
	writeln('-- Agregando celulares --');
	LeerCelular(c);
	while(c.codigo <> -1) do begin
		write(arch_log, c);
		LeerCelular(c);
	end;
	writeln('-- Fin carga --');
end;
procedure ModificarStock(var arch_log: Archivo);
var
	nombre: TString;
	ok: boolean;
	c: Celular;
	sm, sd: integer;
begin
	ok:= false;
	writeln('-- Modificar Stock --');
	write('Ingrese nombre de celular: ');
	readln(nombre);
	reset(arch_log);
	while not eof(arch_log) and (not ok) do begin
		read(arch_log, c);
		if(c.nombre = nombre) then begin
			writeln('-> Stock Minimo Actual: ', c.stockMinimo);
			write('-> Nuevo Stock Minimo: ');
			readln(sm);
			writeln('');
			writeln('-> Stock Disponible Actual: ', c.stockDisponible);
			write('-> Nuevo Stock Disponible: ');
			readln(sd);
			c.stockMinimo := sm;
			c.stockDisponible := sd;
			seek(arch_log, filepos(arch_log) - 1);
			write(arch_log, c);
			ok:= true;
		end;
	end;
	if(ok) then
		writeln('Registro modificado!')
	else
		writeln('No se encontro el registro');
	writeln('-----');
	close(arch_log);
end;
procedure ExportarSinStock(var arch_log: Archivo);
var
	c: Celular;
	txt: Text;
begin
	writeln('-- Exportando archivo --');
	Assign(txt, 'SinStock.txt');
	rewrite(txt);
	reset(arch_log);
	while not eof(arch_log) do begin
		read(arch_log, c);
		if(c.stockDisponible = 0) then begin
			writeln(txt, c.codigo:10, c.precio:10:2, c.marca:10);
			writeln(txt, c.stockDisponible:10, c.stockMinimo:10, c.descripcion:10);
			writeln(txt, c.nombre:10);
		end;
	end;
	writeln('-----');
	close(arch_log);
	close(txt);
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
	writeln('[e] Agregar uno o mas celulares');
	writeln('[f] Modificar stock de un celular');
	writeln('[g] Exportar archivo a "SinStock.txt"');
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
		'e':
		begin	
			AgregarCelular(arch_log);
		end;
		'f':
		begin
			ModificarStock(arch_log);
		end;
		'g':
		begin
			ExportarSinStock(arch_log);
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
		write ('SI INGRESA CUALQUIER CARACTER SE DESPLEGARA NUEVAMENTE EL MENU. SI INGRESA "Z" SE CERRARA LA CONSOLA: '); readln (letra);
		if (letra = 'Z') or (letra = 'z') then
			loop:= false
		else begin
			clrscr;
			ShowMenu(arch_log, nombre);
		end;
	end;
END.
