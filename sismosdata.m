#ANALISIS DE SISMOS#
#SE DIVIDIO LA TAREA EN 6 PEDAZOZ:#
#HW1: Poder abrir el csv y leer sus contenidos#
#HW2: Encontrar el sismo mas cercano a residencia(Santa Barbara)#
#HW3: Contadores de magnitudes de sismos#
#HW6: Realizar el modelo de Gutenberg Richter, Ajuste Lineal y Correccion de Errores#
#HW4: Convertir fechas a dias y Promedios de sismos por a�o#







#___________________________________________________________________________________________________________________________________________________________________________________#

#HW 1: OPEN THE CSV AND READ ITS CONTENTS#

#primeramente se buscara abrir el archivo#
#se probaron varios comnados como, csvread, textread, xlsread#
#el problema son los diferentes tipos de datos de la tabla#
#se termino usando el comando textscan, debido a que se le puede indicar el tipo de caracter para cada columna#
#un error encontrado es que en la columna 14 que indica el lugar del sismo, una coma separaba los strings lo que originaba un error ya que es un archivo .csv#


fid = fopen('sismosdata.csv', 'r');
 

#abra el archivo sismosdata.csv y lealo#

M = textscan(fid, '%s %n %f %f %f %s %f %f %f %f %s %s %s %s %s %f %f %f %f %s %s %s','Delimiter',',',"EmptyValue",NaN,'HeaderLines',1);

#las comas separan cada columna, en las cuales se especifica su tipo de dato, y se le indica que el delimitador es una coma#
#Textscan funciona agregando un array a cada columna especificada en el comando, o sea que m es una matriz formada por diferentes arrays#
 
#para llamar los %s se puede hacer como un arreglo bidimensional M{1}{1}.# 
#Para llamar los %f se puede hacer como un arreglo bidimensional M{7}(1)#


######################################################################################################################################################
######################################################################################################################################################
######################################################################################################################################################
######################################################################################################################################################
######################################################################################################################################################

#HW 2: Encontrando el terremoto mas cercano a Santa Barbara#


#------------------------LOGICA-------------------------------------------------------------------------------#

#la logica que se utilizo es compar la latitud y longitud de Santa Barbara con las de los sismos#
#suponiendo una localidad plana se encuentra la distancia y se compara con in ciclo for hasta definir la distancia mas corta#


#-----------------------VARIABLES-------------------------------------------------------------#
#x es el valor de la fila de M, se inicia en 1#
#Nearest es la Variable a la que se le agrega el elemento de la matrix donde se encuentra el lugar mas cercano#
#sblat y sblon son Latitud y longitud de Santa Barbara#
#dis es la variable que va guardando las distancias# 
#lat y lon son las variables donde se agregan las latitudes y longitudes que se obtienen de la M{}() y se van a comparar#
#En min y max se agregan los valores de dis minimos encontrados, inicialmente se coloca un max alto para que desde la primera comparacion, que sera lat=M{2}(1) y lon=M{3}(1) quede como la distancia minima y se agregue a la variable min#


x = 1;
nearest=0;
sblat = 14.9194403;
sblon = -88.2361069;
dis = 0;
lat = 0;
lon = 0;
min = 0;
max = 1000000;         

#-------------------------------CICLO FOR ANIDADO CON UN IF------------------------------------------#           

#sin usar haversine#
#se utiliza un for iniciando en 1 hasta la longitud de M, para que el ciclo se repita para todas las filas de la matriz M#
#se agrega el valor de la latitud de la fila especifia ebc a lat#
#se agrega el valor de la longitud de la fila especific ebca a lon#
#sabemos que la latitud esta en M{2} y la longitud en M{3}#
#se encuentra la distancia suponiendo localidad plana para lat y lon especificos de ebc, se utiliza la formula de distancia entre dos puntos#
#con el if se compara la distancia especifia del ebc y la variable max#
#A max y min se le agrega el valor de dis, para comparar y hacer el display#    
#se agrega el numero de fila dode se encuentra la menor distancia para poder manipular a gusto#
         
            for x=1:length(M{2})  
            
            
                lat = M{2}(x);
   
                lon = M{3}(x); 

            

                #dis = sqrt((sblat - lat)^2 + (sblon - lon)^2); #no se utiliza haversine
                [ dist,az]= distance([sblat,sblon],[lat,lon]); #se utiliza haversine, con la funcion distance#        

                if (dis < max)  
                    
               
                    max = dis; 
                    min = dis;

                    nearest  = x;
                  
                endif  
                
            endfor
