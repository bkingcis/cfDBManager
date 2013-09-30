<!--- COMPONENT --->
<cfcomponent displayname="DBTable" output="false" hint="I am the DBTable class." bean="true">
<cfproperty name="tableName" type="string" default="" />
<cfproperty name="tableType" type="string" default="" />
<cfproperty name="remarks" type="string" default="" />

<!--- PSEUDO-CONSTRUCTOR --->
<cfset variables.instance = {
	tableName = '',
	tableType = '',
	remarks = '',
} />

<!--- INIT --->
<cffunction name="init" access="public" output="false" returntype="any" hint="I am the constructor method for the DBTable class.">
  <cfargument name="tableName" type="string" required="true" default="" hint="" />
  <cfargument name="tableType" type="string" required="false" default="" hint="" />
  <cfargument name="remarks" type="string" required="false" default="" hint="" />
  <!--- set the initial values of the bean --->
  <cfscript>
	setTableName(ARGUMENTS.tableName);
	setTableType(ARGUMENTS.tableType);
	setRemarks(ARGUMENTS.remarks);
  </cfscript>
  <cfreturn this>
</cffunction>

<!--- SETTERS --->
<cffunction name="setTableName" access="public" output="false" hint="I set the tableName value into the variables.instance scope.">
  <cfargument name="tableName" type="string" required="true" default="" hint="I am the tableName value." />
  <cfset variables.instance.tableName = ARGUMENTS.tableName />
</cffunction>

<cffunction name="setTableType" access="public" output="false" hint="I set the tableType value into the variables.instance scope.">
  <cfargument name="tableType" type="string" required="false" default="" hint="I am the tableType value." />
  <cfset variables.instance.tableType = ARGUMENTS.tableType />
</cffunction>

<cffunction name="setRemarks" access="public" output="false" hint="I set the remarks value into the variables.instance scope.">
  <cfargument name="remarks" type="string" required="false" default="" hint="I am the remarks value." />
  <cfset variables.instance.remarks = ARGUMENTS.remarks />
</cffunction>

<!--- GETTERS --->
<cffunction name="getTableName" access="public" output="false" returntype="numeric" hint="I return the tableName value.">
  <cfreturn variables.instance.tableName />
</cffunction>

<cffunction name="getTableType" access="public" output="false" returntype="numeric" hint="I return the tableType value.">
  <cfreturn variables.instance.tableType />
</cffunction>

<cffunction name="getRemarks" access="public" output="false" returntype="numeric" hint="I return the remarks value.">
  <cfreturn variables.instance.remarks />
</cffunction>

<!--- UTILITY METHODS --->
<cffunction name="getMemento" access="public" output="false" hint="I return a struct of the variables.instance scope.">
  <cfreturn variables.instance />
</cffunction>
</cfcomponent>
