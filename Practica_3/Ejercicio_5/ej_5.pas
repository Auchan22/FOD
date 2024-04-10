{
5. Dada la estructura planteada en el ejercicio anterior, implemente el siguiente módulo:
Abre el archivo y elimina el título del libro recibido como parámetro
manteniendo la política descripta anteriormente
procedure eliminar (var a: tArchLibros ; titulo: string);
}

program ej5_p3;
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

procedure eliminar(var a:tArchLibros; titulo: tTitulo);
var
	cabecera, act: tTitulo;
	ok: boolean;
begin
	reset(a);
	ok:= false;
	leer(a, cabecera);
	leer(a, act);
	while (act <> valoralto) and (not ok) do begin
		if(act = titulo) then begin
			ok:= true;
			seek(a, filepos(a)-1);
			cabecera:= IntToStr(filepos(a));
			write(a, cabecera);
			seek(a, 0);
			write(a, cabecera);
		end
		else
			leer(a, act);
	end;
	if ok then writeln('Titulo eliminado')
	else writeln('No se encontro el titulo indicado');
	close(a);
end;

var
	arch: tArchLibros;
BEGIN
	assign(arch, 'libros.dot');
	crear(arch);
	agregar(arch, 'pepe');
	agregar(arch, 'miguel');
	agregar(arch, 'juan');
	listar(arch);
	eliminar(arch, 'b');
	listar(arch);
	agregar(arch, 'bebe');
	listar(arch);
	eliminar(arch, 'raul');
END.