#Usando Haversine#
#Calcular la distancia en coordenadas cilindricas#     

       
#-------------------------------------------------OUTPUTS-------------------------------------------
#Se muestra en pantalla la informacion necesaria de nearest, que vendria a ser la fila donde se encuentra el sismo mas cercano a x,y lugar#
#Se tuvo que buscar la latitud y longitud de la fila especifica por que el lugar que aparece en M solo es 'Honduras' #

disp('SISMO MAS CERCANO AL DEPARTAMENTO DE SANTA BARBARA'),disp("\n")
display("El sismo mas cercano a Santa Barbara se dio en la fecha: "),  disp(M{1}{nearest});  
disp("En latitud: "),  disp(M{2}(nearest)), disp('y longitud: '), disp(M{3}(nearest));
disp('Que es el municipio de San Nicolas, Santa Barbara')
disp('Con magnitud: '), disp(M{5}(nearest));
disp('Info en la fila del archivo csv: '), disp(nearest+1);
disp("\n");
           

    
           
######################################################################################################################################################
######################################################################################################################################################
######################################################################################################################################################
######################################################################################################################################################

#HW 3:contar sismos   con intervalos (4,5),(5,6),(6,7) y (7,8) #
  


#--------------------------------LOGICA------------------------------------------------#
#usar ciclos for para que lea toda la columna de magnitudes de M{}() que es la lectura del textscan de los datos de sismos#
#anidar if else con condicionantes min y max los valores de las magnitudes especificadas en la tarea#

#----------------------------VARIABLES--------------------------------------------------# 
#x es el integer de el ciclo for, o la fila de M que se esta leyendo#
#cont23 a cont78 son los contadores donde se guarda la sumatoria de sismos que cumplen la condicion, example: cont23 es la sumatoria de sismos de magnitudes dos a tres#
#cont suma todos los demas sismos con magnitudes no pedidas#
#magmatrix es un arreglo de: magnitudes vs sismos/a�o en esa magnitud#

x0= 1;,  cont23 = 0;, cont34=0;, cont45=0;, cont56=0;, cont67=0;,cont78=0;,cont=0; 

magmatrix=zeros(6,2); 
#X=zeros(6,2);
#Y=zeros(6,2);

            

#------------------------------------------PRIMER CICLO FOR --------------------------------------           

#x representa las filas de las matriz M, entonces el ciclo se repite desde la fila 1 hasta el tama�o de la matriz M#
#Si se cumple la condicion que cualquier fila x de la columna 5 M{5}(x), de la matriz M tiene valores de mag entre 4 y 5...etc, se le agrega +1 al contador#
#La misma logica se repite para contar los sismos de las magnitudes solicitadas#           
                for x=1:length(M{5})  
                    if(M{5}(x) >=2 && M{5}(x)<3)
                    
                        cont23++;
    
                    elseif(M{5}(x)>=3 && M{5}(x)<4)
                        
                        cont34++;
                        
                    elseif(M{5}(x) >= 4 && M{5}(x) < 5)   
                       
                        cont45++;                              
                    
                    elseif(M{5}(x) >= 5 && M{5}(x) < 6)
                        
                        
                        cont56++;
                        
                    elseif(M{5}(x) >= 6 && M{5}(x) < 7)
                         
                        
                        cont67++;
                           
                    elseif(M{5}(x) >= 7 && M{5}(x) < 8)
                        
                        
                        cont78++;
                        
                    else
                    
                        cont++;                          
                    endif
                    
                endfor        
                
#---------------------------------------FIN DE HW:#3---------------------------------------------------------------------------------#


#-----------------------------------------------------------------------------------------------------------------------------------#



#HW 6:realicionar el modelo de gutenberg richter, ajustar el modelo lineal y encontrar el error del ajuste            

