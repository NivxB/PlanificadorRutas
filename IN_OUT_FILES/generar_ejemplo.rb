# para generar un caso de ejemplo puede ejecutarlo de la siguiente manera:
# ruby generar_ejemplo.rb
# Se crearan los siguientes archivos: entrada.txt, salida.txt, calculos.txt


def calcular_ruta(pepsi_x, pepsi_y, indices, x, y)
  i = 0
  origen_x = pepsi_x
  origen_y = pepsi_y
  distancia_total = 0
  while (i < indices.length) do
    destino_x = x[indices[i]]
    destino_y = y[indices[i]]
    distancia = Math.sqrt((destino_x-origen_x)**2 + (destino_y-origen_y)**2)
    distancia_total = distancia_total + distancia
    
    origen_x = destino_x
    origen_y = destino_y
    
    i = i + 1
  end
  
  
  destino_x = pepsi_x
  destino_y = pepsi_y
  
  distancia = Math.sqrt((destino_x-origen_x)**2 + (destino_y-origen_y)**2)
  distancia_total = distancia_total + distancia
  
  return distancia_total
end

camiones=3+Random.rand(500)
tiendas=50+Random.rand(7500)

x = tiendas.times.map{Random.rand(10000)}
y = tiendas.times.map{Random.rand(10000)}

pepsi_x = Random.rand(10000)
pepsi_y = Random.rand(10000)

file = File.open("entrada.txt", "w")
file.puts("#{camiones}")
file.puts("#{pepsi_x},#{pepsi_y}")

i = 0
while (i < tiendas) do
  file.puts("#{x[i]},#{y[i]}")
  i = i + 1
end
file.close()

#Este es un algoritmo tonto que divide la lista de tiendas en partes iguales por cada camion
#las tiendas son seleccionadas de manera aleatoria para cada camion


indices = (0..(tiendas-1)).to_a
indices_revueltos = indices.shuffle!
tiendas_por_camion = (tiendas / camiones.to_f).ceil
rutas = indices_revueltos.each_slice(tiendas_por_camion).to_a

calculos = File.open("calculos.txt", "w")

file = File.open("salida.txt", "w")
i = 0
puts("Tiendas: #{tiendas} Camiones: #{camiones} Tiendas por camion: #{tiendas_por_camion} Rutas: #{rutas.length}")
while (i < rutas.length) do
  ruta = rutas[i]
  file.puts("#{ruta.length}")
  j = 0
  while (j < ruta.length) do
    file.puts("#{ruta[j]}")
    j = j + 1
  end
  
  distancia_total = calcular_ruta(pepsi_x, pepsi_y, ruta, x, y)
  calculos.puts("Ruta #{i} distancia: #{distancia_total}")
  
  i = i + 1
end
file.close()
calculos.close()

