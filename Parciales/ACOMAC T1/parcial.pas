program parcial_acomac_t1;
uses crt;
type
	dinosaurio = record
		codigo: integer;
		tipo: integer;
		altura: real;
		peso: real;
		descripcion: string[50];
		zona: string[20];
	end;
	
	archivo = file of dinosaurio;
	
procedure cargarMaestro(var a: archivo);
	procedure leerDinosaurio(var d: dinosaurio);
	begin
		writeln('-----');
		write('Ingrese codigo: ');readln(d.codigo);
		if(d.codigo <> -1) then begin
			write('Ingrese tipo: ');readln(d.tipo);
			write('Ingrese altura: ');readln(d.altura);
			write('Ingrese peso: ');readln(d.peso);
			write('Ingrese descripcion: ');readln(d.descripcion);
			write('Ingrese zona: ');readln(d.zona);
		end;
		writeln('-----');
	end;
var
	d: dinosaurio;
begin
	writeln('-- Cargando maestro --');
	rewrite(a);
	leerDinosaurio(d);
	while d.codigo <> -1 do begin
		write(a, d);
		leerDinosaurio(d);
	end;
	close(a);
	writeln('-----');
end;

procedure eliminarDinosaurios(var a: archivo);
var
	t: integer;
	act, cabecera: dinosaurio;
	ok: boolean;
begin
	writeln('-- Baja de Dinosaurios --')

end;

BEGIN
	
	
END.

