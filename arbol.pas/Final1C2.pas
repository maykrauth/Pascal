program final2019;
{$INCLUDE/IntroProg/Estructu}

const
    M=2; //FIL
    N=2; //COL

type Secu= array[1..M,1..N]of integer;



procedure cargar_mat(var secuencia:Secu);
var fi, co:integer;
begin
    for fi:=1 to M do 
    begin
        for co:= 1 to N do
        begin
            writeln('Ingresar secuencias de numeros por fila ', fi, 'y por columna ', co);
            readln(secuencia[fi,co]);
        end;
    end;
end;
function sumaMatriz(posI, posF, columna:integer;secuencia:Secu):integer;
var contador, inicio:integer;
begin
    contador:=0;
    for inicio:=posI to posF do 
        contador:= contador + secuencia[inicio,columna];
    sumaMatriz:=contador;
end;
procedure buscarIndices(var secuencia:Secu; var indI, indF, col:integer);
var
    fi, co, posI, posF, columna, sumaMayor:integer;
begin
    sumaMayor:=0;
    for co:=1 to N do
    begin
        for fi:=1 to M do 
        begin
            if (secuencia[fi,co]<> 0)  and (fi >=  M) then 
            begin
                 writeln('entrabuscarindice');
                posI:=fi;
                columna:=co;
            end
            else
                posf:=fi;
            if (sumaMatriz(posI, posF, columna, secuencia) > sumaMayor) then
                begin
                    sumaMayor:=sumaMatriz(posI, posF, columna, secuencia);
                    indI:=posI;
                    indF:=posF;
                    col:=columna;
                end;
        end;
    end;
end;
procedure ordenarMatriz(var secuencia:Secu; indI,indF,col:integer);
var fi, aux:integer;
begin
    for fi:=indI to indF -1 do
    begin
    writeln('entraodenar');
        if(secuencia[fi,col] < secuencia[fi+1,col]) then
        begin
            aux:=secuencia[fi+1,col];
            secuencia[fi+1,col]:=secuencia[fi,col];
            secuencia[fi,col]:= aux;
        end;
    end;
end;
procedure procesarMatriz(var secuencia:Secu);
var indI, indF, col:integer;
begin
writeln('entra');
    buscarIndices(secuencia, indI, indF,col);
    ordenarMatriz(secuencia, indI, indF,col);
end;
procedure Imprimir_Mat(secuencia:Secu);
var fi,co:integer;
begin
    for fi:=1 to M do
    begin
        for co:=1 to N do 
        begin
            writeln(secuencia[fi, co], ' ');
        end;
    end;
end;
var
    secuencia:Secu;
begin
    cargar_mat(secuencia);
    procesarMatriz(secuencia);
    imprimir_mat(secuencia);
    
end.