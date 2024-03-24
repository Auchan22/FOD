{
10. La empresa de software ‘X’ posee un servidor web donde se encuentra alojado el sitio de la
organización. En dicho servidor, se almacenan en un archivo todos los accesos que se realizan al sitio.
La información que se almacena en el archivo es la siguiente: año, mes, dia, idUsuario y tiempo de acceso
al sitio de la organización. El archivo se encuentra ordenado por los siguientes criterios: año, mes, dia e
idUsuario.
Se debe realizar un procedimiento que genere un informe en pantalla, para ello se indicará el año
calendario sobre el cual debe realizar el informe. El mismo debe respetar el formato mostrado a
continuación:
}

program ej10_p2;
uses crt;
type
	acceso = record
		anio: integer;
		mes: integer;
		dia: integer;
		idUsuario: integer;
		tiempo: real;
	end;
	
	archivo = file of acceso;
	
procedure cargarArchivo(var arch: archivo);
	procedure leerAcceso(var a: acceso);
	begin
		writeln('-----');
		write('Ingrese anio: ');
		readln(a.anio);
		if(a.anio <> -1) then begin
			write('Ingrese anio: ');
			readln(a.anio);
		end;
		writeln('-----');
	end;

BEGIN
	

END.

