% FINAL ALGORITMO - INTERPOLACION Y LONGITUD DE ARCO, hecho por Peraldo Namoc, George
clc

disp('----------------------------------------------------------------------------')
disp('                ALGORITMO DE INTERPOLACION Y LONGITUD DE ARCO')
disp('----------------------------------------------------------------------------')
printf('\n\n                      INGRESO DE DATOS \n\n')

while true
  
  base_ancho = input('Digite el ancho perteneciente a la base del arco en Metros : ');
  printf('\n')
  particiones = input('Digite la cantidad de particiones a realizar: ');
  printf('\n')
  if altura <= 1 || particiones <= 1
    printf('\n\n\tLos valores ingresados deben ser mayor a 1.\n\n')
  else
    break
  endif
  
endwhile

h = (base_ancho)/particiones;

dy = [];
dx = [0:h:base_ancho];

for i = 1:particiones + 1
  printf('Ingrese el valor de la altura a una distancia de %d m, partiendo desde el punto inicial de medicion : ',dx(i));
  dy = [dy, input('')];
endfor


disp('----------------------------------------------------------------------------')
printf('\n\n                      DATOS INGRESADOS \n\n')

printf('\n\n base_ancho [m]  Altura[m] \n\n')
disp([dx' dy'])

disp('----------------------------------------------------------------------------')


%%--PROCESAMIENTO DE DATOS PARA UNA FUNCION PAR QUE PERTENECE AL DOMINIO 0<=X<=base_ancho


interval = [0:.01:base_ancho];
dyy_spline = interp1(dx,dy,0:.01:base_ancho,'spline');

plot(interval,dyy_spline,'-.')
xlabel('ancho [m]','fontsize',16)
ylabel('altura [m]','fontsize',16)
grid on
title('Interpolacion Spline','fontsize',22)

disp('----------------------------------------------------------------------------')
printf('\n\n                      RESULTADOS \n\n')

fx_spline = polyfit(interval, dyy_spline, 2); % FUNCION INTERPOLADA [SPLINE]
printf('\nFuncion por splines cubicos de grado 2 para la funcion par, simetrica al eje de las ordenadas: \n');
printf('Perteneciente al dominio 0 <= x <= %d \n\n', base_ancho/2);


final_fx = 'f(x) = ';

for i = 1 : length(fx_spline)-1
  final_fx = strcat(final_fx,'(', num2str(fx_spline(i)),')x ', '^',num2str(abs(i-length(fx_spline))), ' + ');
endfor
final_fx = strcat(final_fx, num2str(fx_spline(length(fx_spline))));
disp(final_fx)

a_ = fx_spline(1);
b_ = fx_spline(2);
c_ = fx_spline(3);

%% ECUACION PARA LA LONGITUD DE ARCO

L = @(x) 2*sqrt(1+((2*a_*x)+(b_))^2);

function t_result = regla_trapezio_rc (f, a, b, n)
  
  %----------------------Data----------------------------
  
                          % f(x) -> funcion a integrar
                          % a    -> extremo inferior
                          % b    -> extremo superior
                          % n    -> numero de particiones
  suma = 0;               % acumulador
  
  %--------------Procesamiento de la data----------------
  
  h = (b-a)/n;                  % tamano individual de las particiones 
  for i = 1 : n-1
    x = a + i * h;
    suma += f(x);
  endfor
  %----------------------Resultado-----------------------
  
  t_result = (h/2) * (f(a) + 2*suma + f(b));
endfunction

printf('\n\nLONGITUD DE ARCO POR APROXIMACION EMPLEADO LA REGLA TRAPEZOIDAL: %d metros\n\n',regla_trapezio_rc(L, 0, base_ancho/2, length(dy)-1))

function p_result = regla_parabolica_rc (f, a, b, n)
  
  %----------------------Data----------------------------
  
                          % f(x) -> funcion a integrar
                          % a    -> extremo inferior
                          % b    -> extremo superior
                          % n    -> numero de particiones
  suma_i = 0;             % sumatoria de impares
  suma_p = 0;             % sumatoria de pares
  
  %--------------Procesamiento de la data----------------
  
  h = (b-a)/n;            % tamano individual de las particiones         
  for i = 1 : n-1
    if(mod(i, 2) == 0)
      x = a + i * h;
      suma_p += f(x);
    else
      x = a + i * h;
      suma_i += f(x);
    endif
  endfor
  %----------------------Resultado-----------------------
  
  p_result = (h/3)*( f(a) + 4*suma_i + 2*suma_p + f(b));
endfunction


printf('LONGITUD DE ARCO POR APROXIMACION EMPLEADO LA REGLA PARABOLICA: %d metros',regla_parabolica_rc(L, 0, base_ancho/2, length(dy)-1))

