
program funcionesArbol;
{$INCLUDE/IntroProg/Estructu}

const max= 2;
type punteroArbol=^nodoArbol;
    nodoArbol=record
    DNI:string[15];
    NUsuario:string[15];
    izq,der:punteroArbol
    end;
    archivo_arbol=record
        usudni:string[15];
        usuario:string[15]
    end;
    archivoDeDatos=file of archivo_arbol;
var 
    arbol:punteroArbol;
    tipoArch:file of archivo_arbol;
    ingresarDNI:string[15];
    
    


procedure AgregarDatos(var archivo:archivoDeDatos );
var
    ubiArchivo:string[30];
    registro:archivo_arbol;
    valordni,valorUs:string[15];
    min:integer;
   
begin
//aca tengo ptoblemas
    ubiArchivo:='/work/krauth_enteros.dat';
    
    assign(archivo,ubiArchivo);
    rewrite(archivo);
    for min:=1 to max do
    begin
        writeln('ingresar dni');
        readLn(valordni);
        writeln('ingresar usuario');
        readLn(valorUs);
        registro.usudni:=valordni;
        registro.usuario:= valorUs;
        write(archivo, registro);
    
    end;
    close(archivo); 
end;
procedure insertarnodoArbol(var rearchivo:archivo_arbol; var reTipoArbol:punteroArbol);
var nodoAux:punteroArbol;
    
begin
    if(reTipoArbol <> nil) then
    begin
        if (reTipoArbol^.DNI > rearchivo.usudni) then
            insertarnodoArbol(rearchivo, reTipoArbol^.izq)
        else
            insertarnodoArbol(rearchivo, reTipoArbol^.der);
    end
    else
        begin
        
            new(nodoAux);
            nodoAux^.DNI:= rearchivo.usudni;
            nodoAux^.NUsuario:=rearchivo.usuario;
            nodoAux^.izq:= nil;
            nodoAux^.der:= nil;
            reTipoArbol:= nodoAux;
        end;

end;

procedure cargarArbol(var reAch:archivoDeDatos; var arbolDat:punteroArbol );
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






function punteroAlNodo(reArbol:punteroArbol; dato:string):punteroArbol;

begin
    if (reArbol = nil) then
            punteroAlNodo:=nil
    else
    if (reArbol^.DNI = dato) then 
        begin
            punteroAlNodo:=reArbol;
            write('entro?');
        end
        else 
        if (reArbol^.DNI < dato) then
            begin
                punteroAlNodo:=punteroAlNodo(reArbol^.der,dato);
            
            end
        else
            begin
                punteroAlNodo:=punteroAlNodo(reArbol^.izq,dato);
            
            end;
        
end;
procedure buscarNodo(prArbol:punteroArbol; datos:string);

var puntUsuario:punteroArbol;

begin
    puntUsuario:=punteroAlNodo(prArbol,datos);
    if puntUsuario <> nil then 
    writeln('El DNI ', datos,'tiene el usurio ', puntUsuario^.NUsuario)

    else 
    writeln('usuario no existe');
end;
begin
    // Estaria bueno que esta funcion se llamara CARGAR archivo.
    AgregarDatos(tipoArch);
    // El llamado de esta funcion no lo entiendo... porque le pasas registroAux ?
    //writeLn('registroAux');
    // registroAux no tiene nada...
    //writeLn(tipoArch.usudni);
    cargarArbol(tipoArch,arbol);
    writeln('Ingresar el dni solamente numeros test');
    readln(ingresarDNI);
    buscarNodo(arbol,ingresarDNI);
    
end.