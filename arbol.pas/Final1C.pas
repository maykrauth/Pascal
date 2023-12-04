program final;

{$INCLUDE/IntroProg/Estructu}

const
    MAXFIL=4;
    MAXCOL=4;

type matriz=array[1..MAXFIL, 1..MAXCOL] of integer;

var 
    mat:matriz;

procedure cargarMatriz(var mat:matriz);
var fi, co:integer;
begin
    for fi:=1 to MAXFIL do 
    begin
        for co:=1 to MAXCOL do
        begin
            writeln('Insertar numeros en la matriz ', 'fila ', fi, ' y columna ', co );
            readln(mat[fi,co]);
        end;
        
    end;
end;
function promedioFila(fi:integer ; mat:matriz): real;
var  co, contador:integer;
begin
    contador:=0;
    for co:=1 to MAXCOL do 
        contador:=contador+mat[fi, co];
        
    promedioFila:=(contador/MAXCOL);
end;

procedure procesarMatriz(var mat:matriz);
var indice, fi,co, aux:integer;
begin
/// Promedio positivo
    for indice:=1 to MAXFIL do 
    begin
        for fi:=1 to MAXFIL-1 do 
        begin
        
            if (promedioFila(fi, mat) < promedioFila(fi+1, mat)) then
            begin
                for co:=1 to MAXCOL do 
                begin
                    aux:=mat[fi,co ];
                    mat[fi,co]:=mat[fi+1,co];
                    mat[fi+1,co]:=aux;
                end;
                    
            end;
        end;
        
    end;
end;

procedure ordenamientoCorrespondiente(var mat:matriz);
var indi,fi,co,aux:integer;
begin
    for indi:=1 to MAXFIL do 
    begin
        for fi:=1 to MAXFIL-1 do 
        begin
            if (promedioFila(fi,mat) >= 0) and (promedioFila(fi+1, mat)>= 0) then 
            begin
                if (promedioFila(fi, mat) >= promedioFila(fi+1, mat)) then
                begin
                    for co:=1 to MAXCOL do 
                    begin
                        aux:=mat[fi+1,co ];
                        mat[fi+1,co]:=mat[fi,co];
                        mat[fi,co]:=aux;
                    end;
                end;
            end
            else if (promedioFila(fi,mat) < 0) and (promedioFila(fi+1, mat) < 0) then
            begin
                if (promedioFila(fi, mat) > promedioFila(fi+1, mat)) then
                begin
                    for co:=1 to MAXCOL do 
                    begin
                        aux:=mat[fi,co ];
                        mat[fi,co]:=mat[fi+1,co];
                        mat[fi+1,co]:=aux;
                    end;
                end;
            end;
        end;
        
    end;
end;
procedure Imprimir_Mat(mat:matriz);
var fi,co:integer;
begin
    for fi:=1 to MAXFIL do
    begin
        for co:=1 to MAXCOL do 
        begin
            writeln(mat[fi, co], ' ');
        end;
    end;
end;
    {else if promedioFila(fi,mat) < 0 then 
    begin
        if promedioFila(fi, mat) < promedioFila(fi+1, mat) then
        begin
            for co:=1 to MAXCOL do 
            begin
                aux:=mat[fi+1,co ];
                mat[fi+1,co]:=mat[fi,co];
                mat[fi,co]:=aux;
            end;
        end;
    end;}
begin
    cargarMatriz(mat);
    procesarMatriz(mat);
    ordenamientoCorrespondiente(mat);
    Imprimir_Mat(mat);
end.