program trabajoInstaPas;

Uses 
    sysutils, DateUtils, crt;


const MAX= 15;
    UbiArchivoUsuario = '/home/Mayra/Documentos/PAscal/ArchivoUsua.dat';
    UbiArchivoHistorias= '/home/Mayra/Documentos/PAscal/ArchivoHisto.dat';
    UbiArchivoSeguidos= '/home/Mayra/Documentos/PAscal/archivoSeguidos.dat'; 


type
    Dato=string[8];
    listHistorias=^nodoHistoria;
    nodoHistoria=record
        fecha:TDateTime;
        texto:string[150];
        sig:listHistorias
    end;
    
    arbUsuarios=^nodoArbol;
    nodoArbol=record
        Nombre:Dato;
        password:Dato;
        email:string;
        usuarios:arbUsuarios;
        historias:listHistorias;
        izq, der:arbUsuarios
    end;

    Usuario=record
        seguidor:Dato;
        seguido:string
    end;

    archUsurarios=record
        Nombre:Dato;
        password:Dato;
        email:string
    end;

    archHistorias=record
        tipoFecha:TDateTime;
        texto:string
    end;
    
    archSeguidos=record
        nombredeUsuario:Usuario
    end;
    archUsu=file of archUsurarios;
    archSeg=file of archSeguidos;
    archHist=file of archHistorias;

/////////////////////////////////////////////Definicion de variables///////////////////////////////////////////////
var Arbol:arbUsuarios;
        Lista:arbUsuarios;
        ArchSegui:archSeg;
        ArchHisto:archHist;
        ArchUsuario:archUsu;


/////////////////////// BUSQUEDA USUARIO //////////////////////////////////////////////////////

{
    verifica que el usuario exista y en caso de hacerlo devuelve el puntero a ese usuario caso contrario nil.
}
function BusquedaUser(Arbol:arbUsuarios; NomUser:Dato):arbUsuarios;
begin
    if Arbol= nil then
        BusquedaUser:=nil
    else
        if Arbol^.Nombre=NomUser then
            BusquedaUser:= Arbol
        else
            if Arbol^.Nombre<NomUser then
                BusquedaUser:=BusquedaUser(Arbol^.der,NomUser)
            else
                BusquedaUser:= BusquedaUser(Arbol^.izq,NomUser)
end;


///////////////////////////////// METODOS NIVEL 2 /////////////////////////////////////////////

procedure eliminarNodoLista(var aBorrar, seguidores: arbUsuarios);
begin
    if (seguidores <> nil) then
        begin
            if (seguidores^.nombre = aBorrar^.nombre) then
                begin
                    seguidores := seguidores^.usuarios;
                    aBorrar^.usuarios := nil;
                end
            else
                eliminarNodoLista(aBorrar, seguidores^.usuarios);
        end;
end;

function usuarioSeguido(seguidores: arbUsuarios; nombreSeguidor: Dato):boolean;
begin
    if (seguidores = nil) then
        begin
            usuarioSeguido := false;
        end
    else
        if (seguidores^.Nombre = nombreSeguidor) then
            usuarioSeguido := true
        else
            usuarioSeguido:= usuarioSeguido(seguidores^.usuarios, nombreSeguidor);
        
end;

{
 Eliminar un usuario de mi lista de seguir. Verificar que esté en mi lista.   
}

procedure EliminarSeguidor(var Arbol:arbUsuarios; var usuarioLogueado: arbUsuarios);
var nombSeguidor:Dato; puntSeguidor: arbUsuarios;
begin
    writeLn('Indique el nombre del usuario a que quiere dejar de seguir.');
    readLn(nombSeguidor);
    puntSeguidor := BusquedaUser(Arbol, nombSeguidor);
    if (puntSeguidor <> nil) then
        begin
            if (usuarioSeguido(usuarioLogueado^.usuarios, nombSeguidor)) then
                begin
                    eliminarNodoLista(puntSeguidor, usuarioLogueado^.usuarios);
                    writeln('Usuario eliminado de la lista de seguidores. (presione una tecla para continuar)');
                end;
            //insertarOrdenadoListaSeguidores(usuarioLogueado^.usuarios, puntNuevoSeguidor);
            readln();
        end
    else
        writeLn('el usuario no existe.')
