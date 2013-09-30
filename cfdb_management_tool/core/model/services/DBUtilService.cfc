<!--- COMPONENT --->
<cfcomponent displayname="DBUtilService" output="false" hint="I am the DBUtilService class. I provide utility methods and facades to interface with the database.">

<!--- Pseudo-constructor --->
<cfset variables.instance = {
	datasource = ''
} />

<!--- INIT --->
<cffunction name="init" access="public" output="false" returntype="any" hint="I am the constructor method of the DBUtilService class.">
  <cfargument name="datasource" type="any" required="true" hint="I am the Datasource bean." />
  <!--- Set the initial values of the Bean --->
  <cfscript>
	variables.instance.datasource = arguments.datasource;
  </cfscript>
  <cfreturn this>
</cffunction>

<!--- PUBLIC METHODS --->

<!--- GET DBVERSION (SINGLETON) --->
<cffunction name="getVersion" access="public" output="false" returntype="any" hint="I return the version information of the database in the DBVersion Singleton (core.model.singletons.DBVersion)">
	<cfargument name="parseResults" type="boolean" required="false" default="true" hint="I determine if the results are parsed or not. Parsed results attempt to minimize the amount of data returned." /> 

	<!--- var scope --->
	<cfset var returnObj = '' />
	<cfset var qGetVersion = '' />
	<cfset var thisDbVersion = 0 />
	
	<!--- get the version information for the datasource --->
	<cfdbinfo datasource="#variables.instance.datasource.getDSN()#" name="qGetVersion" type="version" />
	
	<!--- check if the results are to be parsed --->
	<cfif ARGUMENTS.parseResults>
		<!--- check for the version of the database --->
		<cfif Find('2000',qGetVersion.database_version)>
			<cfset thisDbVersion = 2000 />
		<cfelseif Find('2005',qGetVersion.database_version)>
			<cfset thisDbVersion = 2005 />
		<cfelseif Find('2008',qGetVersion.database_version)>
			<cfset thisDbVersion = 2008 />
		<cfelseif Find('2012',qGetVersion.database_version)>
			<cfset thisDbVersion = 2012 />
		<cfelse>
			<cfset thisDbVersion = qGetVersion.database_version) />
		</cfif>
	<!--- otherwise --->
	<cfelse>
		<!--- do not parse, return results as defined --->
		<cfset thisDbVersion = qGetVersion.database_version) />
	<!--- end checking if the results are to be parsed --->
	</cfif>
			
	<!--- create the DBVersion singleton --->
	<cfset returnObj = CreateObject('component','core.model.singletons.DBVersion').init(
		dbName 				= qGetVersion.database_productname,
		dbVersion 			= thisDbVersion,
		driverName 			= qGetVersion.driver_name,
		driverVersion 		= qGetVersion.driver_version,
		jdbcMajorVersion 	= qGetVersion.jdbc_major_version,
		jdbcMinorVersion 	= qGetVersion.jdbc_minor_version
	) />
	
	<!--- return the singleton --->
	<cfreturn returnObj />
	
</cffunction>