#MODELO DE GUTENBERG RICHTER#            
#magmatrix=[2.99 log10(cont23) ; 3.99 log10(cont34) ; 4.99 log10(cont45) ; 5.99 log10(cont56) ; 6.99 log10(cont67) ; 7.99 log10(cont78)];

#magmatrix es una matriz que contiene en la primera columna los valores de las magnitudes y en la segunda columna la sumatoria de sismos mayores a esa magnitud#
#Example:[4 log10(cont45+cont56+cont67+cont78)] contiene 4 que es la magnitud y la sumatoria de los contadores que tienen magnitudes mayores a 4, en log debido al modelo de Gutenberg-R#

magmatrix=[4 log10(cont45+cont56+cont67+cont78) ; 5 log10(cont56+cont67+cont78) ; 6 log10(cont67+cont78) ; 7 log10(cont78)];




#GRAFICANDO CANTIDAD DE SISMOS VS MAGNITUD DE SISMOS#
#en este ciclo for se grafican los pares ordenados de magmatrix, que luego seran ajustados a una funcion lineal# 
#por alguna razon si se grafica con el ciclo for, no muestra la leyenda correcta el plot#


#for x=1:4
figure(1) 
  plot(magmatrix(:,1),magmatrix(:,2),'color',[0,0,0],'*','markersize',10);
  title('Modelo de Gutenberg-Richter');
  xlabel('Magnitudes');
  ylabel('Numero de sismos acumulado por magnitud');
  hold on
#endfor

#REGRESION LINEAL#

#visto en tutorial sobre regresion lineal en octave#
#the normal equation is that which minimizes the sum of the square differences between the left and right sides of A^(T)Ax=A^(T)b#
#la ecuacion del modelo de Gutenberg Richter es logN=a-bM #
#se utiliza la ecuacion normal A^(T)Ax=A^(T)b para la regresion lineal y re agrega a la variable ajuste#

#---------------------------------------------------------Variables---------------------#
#a la variable x se agregan los valores de magnitud de la matriz definida, magmatrix(:,1)#
#a la variable y se agregan los valores de log10 de la sumatoria de sismos por a�o mayores a la magnitud especifica#
#X mayuscula es la matriz de la ecuacion normal utilizada#
#donde ajuste=[a,b], ajuste(1) es a y ajuste(2) es b#