end;

procedure insertarOrdenadoListaSeguidores(var seguidores:arbUsuarios; nuevoSeguidor: arbUsuarios);
begin
    if (seguidores = nil) or (seguidores^.nombre > nuevoSeguidor^.nombre) then
        begin
            nuevoSeguidor^.usuarios := seguidores; 
            seguidores := nuevoSeguidor;
        end
    else
        insertarOrdenadoListaSeguidores(seguidores^.usuarios,nuevoSeguidor);
end;

{
    Agregar un usuario a mi lista de seguir. Verificar que exista y no esté en mi lista.
}

procedure AgregarSeguidor(var Arbol:arbUsuarios; usuarioLogueado: arbUsuarios);
var nombNuevoSeguidor:Dato; puntNuevoSeguidor: arbUsuarios;
begin
    writeLn('Indique el nombre del usuario a seguir.');
    readLn(nombNuevoSeguidor);
    puntNuevoSeguidor := BusquedaUser(Arbol, nombNuevoSeguidor);
    if (puntNuevoSeguidor <> nil) then
        begin
            insertarOrdenadoListaSeguidores(usuarioLogueado^.usuarios, puntNuevoSeguidor);
            writeln('Usuario agregado a la lista. (presione una tecla para continuar)');
            readln();
        end
    else
        writeLn('el usuario no existe.')
end;


{
    Listar los usuarios que sigo
}

procedure ListarSeguidores(seguidores:arbUsuarios);
begin
    if (seguidores <> nil) then
        begin
            writeLn('Seguidor : ', seguidores^.nombre);
            ListarSeguidores(seguidores^.usuarios);
        end
end;

function insertarPrimero(var historias: listHistorias; nuevaHistoria: listHistorias):listHistorias;
begin
    nuevaHistoria^.sig := historias;
    historias := nuevaHistoria;
end;

{
    Escribir una historia: se pide el texto y se carga en la lista incorporando la fecha y hora actual. 
}
procedure escribirHistoria(var usuarioLogueado: arbUsuarios);
var texto:string[150]; auxNodoHistoria: listHistorias;
begin
    auxNodoHistoria := nil;
    writeLn('Ingrese el mensaje de la historia');
    readLn(texto);
    new(auxNodoHistoria);
    auxNodoHistoria^.texto := texto;
    auxNodoHistoria^.fecha := Now;
    auxNodoHistoria^.sig := nil;
    insertarPrimero(usuarioLogueado^.historias, auxNodoHistoria);
end;

procedure mostrarHistorias(historias:listHistorias; fechaInicial: TDateTime);
begin
    if (historias <> nil) then
        begin
            if (historias^.fecha >= fechaInicial) then
                begin
                    writeLn('Historia : ', historias^.texto);
                end;
            mostrarHistorias(historias^.sig, fechaInicial);
        end
end;

procedure recorrerSeguidores(seguidores: arbUsuarios; fechaInicial: TDateTime);
begin
    writeLn('recorrerSeguidores');
    if (seguidores <> nil) then
        begin
            writeln('entra aca ?');
            mostrarHistorias(seguidores^.historias, fechaInicial);
            recorrerSeguidores(seguidores^.usuarios, fechaInicial);
        end
end;

{
    Listar las historias de los últimos xxx días de los usuarios que sigo. 
    Esta opción primero solicita al usuario la cantidad de días hacia atrás que desea ver, 
    luego muestra por pantalla todas las historias que escribieron los usuarios que sigo desde esa fecha inicial hasta ahora, 
    para cada uno se muestra, usuario, fecha-hora, e historia. El orden es por usuario (alfabético) y de último a primero por fecha-hora.
}
procedure ListarHistorias(usuarioLogueado: arbUsuarios);
var diasAtras: integer; fechaInicial, Tiempo2: TDateTime;
begin
    Tiempo2 := Now;
    writeLn('Ingrese la cantidad de dias hacia atras que desea ver');
    readLn(diasAtras);
    fechaInicial := IncDay(Now, -diasAtras);
    recorrerSeguidores(usuarioLogueado^.usuarios, fechaInicial);
