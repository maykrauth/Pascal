pprogram ejercicio7;
{ordenar matriz de for descendente por columna de acuerdo a la cantidad de ceros}
uses
    crt;
const
    MAXFIL=6;
    MAXCOL= 5;
type mat=array[1..MAXFIL, 1..MAXCOL]of integer;

var matNum: mat;

procedure cargarMatriz(var matNum:mat);
var fi, co:integer;
begin
    for fi:=1 to MAXFIL do
    begin
        for co:=1 to MAXCOL do 
        begin
            writeln('ingresar numeros de 0 al 9, la fila  ', fi, ' y columna', co );
            readln(matNum[fi,co]);
            if (matNum[fi,co] > 9) then
            begin
                writeln('invalido vuelva a ingresar un numero');
                readln(matNum[fi,co]);
            end;
        end;
        
    end;
    clrscr;
end;

function cantCeros(matNum:mat; col:integer):integer;
var fi, contador:integer;
begin
    contador:= 0;
    for fi:=1 to MAXFIL do
    begin
        if (matNum[fi,col] = 0) then
        begin
            contador:=contador +1
        end;
    end;
    cantCeros:=contador;
end;
procedure intercambio(var matNum:mat; col, fil:integer);
var fi, aux:integer;
begin
    for fi:=fil to MAXFIL-1 do 
    begin
        aux:=matNum[fi,col];
        matNum[fi,col]:= matNum[fi+1, col];
        matNum[fi+1, col]:=aux
    end;
end;
procedure ordenarColumna(var matNum:mat);
var col, fil, cantNulos,  indice:integer;
begin
    for col:=1 to MAXCOL do 
    begin
        cantNulos:=cantCeros(matNum, col);
        if (cantNulos <> 0) then 
        begin
            for indice:=1 to cantNulos do 
            begin
                for fil:=1 to MAXFIL do
                begin
                    if (matNum[fil,col]=0) then
                        intercambio(matNum,col,fil)
                end;
            end; 
        end;
    end;
end;
procedure intercambioColumna(var matNum:mat; col:integer);
var indice, aux:integer;
begin
    for indice:=1 to MAXFIL do
    begin
        aux:=matNum[indice,col];
        matNum[indice,col]:=matNum[indice,col+1];
        matNum[indice,col+1]:=aux;
    end;
end;
procedure procesarMatriz(var matNum:mat);
var col, indice, colMenor, colMayor:integer;
begin
    for indice:=1 to MAXCOl-1 do
    begin
        for col:=1 to MAXCOL-1 do
        begin
            colMenor:=col;
            colMayor:=col+1;
            if (cantCeros(matNum,colMenor) > cantCeros(matNum, colMayor)) then
                intercambioColumna(matNum, colMenor);
        end;
    end;
end;
procedure imprimirPorCondola(matNum:mat);
var fi, co:integer;
begin
    for fi:=1 to MAXFIL do 
    begin
        for co:=1 to MAXCOL do 
        //write('ordenamiento matriz');
        writeln(matNum[fi,co]);
    end;
end;
begin
    cargarMatriz(matNum);
    ordenarColumna(matNum);
    procesarMatriz(matNum);
    imprimirPorCondola(matNum);
end.