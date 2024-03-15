{
Se dispone de un archivo con información de los alumnos de la Facultad de Informática. Por
cada alumno se dispone de su código de alumno, apellido, nombre, cantidad de materias
(cursadas) aprobadas sin final y cantidad de materias con final aprobado. Además, se tiene
un archivo detalle con el código de alumno e información correspondiente a una materia
(esta información indica si aprobó la cursada o aprobó el final).
Todos los archivos están ordenados por código de alumno y en el archivo detalle puede
haber 0, 1 ó más registros por cada alumno del archivo maestro. Se pide realizar un
programa con opciones para:
a. Actualizar el archivo maestro de la siguiente manera:
i.Si aprobó el final se incrementa en uno la cantidad de materias con final aprobado.
ii.Si aprobó la cursada se incrementa en uno la cantidad de materias aprobadas sin
final.
b. Listar en un archivo de texto los alumnos que tengan más de cuatro materias
con cursada aprobada pero no aprobaron el final. Deben listarse todos los campos.
NOTA: Para la actualización del inciso a) los archivos deben ser recorridos sólo una vez.
}

program ej2_p2;
uses crt;
const 
	valoralto = 999;
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
procedure leer(var arch: detalle; var dato: a_resumen);
begin
	if(not eof(arch)) then
		read(arch, dato)
	else
		dato.codigo := valoralto;
end;
procedure actualizar(var arch_m: maestro; var arch_d: detalle);
var
	aux: a_resumen;
	a: alumno;
	cod: integer;
	tot_cursada, tot_fin: integer;
begin
	reset(arch_m);
	reset(arch_d);
	read(arch_m, a);
	leer(arch_d, aux);
	while(aux.codigo <> valoralto) do begin
		cod:= aux.codigo;
		tot_cursada:= 0;
		tot_fin:= 0;
		//Agrupamos valores
		while(aux.codigo = cod) do begin
			if(aux.fin = 1) then tot_fin := tot_fin + 1;
			if(aux.cursada = 1) then tot_cursada:= tot_cursada + 1;
			leer(arch_d, aux);
		end;
		//Buscamos registro en el maestro
		while(a.codigo <> cod) do
			read(arch_m, a);
		a.cantMsin:= a.cantMsin + tot_cursada;
		a.cantMcon:= a.cantMcon + tot_fin;
		seek(arch_m, filepos(arch_m)-1);
		write(arch_m, a);
		
		if(not eof(arch_m)) then read(arch_m, a);
	end;
	close(arch_d);
	close(arch_m);
end;
procedure ShowMenu(opc: char; var arch: maestro)
BEGIN
	
	
END.