m=4;
x=magmatrix(:,1);
y=magmatrix(:,2);
X=[ones(4,1) x];
ajuste = (pinv(X'*X))*X'*y;  #You should get theta(ajuste) = [a ; b]. This means that our fitted equation is as follows: y = ax + b. #
plot(X(:,2), X*ajuste, '-')
legend('Datos experimentales','Regresion Lineal')
hold off

#ERROR EN LA REGRESION#

#El ciclo for se utiliza para generar las matrices con los terminos utilizados en las ecuaciones para encontrar la incertidumbre en la regresion lineal#


#------------------------Variables-------------------------------------------------#

#yiyi es una matriz 4x1 que contiene los valores de y^2#
#xixi es una matriz 4x1 que contien los valores de x^2#
#xiyi es una matriz 4x1 que contiene los valores de x*y#
#fxi es una matriz 4x1 que contiene los valores f(xi) de y=a+bxi
#sy es una matriz de 4x1 que contiene los valores de sy, que se utiliza para encontrar la incertidumbre#
#a alfa se agrega el valor del intercepto encontrado en el ajuste"
#a beta se agrega el valor de la pendiente del ajuste#



alfa=ajuste(1);
beta=ajuste(2);



#encontrando el factor Sy#
#Sy se utiliza para encontrar la incertidumbre#
#sumatorias de xi,yi y xi^2#

for i=1:4
  yiyi(i,1)=(y(i)*y(i));
  xiyi(i,1)=(x(i)*y(i));
  xixi(i,1)=(x(i)*x(i));
  fxi(i,1)=beta*x(i,1)+alfa;
  sy(i,1)=sqrt((fxi(i)-y(i))^2/(4-2));
  
endfor



#--------------------------------------------------------------------------------------------------------------------------------------------------------#

#una ves se definen las matrices con los terminos necesarios, se procede a definir las sumatorias necesarias para encontrar la incertidumbre#
#Variables#
#sumsy es la sumatoria de todos los componentes de la matriz Sy(i,1)#
#sumyi es la sumatoria de todos los valores de y() que contiene los log de los sismos mayores a la magnitud especifica#
#sumxi es la sumatoria de los valores de x, que contiene las magnitudes#
#sumxixi es la sumatoria de los valores de la matriz que contiene x^2#
#sumyiyi es la sumatoria de los valores de la matriz que contiene y^2#
##sumxiyi es la sumatoria de los valores de la multiplicacion de los elementos de yi y xi#

sumsy=sy(1)+sy(2)+sy(3)+sy(4);
sumyi=(y(1)+y(2)+y(3)+y(4));
sumxi=(x(1)+x(2)+x(3)+x(4));
sumxixi=(xixi(1)+xixi(2)+xixi(3)+xixi(4));
sumyiyi=(yiyi(1)+yiyi(2)+yiyi(3)+yiyi(4));
sumxiyi=xiyi(1)+xiyi(2)+xiyi(3)+xiyi(4);
#fxiyi=(fxi(1)-magmatrix(1,2)+fxi(2)-magmatrix(2,2)+fxi(3)-magmatrix(3,2)+fxi(4)-magmatrix(4,2))^2;
#sy=sqrt((fxi)-yi)^2/(4-2)


#ya con todos los terminos definidos se procede a encontrar los errores en el ajuste#
#se utilizo las ecuaciones de incertidumbre del archivo introduccion a errores experimentales realizado por Jorge Perez y Roger "Rogelio" Raudales#
#--------------------------------------Variables-------------------------#
#dela equivale al error en alfa#
#delb equivale al error en beta#

dela=sumsy*sqrt((sumxixi)/(4*sumxixi-(sumxi)^2));
delb=sumsy*sqrt(4/(4*sumxixi-(sumxi)^2));
#xysum=(xy(1,1)+xy(2,1)+xy(3,1)+xy(4,1));
#xxsum=(xx(1,1)+xx(2,1)+xx(3,1)+xx(4,1));

#encontrando la correlacion entre los datos experimentales y el modelo lineal#
#rr=(4*(sumxiyi)-(sumxi*sumyi))/((sqrt(4*(sumxixi-(sumxi)^2)))*sqrt((4*sumyiyi)-(sumyi)^2));

#for i=1:4
  #SCE=(y(i,1)-yprom)^2
  





#------------------------------OUTPUTS-------------------------------------------------------
disp('CONTADORES DE MAGNITUD DE SISMOS'),disp("\n")
disp('La cantidad de sismos con magnitud entre [2,3) es: '),disp(cont23);
disp('La cantidad de sismos con magnitud entre [3,4) es: '),disp(cont34);            
disp('La cantidad de sismos con magnitud entre [4,5) es: '),disp(cont45);
disp('La cantidad de sismos con magnitud entre [5,6) es: '),disp(cont56);
disp('La cantidad de sismos con magnitud entre [6,7) es: '),disp(cont67);
disp('La cantidad de sismos con magnitud entre [7,8) es: '),disp(cont78);
disp('La cantidad de sismos con otras magnitudes es: '),disp(cont);
disp('La cantidad de sismos totales analizados es:'),disp(cont23 + cont34 + cont45 + cont56 + cont67 + cont78 + cont);
disp("\n");

disp('MODELO DE GUTENBERG-RICHTER'),disp("\n");
disp('Se utilizo el modelo de Gutenberg Richter: logN=a-bM');
disp('Se realizo una regresion lineal para encontrar los valores a y b del ajuste');   
disp('siendo el valor de a:'),disp(alfa);
disp('y el valor de b:'),disp(beta);
disp('La incertidumbre encontrada en el ajuste fue:');
disp('para a:'),disp(dela);
disp('para b:'),disp(delb);
disp("\n");     

######################################################################################################################################################
######################################################################################################################################################
######################################################################################################################################################
######################################################################################################################################################
######################################################################################################################################################

#HW 4: CALCULAR PROMEDIO DE SISMOS POR A�O#

#-------------------LOGICA------------------------------------------------------#
#se debe pasar las fechas a segundos(minutos o dias) y despues hacer la diferencia de fechas final e inicial#
#se divide la diferencica de tiempos entre la cantidad de sismos totales almacenada en los contadores#
#usando la funcion datenum(year, month, day, hour, minute, second), se convierten fechas en dias#
#str2num convierte un string en un integer, es necesario usarlo en datenum, debido a que en el textscan se definio la columna de fechas como strings#
#crear una matriz de zeros con tantas filas como el tama�o de M, y una columna que seria la de fechas en el csv, y agregarle los valores en dias de las fechas M{1}#

#-------------------------VARIABLES---------------------------------------------#
#D que es la matriz donde se almacenan las fechas de M{1} convertidas en dias#
#x es la variable coontador del ciclo for#
#dif es la variable donde se agrega la diferencia de tiempo final vs inicial en dias#
#tyear almacena cuantos a�os han transcurrido desde la primera hasta la ultima medicion#
#csismos almancena la cantidad total de sismos, se suman los contadores de la tarea #3#
#siscontnyear almacena la cantidad de sismos por a�o#


#----------------------------------------CICLO FOR-------------------------------------------#
#se agrega toda la columna M{1} de fechas a una matriz de zeros D#
#con el ciclo for que inicia en la columna uno de D y finaliza en la ultima columna del archivo csv#
#se va agregando a la matriz de Zeros los valores de las fechas en dias, quedando una matriz D con la misma dimension que M{1}#
#D(x,1) siginifica que para cada valor de x, que iniciara en 1 se le agregara a esa fila el valor en dias del datenum#
#ex:el argumento primero de datenum es el a�o, que es equivalente a los primeros cuatro terminos de la columna 1, fila x asi : str2num(M{1}{x}(1:4)#
#D es una matriz, no un arreglo bidimensional como el que genera el textscan#
#si quiero la fecha M{1}{1} en dis(s o m), se llama como S(1)...etc#   

D=zeros(length(M{1}),1);
for x=1:length(M{1})
  D(x,1)=datenum(str2num(M{1}{x}(1:4)),str2num(M{1}{x}(6:7)),str2num(M{1}{x}(9:10)),str2num(M{1}{x}(12:13)),str2num(M{1}{x}(15:16)),str2num(M{1}{x}(18:19)));

  

endfor

dif=abs(D(length(M{1}))-D(1));
tyear=dif/(365.4);
csismos=cont23 + cont34 + cont45 + cont56 + cont67 + cont78;
sisyear=csismos/tyear;
siscont23year=cont23/tyear;
siscont34year=cont34/tyear;
siscont45year=cont45/tyear;
siscont56year=cont56/tyear;
siscont67year=cont67/tyear;
siscont78year=cont78/tyear;
siscontyear=cont/tyear;

#----------------------------------------OUTPUTS----------------------------------------------------#
disp('CONVERSION DE FECHAS A DIAS Y PROMEDIO DE SISMOS POR A�O')
disp('La cantidad total de a�os es: '), disp(tyear)
disp('La cantidad total de sismos por a�o es: '), disp(sisyear)
disp('La cantidad de sismos por a�o con magnitud entre [2,3) es: '),disp(siscont23year);
disp('La cantidad de sismos por a�o con magnitud entre [3,4) es: '),disp(siscont34year);
disp('La cantidad de sismos por a�o con magnitud entre [4,5) es: '),disp(siscont45year);
disp('La cantidad de sismos por a�o con magnitud entre [5,6) es: '),disp(siscont56year);
disp('La cantidad de sismos por a�o con magnitud entre [6,7) es: '),disp(siscont67year);
disp('La cantidad de sismos por a�o con magnitud entre [7,8) es: '),disp(siscont78year);
disp('La cantidad de sismos por a�o con otras magnitudes es: '),disp(siscontyear);
disp("\n");

######################################################################################################################################################
######################################################################################################################################################
######################################################################################################################################################
######################################################################################################################################################
######################################################################################################################################################

#HW 5: CARGAR EL MAPA CONTORNO DE HN#

A=zeros(length(M{3}),1);
B=zeros(length(M{2}),1);


figure(2)
[p14,y14]=textread('hnmap14.dat','%f %f','Headerlines',2);
plot(p14,y14, "linewidth",3,'color',[0,0,0])
title('Mapeo de sismos ocurridos en Honduras desde 1921')
ylabel('latitud')
xlabel('longitud')

hold on

[p0,y0]=textread('hnmap0.dat','%f %f','Headerlines',2);
plot(p0,y0, "linewidth",3,'color',[0,0,0])
hold on

[p1,y1]=textread('hnmap1.dat','%f %f','Headerlines',2);
plot(p1,y1, "linewidth",3,'color',[0,0,0])
hold on

[p2,y2]=textread('hnmap2.dat','%f %f','Headerlines',2);
plot(p2,y2, "linewidth",3,'color',[0,0,0])
hold on

[p3,y3]=textread('hnmap3.dat','%f %f','Headerlines',2);
plot(p3,y3, "linewidth",3,'color',[0,0,0])
hold on

[p4,y4]=textread('hnmap4.dat','%f %f','Headerlines',2);
plot(p4,y4, "linewidth",3,'color',[0,0,0])
hold on

[p5,y5]=textread('hnmap5.dat','%f %f','Headerlines',2);
plot(p5,y5, "linewidth",3,'color',[0,0,0])
hold on

[p6,y6]=textread('hnmap6.dat','%f %f','Headerlines',2);
plot(p6,y6, "linewidth",3,'color',[0,0,0])
hold on

[p7,y7]=textread('hnmap7.dat','%f %f','Headerlines',2);
plot(p7,y7, "linewidth",3,'color',[0,0,0])
hold on

[p8,y8]=textread('hnmap8.dat','%f %f','Headerlines',2);
plot(p8,y8, "linewidth",3,'color',[0,0,0])
hold on

[p9,y9]=textread('hnmap9.dat','%f %f','Headerlines',2);
plot(p9,y9, "linewidth",3,'color',[0,0,0])
hold on

[p10,y10]=textread('hnmap10.dat','%f %f','Headerlines',2);
plot(p10,y10, "linewidth",3,'color',[0,0,0])
hold on

[p11,y11]=textread('hnmap11.dat','%f %f','Headerlines',2);
plot(p11,y11, "linewidth",3,'color',[0,0,0])
hold on

[p12,y12]=textread('hnmap12.dat','%f %f','Headerlines',2);
plot(p12,y12, "linewidth",3,'color',[0,0,0])
hold on

[p13,y13]=textread('hnmap13.dat','%f %f','Headerlines',2);
plot(p13,y13, "linewidth",3,'color',[0,0,0])
hold on

herror=zeros(length(M{16}),1);
magrate=zeros(length(M{5}),1);
m1=zeros(length(M{4}),1);
m2=zeros(length(M{4}),1);
m3=zeros(length(M{4}),1);
m4=zeros(length(M{4}),1);
min2=0;
max2=0;
min3=0;
max3=0;


for x=1:length(M{1})
  
  if(M{4}(x)>min3)
  
  min3=M{4}(x);
  max3=M{4}(x);
  
  endif
endfor


#-------------------------------------------------------------------------------------------------------------------#
#Encontrando el valor de magnitud mayor#

for x=1:length(M{1})
  
  if(M{5}(x)>min2)
  
  min2=M{5}(x);
  max2=M{5}(x);
  
  endif
endfor
  
#----------------------------------------------------------------------------------------------------------------#

#Aqui ya teniendo el valor de magnitud mayor se crea una matriz llamada magrate(x,1) que contiene la relacion entre cada valor de profundidad entre el valor maximo de profundidad#
#max2 se usara mas adelante para definirlos ratios de magnitud, dividiendo elemento de magnitud/magnitud maxima#
#esos ratios de magnitud se usaran para definir el tama�o del circulo#

for x=1:length(M{4})
  #color(x,1)=((M{4}(x)/max3));
  #magrate(x,1)=(M{5}(x)/max2)*20;
  herror(x,1)=(M{16}(x)*(180/pi))/6371;
  #verror(x,1)=(M{16}(x)*(180/pi))/6371;
  #A(x,1)=(M{3}(x));
  #B(x,1)=M{2}(x);
  
endfor


#--------------------------------------------------------------------------------------------------------------------

#for j=1:length(M{1})
  #A(j,1)=(M{3}(j));
  #B(j,1)=M{2}(j);
#endfor



#---------------------------------------------------------------------------------------------------------------------------#
#OBTENIENDO LAS MATRICES NECESARIAS PARA GRAFICAR#
#Se grafican los pares ordenados donde#
#M{4}(x) contiene los valores de profundidad#
#M{2}(x) contiene los valores de latitud#
#M{3}(x) contiene los valores de longitud#
#m1 contiene los valores de magnitud que cumplen el condicional#
#mx1 contiene los valores de latitud que cumplen ese condicional#
#my1 contiene los valores de longitud que cumplen ese condicional#
#se repite para mx2,my2 ; mx3,my3 ; mx4,my4#
#a las matrices mp1 a mp4 se agregan los valores de magnitud de los elementos que cumplen los condicionales#
#Ex: mp1 contiene los valores de magnitud de los elementos que cumplen profundidad entre 0 y 25#
#Aqui se utiliza el ratio al dividir estos valores entre el valor de magnitud maximo max2 y se multiplica por 100 para que el markersize tenga un valor entre 0 y 10#
#el markersize dependera del ratio valor de magnitu/magnitud mayor#
 
for x=1:length(M{1})
    
  if (M{4}(x)>=0) && (M{4}(x)<25) 
      m1(x,1)=M{4}(x);
      mx1(x,1)=M{3}(x);
      my1(x,1)=M{2}(x);
      mp1(x,1)=(M{5}(x)/max2)*100;   
   
  else
    if (M{4}(x)>=25) && (M{4}(x)<50)
        m2(x,1)=M{4}(x);
        mx2(x,1)=M{3}(x);
        my2(x,1)=M{2}(x);  
        mp2(x,1)=(M{5}(x)/max2)*100;
  else
    if (M{4}(x)>=50) && (M{4}(x)<150)
        m3(x,1)=M{4}(x);
        mx3(x,1)=M{3}(x);
        my3(x,1)=M{2}(x);  
        mp3(x,1)=(M{5}(x)/max2)*100;

  else if (M{4}(x)>=150) && (M{4}(x)<300)
        m4(x,1)=M{4}(x);
        mx4(x,1)=M{3}(x);
        my4(x,1)=M{2}(x);
        mp4(x,1)=(M{5}(x)/max2)*100;
        end
    end
  end


  #en este ciclo for por alguna razon a cada m1,m2,m3,m4 se le agregan los valores del condicional#
  #pero en las filas que no se cumple se rellena con cero#
  #Ex: length(m4)=1125 cuando deberia de ser 64#
  #Esto se resolvera usando el comando nonzeros, que retorna un vector con los valores no zeros de una matriz#  
   
  
    
    
   
    
  endif  
endfor

#DEFINIENDO LAS MATRICES QUE CUMPLEN LOS CONDICIONALES#
#m11=nonzeros(m1):contiene los elementos de la matriz original que tienen una profundidad entre 0 y 25# 
#m22=nonzeros(m2):contiene los elementos de la matriz original que tienen una profundidad entre 26 y 50#
#m33=nonzeros(m3):contiene los elementos de la matriz original que tienen una profundidad entre 51 y 150# 
#m44=nonzeros(m4):contiene los elementos de la matriz original que tienen una profundidad entre 151 y 300#
#mx11=nonzeros(mx1)... contiene los valores de latitud que cumplen profundidad entre 0 y 25 etc#
#my11=nonzeros(my1)... contiene los valores de longitud que cumplen profundidad entre 0 y 25 etc#
#mp1 contiene los valores de magnitud para los elementos que cumplen profundidad entre 0 y 25 divididos entre max2 que contiene el valor mayor de magnitud#
  

#matrices que contienen#

#profundidades#
m11=nonzeros(m1);
m22=nonzeros(m2);
m33=nonzeros(m3);
m44=nonzeros(m4);

#latitudes#
mx11=nonzeros(mx1);
mx22=nonzeros(mx2);
mx33=nonzeros(mx3);
mx44=nonzeros(mx4);

#longitudes#
my11=nonzeros(my1);
my22=nonzeros(my2);
my33=nonzeros(my3);
my44=nonzeros(my4);

#magnitudes#
mp11=nonzeros(mp1);
mp22=nonzeros(mp2);
mp33=nonzeros(mp3);
mp44=nonzeros(mp4);

#Graficando las matrices que contienen los valores de profundidad especificados en los condicionales if#
#el problema de usar plot es que tenia que graficar en un ciclo for, lo que hacia e programa lento#
#scatter(x,y,s,c) lo que hace es que coloca un marcador definido por los puntos x,y#
#el tama�o del marcador es definido por s, en este caso s es un vector columna del mismo tama�o de x,y#
#el color es definido por c, en este caso es un valor rgb[n,n,n]#


scatter(mx11(:,1),my11(:,1),mp11(:,1),[0,1,0]); #verde#
hold on
scatter(mx22(:,1),my22(:,1),mp22(:,1),[0,0,1]);  #azul#
hold on
scatter(mx33(:,1),my33(:,1),mp33(:,1),[0.4,0,0.4]); #morado#
hold on
scatter(mx44(:,1),my44(:,1),mp44(:,1),[1,1,0]); #amarillo#
hold on

#scatter(mx22(:,1),my22(:,1),'color',[0,0,1],'o','markersize',mp22(:,1)) 
#scatter(mx33(:,1),my33(:,1),'color',[0,1,0],'o','markersize',mp33(:,1))
#scatter(mx44(:,1),my44(:,1),'color',[0,1,0],'o','markersize',mp44(:,1))
  
#endfor
#for x=1:length(mx22)  
  #plot(mx22(:,1),my22(:,1),'color',[0,0,1])
  
#endfor
#for x=1:length(mx33)  
  #plot(mx33(:,1),my33(x,1),'color',[0.4,0,0.4])
  
#endfor
#for x=1:length(mx44)  
  #plot(mx44(:,1),my44(:,1),'color',[1,1,0])
  
  
#endfor


#----------------------------------------------------------------------------------------------------------------------#

#Aqui se grafica el error horizontal, se realizo la suposicion tal que el error vertical seria el mismo al error horizontal#
#Octave contiene un comando especifico llamado errorbar() el cual con los argumentos correctos genera las graficas de errores#
#Lo que se hizo fue agregar a una matriz de una columna llamada errorbar(x,1) todos los valores que contienen el error horizontal de los datos#
#Entonces en cada par ordenado de latitud M{2}(x) y longitud M{3}(x) se grafica el error establecido en errorbar(x,1)#
for x=1:length(M{1})
  h=errorbar(M{3}(x),M{2}(x),herror(x,1),herror(x,1),'#~>');  
  set (h, "color", [1 0 0]);  #rojo#
  
endfor
  

#----------------------------------------------------------------------------------------------------------#


#CODIGO DONDE EL CODIGO DE COLORES NO ES EFICIENTE#
#for j=1:length(M{1})
  #A(j,1)=(M{3}(j));
  #B(j,1)=M{2}(j);
  #plot(A(j,1),B(j,1),'color',[1*color(j), 0, 0],'o','markersize',magrate(j));
  #hold on;
  
#endfor  


#OUTPUTS#
disp('CODIGO DE COLORES OBSERVADO EN EL MAPA DE SISMOS')
disp('Los sismos en verde tienen magnitud entre 0 y 25 Km');
disp('Los sismos en azul tienen magnitud entre 26 y 50 Km');   
disp('Los sismos en morado tienen magnitud entre 51 y 150 Km');
disp('Los sismos en amarillo tienen magnitud entre 150 y 300 Km');
disp('Los rectangulos rojos representan el error horizontal y vertical');
disp("\n");

disp('VALOR MAXIMO DE MAGNITUD Y PROFUNDIDAD')
disp('El valor maximo de magnitud es:'),disp(max2);
disp('El valor maximo de profundidad es:'),disp(max3);  
disp("\n");

disp('CONTADORES DE PROFUNDIDAD');
disp('la cantidad de sismos con profundidad entre 0 y 25 Km es:'),disp(length(m11));
disp('la cantidad de sismos con profundidad entre 26 u 50 Km es:'),disp(length(m22));
disp('la cantidad de sismos con profundidad entre 51 u 150 Km es:'),disp(length(m33));
disp('la cantidad de sismos con profundidad entre 151 u 300 Km es:'),disp(length(m11));
disp("\n");
  

disp("GG WP");  