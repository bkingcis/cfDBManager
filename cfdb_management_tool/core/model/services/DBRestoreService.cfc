<!--- COMPONENT --->
<cfcomponent displayname="DBRestoreService" outputData="false" hint="I am the DBRestoreService class. I provide methods to restore data in the database.">

<!--- Pseudo-constructor --->
<cfset variables.instance = {
	datasource = ''
} />

<!--- INIT --->
<cffunction name="init" access="public" outputData="false" returntype="any" hint="I am the constructor method of the DBRestoreService class.">
  <cfargument name="datasource" type="any" required="true" hint="I am the Datasource bean." />
  <!--- Set the initial values of the Bean --->
  <cfscript>
	variables.instance.datasource = arguments.datasource;
  </cfscript>
  <cfreturn this>
</cffunction>

<!--- PUBLIC METHODS --->

<!--- RESTORE TABLE --->
<cffunction name="restoreTable" access="public" outputData="false" returntype="boolean" hint="I restore a table to the local file system and return the filename.">
	<cfargument name="tableName" type="string" required="true" hint="I am the name of the table in the database to retore to." />
	<cfargument name="columnList" type="string" required="true" hint="I am the columns of the table that should be retored." />
	<cfargument name="filename" type="string" required="true" hint="I am the name of the file to use for this restore." />
	<cfargument name="overwrite" type="boolean" required="false" default="true" hint="I am a flag to determine if the data in the database table should be overwritten or appended to. Default is 'true'." />
	<cfargument name="format" type="string" required="false" default="xml" hint="I am the input format for this restore, one of 'xml' (default), 'json' or 'csv'." />
	
	<!--- var scope --->
	<cfset var qPutData = '' />
	<cfset var qDelData = '' />
	<cfset var inputData = '' />
	<cfset var outputData = '' />
	<cfset var thisColumn = '' />
	<cfset var success = false />
	<cfset var thisError = '' />
	
	<!--- check if the file exists --->
	<cfif FileExists(ExpandPath('../../../storage/data/restore/#ARGUMENTS.filename#'))>
		<!--- it does, check if the file is zipped --->
		<cfif FindNoCase('zip',ListLast(ARGUMENTS.filename,'.'))>
			<!--- it is, unzip the file --->
			<cfzip action="unzip" destination="#ExpandPath('../../../storage/data/restore/)#" file="#ExpandPath('../../../storage/data/restore/#ARGUMENTS.filename#')#" overwrite="true" recurse="false" storepath="false">
			<!--- delete the zip file --->
			<cffile action="delete" file="#ExpandPath('../../../storage/data/restore/#ARGUMENTS.filename#')#" />
			<!--- modify the filename --->
			<cfset ARGUMENTS.filename = Left(ARGUMENTS.filename,Len(ARGUMENTS.filename)-4) />
		<!--- end checking if the file is zipped --->
		</cfzip>
		<!--- read the file --->
		<cffile action="read" charset="utf-8" file="#ExpandPath('../../../storage/data/restore/#ARGUMENTS.filename#')#" variable="inputData" />
	
		<!--- check if the inputData format is XML --->
		<cfif FindNoCase('xml',ARGUMENTS.format)>
			<!--- it is, convert the data to a CFML query --->
			<cfwddx action="wddx2cfml" input="#inputData#" output="outputData">
		<!--- otherwise, check if the inputData format is JSON --->
		<cfelseif FindNoCase('json',ARGUMENTS.format)>
			<!--- it is, deserialize the array data --->
			<cfset outputData = DeSerializeJSON(inputData) />
		<!--- end checking the inputData format of the restore --->
		</cfif>
		
		<!--- check if we are overwriting this table or appending to it --->
		<cfif ARGUMENTS.overwrite>
			<!--- we are overwriting, so delete all the data in the table --->
			<cfquery name="qDelData" datasource="#variables.instance.datasource.getDSN()#">
				DELETE FROM #ARGUMENTS.tableName#
			</cfquery>
		<!--- end checking if we are overwriting or appending the table --->
		</cfif>
		
		<!--- try --->
		<cftry>
			<!--- check if the format of outputData is a query --->
			<cfif IsQuery(outputData)>
				<!--- it is a query, loop over the query --->
				<cfloop query="outputData">
					<!--- insert this record into the database table --->
					<cfquery name="qPutData" datasource="#variables.instance.datasource.getDSN()#">
						INSERT INTO #ARGUMENTS.tableName#
							( #outputData.columnList# )
						VALUES
							(
						<cfloop index="thisColumn" list="#outputData.columnList#">
							<cfqueryparam value="#outputData[thisColumn]#"><cfif thisColumn NEQ ListLast(outputData.columnList)>,</cfif>
						</cfloop>
							)
					</cfquery>
				<!--- end looping through the query --->
				</cfloop>
				<!--- and set the success to true --->
				<cfset success = true />
			<!--- otherwise, check if the format of outputData is an array --->
			<cfif IsArray(outputData)>
				<!--- it is, loop through the array --->
				<cfloop from="1" to="#ArrayLen(outputData)#" index="iX">
					<!--- insert this record into the database table --->
					<cfquery name="qPutData" datasource="#variables.instance.datasource.getDSN()#">
						INSERT INTO #ARGUMENTS.tableName#
							( #StructKeyList(outputData[iX])# )
						VALUES
							(
						<cfloop index="thisColumn" list="#StructKeyList(outputData[iX])#">
							<cfqueryparam value="#outputData[iX][thisColumn]#"><cfif thisColumn NEQ ListLast(StructKeyList(outputData[iX]))>,</cfif>
						</cfloop>
							)
					</cfquery>
				<!--- end looping through the array --->
				</cfloop>
				<!--- and set the success to true --->
				<cfset success = true />		
			<!--- end checking if the format of outputData is a query or an array --->
			</cfif>
			
		<!--- catch any errors --->
		<cfcatch type="any">
			<!--- save the error content --->
			<cfsavecontent variable="thisError">
				<!--- dump the data --->
				<cfdump var="#cfcatch#" label="Error" format="text" />
			</cfsavecontent>
			<!--- log the error --->
			<cflog text="#thisError#" type="Error" log="Application" thread="yes" date="yes" time="yes" application="yes" />
		</cfcatch>
		
		<!--- end trying --->
		</cfif>
	
	<!--- delete the input file --->
	<cffile action="delete" file="#ExpandPath('../../../storage/data/restore/#ARGUMENTS.filename#')#" />
		
	<!--- end checking if the file exists --->
	</cfif>
	
	<!--- return the success variable --->
	<cfreturn success />
	
</cffunction>

</cfcomponent>