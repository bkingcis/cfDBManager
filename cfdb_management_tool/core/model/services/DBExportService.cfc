<!--- COMPONENT --->
<cfcomponent displayname="DBExportService" output="false" hint="I am the DBExportService class. I provide methods to export data in the database.">

<!--- Pseudo-constructor --->
<cfset variables.instance = {
	datasource = ''
} />

<!--- INIT --->
<cffunction name="init" access="public" output="false" returntype="any" hint="I am the constructor method of the DBExportService class.">
  <cfargument name="datasource" type="any" required="true" hint="I am the Datasource bean." />
  <cfargument name="utilService" type="any" required="true" hint="I am the DBUtilService service." />
  <!--- Set the initial values of the Service --->
  <cfset variables.instance.datasource = ARGUMENTS.datasource />
  <cfset variables.instance.utilService = ARGUMENTS.utilService />
  <!--- return the service --->
  <cfreturn this>
</cffunction>

<!--- PUBLIC METHODS --->

<!--- BACKUP TABLE --->
<cffunction name="exportTable" access="public" output="false" returntype="string" hint="I export a table to the local file system and return the filename.">
	<cfargument name="tableName" type="string" required="true" hint="I am the name of the table in the database to export." />
	<cfargument name="format" type="string" required="false" default="mysql" hint="I am the output format for this export, one of 'mysql' (default), 'mssql', 'xml' or 'json'." />
	
	<!--- var scope --->
	<cfset var dbColumnObj = '' />
	<cfset var fileExt = '' />
	<cfset var outputData = '' />
	
	<!--- check if the output format is XML --->
	<cfif FindNoCase('xml',ARGUMENTS.format)>
		<!--- it is, get the memento array of this table --->
 		<cfset dbColumnObj = variables.instance.utilService.getTableColumns(tableName = ARGUMENTS.tableName, useMemento = true) />
		<!--- and convert the data to XML --->
		<cfwddx action="cfml2wddx" input="#dbColumnObj.getMemento()#" output="outputData">
		<!--- set the file extension to .xml --->
		<cfset fileExt = '.xml' />
		<!--- otherwise, check if the output format is JSON --->
	<cfelseif FindNoCase('json',ARGUMENTS.format)>
		<!--- it is, get the memento array of this table --->
 		<cfset dbColumnObj = variables.instance.utilService.getTableColumns(tableName = ARGUMENTS.tableName, useMemento = true) />
		<!--- and serialize the array data --->
		<cfset outputData = SerializeJSON(dbColumnObj.getMemento()) />
		<!--- set the file extension to .json --->
		<cfset fileExt = '.json' />
	<!--- otherwise, check if the output format is MySQL --->
	<cfelseif FindNoCase('mysql',ARGUMENTS.format)>
		<!--- export the table in mysql format --->
		<cfsavecontent variable="outputData">
	
	
	<!--- otherwise, check if the output format is MSSQL --->
	<cfelseif FindNoCase('mssql',ARGUMENTS.format)>
	
	
	<!--- end checking the output format of the export --->
	</cfif>
	
	<!--- check if we're using zip to store the table data --->
	<cfif ARGUMENTS.useZip>
		<!--- we are, set the .zip filename --->
		<cfset thisFilename = expandPath("../../../storage/data/export/#baseFilename##fileExt#.zip")>
		<!--- zip the outputData --->
		<cfzip action="zip" file="#thisFilename#" overwrite="true">
			<cfzipparam content="#outputData#" entrypath="#baseFilename##fileExt#" />
		</cfzip>
	<!--- otherwise --->
	<cfelse>
		<!--- not using zip, set the output filename --->
		<cfset thisFilename = expandPath("../../../storage/data/export/#baseFilename##fileExt#")>
		<!--- and write the data to a file --->
		<cffile action="write" addnewline="yes" charset="utf-8" file="#thisFilename#" output="#outputData#" fixnewline="yes" nameconflict="overwrite" />
	</cfif>
	
	<!--- return the filename --->
	<cfreturn thisFilename />
	
</cffunction>

</cfcomponent>