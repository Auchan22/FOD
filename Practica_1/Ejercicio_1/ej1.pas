{
Realizar un algoritmo que cree un archivo de números enteros no ordenados y permita
incorporar datos al archivo. Los números son ingresados desde teclado. El nombre del
archivo debe ser proporcionado por el usuario desde teclado. La carga finaliza cuando
se ingrese el número 30000, que no debe incorporarse al archivo.
}


program ej1_p1;
TYPE
	archivo = file of integer;
VAR
	arch: archivo;
	num: integer;
	nombre: string[20];
BEGIN
	write('Ingrese nombre del archivo: ');
	read(nombre);
	Assign(arch, nombre);
	rewrite(arch);
	write('Ingrese numero: ');
	read(num);
	while(num <> 30000) do begin
		write(arch, num);
		write('Ingrese numero: ');
		read(num);
	end;
	close(arch);
END.

