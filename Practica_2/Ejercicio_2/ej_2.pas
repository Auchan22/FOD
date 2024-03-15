{
Se dispone de un archivo con información de los alumnos de la Facultad de Informática. Por
cada alumno se dispone de su código de alumno, apellido, nombre, cantidad de materias
(cursadas) aprobadas sin final y cantidad de materias con final aprobado. Además, se tiene
un archivo detalle con el código de alumno e información correspondiente a una materia
(esta información indica si aprobó la cursada o aprobó el final).
Todos los archivos están ordenados por código de alumno y en el archivo detalle puede
haber 0, 1 ó más registros por cada alumno del archivo maestro. Se pide realizar un
programa con opciones para:
a. Crear el archivo maestro a partir de un archivo de texto llamado “alumnos.txt”.
b. Crear el archivo detalle a partir de en un archivo de texto llamado “detalle.txt”.
c. Listar el contenido del archivo maestro en un archivo de texto llamado“reporteAlumnos.txt”.
d. Listar el contenido del archivo detalle en un archivo de texto llamado
“reporteDetalle.txt”.
e. Actualizar el archivo maestro de la siguiente manera:
i. Si aprobó el final se incrementa en uno la cantidad de materias con final
aprobado.
ii. Si aprobó la cursada se incrementa en uno la cantidad de materias aprobadas
sin final.
f. Listar en un archivo de texto los alumnos que tengan más de cuatro materias
con cursada aprobada pero no aprobaron el final. Deben listarse todos los campos.
NOTA: Para la actualización del inciso e) los archivos deben ser recorridos sólo una vez.
}

program ej2_p2;
uses crt;
type
	rango = 0..1;
	alumno = record
		codigo: integer;
		apellido: string[20];
		nombre: string[20];
		cantMsin: integer;
		cantMcon: integer;
	end;
	a_resumen = record
		codigo: integer;
		fin: rango; //0 desaprobado 1 aprobado
		cursada: rango;
		nombre: string[20];
	end;
	maestro = file of alumno;
	detalle = file of a_resumen;
procedure cargarMaestro(var arch: maestro);
var
	a: alumno;
	txt: Text;
begin
	writeln('-- Iniciando carga archivo --');
	Assign(txt, alumnos.txt);
	reset(txt);
	rewrite(arch);
	while not eof(txt) do begin
		readln(txt, a.codigo, a.apellido, a.nombre, a.cantMsin, a.cantMcon);
		write(arch, a);
	end;
	close(arch);
	close(txt);
	writeln('-- Fin carga archivo --');
end;
procedure
BEGIN
	
	
END.

