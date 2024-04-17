{
Se cuenta con un archivo que almacena información sobre especies de aves en vía
de extinción, para ello se almacena: código, nombre de la especie, familia de ave,
descripción y zona geográfica. El archivo no está ordenado por ningún criterio. Realice
un programa que elimine especies de aves, para ello se recibe por teclado las
especies a eliminar. Deberá realizar todas las declaraciones necesarias, implementar
todos los procedimientos que requiera y una alternativa para borrar los registros. Para
ello deberá implementar dos procedimientos, uno que marque los registros a borrar y
posteriormente otro procedimiento que compacte el archivo, quitando los registros
marcados. Para quitar los registros se deberá copiar el último registro del archivo en la
posición del registro a borrar y luego eliminar del archivo el último registro de forma tal
de evitar registros duplicados.
Nota: Las bajas deben finalizar al recibir el código 500000
}


program ej7_p3;
uses crt;
const
	valoralto = 5000;
type
	ave = record
		cod: integer;
		especie: string[20];
		familia: string[20];
		descripcion: string[100];
		zona: string[50];
	end;
	
	archivo = file of ave;

procedure cargarArchivo(var a: archivo);
	procedure leerAve(var a: ave);
	begin
		writeln('-----');
		write('Ingrese codigo: '); readln(a.cod);
		if(a.cod <> -1) then begin
			write('Ingrese especie: '); readln(a.especie);
			write('Ingrese familia: '); readln(a.familia);
			write('Ingrese descripcion: '); readln(a.descripcion);
			write('Ingrese zona: '); readln(a.zona);
		end;
		writeln('-----');
	end;
var
	av: ave;
begin
	writeln('-- Carga Archivo --');
	rewrite(a);
	leerAve(av);
	while(av.cod <> -1) do begin
		write(a, av);
		leerAve(av);
	end;
	close(a);
	writeln('-----');
end;
procedure leer(var a: archivo; var dato: ave);
begin
	if not eof(a) then
		read(a, dato)
	else
		dato.cod:= valoralto;
end;
procedure imprimirArchivo(var a: archivo);
	procedure imprimirAve(a: ave);
	begin
		writeln('-----');
		writeln('-> Codigo: ', a.cod);
		writeln('-> Especie: ', a.especie);
		writeln('-> Familia: ', a.familia);
		writeln('-> Descripcion: ', a.descripcion);
		writeln('-> Zona: ', a.zona);
		writeln('-----');
	end;
var
	av: ave;
begin
	reset(a);
	leer(a, av);
	while(av.cod <> valoralto) do begin
		imprimirAve(av);
		leer(a, av);
	end;
	close(a);
end;

// Este metodo va a buscar del ultimo al primero aquel dato que tenga que no este borrado
procedure EncontrarUltimo(var a: archivo; var dato: ave; var pos: integer);
begin
	seek(a, pos);
	read(a, dato);
	while(dato.cod <> -1) do begin
		seek(a, pos - 1);
		pos:= filepos(a);
		read(a, dato);
	end;
end;

procedure BajaLogica(var a: archivo);
var
	dato: ave;
	c: integer;
begin
	reset(a);
	write('Ingrese código de ave a eliminar: ');readln(c);
	while(c <> valoralto) do begin
		leer(a, dato);
		while(dato.cod <> valoralto) do begin
			if(dato.cod = c) then begin
				dato.cod := -1;
				seek(a, filepos(a)-1);
				write(a, dato);
			end;
			leer(a, dato);
		end;
		write('Ingrese código de ave a eliminar: ');readln(c);
		seek(a, 0);
	end;
	close(a);
end;

procedure BajaFisica(var a: archivo);
var
	aux, ultimo: ave;
	pos, posUlt: integer;
begin
	reset(a);
	leer(a, aux);
	//Almacenamos la ultima pos del archivo
	posUlt:= filepos(a)-1;
	while(aux.cod <> valoralto) and (posUlt >= filepos(a))do begin
		pos:= filepos(a);
		if(aux.cod = -1) then begin
			EncontrarUltimo(a, ultimo, posUlt);
			posUlt:= posUlt-1; //Vuelvo "atras" en la pos
			seek(a, pos-1);
			write(a, ultimo); //Reemplazo el dato en la pos que estaba el eliminado logico
		end;
		leer(a, aux);
	end;
	seek(a, posUlt + 1);
	truncate(a); //Le digo al archivo que marque la pos actual como la ultima, eliminando los archivos que hay despues(evita duplicados)
	close(a);
end;
var
	a: archivo;
	n: integer;
BEGIN
	assign(a, 'maestro.data');
	cargarArchivo(a);
	clrscr;
	readln(n);
	imprimirArchivo(a);
	BajaLogica(a);
	BajaFisica(a);
	readln(n);
	clrscr;
	imprimirArchivo(a);
END.

