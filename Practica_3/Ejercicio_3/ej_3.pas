{

}
program ej3_p3;
uses crt;
const
	valoralto = 999;
type
	novela = record
		cod: integer;
		genero: string[10];
		nombre: string[20];
		duracion: integer;
		director: string[20];
		precio: real;
	end;
		
	archivo = file of novela;
	
	procedure leerNovela(var n: novela);
	begin
		writeln('-----');
		write('Ingrese cod de novela: ');readln(n.cod);
		if(n.cod <> -1) then begin
			write('Ingrese genero de novela: ');readln(n.genero);
			write('Ingrese nombre de novela: ');readln(n.nombre);
			write('Ingrese duracion de novela: ');readln(n.duracion);
			write('Ingrese director de novela: ');readln(n.director);
			write('Ingrese precio de novela: ');readln(n.precio);
		end;
		writeln('-----');
	end;
	
procedure CargarArchivo(var arch: archivo);
var
	n: novela;
begin
	writeln('-- Cargando archivo --');
	rewrite(arch);
	n.cod := 0;
	write(arch, n);
	leerNovela(n);
	while(n.cod <> -1) do begin
		write(arch, n);
		leerNovela(n);
	end;
	close(arch);
	writeln('-----');
end;

procedure leer(var arch: archivo; var dato: novela);
begin
	if(not eof(arch)) then
		read(arch, dato)
	else
		dato.cod := valoralto;
end;

procedure AltaNovela(var arch: archivo);
var
	cabecera, n: novela;
begin
	reset(arch);
	leer(arch, cabecera);
	LeerNovela(n);
	if(cabecera.cod = 0) then begin
		//Si la cabecera esta en 0, quiere decir que no hay lugar disponible
		// Por lo que se agrega al final
		seek(arch, filesize(arch));
		write(arch, n);
	end
	else begin
		seek(arch, (cabecera.cod * (-1))); 
		// Ya que la cabecera se guarda en negativo
		// Multiplicamos la cabecera por -1 para obtener la pos a almacenar la novela
		read(arch, cabecera); // Cabecera ahora tiene el elemento de esa pos (marcada como libre)
		seek(arch, filepos(arch)- 1);
		write(arch, n);
		seek(arch, 0);
		write(arch, cabecera); // Ahora la cabecera posee la pos libre
	end;
	close(arch);
end;

procedure ModificarNovela(var arch: archivo);
	procedure leerModif(var n: novela);
	begin
		
	end;
var
	n: novela;
	cod: integer;
begin
	writeln('-- Modificar Novela --');
	writeln('');
	write('Ingrese codigo de novela: ');
	readln(cod);
	reset(arch);
	leer(arch, n);
	if(n.cod <> valoralto) then begin
		while(n.cod <> cod) do
			leer(arch, n);
		write(' Nuevo genero (',n.genero,'): ');readln(n.genero);
		write(' Nuevo nombre (',n.nombre,'): ');readln(n.nombre);
		write(' Nuevo duracion (',n.duracion,'): ');readln(n.duracion);
		write(' Nuevo director (',n.director,'): ');readln(n.director);
		write(' Nuevo precio (',n.precio:0:2,'): ');readln(n.precio);
		seek(arch, filepos(arch)-1);
		write(arch, n);
	end;
	close(arch);
	writeln('-----');
end;

procedure EliminarNovela(var arch: archivo);
var
	cabecera, n: novela;
	cod, pos: integer;
begin
	reset(arch);
	writeln('-- Eliminar Novela --');
	writeln('');
	read(arch, cabecera);
	write('Ingrese cod de novela a eliminar: ');readln(cod);
	leer(arch, n);
	while(n.cod <> cod) do
		leer(arch, n);
	if(n.cod = cod) then begin
		pos:= filepos(arch)-1;
		n:= cabecera;
		seek(arch, pos);
		write(arch, n); // Sobreescribo los datos del registro actual con los de la cabecera
		cabecera.cod:= -pos;
		seek(arch, 0);
		write(arch, cabecera);
	end
	else
		writeln(' No se encuentra la novela con el código indicado!');
	writeln('-----');
	close(arch);
end;

procedure AbrirArchivo(var arch: archivo);
var
	opc: char;
begin
	writeln('------');
	writeln('Ingrese por teclado la opción a efectuar: ');
	writeln('');
	writeln('[a] Alta Novela');
	writeln('[b] Modificar Novela');
	writeln('[c] Eliminar Novela');
	writeln('');
	readln(opc);
	writeln('OPCION ELEGIDA -->  ', opc);
	writeln('------');	
	case opc of
		'a':
		begin
			AltaNovela(arch);
		end;
		'b':
		begin
			ModificarNovela(arch);
		end;
		'c': 
		begin
			EliminarNovela(arch);
		end;
		else writeln('No se encuentra la opción...');
	end;
end;

procedure Listar(var arch: archivo);
var
	txt: Text;
	n: novela;
begin
	assign(txt, 'novelas.txt');
	reset(arch);
	rewrite(txt);
	writeln(txt, '| CODIGO |         NOMBRE          | GENERO |');
	while(not eof(arch)) do begin
		read(arch, n);
		if(n.cod > 0) then
			writeln(txt, '| ',n.cod:6,' | ',n.nombre:20,' | ',n.genero:10,' |');
	end;
	close(arch);
	close(txt);
end;
	
procedure ShowMenu(var arch_log: archivo);
var
	opc: byte;
begin
	writeln('------');
	writeln('Ingrese por teclado la opción a efectuar: ');
	writeln('');
	writeln('[0] Cargar el archivo');
	writeln('[1] Abrir el archivo');
	writeln('[2] Listar novelas en "novelas.txt"');
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
			Listar(arch_log);
		end;
		else writeln('No se encuentra la opción...');
	end;
end;

VAR
	arch: archivo;
	loop: boolean;
	letra: char;
BEGIN
	loop:= true;
	Assign(arch, 'novelas.dat');
	ShowMenu(arch);
	while (loop) do begin
		write ('SI INGRESA CUALQUIER CARACTER SE DESPLEGARA NUEVAMENTE EL MENU. SI INGRESA E SE CERRARA LA CONSOLA: '); readln (letra);
		if (letra = 'E') or (letra = 'e') then
			loop:= false
		else begin
			clrscr;
			ShowMenu(arch);
		end;
	end;
END.

