{

}


program ej_16_2024;
uses crt;
const
	n = 2;
	valoralto = 999;
type
	moto = record
		cod: integer;
		nombre: string[20];
		desc: string[50];
		modelo: integer;
		marca: string[20];
		stock: integer;
	end;
	
	venta = record
		cod: integer;
		precio: real;
		fecha: string[20];
	end;
	
	maestro = file of moto;
	detalle = file of venta;
	
	arr_det = array[1..n] of detalle;
	arr_reg = array[1..n] of venta;

procedure leer(var arch: detalle; var dato: venta);
begin
	if(not eof(arch)) then
		read(arch, dato)
	else
		dato.cod := valoralto;
end;

procedure minimo(var reg: arr_reg; var det: arr_det; var min: venta);
var
	i, iMin: integer;
begin
	iMin:= 0;
	min.cod:= valoralto;
	for i:= 1 to n do begin
		if(reg[i].cod <> valoralto) then begin
			if(reg[i].cod < min.cod) then begin
				iMin:= i;
				min:= reg[i];
			end;
		end;
	end;
	
	if(iMin <> 0) then 
		leer(det[iMin], reg[iMin]);
end;

procedure maximo(var maxM: moto; m: moto; var maxCant: integer; cant: integer);
begin
	if(cant > maxCant) then begin
		maxM:= m;
		maxCant:= cant;
	end;
end;

procedure imprimirMoto(m: moto);
begin
	writeln('-----');
	writeln('-> Codigo: ', m.cod);
	writeln('-> Nombre: ', m.nombre);
	writeln('-> Descripcion: ', m.desc);
	writeln('-> Modelo: ', m.modelo);
	writeln('-> Marca: ', m.marca);
	writeln('-> Stock: ', m.stock);
	writeln('-----');
end;

procedure actualizar(var arch: maestro; var arr: arr_det);
var
	min: venta;
	codActual, totVendida: integer;
	m, maxMoto: moto;
	maxCant: integer;
	reg: arr_reg;
	i: integer;
begin
	maxCant:= -1;
	for i:= 1 to n do begin
		reset(arr[i]);
		leer(arr[i], reg[i]);
	end;
	reset(arch);
	minimo(reg, arr, min);
	read(arch, m);
	while(min.cod <> valoralto) do begin
		codActual:= min.cod;
		totVendida:= 0;
		while(codActual = min.cod) do begin
			totVendida += 1;
			minimo(reg, arr, min);
		end;
		while(codActual <> m.cod) do
			read(arch, m);
		m.stock -= totVendida;
		maximo(maxMoto, m, maxCant, totVendida);
		
		seek(arch, filepos(arch)-1);
		write(arch, m);
	end;
	for i:= 1 to n do
		close(arr[i]);
	close(arch);
	writeln('La moto que tuvo mayor cantidad de unidades vendidas fue: ');
	imprimirMoto(maxMoto);
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
	procedure leerMoto(var m: moto);
	begin
		writeln('-----');
		write('Ingrese codigo: ');
		readln(m.cod);
		if(m.cod <> -1) then begin
			write('Ingrese nombre: ');
			readln(m.nombre);
			write('Ingrese descripcion: ');
			readln(m.desc);
			write('Ingrese modelo: ');
			readln(m.modelo);
			write('Ingrese marca: ');
			readln(m.marca);
			write('Ingrese stock: ');
			readln(m.stock);
		end;
		writeln('-----');
	end;
var
	m: moto;
begin
	writeln('-- Carga Maestro --');
	rewrite(arch);
	leerMoto(m);
	while(m.cod <> -1) do begin
		write(arch, m);
		leerMoto(m);
	end;
	close(arch);
	writeln('-----');
end;

procedure cargarDetalles(var arr: arr_det);
	procedure leerVenta(var v: venta);
	begin
		writeln('-----');
		write('Ingrese codigo: ');
		readln(v.cod);
		if(v.cod <> -1) then begin
			write('Ingrese fecha: ');
			readln(v.fecha);
			write('Ingrese precio: ');
			readln(v.precio);
		end;
		writeln('-----');
	end;
var
	v: venta;
	i: integer;
begin
	for i:= 1 to n do begin
		writeln('-- Cargando detalle: ',i,' --');
		rewrite(arr[i]);
		leerVenta(v);
		while(v.cod <> -1) do begin
			write(arr[i], v);
			leerVenta(v);
		end;
		close(arr[i]);
		writeln('-----');
	end;
end;

var
	arch: maestro;
	arr: arr_det;
BEGIN
	assign(arch, 'maestro');
	asignarDetalles(arr);
	cargarMaestro(arch);
	cargarDetalles(arr);
	actualizar(arch, arr);
END.

