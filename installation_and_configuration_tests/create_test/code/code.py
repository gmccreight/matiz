from pathlib import Path
from pyspark.context import SparkContext
from pyspark.sql.session import SparkSession
sc = SparkContext('local')
spark = SparkSession(sc)

myRange = spark.range(100000000).toDF("number")
divisBy2 = myRange.where("number % 2 = 0")
result = divisBy2.count()
Path('/installation_and_configuration_tests/pyspark_divis_test/results/results.txt').write_text(str(result))
