{
Se necesita contabilizar los votos de las diferentes mesas electorales registradas por
localidad en la provincia de Buenos Aires. Para ello, se posee un archivo con la
siguiente información: código de localidad, número de mesa y cantidad de votos en
dicha mesa. Presentar en pantalla un listado como se muestra a continuación:
Código de Localidad Total de Votos
................................ ......................
................................ ......................
Total General de Votos: ………………
NOTAS:
● La información en el archivo no está ordenada por ningún criterio.
● Trate de resolver el problema sin modificar el contenido del archivo dado.
● Puede utilizar una estructura auxiliar, como por ejemplo otro archivo, para
llevar el control de las localidades que han sido procesadas.
}

program ej2_p2;
uses crt;
const
	valoralto = 999;
type
	mesa = record
		codLocalidad: integer;
		nroMesa: integer;
		cantVotos: integer;
	end;
	
	archivo = file of mesa;
	
procedure cargarArchivo(var a: archivo);
var
	l: mesa;
	txt: Text;
begin
	assign(txt, 'archivo.txt');
	reset(txt);
	rewrite(a);
	while not eof(txt) do begin
		readln(txt, l.codLocalidad, l.nroMesa, l.cantVotos);
		write(a, l);
	end;
	writeln('Archivo maestro generado');
	close(txt);
	close(a);
end;

procedure leer(var a: archivo; var d: mesa);
begin
	if not eof(a) then
		read(a, d)
	else
		d.codLocalidad:= valoralto;
end;

procedure corteDeControl(var a, arch: archivo; var cantTotal: integer);
var
	m, aux: mesa;
	ok: boolean;
begin
	reset(a);
	rewrite(arch);
	while not eof(a) do begin
		read(a, m);
		ok:= false;
		seek(arch, 0); //Siempre voy a empezar desde el principio del archivo auxiliar, que va a agrupar los codigos
		while(not eof(arch)) and (not ok) do begin
			read(arch, aux);
			if(aux.codLocalidad = m.codLocalidad) then ok:= true; //Si lo encuentra, termina el loop
		end;
		if(ok) then begin // Si lo encuentra, va a ir sumarizando sobre ese registro
			aux.cantVotos := aux.cantVotos + m.cantVotos;
			seek(arch, filepos(arch)-1);
            write(arch, aux);
		end
		else // En el caso que no lo encontro, lo va a insertar
			write(arch, m);
		cantTotal := cantTotal + m.cantVotos;
	end;
	close(a);
	close(arch);
end;

procedure imprimirAuxiliar(var a: archivo; cant: integer);
var
	m: mesa;
begin
	reset(a);
	writeln('CODIGO DE LOCALIDAD ......................... CANTIDAD DE VOTOS');
	while not eof(a) do begin
		read(a, m);
		writeln(m.codLocalidad,'  ......................... ',m.cantVotos);
	end;
	writeln('CANTIDAD TOTAL DE VOTOS: ', cant);
	close(a);
end;

var
	cantTotal: integer;
	aux, a: archivo;
BEGIN
	assign(aux, 'Auxiliar');
	assign(a, 'Archivo');
	cargarArchivo(a);
	cantTotal:= 0;
	corteDeControl(a, aux, cantTotal);
	imprimirAuxiliar(aux, cantTotal);
END.

