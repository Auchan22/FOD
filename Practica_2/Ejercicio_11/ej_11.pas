{
Suponga que usted es administrador de un servidor de correo electrónico. En los logs del
mismo (información guardada acerca de los movimientos que ocurren en el server) que se
encuentra en la siguiente ruta: /var/log/logmail.dat se guarda la siguiente información:
nro_usuario, nombreUsuario, nombre, apellido, cantidadMailEnviados. Diariamente el servidor
de correo genera un archivo con la siguiente información: nro_usuario, cuentaDestino,
cuerpoMensaje. Este archivo representa todos los correos enviados por los usuarios en un día
determinado. Ambos archivos están ordenados por nro_usuario y se sabe que un usuario
puede enviar cero, uno o más mails por día.
}
program ej11_p2;
uses crt;
const
	MAX_DIA = 31;
	valoralto = 999;
type
	dias = 1..MAX_DIA;

	reg_m = record
		nro_usr: integer;
		nombre_usr: string[20];
		nombre: string[20];
		apellido: string[20];
		cant: integer;
	end;
	
	reg_d = record
		nro_usr: integer;
		cuentaDestino: string[20];
		cuerpoMensaje: string[100];
	end;
	
	maestro = file of reg_m;
	detalle = file of reg_d;
	
	arr_det = array[dias] of detalle;
	arr_reg = array[dias] of reg_d;
	
procedure cargarMaestro(var arch: maestro);
	procedure leerRegistro(var r: reg_m);
	begin
		writeln('-----');
		write('Ingrese nro de usuario: ');
		readln(r.nro_usr);
		if(r.nro_usr <> -1) then begin
			write('Ingrese nombre de usuario: ');
			readln(r.nombre_usr);
			write('Ingrese nombre de persona: ');
			readln(r.nombre);
			write('Ingrese apellido de persona: ');
			readln(r.apellido);
			write('Ingrese cantidad total de mails enviados: ');
			readln(r.cant);
		end;
		writeln('-----');
	end;
var
	r: reg_m;
begin
	writeln('-- Carga Maestro --');
	rewrite(arch);
	leerRegistro(r);
	while(r.nro_usr <> -1) do begin
		write(arch, r);
		leerRegistro(r);
	end;
	close(arch);
	writeln('-----');
end;

procedure asignarDetalles(var arr: arr_det);
var
	i: dias;
	aux: string;
begin
	for i:= 1 to MAX_DIA do begin
		str(i, aux);
		assign(arr[i],'detalle_dia_'+aux);
	end;
end;

procedure inicialiarDetalles(var arr: arr_det);
var
	i: dias;
begin
	for i:= 1 to MAX_DIA do begin
		rewrite(arr[i]);
		close(arr[i]);
	end;
end;

procedure cargarDetalles(var arr: arr_det);
	procedure leerRegistro(var r: reg_d);
		begin
		writeln('-----');
		write('Ingrese nro de usuario: ');
		readln(r.nro_usr);
		if(r.nro_usr <> -1) then begin
			write('Ingrese usuario destino: ');
			readln(r.cuentaDestino);
			write('Ingrese cuerpo del mensaje: ');
			readln(r.cuerpoMensaje);
		end;
		writeln('-----');
	end;
var
	r: reg_d;
	d: integer;
	loop: boolean;
begin
	writeln('-- Carga Detalles --');
	loop:= true;
	while(loop) do begin
		writeln('');
		write('Ingrese día a cargar (-1 para finalizar): ');
		readln(d);
		if(d <> -1) then begin
			rewrite(arr[d]);
			leerRegistro(r);
			while(r.nro_usr <> -1) do begin
				write(arr[d], r);
				leerRegistro(r);
			end;
			close(arr[d]);
		end
		else
			loop:= false;
	end;
	writeln('-----');
end;

procedure imprimirMaestro(var arch: maestro);
	procedure imprimirRegistro(r: reg_m);
	begin
		writeln('-----');
		writeln('-> Nro Usuario: ', r.nro_usr);
		writeln('-> Nombre Usuario: ', r.nombre_usr);
		writeln('-> Nombre: ', r.nombre);
		writeln('-> Apellido: ', r.apellido);
		writeln('-> Total mails enviados: ', r.cant);
		writeln('-----');
	end;
var
	r: reg_m;
begin
	reset(arch);
	while(not eof(arch)) do begin
		read(arch, r);
		imprimirRegistro(r);
	end;
	close(arch);
end;

procedure leer(var arch: detalle; var dato: reg_d);
begin
	if(not eof(arch)) then
		read(arch, dato)
	else
		dato.nro_usr := valoralto;
end;

procedure minimo(var reg: arr_reg; var det: arr_det; var min: reg_d);
var
	i, iMin: integer;
begin
	iMin:= 0;
	min.nro_usr := valoralto;
	for i:= 1 to MAX_DIA do begin
		if(reg[i].nro_usr <> valoralto) then begin
			if(reg[i].nro_usr < min.nro_usr) then begin
				iMin:= i;
				min:= reg[i];
			end;
		end;
	end;
	
	if(iMin <> 0) then begin
		leer(det[iMin], reg[i]);
	end;
end;

procedure actualizar(var arch_m: maestro; var arr: arr_det);
var
	min: reg_d;
	r: reg_m;
	i: integer;
	nroActual: integer;
	reg: arr_reg;
	tot: integer;
begin
	for i:= 1 to MAX_DIA do begin
		reset(arr[i]);
		leer(arr[i], reg[i]);
	end;
	reset(arch_m);
	read(arch_m, r);
	minimo(reg, arr, min);
	while(min.nro_usr <> valoralto) do begin
		nroActual:= min.nro_usr;
		tot:= 0;
		while(min.nro_usr = nroActual) do begin
			tot:= tot + 1;
			minimo(reg, arr, min);
		end;
		while(r.nro_usr <> nroActual) do
			read(arch_m, r);
		r.cant:= r.cant + tot;
		seek(arch_m, filepos(arch_m)-1);
		write(arch_m, r);
		if(not eof(arch_m)) then
			read(arch_m, r);
	end;
	for i:= 1 to MAX_DIA do
		close(arr[i]);
	close(arch_m);
end;

procedure leerMaestro(var arch: maestro; var dato: reg_m);
begin
	if(not eof (arch)) then
		read(arch, dato)
	else
		dato.nro_usr:= valoralto;
end;

procedure generarArchivo(var arch_m: maestro; var arr: arr_det);
var
	txt: Text;
	d: reg_d;
	r: reg_m;
	d: integer;
	nroActual, totActual: integer;
begin
	writeln('-----');
	write('Ingrese día para generar reporte (1-31): ');
	readln(d);
	if(d < 1) or (d > 31) then
		writeln('Ingrese un dia entre el 1 y 31')
	else begin
		reset(arr[d]);
		reset(arch_m);
		leerMaestro(arch_m, r);
		while r.nro_usr <> valoralto do begin
			nroActual:= r.nro_usr;
			read(arr[d], d);
			//Esto es si no existe en el detalle seleccionado
					
		end;
		close(arr[d]);
		close(arch_m);
	end;
	writeln('-----');
end;

BEGIN
	
	
END.

