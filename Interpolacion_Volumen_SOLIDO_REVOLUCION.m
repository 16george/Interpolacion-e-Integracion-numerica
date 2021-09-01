% FINAL ALGORITMO - INTERPOLACION Y VOLUMENES DE SOLIDOS DE REVOLUCION, hecho por Peraldo Namoc, George
clc

disp('----------------------------------------------------------------------------')
disp('ALGORITMO DE INTERPOLACION E INTEGRACION NUMERICA PARA SOLIDOS DE REVOLUCION')
disp('----------------------------------------------------------------------------')
printf('\n\n                      INGRESO DE DATOS \n\n')



while true
  
  altura = input('Digite la altura del solido en cm : ');
  printf('\n')
  particiones = input('Digite la cantidad de particiones a realizar: ');
  printf('\n')
  if altura <= 1 || particiones <= 1
    printf('\n\n\tLos valores ingresados deben ser mayor a 1.\n\n')
  else
    break
  endif
  
endwhile

h = (altura)/particiones;

dy = [];
dx = [0:h:altura];


for i = 1:particiones + 1
  printf('Ingrese el valor del radio a una distancia de %d cm, partiendo desde el punto inicial de medicion : ',dx(i));
  dy = [dy, input('')];
endfor

disp('----------------------------------------------------------------------------')
printf('\n\n                      DATOS INGRESADOS \n\n')

printf('\n\n         Altura [cm]                    Radio[cm] \n\n')
disp([dx' dy'])

disp('----------------------------------------------------------------------------')

interval = [0:.01:altura];

dyy_linear = interp1(dx,dy,0:.01:altura,'linear');
dyy_cubic = interp1(dx,dy,0:.01:altura,'cubic');
dyy_spline = interp1(dx,dy,0:.01:altura,'spline');

subplot(2,2,1) %% Grafico de dispersion
plot(dx,dy,'o')
xlabel('altura [cm]','fontsize',16)
ylabel('radio [cm]','fontsize',16)
grid on
title('Grafico de dispersion','fontsize',22)

subplot(2,2,2) %% Grafico de Interpolacion Lineal
plot(interval,dyy_linear,'-.')
xlabel('altura [cm]','fontsize',16)
ylabel('radio [cm]','fontsize',16)
grid on
title('Interpolacion Lineal','fontsize',22)

subplot(2,2,3) %% Grafico de Interpolacion Cubica
plot(interval,dyy_cubic,'-.')
xlabel('altura [cm]','fontsize',16)
ylabel('radio [cm]','fontsize',16)
grid on
title('Interpolacion Cubica','fontsize',22)

subplot(2,2,4) %% Grafico de Interpolacion Spline
plot(interval,dyy_spline,'-.')
xlabel('altura [cm]','fontsize',16)
ylabel('radio [cm]','fontsize',16)
grid on
title('Interpolacion Spline','fontsize',22)

disp('----------------------------------------------------------------------------')
printf('\n\n                      FUNCIONES INTERPOLADAS \n\n')

fx_linear = polyfit(interval, dyy_linear,1); % FUNCION INTERPOLADA [LINEAL]
printf('Funcion Lineal : f(x) = (%d)x + %e \n\n\n', fx_linear(1), fx_linear(2))

fx_cubic = polyfit(interval, dyy_cubic, 3); % FUNCION INTERPOLADA [CUBICA]
printf('Funcion Cubica : f(x) = (%d)x^3 + (%e)x^2 + (%f)x + (%g) \n\n\n', fx_cubic(4), fx_cubic(3), fx_cubic(2), fx_cubic(1))

fx_spline = polyfit(interval, dyy_spline, ceil(length(dy)-1)); % FUNCION INTERPOLADA [SPLINE]
printf('Funcion por splines cubicos de grado %d : \n\n', (length(dy)-1))

final_fx = 'f(x) = ';

for i = 1 : length(fx_spline)-1
  final_fx = strcat(final_fx,'(', num2str(fx_spline(i)),')x ', '^',num2str(abs(i-length(fx_spline))), ' + ');
endfor
final_fx = strcat(final_fx, num2str(fx_spline(length(fx_spline))));
disp(final_fx)


disp('----------------------------------------------------------------------------')
printf('\n\n     VOLUMEN DEL SOLIDO DE REVOLUCION POR APROXIMACION\n\n')

printf('\n\n                REGLA TRAPEZOIDAL\n\n')

function t_result = regla_trapezio_vol_src (x, y)
  
  %----------------------Data----------------------------
  
                          % x    -> vector de la variable independiente
                          % y    -> vector de la variable dependiente 
  a = x(1);               % a    -> extremo inferior
  b = x(length(x));       % b    -> extremo superior
  n = length(y) - 1;      % n    -> numero de particiones
  suma = 0;               % acumulador
  y = y(:).^2;             % adaptado a calculo de volumen
  
  %--------------Procesamiento de la data----------------
  
  h = (b-a)/n;            % tama?o individual de las particiones 
  for i = 2 : length(y) - 1
    suma += y(i);
  endfor
  %----------------------Resultado-----------------------
  
  t_result = pi * (h/2) * (y(1) + 2*suma + y(length(y)));
endfunction

printf(' EL VOLUMEN DEL SOLIDO POR APROXIMACION PARA LA REGLA TRAPEZOIDAL ES EQUIVALENTE A: %d cm^3 \n\n', regla_trapezio_vol_src(interval, dyy_spline))

printf('\n\n                REGLA PARABOLICA/SIMPSON\n\n')

function p_result = regla_parabolica_vol_src (x, y)
  
  %----------------------Data----------------------------
                          
                          % x    -> vector de la variable independiente
                          % y    -> vector de la variable dependiente 
  a = x(1);               % a    -> extremo inferior
  b = x(length(x));       % b    -> extremo superior
  n = length(y) - 1;      % n    -> numero de particiones
  suma_i = 0;             % sumatoria de impares
  suma_p = 0;             % sumatoria de pares
  y = y(:).^2;             % adaptado a calculo de volumen
  
  %--------------Procesamiento de la data----------------
  
  h = (b-a)/n;            % tama?o individual de las particiones         
  for i = 2 : length(y) - 1
    if(mod(i, 2) == 0)
      suma_i += y(i);
    else
      suma_p += y(i);
    endif
  endfor
  %----------------------Resultado-----------------------
  
  p_result = pi * (h/3)*( y(1) + 4*suma_i + 2*suma_p + y(length(y)));
endfunction

printf(' EL VOLUMEN DEL SOLIDO POR APROXIMACION PARA LA REGLA PARABOLICA/SIMPSON ES EQUIVALENTE A: %d cm^3 \n\n', regla_parabolica_vol_src(interval, dyy_spline))
