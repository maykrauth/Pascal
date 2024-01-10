program final1;
{$INCLUDE/IntroProg/Estructu}
{Se tiene una matriz de enteros la cual esta separado por uno o mas ceros, se pide buscar la secuencia de mayor valor y ordenarlo de ascendentemente }
const
    MAXFIL=3;
    MAXCOL=3;
type
    mat=array[1..MAXFIL, 1..MAXCOL] of integer;

var matriz:mat; 
procedure cargarMatriz(var matriz:mat);
var fil,col:integer;
begin
    for fil:=1 to MAXFIL do
    begin
        for col:=1 to MAXCOL do 
        begin
            writeln('ingresa la secuencia de numeros del 1 al 9, el finde de la secuencia se separa por ceros fila ',fil,'columna ',col );
            readln(matriz[fil,col]);
        end;
    end;
    
end;
function inicProxSecuencia(matriz:mat; fil,col:integer):integer;
begin
    while (fil < MAXFIL) and (matriz[fil,col]= 0) do
        fil:= fil+1;
    inicProxSecuencia:=fil;
end;

function finalProxSecuencia(matriz:mat;fil,col:integer):integer;
begin
    while (fil <= MAXFIL) and (matriz[fil,col]<> 0) do
        fil:= fil+1;
    if (fil = 1) then
        finalProxSecuencia:=fil+1
    else
        finalProxSecuencia:=fil-1;
end;

function sumarSecuencia(matriz:mat; auxInic,auxfin,col:integer):integer;
var fil,suma:integer;
begin
    suma:= 0;
    for fil:=auxInic to auxFin do 
        suma:= suma + matriz[fil,col];
    sumarSecuencia:=suma;
end;

procedure mayorSecuencia(matriz:mat; var posInic, posFin, posCol:integer);
var auxInic, auxFin, fil, col, sumaParcial,sumaTotal:integer;
begin
    writeln('entra mayor');
    sumaTotal:=0;
    sumaParcial:=0;
    for col:= 1 to MAXCOL do 
    begin
        fil:= 1;
        while fil <= MAXFIL do 
            begin
                auxInic:=inicProxSecuencia(matriz, fil, col);
                auxFin:=finalProxSecuencia(matriz, auxInic,col);
                sumaParcial:=sumarSecuencia(matriz, auxInic, auxFin, col);
                writeln('auxInic : ', auxInic);
                writeln('auxFin : ', auxFin);
                writeln('sumaParcial : ', sumaParcial);
                writeln('col  : ', col);
                
                if sumaParcial > sumaTotal then 
                    begin
                        sumaTotal:= sumaParcial;
                        posInic:= auxInic;
                        posFin:= auxFin;
                        posCol:=col;
                        
                    end;
                
                fil:= auxFin + 1;
                writeln('fil  : ', fil);
                readln();
                if (fil = MAXFIL) and (matriz[fil,col] = 0) then 
                    fil:= fil + 1;
            end;
    end;
    
end;


procedure ordenarMat(var matriz:mat; inicio, final, colum:integer);
var fil, aux:integer;
begin
    for fil:=inicio to final -1 do
    begin
        while (matriz[fil,colum] >= matriz[fil+1, colum]) do
        begin
            {writeln(inicio);
            writeln(final);
            writeln(colum);}
            aux:=matriz[fil,colum];
            matriz[fil,colum]:=matriz[fil+1, colum];
            matriz[fil+1,colum]:=aux;
        end;
    end;
end;
procedure procesarMatriz(var matriz:mat);
var posInic, posFin, posCol:integer;
begin
    writeln('entro');
    mayorSecuencia(matriz,posInic,posFin, posCol);
    ordenarMat(matriz, posInic, posFin, posCol);
end;


procedure Imprimir_Mat(matriz:mat);
var fi,co:integer;
begin
    for fi:=1 to MAXFIL do
    begin
        for co:=1 to MAXCOL do 
        begin
            write(matriz[fi, co], ' ');
        end;
        writeln('')
    end;
end;

begin
    cargarMatriz(matriz);
    Imprimir_Mat(matriz);
    procesarMatriz(matriz);
    Imprimir_Mat(matriz);
end.