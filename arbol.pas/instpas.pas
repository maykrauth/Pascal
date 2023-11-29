program trabajoInstaPas;

Uses 
    sysutils, DateUtils, crt;


const MAX= 15;
    UbiArchivoUsuario = '/home/Mayra/Documentos/PAscal/ArchivoUsua.dat';
    UbiArchivoHistorias= '/home/Mayra/Documentos/PAscal/ArchivoHisto.dat';
    UbiArchivoSeguidos= '/home/Mayra/Documentos/PAscal/archivoSeguidos.dat'; 


type

    listHistorias=^nodoHistoria;
    nodoHistoria=record
        tipoFecha:TDateTime;
        texto:string[150];
        ste:listHistorias
    end;
    
    arbUsuarios=^nodoArbol;
    nodoArbol=record
        Nombre:string[15];
        password:string[8];
        email:string[15];
        usuarios:arbUsuarios;
        historias:listHistorias;
        izq, der:arbUsuarios
    end;

    {fecha=record
        dia:[1..30];
        mes:[1..12];
        anio:[2023];
        hora:string[15]
    end;}

    Usuario=record
        seguidor:string;
        seguido:string
    end;

    archUsurarios=record
        Nombre:string[15];
        password:string[8];
        emial:string[15]
    end;

    archHistorias=record
        tipoFecha:TDateTime;
        texto:string[150]
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


///////////////////////////////// METODOS NIVEL 2 /////////////////////////////////////////////


procedure mostrarHistorias(seguidores: arbUsuarios; fechaInicial: TDateTime);
begin
    writeLn('mostrarHistorias');
    if (seguidores <> nil) then
        begin
            writeLn('test')
        end;
end;

{
    Listar las historias de los últimos xxx días de los usuarios que sigo. 
    Esta opción primero solicita al usuario la cantidad de días hacia atrás que desea ver, 
    luego muestra por pantalla todas las historias que escribieron los usuarios que sigo desde esa fecha inicial hasta ahora, 
    para cada uno se muestra, usuario, fecha-hora, e historia. El orden es por usuario (alfabético) y de último a primero por fecha-hora.
}
procedure ListarHistorias(usuario: arbUsuarios);
var diasAtras: integer; fechaInicial, Tiempo2: TDateTime;
begin
    Tiempo2 := Now;
    writeLn('Ingrese la cantidad de dias hacia atras que desea ver');
    readLn(diasAtras);
    fechaInicial := IncDay(Now, -diasAtras);
    mostrarHistorias(usuario^.usuarios, fechaInicial);
end;


////////////////////////////////// NIVEL 2 ////////////////////////////////////////////////

procedure Nivel_2(var Arbol: arbUsuarios; usuarioLogueado:arbUsuarios);
var Opcion: integer;
    Salir: boolean;
begin
    Salir:=True;
    while Salir=True do begin
        writeln('NIVEL 2');
        writeln('1) Listar las historias de los últimos xxx días de los usuarios que sigo. Esta opción primero solicita al usuario la cantidad de días hacia atrás que desea ver, luego muestra por pantalla todas las historias que escribieron los usuarios que sigo desde esa fecha inicial hasta ahora, para cada uno se muestra, usuario, fecha-hora, e historia. El orden es por usuario (alfabético) y de último a primero por fecha-hora.');
        readln(Opcion);
        clrscr;
        case Opcion of 
            1:ListarHistorias(usuarioLogueado);
            //2:CrearUsuario(Arbol);
            //3:CantUsuario(Arbol);
            //4:PromedioSeguidores(Arbol)
            //5:UsuarioHistorias(ArchHisto)
            6:Salir:=False;
        end;
    end;
end;

function BusquedaUser(Arbol:arbUsuarios; NomUser:string):arbUsuarios;
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

function verificaUsuarioLogin(Usuario:arbUsuarios; Pass:string) : boolean;
begin
    if Usuario^.password = Pass then
        verificaUsuarioLogin := true
    else
        verificaUsuarioLogin := false;
end;

// Verifica que el usuario se encuentre en el arbol y la contraseña sea correcta //
procedure Login(var Arbol:arbUsuarios);
var Usuario:string[15]; Pass:string[8]; NodoUsuario: arbUsuarios;
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
                InsertarOrdenado(Arbol^.der, nuevoUsuario)
            else
                InsertarOrdenado(Arbol^.izq, nuevoUsuario)
        end
    else
        Arbol:= nuevoUsuario;
end;

procedure CrearUsuario(var Arbol: arbUsuarios);
var Usuario, Pass, email: string; nuevoUsuario: arbUsuarios;
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
var test : integer;
begin
    test := CantUsuarios(Arbol);
    writeLn('test ', test);
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