{
Realizar un algoritmo, que utilizando el archivo de números enteros no ordenados
creados en el ejercicio 1, informe por pantalla cantidad de números menores a 1500 y
el promedio de los números ingresados. El nombre del archivo a procesar debe ser
proporcionado por el usuario una única vez. Además, el algoritmo deberá listar el
contenido del archivo en pantalla.
}


program ej2_p1;
TYPE
	archivo = file of integer;
procedure imprimirArchivo(var arch_log: archivo);
var
	num, cant, cantM, total: integer;
	prom: real;
begin
	cant:= 0;
	cantM:= 0;
	total:= 0;
	reset(arch_log);
	while not eof(arch_log) do begin
		cant:= cant + 1;
		read(arch_log, num);
		total:= total + num;
		if(num <= 1500) then
			cantM:= cantM + 1;
		writeln('Numero: ', num);
	end;
	close(arch_log);
	writeln('');
	writeln('Numeros menores a 1500: ', cantM);
	writeln('');
	prom:= total div cant;
	writeln('Promedio: ', prom:0:2);
end;

var
	arch: archivo;
	nombre: string[20];
BEGIN
	writeln('');
	write('Ingrese nombre del archiv0: ');
	read(nombre);
	Assign(arch, nombre);
	imprimirArchivo(arch);
END.

