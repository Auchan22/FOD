{
La editorial X, autora de diversos semanarios, posee un archivo maestro con la información
correspondiente a las diferentes emisiones de los mismos. De cada emisión se registra:
fecha, código de semanario, nombre del semanario, descripción, precio, total de ejemplares
y total de ejemplares vendido.
Mensualmente se reciben 100 archivos detalles con las ventas de los semanarios en todo el
país. La información que poseen los detalles es la siguiente: fecha, código de semanario y
cantidad de ejemplares vendidos. Realice las declaraciones necesarias, la llamada al
procedimiento y el procedimiento que recibe el archivo maestro y los 100 detalles y realice la
actualización del archivo maestro en función de las ventas registradas. Además deberá
informar fecha y semanario que tuvo más ventas y la misma información del semanario con
menos ventas.
Nota: Todos los archivos están ordenados por fecha y código de semanario. No se realizan
ventas de semanarios si no hay ejemplares para hacerlo
}
program ej_15_2024;
uses crt;
const
	n = 100;
	valoralto = 999;
type
	emision = record
		fecha: string;
		cod_semanario: integer;
		nombre: string[20];
		desc: string[100];
		precio: real;
		tot: integer;
		tot_ven: integer;
	end;
	
	venta = record
		fecha: string;
		cod_semanario: integer;
		cant_vendidos: integer;
	end;

BEGIN
	
	
END.

