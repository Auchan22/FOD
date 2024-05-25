program parcial_2019;
uses crt;
const
	n = 2;
	valoralto = 9999;
type
	resumen = record
		cod_farmaco: integer;
		nombre: string[20];
		fecha: integer;
		cantidad_vendida: integer;
		forma_pago: string[10];
	end;
	
	archivo = file of resumen;
	
	arr_reg = array[1..n] of resumen;
	arr_suc = array[1..n] of archivo;
	
procedure leer(var a: archivo; var d: resumen);
begin
	if(not eof(a)) then
		read(a, d)
	else
		d.cod_farmaco:= valoralto;
end;
	
procedure minimo(var reg: arr_reg; var suc: arr_suc; var min: resumen);
var
	i, iMin: integer;
begin
	iMin:= 0;
	min.cod_farmaco:= valoralto;
	min.fecha:= valoralto;
	for i:= 1 to n do begin;
		if(reg[i].cod_farmaco <> valoralto) then begin
			if(reg[i].cod_farmaco < min.cod_farmaco) or ((reg[i].cod_farmaco = min.cod_farmaco) and (reg[i].fecha < min.fecha)) then begin
				iMin:= i;
				min:= reg[i];
			end;
		end;
	end;
	if(iMin <> 0) then
		leer(suc[iMin], reg[iMin]);
end;

procedure informarResumen(r: resumen);
begin
	writeln('-----');
	writeln('-> Cod. Farmaco: ', r.cod_farmaco);
	//writeln('-> Fecha: ', r.fecha);
	writeln('-> Nombre: ', r.nombre);
	writeln('-> Cantidad Vendida: ', r.cantidad_vendida);
	writeln('-> Forma pago: ', r.forma_pago);
	writeln('-----');
end;

procedure maximo(r: resumen; var max: resumen);
begin
	if(r.cantidad_vendida > max.cantidad_vendida) then
		max:= r;
end;
	
procedure mayorCantidad(var a: arr_suc);
var
	min, r, maxR: resumen;
	arr: arr_reg;
	i: integer;
begin
	for i:= 1 to n do begin
		reset(a[i]);
		leer(a[i], arr[i]);
	end;
	maxR.cantidad_vendida:= -1;
	minimo(arr, a, min);
	while(min.cod_farmaco <> valoralto) do begin
		r:= min;
		r.cantidad_vendida:= 0;
		while(min.cod_farmaco = r.cod_farmaco) and (min.fecha = r.fecha) do begin
			r.cantidad_vendida := r.cantidad_vendida + min.cantidad_vendida;
			minimo(arr, a, min);
		end;
		writeln(r.cantidad_vendida);
		maximo(r, maxR);
	end;
	for i:= 1 to n do
		close(a[i]);
	informarResumen(maxR);
end;

procedure asignarArchivos(var a: arr_suc);
var
	i: integer;
	aux: string;
begin
	for i:= 1 to n do begin
		str(i, aux);
		assign(a[i], 'archivo_'+aux);
	end;
end;

procedure cargarArchivos(var a: arr_suc);

	procedure leerResumen(var r: resumen);
	begin
		writeln('-----');
		write('Ingrese cod. farmaco: ');readln(r.cod_farmaco);
		if(r.cod_farmaco <> -1) then begin
			write('Ingrese nombre: ');readln(r.nombre);
			write('Ingrese fecha: ');readln(r.fecha);
			write('Ingrese cantidad vendida: ');readln(r.cantidad_vendida);
			write('Ingrese forma de pago: ');readln(r.forma_pago);
		end;
		writeln('-----');
	end;

var
	r: resumen;
	i: integer;
begin
	for i:= 1 to n do begin
		writeln('-- Cargando archivo: ',i,' --');
		rewrite(a[i]);
		leerResumen(r);
		while(r.cod_farmaco <> -1) do begin
			write(a[i], r);
			leerResumen(r);
		end;
		close(a[i]);
		clrscr;
	end;
end;

var
	a: arr_suc;
BEGIN
	asignarArchivos(a);
	//cargarArchivos(a);
	mayorCantidad(a);
END.