<!--- GET TABLES AND/OR VIEWS --->
<cffunction name="getTablesViews" access="public" output="false" returntype="any" hint="I return the tables and views as a struct with an array of (core.model.beans.)DBTable and (core.model.beans.)DBView objects.">
	<cfargument name="excludeTables" type="boolean" required="false" default="false" hint="I am a flag to determine if tables should be excluded form the returned data." />
	<cfargument name="excludeViews" type="boolean" required="false" default="false" hint="I am a flag to determine if views should be excluded form the returned data." />

	<!--- var scope --->
	<cfset var qGetTablesViews = '' />
	<cfset var qGetTables = '' />
	<cfset var tableArray = ArrayNew(1) />
	<cfset var DBTableObj = '' />
	<cfset var qGetViews = '' />
	<cfset var viewArray = ArrayNew(1) />
	<cfset var DBViewObj = '' />
	<cfset var returnStruct = StructNew() />
	
	<!--- get the tables and views for the datasource --->
	<cfdbinfo datasource="#variables.instance.datasource.getDSN()#" name="qGetTablesViews" type="tables" />
	
	<!--- check if tables should be included in the results --->
	<cfif NOT ARGUMENTS.excludeTables>
	
		<!--- get the tables from the query --->
		<cfquery name="qGetTables" dbtype="query">
		SELECT remarks, table_name, table_type
		FROM qGetTableViews
		WHERE table_type = <cfqueryparam value="TABLE" cfsqltype="cf_sql_varchar" />
		</cfquery>

		<!--- convert the query into an array of DBTable objects --->
		<cfloop query="qGetTables">
			<!--- create the DBTable object --->
			<cfset DBTableObj = CreateObject('component','core.model.beans.DBTable').init(
				tableName	= qGetTables.table_name,
				tableType	= qGetTables.table_type,
				remarks		= qGetTables.remarks
			) />
			<!--- put the object into the tableArray --->
			<cfset ArrayAppend(tableArray,DBTableObj) />
		<!--- end looping through the query --->
		</cfloop
		
		><!--- put the tableArray into the returnStruct --->
		<cfset returnStruct.tables = tableArray />
		
	<!--- end checking if tables should be included in the results --->
	</cfif>

	<!--- check if views should be included in the results --->
	<cfif NOT ARGUMENTS.excludeViews>
	
		<!--- get the views from the query --->
		<cfquery name="qGetViews" dbtype="query">
			SELECT remarks, table_name, table_type
			FROM qGetTableViews
			WHERE table_type = <cfqueryparam value="VIEW" cfsqltype="cf_sql_varchar" />
		</cfquery>

		<!--- convert the query into an array of DBView objects --->
		<cfloop query="qGetViews">
			<!--- create the DBView object --->
			<cfset DBViewObj = CreateObject('component','core.model.beans.DBView').init(
				viewName	= qGetViews.table_name,
				viewType	= qGetViews.table_type,
				remarks		= qGetViews.remarks
			) />
			<!--- put the object into the tableArray --->
			<cfset ArrayAppend(viewArray,DBViewObj) />
		<!--- end looping through the query --->
		</cfloop>
		
		<!--- put the viewArray into the returnStruct --->
		<cfset returnStruct.views = viewArray />
		
	<!--- end checking if views should be included in the results --->
	</cfif>
	
	<!--- return the data --->
	<cfreturn returnStruct />
	
</cffunction>

<!--- GET TABLE COLUMNS --->
<cffunction name="getTableColumns" access="public" output="false" returntype="array" hint="I return an array of (core.model.beans.)DBColumn objects for columns in a table.">
	<cfargument name="tableName" type="string" required="true" hint="I am the name of the database table to return column data for." />
	<cfargument name="useMemento" type="boolean" required="false" default="false" hint="I am a flag to determine if the data is returned as an array of objects (false, default), or as an array of the memento's of each object (true)." />
	
	<!--- var scope --->
	<cfset var qGetColumns = '' />
	<cfset var DBColumnObj = '' />
	<cfset var returnArray = ArrayNew(1) />
	
	<!--- get the columns for the passed table --->	
	<cfdbinfo datasource="#variables.instance.datasource.getDSN()#" name="qGetColumns" type="columns" table="#ARGUMENTS.tableName#" />

	<!--- set the first array as a list of column names --->
	<cfset returnArray[1] = ValueList(qGetColumns.column_name) />
	
	<!--- loop through the columns --->
	<cfloop query="qGetColumns">	
		<!--- create a DBColumn object for each column --->
		<cfset DBColumnObj = CreateObject('component','core.model.beans.DBColumn').init(
			columnName		= qGetColumns.column_name,
			columnType 		= qGetColumns.type_name,
			columnSize 		= qGetColumns.column_size,
			defaultValue 	= qGetColumns.column_default_value,
			isNullable 		= qGetColumns.is_nullable,
			isPrimary 		= qGetColumns.is_primary_key,
			isForeign 		= qGetColumns.is_foreign_key,
			charOctLen 		= qGetColumns.char_octet_length,
			decimalDigits 	= qGetColumns.decimal_digits,
			displayOrder 	= qGetColumns.ordinal_position,
			refPrimary		= qGetColumns.referenced_primarykey,
			refPrimaryTable = qGetColumns.referenced_primarykey_table,
			remarks 		= qGetColumns.remarks
		) />
		<!--- check if returning an array of objects or memento's --->
		<cfif ARGUEMENTS.useMemento>
			<!--- we're returning memento's, add the memento of this object to the array --->
			<cfset ArrayAppend(returnArray,DBColumnObj.getMemento()) />
		<!--- otherwise --->
		<cfelse>
			<!--- add the DBColumn object to the returnArray --->
			<cfset ArrayAppend(returnArray,DBColumnObj) />
		</cfif>
		
	<!--- end looping through the columns --->
	</cfloop>
	
	<!--- return the returnArray --->
	<cfreturn returnArray />
	
</cffunction>


</cfcomponent>