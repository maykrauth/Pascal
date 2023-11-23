program funcionesArbol;
{$INCLUDE/IntroProg/Estructu}


const max= 5;
// TIPOS DE DATOS de las variables 

type pArbol=^nodoarbol;
    nodoarbol=record
        dato:integer;
        izq,der:pArbol
    end;
    archivo_arbol=record
        num:integer
    end;
    archivoDeDatos=file of archivo_arbol;

// VARIABLES DONDE SE ALMACENAN LOS DATOS del programa principal
var arbol:pArbol;
    nuevoArchivo: archivoDeDatos;
    registro:archivo_arbol;

procedure AgregarDatos(var archivo:archivoDeDatos; var registroA:archivo_arbol );
var
    ubiArchivo:string;
    dato,min:integer;
begin
    ubiArchivo:='/work/krauth_enteros.dat';
    
    assign(archivo,ubiArchivo);
    rewrite(archivo);
    for min:=1 to max do
    begin
        writeln('Fila DADA');
        read(dato);
        registroA.num := dato;
        write(archivo, registroA);
        dato:=0;
    end;
    close(archivo); 
end;

procedure mostrarPorConsola(var proximoArchivo:archivoDeDatos; var nuevoArchivo:archivo_arbol);
var 
    url:string[25];
begin
    writeln('Fila asdfsdafasdf');
    url:='/work/krauth_enteros.dat';
    assign(proximoArchivo, url);
    reset(proximoArchivo);
    while not EOF (proximoArchivo) do 
    begin
        
        read(proximoArchivo,nuevoArchivo);
        writeLn(nuevoArchivo.num);
    end;
    close(proximoArchivo);
end;

procedure insertarnodoArbol(var registroAux:archivo_arbol; var reArbol:pArbol);
var nodoAux:pArbol;
begin
    if(reArbol <> nil) then
    begin
        if (reArbol^.dato < registroAux.num) then
            insertarnodoArbol(registroAux, reArbol^.izq)
        else
        begin
            insertarnodoArbol(registroAux, reArbol^.der);
            writeln('Fila MAYOT');
        end
    end
    else
    begin
    writeln('Fila ENTRO');
        new(nodoAux);
        nodoAux^.dato := registroAux.num;
        nodoAux^.izq := nil;
        nodoAux^.der := nil;
        reArbol := nodoAux;
    end;

end;

procedure cargarArbol(var reAch:archivoDeDatos; var arbolDat:pArbol );
var reRegistro:archivo_arbol;
begin
    assign(reAch,'/work/krauth_enteros.dat');
    reset(reAch);
    while not EOF(reAch) do 
    begin
        read(reAch,reRegistro);
        insertarnodoArbol(reRegistro, arbolDat);
    end;
    close(reAch);
end;


{procedure imprimirArbolPreOrden(reOrdenArbol:pArbol);
begin
    if (reOrdenArbol <> nil) then 
        begin
            writeln(reOrdenArbol^.dato);
            imprimirArbolPreOrden(reOrdenArbol^.izq);
            imprimirArbolPreOrden(reOrdenArbol^.der);
        end;
end;}

{procedure imprimerArbolInorde(InordeArbol:pArbol);
begin
    if (InordeArbol <> nil) then
    begin
        imprimerArbolInorde(InordeArbol^.izq);
        writeln(InordeArbol^.dato);
        imprimerArbolInorde(InordeArbol^.der);
    end;
end;}
{procedure imprimerArbolPosOrden(PosArbol:pArbol);
begin
    if(PosArbol <> nil) then
    begin
        imprimerArbolPosOrden(PosArbol^.izq);
        imprimerArbolPosOrden(PosArbol^.der);
        writeln(PosArbol^.dato);
    end;
end;}

///// progrma principal 

begin
    arbol:=nil;
    AgregarDatos(nuevoArchivo,registro);
    mostrarPorConsola(nuevoArchivo,registro);
    cargarArbol(nuevoArchivo,arbol);
    //imprimirArbolPreOrden(arbol);
    //imprimerArbolInorde(arbol);
    //imprimerArbolPosOrden(arbol);
end.
////