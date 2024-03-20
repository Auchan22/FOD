{
8. Se tiene información en un archivo de las horas extras realizadas por los empleados de una
empresa en un mes. Para cada empleado se tiene la siguiente información: departamento,
división, número de empleado, categoría y cantidad de horas extras realizadas por el
empleado. Se sabe que el archivo se encuentra ordenado por departamento, luego por división,
y por último, por número de empleado. Presentar en pantalla un listado con el siguiente
formato:

Departamento
División
Número de Empleado Total de Hs. Importe a cobrar
...... .......... .........
...... .......... .........
Total de horas división: ____
Monto total por división: ____

División
.................

Total horas departamento: ____
Monto total departamento: ____

Para obtener el valor de la hora se debe cargar un arreglo desde un archivo de texto al
iniciar el programa con el valor de la hora extra para cada categoría. La categoría varía de 1
a 15. En el archivo de texto debe haber una línea para cada categoría con el número de
categoría y el valor de la hora, pero el arreglo debe ser de valores de horas, con la posición
del valor coincidente con el número de categoría.
}

program ej8_p2;
uses crt;
const
	valoralto = 999;
	n = 15;
type
	cat = 1..n;
	empleado = record
		departamento: integer;
		division: integer;
		nro: integer;
		categoria: cat;
		cantHoras: integer;
	end;
	
	valor = record
		valor: real;
		categoria: cat;
	end;
	
	arr_valores = array[cat] of real;
	
	archivo = file of empleado;
	
procedure cargarValores(var arr: arr_valores);
var
	txt: Text;
	v: valor;
begin
	Assign(txt, 'valores.txt');
	reset(txt);
	while(not eof(txt)) do begin
		readln(txt, v.categoria, v.valor);
		arr[v.categoria]:= v.valor;
	end;
	close(txt);
end;

procedure cargarMaestro(var arch: archivo);
	procedure leerEmpleado(var e: empleado);
	begin
		writeln('----');
		write('Ingrese departamento: ');
		readln(e.departamento);
		if(e.departamento <> -1) then begin
			write('Ingrese division: ');
			readln(e.division);
			write('Ingrese nro de empleado: ');
			readln(e.nro);
			write('Ingrese categoria (1..15): ');
			readln(e.categoria);
			write('Ingrese cant de horas: ');
			readln(e.cantHoras);
		end;
		writeln('----');
	end;
	
var
	e: empleado;
begin
	writeln('-- Iniciando carga --');
	rewrite(arch);
	leerEmpleado(e);
	while(e.departamento <> -1) do begin
		write(arch, e);
		leerEmpleado(e);
	end;
	close(arch);
	writeln('-----');
end;

procedure imprimirValores(arr: arr_valores);
var
	i: integer;
begin
	for i:= 1 to n do begin
		writeln('Categoria: ',i, ' valor: ', arr[i]:0:2);
	end;
end;

procedure leer(var arch: archivo; var dato: empleado);
begin
	if(not eof(arch)) then
		read(arch, dato)
	else
		dato.departamento := valoralto;
end;

procedure listar(var arch: archivo; arr: arr_valores);
var
	depActual, divActual, nroActual: integer;
	h_div, h_dep, h_emp: integer;
	m_div, m_dep, m_emp: real;
	e: empleado;
begin
	reset(arch);
	leer(arch, e);
	while(e.departamento <> valoralto) do begin
		depActual:= e.departamento;
		h_dep:= 0;
		m_dep:= 0;
		writeln('DEPARTAMENTO: ',depActual);
		writeln('');
		while(e.departamento = depActual) do begin
			m_div:= 0;
			h_div:= 0;
			divActual:= e.division;
			writeln('DIVISION: ',divActual);
			writeln('');
			writeln('NRO DE EMPLEADO | TOTAL HS | IMPORTE A COBRAR');
			while(e.departamento = depActual) and (e.division = divActual) do begin
				nroActual:= e.nro;
				h_emp:= 0;
				m_emp:= 0;
				while (e.departamento = depActual)
				and (e.division = divActual)
				and (e.nro = nroActual) do begin
					h_emp:= h_emp + e.cantHoras;
					m_emp:= e.cantHoras * arr[e.categoria];
					leer(arch, e);
				end;
				writeln(nroActual:15,'|',h_emp:10,'|',m_emp:17:2);
				h_div:= h_div + h_emp;
				m_div:= m_div + m_emp;
			end;
			h_dep += h_div;
			m_dep += m_div;
			writeln('TOTAL DE HORAS DIVISION: ',h_div);
			writeln('MONTO TOTAL POR DIVISION: ',m_div:0:2);
			writeln('');
		end;
		writeln('TOTAL HORAS DEPARTAMENTO: ', h_dep);
		writeln('MONTO TOTAL DEPARTAMENTO: ', m_dep:0:2);
		writeln('');
	end;
	close(arch);
end;

var
	arch: archivo;
	arr: arr_valores;
BEGIN
	Assign(arch, 'maestro');
	cargarValores(arr);
	//imprimirValores(arr);
	cargarMaestro(arch);
	listar(arch, arr);
END.

