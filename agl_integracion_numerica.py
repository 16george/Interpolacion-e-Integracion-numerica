import numpy as np
import matplotlib.pyplot as plt

opc = int(input('''
                Trapezoid rule and Parabolic/Simpson rule

    1. Integracion Numerica [NO regla de correspondencia]
    2. Integracion Numerica [regla de correspondencia]

    SELECCIONE UNA OPCION: '''))


def size_fx():
    n = int(input('Digite el tamaño del vector f(x): '))
    print('\nIngrese los valores para la variable independiente x: ')
    return n

def plot_graph(a, b, n, x, y, title, x_label, y_label):
    xi = np.linspace(a,b,n+1)
    plt.plot(x, y)
    plt.title(title)
    plt.xlabel(x_label)
    plt.ylabel(y_label)
    plt.fill_between(x,0,y, color = 'b')
    for i in range(0, n,1):
        plt.axvline(xi[i], color = 'w')
    plt.show()

def trapezoid_rule(y, h):
    suma = 0
    for i in range (1, len(y)-1):
        suma += y[i]
    trapezoid_rule = (h/2)*(y[0] + (2*suma) + y[len(y)-1])
    print('RESULTADO [Trapezoid rule] : {0}'.format(trapezoid_rule))

def parabolic_rule(y, h):
    suma_i = 0
    suma_p = 0

    for i in range (1, len(y)-1):
        if i%2==0:
            suma_p += y[i]
        else:
            suma_i += y[i]   

    parabolic_rule = (h/3)*(y[0] + ((4*suma_i) + (2*suma_p)) + y[len(y)-1])
    print('RESULTADO [Parabolic/Simpson rule] : {0}'.format(parabolic_rule))

def int_no_rc():
    ## ----------------------INPUT DATA----------------------
    x = []
    y = []
    n = size_fx()   
    for i in range(0,n):
        x.append(float(input('Digite valor para X en {0}: '.format(i))))

    for i in range(0,n):
        y.append(float(input('Digite valor para f(x) en {0}: '.format(i))))
    ## ----------------------DATA PROCESSING----------------------
    a = x[0]
    b = x[len(x)-1]
    n = len(y)-1
    h = (b-a)/n
    ## --------------------------------------Trapezoid rule
    
    trapezoid_rule(y, h)

    ## --------------------------------------Parabolic/Simpson rule 

    parabolic_rule(y, h)

    ## --------------------------PLOT----------------------
               
    title = input('Digite el titulo del grafico: ')
    x_label = input('Digite la etiqueta para el eje X: ')
    y_label = input('Digite la etiqueta para el eje Y: ')
    plot_graph(a, b, n, x, y, title, x_label, y_label)
    

def run_alg():
    if opc == 1:
        print('INTEGRACION NUMERICA [Trapezoid rule and Parabolic/Simpson rule]')
        int_no_rc()

    
if __name__ == "__main__":
    run_alg()