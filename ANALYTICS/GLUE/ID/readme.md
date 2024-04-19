# Set up
- Get the right data into the right buckets.

# Lab 1
- Creating crawlers - csv and json.

# Lab 2 - Glue Studio and Spark Jobs/Notebooks
- Spark revolves around the concept of a resilient distributed dataset (RDD), which is a fault-tolerant collection of elements that can be operated on in parallel. There are two ways to create RDDs: parallelizing an existing collection in your driver program, or referencing a dataset in an external storage system, such as a shared filesystem, HDFS, HBase, or any data source offering a Hadoop InputFormat.

 
- RDD (Resilient Distributed Dataset) is a fundamental building block of PySpark which is fault-tolerant, immutable distributed collections of objects. Immutable meaning once you create an RDD you cannot change it. Each record in RDD is divided into logical partitions, which can be computed on different nodes of the cluster.

In other words, RDDs are a collection of objects similar to list in Python, with the difference being RDD is computed on several processes scattered across multiple physical servers also called nodes in a cluster while a Python collection lives and process in just one process.

- PySpark benefits
In-Memory Processing - PySpark loads the data from disk and process in memory and keeps the data in memory, this is the main difference between PySpark and Mapreduce (I/O intensive). In between the transformations, we can also cache/persists the RDD in memory to reuse the previous computations.

Immutability - PySpark RDDs are immutable in nature meaning, once RDDs are created you cannot modify. When we apply transformations on RDD, PySpark creates a new RDD and maintains the RDD Lineage.

Fault Tolerance - PySpark operates on fault-tolerant data stores on HDFS, S3 e.t.c hence any RDD operation fails, it automatically reloads the data from other partitions. Also, When PySpark applications running on a cluster, PySpark task failures are automatically recovered for a certain number of times (as per the configuration) and finish the application seamlessly.

Lazy Evolution - PySpark does not evaluate the RDD transformations as they appear/encountered by Driver instead it keeps the all transformations as it encounters(DAG) and evaluates the all transformation when it sees the first RDD action.

Partitioning - When you create RDD from a data, It by default partitions the elements in a RDD. By default it partitions to the number of cores available.

- Spark RDD Transformations
Transfromation performed over Spark are RDD Transformations; which may result to one or more RDDs. RDDs are immutable in nature, transformation always create new RDD without updating the existing one.

Lazy Transformation

RDD Transformations are lazy transformations. It mean none of the operations get executed untill you can call an action on Spark RDD.

RDD Transformation Type

1. Narrow Transformation

Narrow transformations are the result of map() and filter() functions on the compute data that live on a single partition. That means there is no data movement between partitions to execute narrow transformations.

Functions such as map(), mapPartition(), flatMap(), filter(), union() are some examples of narrow transformation

2. Wider/Shuffle transformations

Wider transformations are the result of groupByKey() and reduceByKey() functions on the compute data that live on many partitions. This means there will be data movements between partitions to execute wider transformations. Since these shuffles the data, they also called shuffle transformations.

You can learn more about Spark transformation here .

filter() Return a new dataset formed by selecting those elements of the source on which function returns true.

- Working with Key-Value Pairs
While most Spark operations work on RDDs containing any type of objects, a few special operations are only available on RDDs of key-value pairs. The most common ones are distributed-shuffle-operations, such as grouping or aggregating the elements by a key.

In Python, these operations work on RDDs containing built-in Python tuples such as (1, 2). Simply create such tuples and then call your desired operation.

# Dataframe
- Spark createOrReplaceTempView()
How does the createOrReplaceTempView() method work in Spark and what is it used for? One of the main advantages of Apache Spark is working with SQL along with DataFrame/Dataset API. So if you are comfortable with SQL, you can create a temporary view on DataFrame/Dataset by using createOrReplaceTempView() and using SQL to select and manipulate the data.

A Temporary view in Spark is similar to a real SQL table that contains rows and columns but the view is not materialized into files. In this article, we will be discussing what is createOrReplaceTempView() and how to use it to create a temporary view and run Spark SQL queries.
