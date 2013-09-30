<!--- COMPONENT --->
<cfcomponent displayname="DBBackupService" output="false" hint="I am the DBBackupService class. I provide methods to backup data in the database.">

<!--- Pseudo-constructor --->
<cfset variables.instance = {
	datasource = ''
} />

<!--- INIT --->
<cffunction name="init" access="public" output="false" returntype="any" hint="I am the constructor method of the DBBackupService class.">
  <cfargument name="datasource" type="any" required="true" hint="I am the Datasource bean." />
  <!--- Set the initial values of the Bean --->
  <cfscript>
	variables.instance.datasource = arguments.datasource;
  </cfscript>
  <cfreturn this>
</cffunction>

<!--- PUBLIC METHODS --->

<!--- BACKUP TABLE --->
<cffunction name="backupTable" access="public" output="false" returntype="string" hint="I backup a table to the local file system and return the filename.">
	<cfargument name="tableName" type="string" required="true" hint="I am the name of the table in the database to back up." />
	<cfargument name="columnList" type="string" required="true" hint="I am the columns of the table that should be backed up." />
	<cfargument name="useZip" type="boolean" required="false" default="true" hint="I am a flag to determine if the output file should be in .zip format." />
	<cfargument name="format" type="string" required="false" default="xml" hint="I am the output format for this backup, one of 'xml', 'json', 'csv' or 'html'." />
	
	<!--- var scope --->
	<cfset var qGetData = '' />
	<cfset var outputData = '' />
	<cfset var thisColumn = 0 />
	<cfset var thisStruct = StructNew() />
	<cfset var thisArray = ArrayNew(1) />
	<cfset var newLine = Chr(13) & Chr(10) />
	<cfset var buffer = CreateObject( "java", "java.lang.StringBuffer" ).Init() />
	<cfset var rowData = ArrayNew(1) />
	<cfset var columnName = '' />
	<cfset var columnArray = '' />
	<cfset var columnIndex = '' />
	<cfset var columnCount = 0 />
	<cfset var fileExt = '' />
	<cfset var baseFilename = variables.instance.datasource.getDSN() & '_' & ARGUMENTS.tableName & '_' & DateFormat(Now(),'yyyymmdd') />
	<cfset var thisFilename = '' />
	
	<!--- get the data --->
	<cfquery name="qGetData" datasource="#variables.instance.datasource.getDSN()#">
		SELECT #ARGUMENTS.columnList#
		FROM #ARGUMENTS.tableName#
	</cfquery>
	
	<!--- check if the output format is XML --->
	<cfif FindNoCase('xml',ARGUMENTS.format)>
		<!--- it is, convert the data to XML --->
		<cfwddx action="cfml2wddx" input="#qGetData#" output="outputData">
		<!--- set the file extension to .xml --->
		<cfset fileExt = '.xml' />
		<!--- otherwise, check if the output format is JSON --->
	<cfelseif FindNoCase('json',ARGUMENTS.format)>
		<!--- it is, loop over the data to convert the query to an array of structs instead --->
		<cfloop query="qGetData">
			<!--- create a struct to hold the data --->
			<cfset thisStruct = StructNew() />
			<!--- loop through the columns to backup --->
			<cfloop index="thisColumn" list="#ARGUMENTS.columnList#">
				<!--- set the data into the struct --->
				<cfset thisStruct[thisColumn] = qGetData[thisColumn] />
			</cfloop>
			<!--- add this struct data to the array --->
			<cfset ArrayAppend(thisArray,thisStruct) />
		</cfloop>
		<!--- serialize the array data --->
		<cfset outputData = SerializeJSON(thisArray) />
		<!--- set the file extension to .json --->
		<cfset fileExt = '.json' />
	<!--- otherwise, check if the output format is CSV --->
	<cfelseif FindNoCase('csv',ARGUMENTS.format)>
		<!--- loop over the backup list --->
		<cfloop index="columnName" list="#ARGUMENTS.columnList#">
			<!--- store the current column name --->
			<cfset ArrayAppend(columnArray,Trim(columnName)) />
		</cfloop>
		<!--- store the column count --->
		<cfset columnCount = ArrayLen(columnArray) />
		<!--- loop over the column names --->
		<cfloop index="columnIndex" from="1" to="#columnCount#">
			<!--- add the field name to the row data --->
			<cfset rowData[columnIndex] = """#columnArray[columnIndex]#""" />
		</cfloop>
		<!--- append the row data to the string buffer --->
		<cfset buffer.Append(JavaCast("string",(ArrayToList(rowData,',') & newLine))) />
		<!--- loop over the query --->
		<cfloop query="qGetData">
			<!--- create array to hold row data --->
			<cfset rowData = ArrayNew(1) />
			<!--- loop over the columns --->
			<cfloop index="columnIndex" from="1" to="#columnCount#">
				<!--- add the field to the row data --->
				<cfset rowData[columnIndex] = """#Replace(qGetData[columnArray[columnIndex]][qGetData.CurrentRow],"""","""""","ALL" )#""" />
			</cfloop>
			<!--- append the row data to the string buffer --->
			<cfset buffer.Append(JavaCast("string",(ArrayToList(rowData,',') & newLine))) />
		</cfloop>
		<!--- set the output data from the buffer --->
		<cfset outputData = buffer.ToString() />
		<!--- set the file extension to .csv --->
		<cfset fileExt = '.csv' />
	<!--- otherwise, check if the format is HTML --->
	<cfelseif FindNoCase('html',ARGUMENTS.format)>
		<!---it is, save the content as outputData --->
		<cfsavecontent variable="outputData">
			<!--- dump the query to HTML --->
			<cfdump var="#qGetData#" label="#ARGUMENTS.tableName#" />
		</cfsavecontent>
		<!--- set the file extension to .html --->
		<cfset fileExt = '.html' />
	<!--- end checking the output format of the backup --->
	</cfif>
	
	<!--- check if we're using zip to store the table data --->
	<cfif ARGUMENTS.useZip>
		<!--- we are, set the .zip filename --->
		<cfset thisFilename = expandPath("../../../storage/data/backup/#baseFilename##fileExt#.zip")>
		<!--- zip the outputData --->
		<cfzip action="zip" file="#thisFilename#" overwrite="true">
			<cfzipparam content="#outputData#" entrypath="#baseFilename##fileExt#" />
		</cfzip>
	<!--- otherwise --->
	<cfelse>
		<!--- not using zip, set the output filename --->
		<cfset thisFilename = expandPath("../../../storage/data/backup/#baseFilename##fileExt#")>
		<!--- and write the data to a file --->
		<cffile action="write" addnewline="yes" charset="utf-8" file="#thisFilename#" output="#outputData#" fixnewline="yes" nameconflict="overwrite" />
	</cfif>
	
	<!--- return the filename --->
	<cfreturn thisFilename />
	
</cffunction>

</cfcomponent>