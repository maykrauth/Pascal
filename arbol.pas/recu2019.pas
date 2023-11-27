program recu2019;
{$INCLUDE/IntroProg/Estructu}

const MAX= 10;
const UBICACION_ARCH = '/work/krauth_rec_2019.dat';
const MIN_ARRAY = 1;
const MAX_ARRAY = 5;


type punteroArbol=^nodoArbol;
    nodoArbol=record
        nombre:string;
        categoria:integer;
        listaCat:punteroArbol;
        izq,der:punteroArbol
    end;
    nodoArch=record
        nombre:string;
        categoria:integer
    end;
    arrayCategorias= array[MIN_ARRAY..MAX_ARRAY] of punteroArbol;
    archivoDeDatos=file of nodoArch;
var 
    arbol:punteroArbol;
    indiceCategorias: arrayCategorias;
    tipoArch: file of archivoDeDatos;
    
procedure cargarArchivo();
var
    archivo:archivoDeDatos;
    regArchArbol:nodoArch;
    min, auxCat:integer;
    auxNom:string;
begin
    assign(archivo,UBICACION_ARCH);
    rewrite(archivo);
    for min:=1 to MAX do
    begin
        writeLn('Ingresar nombre');
        readLn(auxNom);
        writeln('Ingresar categoria');
        readLn(auxCat);
        regArchArbol.nombre := auxNom;
        regArchArbol.categoria := auxCat;
        write(archivo, regArchArbol);
    
    end;
    close(archivo); 
end;

procedure imprimirArchivo();
var archivo:archivoDeDatos;
    regArchArbol:nodoArch;
begin
    assign(archivo,UBICACION_ARCH);
    reset(archivo);
    while not eof(archivo) do
        begin
            read(archivo, regArchArbol);
            writeLn('Nombre : ', regArchArbol.nombre);
            writeLn('Categoria : ', regArchArbol.categoria);
        end;
    close(archivo);
end;

procedure insertarOrdenadoLista(aInsertar: punteroArbol; var inicioLista: punteroArbol);
begin
    writeLn('InsertarOrdenadoLista');
    if (inicioLista = nil) or (inicioLista^.nombre > aInsertar^.nombre) then
        begin
            aInsertar^.listaCat := inicioLista; 
            inicioLista := aInsertar;
        end
    else
        insertarOrdenadoLista(aInsertar, inicioLista^.listaCat);
end;

procedure eliminarNodoLista(var aBorrar, inicioLista: punteroArbol);
var nodoAux: punteroArbol;
begin
    writeLn('eliminar nodo lista');
    if (inicioLista <> nil) then
        begin
            if (inicioLista^.nombre = aBorrar^.nombre) then
                begin
                    inicioLista := inicioLista^.listaCat;
                    aBorrar^.listaCat := nil;
                end
            else
                eliminarNodoLista(aBorrar, inicioLista^.listaCat);
        end;
end;

procedure insertarOrdenadoArbol(nuevoReg:nodoArch; var arbol:punteroArbol; var indiceCategorias : arrayCategorias);
var nodoAux:punteroArbol;
begin
    if(arbol <> nil) then
        begin
            if (arbol^.nombre > nuevoReg.nombre) then
                insertarOrdenadoArbol(nuevoReg, arbol^.izq, indiceCategorias)
            else if (arbol^.nombre < nuevoReg.nombre) then
                insertarOrdenadoArbol(nuevoReg, arbol^.der, indiceCategorias)
            else
                begin
                    writeLn('SON IGUALES');
                    if (arbol^.categoria < nuevoReg.categoria) then
                        begin
                            writeLn('Es igual y mayor categoria');
                            eliminarNodoLista(arbol, indiceCategorias[arbol^.categoria]);
                            arbol^.categoria := nuevoReg.categoria;
                            // Actualizar reg
                            //indiceCategorias[nuevoReg.categoria]
                            insertarOrdenadoLista(arbol,indiceCategorias[nuevoReg.categoria]);
                        end;
                end;
        end
    else
        begin
            new(nodoAux);
            nodoAux^.nombre:= nuevoReg.nombre;
            nodoAux^.categoria:= nuevoReg.categoria;
            nodoAux^.listaCat:=nil;
            nodoAux^.izq:= nil;
            nodoAux^.der:= nil;
            insertarOrdenadoLista(nodoAux,indiceCategorias[nuevoReg.categoria]);
            arbol:= nodoAux;
         end;

end;

procedure generarArbol(var arbol:punteroArbol; var indiceCategorias : arrayCategorias);
var regAuxArch:nodoArch;
    archivo:archivoDeDatos;
begin
    assign(archivo,UBICACION_ARCH);
    reset(archivo);
    while not EOF(archivo) do 
        begin
            read(archivo,regAuxArch);
            insertarOrdenadoArbol(regAuxArch, arbol, indiceCategorias);
        end;
    writeLn('Arbol generado..');
    close(archivo);
end;

procedure imprimirPreOrder(arbol:punteroArbol);
var numero:integer;
begin
    if (arbol <> nil) then
        begin
            writeLn(arbol^.nombre);
            imprimirPreOrder(arbol^.izq);
            imprimirPreOrder(arbol^.der);
        end;
end;

procedure imprimirPostOrder(arbol:punteroArbol);
var numero:integer;
begin
    if (arbol <> nil) then
        begin
            imprimirPostOrder(arbol^.izq);
            imprimirPostOrder(arbol^.der);
            writeLn(arbol^.nombre);
        end;
end;

procedure inicializarArray(var indiceCategorias: arrayCategorias );
var min:integer;
begin
    for min:=MIN_ARRAY to MAX_ARRAY do
        begin
            indiceCategorias[min]:=nil;
        end;
    writeLn('Array inicializado en nil');
    writeLn(' ');
end;

procedure imprimirLista(lista:punteroArbol);
begin
    if (lista <> nil) then
        begin
            writeLn('Empleado : ', lista^.nombre);
            imprimirLista(lista^.listaCat);
        end
        
end;

procedure imprimirArray(indiceCategorias: arrayCategorias);
var min:integer;
begin
    for min:=MIN_ARRAY to MAX_ARRAY do
        begin
            writeLn('Categoria : ', min);
            imprimirLista(indiceCategorias[min]);
            writeLn(' ');
        end;
end;

    
// PROGRAMA PRINCIPAL //

begin
    writeLn('Programa principal');
    writeLn(' ');
    inicializarArray(indiceCategorias);
    cargarArchivo();
    writeLn('Archivo generado...');
    imprimirArchivo();
    generarArbol(arbol, indiceCategorias);
    imprimirPreOrder(arbol);
    writeLn(' ');
    imprimirArray(indiceCategorias);
end.