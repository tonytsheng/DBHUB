# script as an example to show multiple jobs in the spark ui
import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from awsglue.dynamicframe import DynamicFrameCollection
from awsglue.dynamicframe import DynamicFrame
from pyspark.sql import functions as F

# Script generated for node Custom transform
def MyTransform(glueContext, dfc) -> DynamicFrameCollection:
    df = dfc.select(list(dfc.keys())[0]).toDF()
    df_modified = df.withColumn('newDestURL', 'www.' + F.substring(F.col('destURL'), 1, 15))\
                    .withColumn('userAgent', F.substring(F.col('userAgent'), 1, 11))
    dyf_modified = DynamicFrame.fromDF(df_modified, glueContext, "modified URLs")
    return(DynamicFrameCollection({"CustomTransform0": dyf_modified}, glueContext))

args = getResolvedOptions(sys.argv, ['JOB_NAME', 'workshop_bucket'])

sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

# Script generated for node S3 bucket
S3bucket_node1 = glueContext.create_dynamic_frame.from_options(format_options={}, connection_type="s3", format="parquet", connection_options={"paths": ["s3://{}/input/lab7/scaling/".format(args['workshop_bucket'])], "recurse": True}, transformation_ctx="S3bucket_node1")

Filter_node1 = Filter.apply(frame = S3bucket_node1,
                              f = lambda x: x["duration"] >=5)
print("Filtered record count:  "+ str(Filter_node1.count()))

# Script generated for node ApplyMapping
ApplyMapping_node2 = ApplyMapping.apply(frame=Filter_node1, mappings=[("custKey", "int", "customer", "int"), ("yearmonthKey", "int", "visitYearMonth", "string"), ("visitDate", "int", "visitDate", "string"), ("adRevenue", "double", "adRevenue", "double"), ("countryCode", "string", "countryCode", "string"), ("destURL", "string", "destURL", "string"), ("duration", "int", "duration", "int"), ("languageCode", "string", "languageCode", "string"), ("searchWord", "string", "searchWord", "string"), ("sourceIP", "string", "sourceIP", "string"), ("userAgent", "string", "userAgent", "string")], transformation_ctx="ApplyMapping_node2")

# Script generated for node S3 bucket
S3bucket_node3 = glueContext.write_dynamic_frame.from_options(frame=ApplyMapping_node2, connection_type="s3", format="glueparquet", connection_options={"path": "s3://{}/output/lab7".format(args['workshop_bucket']), "partitionKeys": ["visitYearMonth", "countryCode"], 'groupSize': '10485760'}, transformation_ctx="S3bucket_node3")

job.commit()