end;


////////////////////////////////// NIVEL 2 ////////////////////////////////////////////////

procedure Nivel_2(var Arbol: arbUsuarios; usuarioLogueado:arbUsuarios);
var Opcion: integer;
    Salir: boolean;
begin
    Salir:=True;
    while Salir=True do begin
        writeln('NIVEL 2');
        writeln('1) Listar las historias de los últimos xxx días de los usuarios que sigo.');
        writeln('2) Escribir una historia');
        writeln('3) Listar los usuarios que sigo');
        writeln('4) Agregar un usuario a mi lista de seguir');
        writeLn('5) Eliminar un usuario de mi lista de seguir');
        writeLn('6) Logout');
        readln(Opcion);
        clrscr;
        case Opcion of 
            1:ListarHistorias(usuarioLogueado);
            2:escribirHistoria(usuarioLogueado);
            3:ListarSeguidores(usuarioLogueado^.usuarios);
            4:AgregarSeguidor(Arbol, usuarioLogueado);
            5:EliminarSeguidor(Arbol, usuarioLogueado);
            6:Salir:=False;
        end;
    end;
end;

function verificaUsuarioLogin(Usuario:arbUsuarios; Pass:Dato) : boolean;
begin
    if Usuario^.password = Pass then
        verificaUsuarioLogin := true
    else
        verificaUsuarioLogin := false;
end;

// Verifica que el usuario se encuentre en el arbol y la contraseña sea correcta //
procedure Login(var Arbol:arbUsuarios);
var Usuario:Dato; Pass:Dato; NodoUsuario: arbUsuarios;
begin
    writeLn('Ingresar nombre usuario');
    readln(Usuario);
    writeLn('Ingresar contraseña');
    readln(Pass);
    NodoUsuario := BusquedaUser(Arbol, Usuario);
    if NodoUsuario <> nil then
        begin
            if verificaUsuarioLogin(NodoUsuario, Pass) then
                Nivel_2(Arbol, nodoUsuario)
            else
                writeLn('pasword incorrecta');
        end
    else
        writeLn('Usuario invalido')
end;

procedure InsertarOrdenado(var Arbol: arbUsuarios; nuevoUsuario: arbUsuarios);
begin
    if (Arbol <> nil) then
        begin
            if (Arbol^.nombre > nuevoUsuario^.nombre) then
                InsertarOrdenado(Arbol^.izq, nuevoUsuario)
            else
                InsertarOrdenado(Arbol^.der, nuevoUsuario)
        end
    else
        Arbol:= nuevoUsuario;
end;

procedure CrearUsuario(var Arbol: arbUsuarios);
var Usuario, Pass, email: Dato; nuevoUsuario: arbUsuarios;
begin
    writeLn('Ingresar nombre usuario');
    readLn(Usuario);
    writeLn('Ingresar password');
    readLn(Pass);
    writeLn('Ingresar email');
    readLn(email);
    nuevoUsuario := BusquedaUser(Arbol, Usuario);
    if (nuevoUsuario = nil) then
        begin
            // Crear nodo
            new(nuevoUsuario);
            nuevoUsuario^.Nombre := Usuario;
            nuevoUsuario^.password := Pass;
            nuevoUsuario^.email := email;
            nuevoUsuario^.usuarios := nil;
            nuevoUsuario^.historias := nil;
            nuevoUsuario^.izq := nil;
            nuevoUsuario^.der := nil;
            InsertarOrdenado(Arbol, nuevoUsuario);
        end
    else
        writeLn('Usuario ya registrado')
    
