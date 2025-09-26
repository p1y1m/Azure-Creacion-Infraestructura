from pyspark.sql import SparkSession
from pyspark.sql.functions import col

# Crear sesión Spark
spark = SparkSession.builder.appName("PipelineVentas").getOrCreate()

# Configurar acceso a Blob Storage
spark.conf.set(
    "fs.azure.account.key.storagepipeline123.blob.core.windows.net",
    "bd8BA25IxGhlB+diEyhBY+tcxQ4FmOor6FVpdN6ZXEO/Znp0o5M9bab4n6p37lIzdiagv4Kh3Oxh+AStOPvhow=="
)

# Ruta al archivo en Blob Storage
input_path = "wasbs://datos@storagepipeline123.blob.core.windows.net/ventas.csv"

# Leer CSV
df = spark.read.csv(input_path, header=True, inferSchema=True)

# Agregar columna 'total'
df_result = df.withColumn("total", col("cantidad") * col("precio"))

# Mostrar primeras filas
df_result.show()

# Guardar resultado en un nuevo blob
output_path = "wasbs://datos@storagepipeline123.blob.core.windows.net/ventas_resultado"
df_result.write.mode("overwrite").csv(output_path, header=True)
