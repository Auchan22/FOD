{
   ej_8.pas
   
   Copyright 2024 Usuario <Usuario@DESKTOP-2LUU1N3>
   
   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
   MA 02110-1301, USA.
   
   
}


program ej8_p3;
uses crt;
const
	valoralto = 'ZZZ';
type
	TString = string[20];
	distribucion = record
		nombre: TString;
		anioLanzamiento: integer;
		nroKernel: integer;
		cantD: integer;
		descripcion: string[50];
	end;
	
	archivo = file of distribucion;
	
procedure leer(var a: archivo; var d: distribucion);
begin
	if(not eof(a)) then
		read(a, d)
	else
		d.nombre := valoralto;
end;

function ExisteDistribucion(var a: archivo; n: TString): boolean;
var
	d: distribucion;
	existe: boolean;
begin
	seek(a, 0);
	leer(a, d);
	existe := false;
	while (d.nombre <> valoralto) and (not existe) do begin
		if(d.nombre = n) and (d.cantD > 0) then
			existe:= true
		else
			leer(a, d);
	end;
	ExisteDistribucion:= existe;
end;

procedure leerDistribucion(var d: distribucion);
begin
	writeln('-----');
	write('Ingrese nombre de distribucion: ');readln(d.nombre);
	if(d.nombre <> valoralto) then begin
		write('Ingrese nro de version de kernel: ');readln(d.nroKernel);
		write('Ingrese anio de lanzamiento: ');readln(d.anioLanzamiento);
		write('Ingrese cant de desarrolladores: ');readln(d.cantD);
		write('Ingrese descripcion: ');readln(d.descripcion);
	end;
	writeln('-----');
end;
	
procedure cargarArchivo(var a: archivo);
var
	d: distribucion;
	posActual: integer;
begin
	rewrite(a);
	d.cantD := 0;
	write(a, d);
	leerDistribucion(d);
	while d.nombre <> valoralto do begin
		posActual:= filepos(a);
		if(not ExisteDistribucion(a, d.nombre)) then begin
			seek(a, posActual);
			write(a, d);
		end
		else
			writeln('Ya existe la distribucion ingresada');
		leerDistribucion(d);
	end;
	close(a);
end;

procedure AltaDistribucion(var a: archivo);
var
	d: distribucion;
	cabecera, act: distribucion;
	pos: integer;
begin
	writeln('-----');
	writeln('-- Agregar Distribucion --');
	writeln('');
	reset(a);
	leerDistribucion(d);
	if(ExisteDistribucion(a, d.nombre)) then
		writeln('Ya existe la distribucion')
	else begin
		seek(a, 0);
		read(a, cabecera);
		pos:= cabecera.cantD * -1;
		if(pos > 0) then begin
			seek(a, pos);
			read(a, act);
			seek(a, filepos(a) - 1);
			cabecera:= act;
			write(a, d);
			seek(a, 0);
			write(a, cabecera);
		end
		else begin
			seek(a, filesize(a));
			write(a, d);
		end;
		writeln('Se agrego la distribucion');
	end;
	close(a);
	writeln('-----');
end;

procedure BajaDistribucion(var a: archivo);
var
	n: TString;
	cabecera, act: distribucion;
	pos: integer;
begin
	writeln('-----');
	reset(a);
	read(a, cabecera);
	write('Ingrese nombre de distribucion: ');readln(n);
	if(ExisteDistribucion(a, n)) then begin
		pos:= filepos(a) -1; //Almaceno la pos del registro eliminado;
		seek(a, pos); // Me posiciono en la ubi del archivo
		read(a, act); // Lo almaceno en act
		seek(a, pos); // Me vuelvo a posicionar
		act.cantD := cabecera.cantD; // Actualizo la ubi del prox elemento disponible con lo que almacena cabecera
		cabecera.cantD:= pos * -1; // Actualizo cabecera con la ult ubi disponible (la recien eliminada)
		write(a, act); // Guardo el elemento eliminado
		seek(a, 0); // Me posiciono en la cabecera
		write(a, cabecera); // Guardo la cabecera con el nuevo index disponible
	end
	else
		writeln('Distribucion no existente');
	close(a);
	writeln('-----');
end;

procedure imprimirArchivo(var a: archivo);
	procedure imprimirDistribucion(d: distribucion);
	begin
		writeln('-----');
		writeln('-> Nombre: ', d.nombre);
		writeln('-> Descripcion: ', d.descripcion);
		writeln('-> Anio Lanzamiento: ', d.anioLanzamiento);
		writeln('-> Version Kernel: ', d.nroKernel);
		writeln('-> Cant de desarrolladores: ', d.cantD);
		writeln('-----');
	end;
var
	d: distribucion;
begin
	reset(a);
	leer(a, d);
	while(d.nombre <> valoralto) do begin
		//if(d.cantD >= 0) then
			imprimirDistribucion(d);
		leer(a, d);
	end;
	close(a);
end;

procedure ShowMenu(var arch_log: archivo);
var
	opc: byte;
	n: TString;
begin
	writeln('------');
	writeln('Ingrese por teclado la opción a efectuar: ');
	writeln('');
	writeln('[0] Cargar el archivo');
	writeln('[1] Verificar existencia de distribucion');
	writeln('[2] Agregar Distribucion');
	writeln('[3] Eliminar Distribucion');
	writeln('[4] Imprimir Archivo');
	writeln('');
	readln(opc);
	writeln('OPCION ELEGIDA -->  ', opc);
	writeln('------');
	
	case opc of
		0:
		begin
			cargarArchivo(arch_log);
		end;
		1:
		begin
			writeln('-----');
			write('Ingrese nombre de distribucion a verificar: ');readln(n);
			reset(arch_log);
			if(ExisteDistribucion(arch_log, n))then
				writeln('Existe la distribucion')
			else
				writeln('No existe la distribución');
			close(arch_log);
			writeln('-----');
		end;
		2: 
		begin
			AltaDistribucion(arch_log);
		end;
		3:
		begin
			BajaDistribucion(arch_log);
		end;
		4:
		begin
			imprimirArchivo(arch_log);
		end;
		else writeln('No se encuentra la opción...');
	end;
end;

var
	arch: archivo;
	loop: boolean;
	letra: char;
BEGIN
	loop:= true;
	assign(arch, 'maestro.data');
	ShowMenu(arch);
	while (loop) do begin
		write ('SI INGRESA CUALQUIER CARACTER SE DESPLEGARA NUEVAMENTE EL MENU. SI INGRESA E SE CERRARA LA CONSOLA: '); readln (letra);
		if (letra = 'E') or (letra = 'e') then
			loop:= false
		else begin
			clrscr;
			ShowMenu(arch);
		end;
	end;
END.