end;

// Función recursiva para contar usuarios en un árbol binario ordenado
function CantUsuarios(Arbol: arbUsuarios): Integer;
var
  izquierdaCount, derechaCount: Integer;
begin
  // Caso base: el nodo es nil (hoja)
  if Arbol = nil then
    CantUsuarios := 0
  else
      begin
        // Recursivamente contar usuarios en el subárbol izquierdo y derecho
        izquierdaCount := CantUsuarios(Arbol^.izq);
        derechaCount := CantUsuarios(Arbol^.der);
    
        // Sumar el Arbol actual y los contadores de los subárboles
        CantUsuarios := 1 + izquierdaCount + derechaCount;
      end;
end;


procedure CantidadUsuarios(Arbol: arbUsuarios);
begin
    writeLn('Cantidad total de Usuarios : ', CantUsuarios(Arbol));
    writeLn('Presione cualquier tecla para continuar ');
    readLn();
    clrscr;
end;

function cantSeguidos(usuario: arbUsuarios): integer;
var Aux:Integer;
begin
    Aux:=0;
    if usuario<>nil then begin
        Aux:=Aux+1;
        Aux:=Aux+cantSeguidos(usuario^.usuarios);
    end;
    cantSeguidos:=Aux;
end;

// Función recursiva para contar cantidad de seguidores
function cantSeguidoresUsuario(Arbol: arbUsuarios) : integer;
var izquierdaCount, derechaCount: Integer;
begin
    // Caso base: el nodo es nil (hoja)
    if Arbol = nil then
        cantSeguidoresUsuario := 0
    else
        begin
            // Recursivamente contar usuarios en el subárbol izquierdo y derecho
            izquierdaCount := cantSeguidoresUsuario(Arbol^.izq);
            derechaCount := cantSeguidoresUsuario(Arbol^.der);
        
            // Sumar el Arbol actual y los contadores de los subárboles
            cantSeguidoresUsuario := cantSeguidos(Arbol^.usuarios) + izquierdaCount + derechaCount;
        end;
end;

procedure PromedioSeguidores(Arbol: arbUsuarios);
var cantUsuarios:integer;
begin
    writeLn('PromedioSeguidores');
    writeLn(cantSeguidoresUsuario(Arbol));
    readLn();
    clrscr;
end;

// BORRAR //
procedure imprimirPostOrder(Arbol:arbUsuarios);
var numero:integer;
begin
    if (Arbol <> nil) then
        begin
            imprimirPostOrder(Arbol^.izq);
            imprimirPostOrder(Arbol^.der);
            writeLn(Arbol^.nombre);
        end;
end;

procedure Nivel_1 (var ArchSegui:archSeg;var ArchHisto:archHist;var ArchUsuario:archUsu;var Arbol:arbUsuarios;var Lista:arbUsuarios);
var 
    Opcion: integer;
    Salir:Boolean;
begin
    Salir:=True;
    while Salir=True do begin
        writeln('Bienvenido');
        writeln(('1)Login'),'                           ', ('2)Crear NuevoUsuario  '));
        writeln(('3)Cantidad total de Usuarios '),('4) Cantidad promedio de Usuarios   '));
        writeln(('5) Mostrar Historias'),('6)Salir y guardar datos'));
        readln(Opcion);
        clrscr;
        case Opcion of 
            1:Login(Arbol);
            2:CrearUsuario(Arbol);
            3:CantidadUsuarios(Arbol);
            4:PromedioSeguidores(Arbol);
            //5:UsuarioHistorias(ArchHisto)
            6:Salir:=False;
            7:imprimirPostOrder(Arbol);
        end;
    end;
    //Salir(ArchSegui,ArchHisto,ArchUsuario,Arbol,Lista);
    writeln('Programa Finalizado');
end;

// PROGRAMA PRINCIPAL //

begin
    writeLn('programa principal');
    Nivel_1(ArchSegui, ArchHisto, ArchUsuario, Arbol, Lista);
end.