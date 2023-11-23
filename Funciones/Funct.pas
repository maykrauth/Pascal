program ingresarDatosAUnArchivo;

{INCLUDE/IntroProg/Estructu}

var 
    Arch:file of integer;
    dato:integer;
begin
    Assign(Arch, 'enteros.dat');
    Rewrite(Arch);
    Writeln('¿iNGRESE UN VALOR, PARA TERMINAR INGRESE 0');
    Read(dato);
    while(dato <> 0) do 
        begin
            write(arch, dato);
            writeln('Ingrese un valor, para terminar ingrese 0');
            Read(dato);
        end;
    clase(Arch);
end;