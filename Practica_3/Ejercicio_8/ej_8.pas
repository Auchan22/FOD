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
		if(d.nombre = n) then
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

var
	arch: archivo;
BEGIN
	assign(arch, 'maestro.data');
	cargarArchivo(arch);
	
END.

