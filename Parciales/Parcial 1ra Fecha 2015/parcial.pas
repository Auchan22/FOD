program parcial2015;
uses crt;
const
	n = 3;
	valoralto = 9999;
type
	producto = record
		cod: integer;
		codBarra: integer;
		categoria: integer;
		stockActual: integer;
		stockMin: integer;
		nombre: string[1];
		descripcion: string[1];
	end;
	
	pedido = record
		cod: integer;
		cant: integer;
		descripcion: string[50];
	end;
	
	detalle = file of pedido;
	maestro = file of producto;
	
	arr_suc = array[1..n] of detalle;
	arr_reg = array[1..n] of pedido;
	
procedure cargarMaestro(var m: maestro);
var
	txt: Text;
	p: producto;
begin
	assign(txt, 'productos.txt');
	reset(txt);
	rewrite(m);
	while(not eof(txt)) do begin
		readln(txt, p.cod, p.codBarra, p.categoria, p.stockActual, p.stockMin);
		readln(txt, p.nombre);
		readln(txt, p.descripcion);
		write(m, p);
	end;
	close(txt);
	close(m);
end;

procedure cargarDetalles(var d: arr_suc);
	procedure leerPedido(var p: pedido);
	begin
		writeln('-----');
		write('Ingrese cod de producto: ');readln(p.cod);
		if(p.cod <> -1) then begin
			write('Ingrese cantidad de producto: ');readln(p.cant);
			write('Ingrese descripcion de pedido: ');readln(p.descripcion);
		end;
		writeln('-----');
	end;
var
	i: integer;
	p: pedido;
begin
	for i:= 1 to n do begin
		writeln('-- Cargando detalle: ',i,' --');
		rewrite(d[i]);
		leerPedido(p);
		while(p.cod <> -1) do begin
			write(d[i], p);
			leerPedido(p);
		end;
		close(d[i]);
		writeln('-----');
		clrscr;
	end;
end;

procedure leerMaestro(var a: maestro; var d: producto);
begin
	if (not eof(a)) then
		read(a, d)
	else
		d.cod := valoralto;
end;

procedure imprimirInforme1(var i1: maestro);
var
	p: producto;
begin
	writeln('-- Productos que quedaron por debajo del stock minimo --');
	reset(i1);
	leerMaestro(i1, p);
	while(p.cod <> valoralto) do begin
		writeln('-----');
		writeln('-> Cod: ', p.cod);
		writeln('-> Categoria: ', p.categoria);
		writeln('-----');
		leerMaestro(i1, p);
	end;
	close(i1);
	writeln('-----');
end;

procedure imprimirInforme2(var i2: maestro);
var
	p: producto;
begin
	writeln('-- Productos que no se pudieron satisfacer --');
	reset(i2);
	leerMaestro(i2, p);
	while(p.cod <> valoralto) do begin
		writeln('-----');
		writeln('-> Cod: ', p.cod);
		writeln('-> Cantidad: ', p.stockActual);
		writeln('-----');
		leerMaestro(i2, p);
	end;
	close(i2);
	writeln('-----');
end;
	
procedure leer(var a: detalle; var d: pedido);
begin
	if not eof(a) then
		read(a, d)
	else
		d.cod := valoralto;
end;

procedure agregarInforme(var i: maestro; p: producto);
begin
	reset(i);
	seek(i, filesize(i));
	write(i, p);
	close(i);
end;

procedure minimo(var d: arr_suc; var reg: arr_reg; var min: pedido);
var
	i, iMin : integer;
begin
	iMin:= 0;
	min.cod := valoralto;
	for i:= 1 to n do begin
		if(reg[i].cod < min.cod) then begin
			iMin:= i;
			min:= reg[i];
		end;
	end;
	if(iMin <> 0) then
		leer(d[iMin], reg[iMin]);
end;

procedure actualizar(var a: maestro; var d: arr_suc; var i1,i2: maestro);
var
	i, diff: integer;
	p: producto;
	min: pedido;
	codActual, cantActual: integer;
	reg: arr_reg;
begin
	for i:= 1 to n do begin
		reset(d[i]);
		leer(d[i], reg[i]);
	end;
	reset(a);
	read(a, p);
	minimo(d, reg, min);
	while(min.cod <> valoralto) do begin
		codActual:= min.cod;
		cantActual:= 0;
		while(min.cod = codActual) do begin
			cantActual += min.cant;
			minimo(d, reg, min);
		end;
		while(p.cod <> codActual) do begin
			read(a, p);
		end;
		seek(a, filepos(a)-1);
		if(p.stockActual < cantActual) then begin
			//Se debe calcular la diff para generar el informe
			diff := cantActual - p.stockActual;
			p.stockActual := diff;
			agregarInforme(i2, p);
			p.stockActual := 0;
		end
		else
			p.stockActual:= p.stockActual - cantActual;
		if(p.stockActual < p.stockMin) then begin
			agregarInforme(i1, p);
		end;
		write(a, p);
	end;
	for i:= 1 to n do
		close(d[i]);
	close(a);
end;

procedure asignarDetalles(var d: arr_suc);
var
	i: integer;
	aux: string;
begin
	for i:= 1 to n do begin
		str(i, aux);
		assign(d[i], 'detalle'+aux);
	end;
end;

var
	m, i1, i2: maestro;
	d: arr_suc;
BEGIN
	assign(m, 'maestro');
	assign(i1, 'informe1');
	assign(i2, 'informe2');
	asignarDetalles(d);
	//cargarMaestro(m);
	//cargarDetalles(d);
	actualizar(m, d, i1, i2);
	imprimirInforme1(i1);
	imprimirInforme2(i2);
END.

