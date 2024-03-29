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
	n = 2;
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
	
	maestro = file of emision;
	detalle = file of venta;
	
	arr_det = array[1..n] of detalle;
	arr_reg = array[1..n] of venta;
	
procedure leer(var arch: detalle; var dato: venta);
begin
	if(not eof(arch)) then
		read(arch, dato)
	else
		dato.cod_semanario:= valoralto;
end;

procedure minimo(var reg: arr_reg; var det: arr_det; var min: venta);
var
	i, iMin: integer;
begin
	iMin:= 0;
	min.cod_semanario := valoralto;
	min.fecha:= 'ZZZ';
	for i:= 1 to n do begin
		if(reg[i].cod_semanario <> valoralto) then begin
			if(reg[i].fecha < min.fecha) or ((reg[i].fecha = min.fecha) and (reg[i].cod_semanario < min.cod_semanario)) then begin
				iMin:= i;
				min:= reg[i];
			end;
		end;
	end;
	
	if(iMin <> 0) then
		leer(det[iMin], reg[iMin]);
end;

procedure actualizar(var arch: maestro; var arr: arr_det);
var
	min: venta;
	e: emision;
	reg: arr_reg;
	i: integer;
	fechaActual: string;
	codActual, totVendido: integer;
begin
	for i:= 1 to n do begin
		reset(arr[i]);
		leer(arr[i], reg[i]);
	end;
	reset(arch);
	read(arch, e);
	minimo(reg, arr, min);
	while min.cod_semanario <> valoralto do begin
		fechaActual:= min.fecha;
		while(min.fecha = fechaActual) do begin
			codActual:= min.cod_semanario;
			totVendido:= 0;
			while(min.fecha = fechaActual) and (min.cod_semanario = codActual) do begin
				totVendido += min.cant_vendidos;
				minimo(reg, arr, min);
			end;
			while(e.cod_semanario <> codActual) or (e.fecha <> fechaActual) do
				read(arch, e);
			if(e.tot >= totVendido) then begin
				e.tot -= totVendido;
				e.tot_ven += totVendido;
				seek(arch, filepos(arch)-1);
				write(arch, e);
			end
			else
				writeln(' -- No se puede realizar la venta debido que se supera la cant disponible en: ', e.cod_semanario);
		end;
	end;
	for i:= 1 to n do
		close(arr[i]);
	close(arch);
end;

procedure asignarDetalles(var arr: arr_det);
var
	i: integer;
	aux: string;
begin
	for i:= 1 to n do begin
		str(i, aux);
		assign(arr[i], 'detalle_'+aux);
	end;
end;

procedure cargarMaestro(var arch: maestro);
	procedure leerEmision(var e: emision);
	begin
		writeln('-----');
		write('Ingresar fecha: ');
		readln(e.fecha);
		if(e.fecha <> 'ZZZ') then begin
			write('Ingresar codigo: ');
			readln(e.cod_semanario);
			write('Ingresar nombre: ');
			readln(e.nombre);
			write('Ingresar descripcion: ');
			readln(e.desc);
			write('Ingresar precio: ');
			readln(e.precio);
			write('Ingresar cant disponibles: ');
			readln(e.tot);
			write('Ingresar cant vendidas: ');
			readln(e.tot_ven);
		end;
		writeln('-----');
	end;
var
	e: emision;
begin
	rewrite(arch);
	writeln('-- Cargando maestro --');
	leerEmision(e);
	while(e.fecha <> 'ZZZ') do begin
		write(arch, e);
		leerEmision(e);
	end;
	writeln('-----');
	close(arch);
end;

procedure cargarDetalles(var arr: arr_det);
	procedure leerVenta(var v: venta);
	begin
		writeln('-----');
		write('Ingrese fecha: ');
		readln(v.fecha);
		if(v.fecha <> 'ZZZ') then begin
			write('Ingrese codigo: ');
			readln(v.cod_semanario);
			write('Ingrese cantidad vendidos: ');
			readln(v.cant_vendidos);
		end;
		writeln('-----');
	end;
var
	i: integer;
	v: venta;
begin
	for i:= 1 to n do begin
		rewrite(arr[i]);
		writeln('-- Cargando detalle: ',i,' --');
		leerVenta(v);
		while(v.fecha <> 'ZZZ') do begin
			write(arr[i], v);
			leerVenta(v);
		end;
		writeln('-----');
		clrscr;
		close(arr[i]);
	end;
end;

procedure imprimirMaestro(var arch: maestro);
	procedure imprimirEmision(e: emision);
	begin
		writeln('-----');
		writeln('-> Fecha: ', e.fecha);
		writeln('-> Cod: ', e.cod_semanario);
		writeln('-> Nombre: ', e.nombre);
		writeln('-> Descripcion: ', e.desc);
		writeln('-> Precio: ', e.precio:0:2);
		writeln('-> Total disponible: ', e.tot);
		writeln('-> Total vendidas: ', e.tot_ven);
		writeln('-----');
	end;
var
	e: emision;
begin
	reset(arch);
	while(not eof(arch)) do begin
		read(arch, e);
		imprimirEmision(e);
	end;
	close(arch);
end;	

procedure informarSemanarios(var arch: maestro);
var
	min, max, e: emision;
begin
	min.tot_ven:= 9999;
	max.tot_ven:= -1;
	reset(arch);
	while not eof(arch) do begin
		read(arch, e);
		if(e.tot_ven > max.tot_ven) then
			max:= e;
		if(e.tot_ven < min.tot_ven) then
			min:= e;
	end;
	close(arch);
	writeln('MAXIMO: ',max.fecha,' | ',max.cod_semanario);
	writeln('MINIMO: ',min.fecha,' | ',min.cod_semanario);
end;

var
	arch: maestro;
	arr: arr_det;
BEGIN
	assign(arch, 'maestro');
	asignarDetalles(arr);
	//cargarMaestro(arch);
	//cargarDetalles(arr);
	//imprimirMaestro(arch);
	//actualizar(arch, arr);
	//imprimirMaestro(arch);
	informarSemanarios(arch);
END.

