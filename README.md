cfDBManager
===========

This project is for the development of a database manager in ColdFusion.

This project has multiple stages, with each stage building on the functionality of the preceeding stage.

The first stage of this project can be described as a 'poor man's database tool'. It will incorporate only 
backup/restore and import/export functionality as defined in the mindmap (using Frremind) included with
this repository.

The second stage will build on these functions and allow the modification of data that exists in a chosen datasource.

The third stage will add the ability to add/modify tables, views and such.

The project is being designed for only MySQL and MSSQL, however PL/SQL Oracle savvy folks are more than welcome to extend
the project to Oracle databases. Big data folks may also extend it to one of the many NoSQL variants.

The backup/restore and import/export phases will include multiple format support (MySQL, MSSQL, JSON, XML, CSV, HTML,
etc. where applicable) and will be controlled primarily by ColdFusion Gateway interfaces that will process the information
in lazy mode, providing both rapid response for the front-end and eliminating timeout conditions when processing large
data sets.
