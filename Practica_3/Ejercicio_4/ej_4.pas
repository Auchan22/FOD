{
4. Dada la siguiente estructura:
type
tTitulo = String[50];
tArchLibros = file of tTitulo ;

Las bajas se realizan apilando registros borrados y las altas reutilizando registros
borrados. El registro 0 se usa como cabecera de la pila de registros borrados: el

número 0 implica que no hay registros borrados y N indica que el próximo registro a
reutilizar es el N, siendo éste un número relativo de registro válido.
a. Implemente el siguiente módulo:
Abre el archivo y agrega el título del libro, recibido como parámetro
manteniendo la política descripta anteriormente
procedure agregar (var a: tArchLibros ; titulo: string);
b. Liste el contenido del archivo omitiendo los libros
}

program ej4_p3;
uses crt, Sysutils;
const 
	valoralto = 'ZZZ';
type
	tTitulo = string[50];
	
	tArchLibros = file of tTitulo;
	
procedure crear(var a: tArchLibros);
	procedure leerTitulo(var t: tTitulo);
	begin
		writeln('-----');
		write('Ingrese titulo: ');readln(t);
		writeln('-----');
	end;
var
	t: tTitulo;
begin
	writeln('-- Cargando archivo --');
	rewrite(a);
	t := '0';
	write(a, t);
	leerTitulo(t);
	while t <> 'ZZZ' do begin
		write(a, t);
		leerTitulo(t);
	end;
	close(a);
	writeln('-----');
end;

procedure leer(var a: tArchLibros; var t: tTitulo);
begin
	if not eof(a) then
		read(a, t)
	else
		t:= valoralto;
end;

procedure agregar(var a: tArchLibros; titulo: tTitulo);
var
	cabecera, act: tTitulo;
	pos: integer;
begin
	reset(a);
	leer(a, cabecera);
	pos := StrToInt(cabecera);
	if(pos > 0) then begin
		seek(a, pos); //Nos posicionamos en el registro libre
		read(a, act); //Leemos el registro libre
		seek(a, filepos(a) -1);
		cabecera:= act;
		write(a, titulo);
		seek(a, 0);
		write(a, cabecera);
	end
	else begin
		seek(a, filesize(a));
		write(a, titulo);
	end;
	close(a);
end;

procedure listar(var a: tArchLibros);
var
	t: tTitulo;
	c: Char;
	b: boolean;
begin
	reset(a);
	leer(a, t);
	while not eof(a) do begin
		leer(a, t);
		for c in t do begin
			b:= c in ['0'..'9'];
			if b then break;
		end;
		if not b then writeln('-> Titulo: ',t);
		//writeln('-> Titulo: ',t);
	end;
	close(a);
end;

var
	arch: tArchLibros;
BEGIN
	assign(arch, 'libros.dot');
	//crear(arch);
	//agregar(arch, 'pepe');
	//agregar(arch, 'miguel');
	//agregar(arch, 'juan');
	//agregar(arch, '1');
	listar(arch);
END.

