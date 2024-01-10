program final2;
{$INCLUDE/IntroProg/Estructu}
const 
    MAXMAT= 6;
    MAXARRE= 5;


type
    mat=array[1..MAXMAT, 1..MAXMAT] of char;
    arr=array[1..MAXARRE] of char;
var 
    matriz :mat;
    patron:arr;

{procedure cargarMatriz(var matriz:mat);
var fi, co:integer;
begin
    for fi:=1 to MAXMAT do 
    begin
        for co:=1 to MAXMAT do 
        begin
            writeln('Ingresar letras, para ingresar en la matriz. Fila ', fi,' y columna', co);
            readln(matriz[fi,co]);
        end;
    end;
end;

}
procedure cargarArreglo(var patron:arr);
var inic:integer;
begin
    for inic:=1 to MAXARRE do
    begin
        writeln('Ingresar una palabra, para buscar en la matriz');
        readln(patron[inic]);
    end;
end;

function detectarPalabra(matriz:mat; padron:arr; var inicM, inicA:integer; var condicion:boolean):boolean;

begin
    
    
    while (inicM <= MAXMAT) and (inicA <= MAXARRE) and(condicion <>  false) do 
    begin
        
        if (matriz[inicM, inicM] = patron[inicA]) then 
        begin
            inicM:=inicM + 1;
            inicA:=inicA + 1;
            detectarPalabra:=condicion;
            
        end
        else
        if (matriz[inicM, inicM] <> patron[inicA]) then
            condicion:= false;
    end;
    detectarPalabra:=condicion;
end;


procedure procesarMatriz(matriz:mat; patron:arr; var inicio, fin:integer);
var indMat, inicM, inicA :integer;
    encontrado,condicion:boolean;
begin
    
    indMat:= 1;
    encontrado:=false;
    while (indMat <= MAXMAT) and (encontrado = false)  do
    begin
        condicion:=true;
        inicA:= 1;
        inicM:= indMat;
        encontrado:= detectarPalabra(matriz, patron, inicM, inicA,condicion);
        if encontrado = false then
        begin
            indMat:= indMat + 1;
            inicA:= 1;
        end 
        else 
        if encontrado = true then
        begin
            fin:=abs( inicM - 1);
            inicio:= abs( MAXARRE - fin) + 1;  
            
        end;
    end;
end;

procedure corrimientoMat (var matriz:mat; patron:arr; inicio, fin:integer);
var inic, aux, indice, posI:integer;
begin
    inic:=inicio;
    indice:=fin;
    writeln('corrimiento', inic);
    if inic <>  1 then 
    
    for aux:= abs(indice - MAXARRE)  downto 1 do 
    begin
        writeln(inicio);
        writeln(fin);
        matriz[indice,indice]:=matriz[aux,aux];
        indice:=indice -1;
    end;
    for posI := 1 to MAXARRE do 
    begin
        matriz[posI,posI]:= patron[posI]
    end;
end;

procedure Imprimir_Mat(matriz:mat);
var fi,co:integer;
begin
    for fi:=1 to MAXMAT do
    begin
        for co:=1 to MAXMAT do 
        begin
            write(matriz[fi, co], ' ');
        end;
        writeln('')
    end;
end;

procedure procedimietoCompleto( var matriz:mat; patron:arr);
var inicio, fin:integer;
begin
    inicio:= 0;
    fin:= 0;
    procesarMatriz(matriz, patron, inicio, fin);
    writeLn('fasdfsdafasdfsad');
    writeln(inicio);
    Imprimir_Mat(matriz);
    if inicio <> 0 then
    begin
        writeln(inicio);
        corrimientoMat(matriz, patron, inicio, fin);
        Imprimir_Mat(matriz);
    end
    else
        writeln('No se encontro coincidencia');
    
end;

begin
    matriz[1,1] := 's';
    matriz[1,2] := 's';
    matriz[1,3] := 'o';
    matriz[1,4] := 'a';
    matriz[1,5] := 'j';
    matriz[1,6] := 'm';
    matriz[2,1] :='b';
    matriz[2,2] := 'a';
    matriz[2,3] :='t';
    matriz[2,4] := 'o';
    matriz[2,5] := 'n';
    matriz[2,6] := 'x';
    matriz[3,1] := 'z';
    matriz[3,2] := 'x';
    matriz[3,3] := 'l';
    matriz[3,4] := 'v';
    matriz[3,5] := 'w';
    matriz[3,6] := 'b';
    matriz[4,1] := 'u';
    matriz[4,2] := 'k';
    matriz[4,3] := 's';
    matriz[4,4] := 't';
    matriz[4,5] := 'a';
    matriz[4,6] := 'm';
    matriz[5,1] := 'l';
    matriz[5,2] := 's';
    matriz[5,3] := 'n';
    matriz[5,4] := 'j';
    matriz[5,5] := 'o';
    matriz[5,6] := 't';
    matriz[6,1] := 'r';
    matriz[6,2] := 'm';
    matriz[6,3] := 'k';
    matriz[6,4] := 'l';
    matriz[6,5] := 'o';
    matriz[6,6] := 'o';
    //cargarMatriz(matriz);
    Imprimir_Mat(matriz);
    cargarArreglo(patron);
    procedimietoCompleto(matriz, patron);