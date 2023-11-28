program trabajoInstaPas

Uses sysutils, DateUtils;



const MAX: 15;

type 
    arbUsuarios=^nodoArbol;
    nodoArbol=record
        Nombre:string[15];
        password:string[8];
        email:string[15];
        usuario:arbUsuarios;
        historias:listHistorias;
        izq, der:arbUsuarios
    end;

    fecha=record
        dia:[1..30];
        mes:[1..12];
        anio:[2023];
        hora:string[15]
    end;

    Usuario=record
        seguidor:string;
        seguido:string
    end;

    listHistorias=^nodoHistoria;
    nodoHistoria=record
        tipoFecha:fecha;
        texto:string[150];
        ste:listHistorias
    end;

    archUsurarios=record
        Nombre:string[15];
        password:string[8];
        emial:string[15]
    end;

    archHistorias=record
        tipoFecha:fecha;
        texto:string[150]
    end;
    
    archSeguidos=record
        nombredeUsuario:Usuario
    end;
    archUsu= file of archUsurarios;
    archSeg= file of archSeguidos;
    archHist= file of archHistorias;

/////////////////////////////////////////////Definicion de variables///////////////////////////////////////////////

