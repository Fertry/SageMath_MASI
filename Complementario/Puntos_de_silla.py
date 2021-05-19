A = [[0,-1,0,-3,-3],[1,-1,0,-2,11],[-1,0,-3,-2,-1],[-1,1,0,-1,-12],[1,-8,0,1,2]]
#A = [[0,-1,0,-3,-3],[1,-1,0,-2,11],[-1,0,-3,-2,-1],[-1,1,0,-1,-12],[1,-8,0,1,2]]

print(A)

maximoFilas = [-999,-999,-999,-999,-999]
minimoColumnas = [999,999,999,999,999]

for i in range(0,5):
    for j in range(0,5):
    
        if (A[i][j] > maximoFilas[i]):
            maximoFilas[i] = A[i][j]
            
        if (A[i][j] < minimoColumnas[j]):
            minimoColumnas[j] = A[i][j]
            
for i in range(0,5):
    for j in range(0,5):
    
        if (maximoFilas[i] == minimoColumnas[j]):
            print("Punto de silla en: " + str(i) + "," + str(j))
        else:
            print("No hay punto de silla")