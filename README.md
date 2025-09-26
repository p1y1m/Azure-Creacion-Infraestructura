# Proyecto Azure – Infraestructura y Pipeline de Datos con Terraform, CLI y PySpark

Este proyecto demuestra la creación y gestión de infraestructura en Azure usando Terraform y Azure CLI, complementado con la ejecución de un pipeline de datos en PySpark.

El desarrollo se realizó principalmente desde Google Colab, integrando Google Drive como soporte, y documentando tanto los despliegues exitosos como la resolución de errores.

## Objetivos del Proyecto

- Implementar Infraestructura como Código (IaC) con Terraform.
- Gestionar servicios de Azure mediante CLI.
- Desplegar recursos clave:  
  - Storage Account  
  - Azure SQL Database  
  - Data Factory  
  - Azure Databricks  
  - Resource Groups  
- Construir un pipeline de datos en Blob Storage utilizando PySpark para consumir y procesar un CSV.

## Arquitectura de la Solución

1. Terraform (main.tf, variables.tf, outputs.tf) define y despliega la infraestructura en Azure.  
2. Azure CLI valida recursos, crea contenedores y sube archivos.  
3. PySpark (pipeline_ventas.py) procesa un archivo ventas.csv en Blob Storage, generando una salida con nuevas columnas y resultados.  
4. Databricks (intentado y documentado) pruebas de integración con Jobs y Workspaces.

## Archivos Clave

- main.tf → definición de recursos (Storage, SQL, Data Factory, Databricks).  
- variables.tf → variables reutilizables para parametrizar despliegues.  
- outputs.tf → outputs de Terraform para referencia posterior.  
- pipeline_ventas.py → script PySpark que:  
  - Lee un CSV desde Azure Blob Storage.  
  - Agrega una columna total = cantidad * precio.  
  - Guarda resultados en un nuevo contenedor.  
- proyecto_azure.py → comandos ejecutados en Google Colab (Terraform init/plan/apply, login CLI, configuración Databricks, PySpark).

## Ejecución del Proyecto

### 1. Preparación del entorno

Instalar Azure CLI, Terraform y autenticar con Azure CLI.

### 2. Inicializar Terraform
```
terraform init
terraform plan -out=tfplan
terraform apply -auto-approve tfplan
```

### 3. Validar recursos en Azure
```
az resource list --resource-group rg-pipeline-demo -o table
```

### 4. Crear contenedor y subir CSV
```
az storage container create --name datos --account-name storagepipeline123 --auth-mode login
az storage blob upload --account-name storagepipeline123 --container-name datos --name ventas.csv --file ventas.csv
```

### 5. Ejecutar Pipeline en PySpark
```
from pyspark.sql import SparkSession
from pyspark.sql.functions import col

spark = SparkSession.builder.appName("PipelineVentas").getOrCreate()

spark.conf.set("fs.azure.account.key.storagepipeline123.blob.core.windows.net", "<clave>")

df = spark.read.csv("wasbs://datos@storagepipeline123.blob.core.windows.net/ventas.csv", header=True, inferSchema=True)
df_result = df.withColumn("total", col("cantidad") * col("precio"))

df_result.write.mode("overwrite").csv("wasbs://datos@storagepipeline123.blob.core.windows.net/ventas_resultado", header=True)
```

## Resultados

- Infraestructura desplegada en Azure usando Terraform + CLI.  
- Creación y administración de Storage, SQL, Data Factory, Databricks.  
- Pipeline de datos en Blob Storage + PySpark.  
- Documentación completa de errores y soluciones aplicadas hasta lograr un pipeline operativo real.

## Evidencias

Código completo: [GitHub Repo Link]  
Ejecución en Google Colab: [Notebook Link]

## Tags
#Azure #Terraform #PySpark #Cloud #DevOps #DataEngineering #IaC #Portafolio
