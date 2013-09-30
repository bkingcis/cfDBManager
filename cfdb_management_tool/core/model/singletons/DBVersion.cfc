<!--- COMPONENT --->
<cfcomponent displayname="DBVersion" output="false" hint="I am the DBVersion class." singleton="true">
<cfproperty name="dbName" type="string" default="0" />
<cfproperty name="dbVersion" type="string" default="0" />
<cfproperty name="driverName" type="string" default="0" />
<cfproperty name="driverVersion" type="string" default="" />
<cfproperty name="jdbcMajorVersion" type="string" default="0" />
<cfproperty name="jdbcMinorVersion" type="string" default="" />

<!--- PSEUDO-CONSTRUCTOR --->
<cfset variables.instance = {
	dbName = '',
	dbVersion = '0',
	driverName = '',
	driverVersion = '0',
	jdbcMajorVersion = '0',
	jdbcMinorVersion = '0'
} />

<!--- INIT --->
<cffunction name="init" access="public" output="false" returntype="any" hint="I am the constructor method for the DBVersion class.">
  <cfargument name="dbName" type="string" required="true" default="" hint="" />
  <cfargument name="dbVersion" type="string" required="false" default="" hint="" />
  <cfargument name="driverName" type="string" required="false" default="" hint="" />
  <cfargument name="driverVersion" type="string" required="false" default="" hint="" />
  <cfargument name="jdbcMajorVersion" type="string" required="false" default="" hint="" />
  <cfargument name="jdbcMinorVersion" type="string" required="false" default="" hint="" />
  <!--- set the initial values of the bean --->
  <cfscript>
	setDbName(ARGUMENTS.dbName);
	setDbVersion(ARGUMENTS.dbVersion);
	setDriverName(ARGUMENTS.driverName);
	setDriverVersion(ARGUMENTS.driverVersion);
	setJdbcMajorVersion(ARGUMENTS.jdbcMajorVersion);
	setJdbcMinorVersion(ARGUMENTS.jdbcMinorVersion);
  </cfscript>
  <cfreturn this>
</cffunction>

<!--- SETTERS --->
<cffunction name="setDbName" access="public" output="false" hint="I set the dbName value into the variables.instance scope.">
  <cfargument name="dbName" type="string" required="true" default="" hint="I am the dbName value." />
  <cfset variables.instance.dbName = ARGUMENTS.dbName />
</cffunction>

<cffunction name="setDbVersion" access="public" output="false" hint="I set the dbVersion value into the variables.instance scope.">
  <cfargument name="dbVersion" type="string" required="false" default="" hint="I am the dbVersion value." />
  <cfset variables.instance.dbVersion = ARGUMENTS.dbVersion />
</cffunction>

<cffunction name="setDriverName" access="public" output="false" hint="I set the driverName value into the variables.instance scope.">
  <cfargument name="driverName" type="string" required="false" default="" hint="I am the driverName value." />
  <cfset variables.instance.driverName = ARGUMENTS.driverName />
</cffunction>

<cffunction name="setDriverVersion" access="public" output="false" hint="I set the driverVersion value into the variables.instance scope.">
  <cfargument name="driverVersion" type="string" required="true" default="" hint="I am the driverVersion value." />
  <cfset variables.instance.driverVersion = ARGUMENTS.driverVersion />
</cffunction>

<cffunction name="setJdbcMajorVersion" access="public" output="false" hint="I set the jdbcMajorVersion value into the variables.instance scope.">
  <cfargument name="jdbcMajorVersion" type="string" required="false" default="" hint="I am the jdbcMajorVersion value." />
  <cfset variables.instance.jdbcMajorVersion = ARGUMENTS.jdbcMajorVersion />
</cffunction>

<cffunction name="setJdbcMinorVersion" access="public" output="false" hint="I set the jdbcMinorVersion value into the variables.instance scope.">
  <cfargument name="jdbcMinorVersion" type="string" required="true" default="" hint="I am the jdbcMinorVersion value." />
  <cfset variables.instance.jdbcMinorVersion = ARGUMENTS.jdbcMinorVersion />
</cffunction>

<!--- GETTERS --->
<cffunction name="getDbName" access="public" output="false" returntype="numeric" hint="I return the dbName value.">
  <cfreturn variables.instance.dbName />
</cffunction>

<cffunction name="getDbVersion" access="public" output="false" returntype="numeric" hint="I return the dbVersion value.">
  <cfreturn variables.instance.dbVersion />
</cffunction>

<cffunction name="getDriverName" access="public" output="false" returntype="numeric" hint="I return the driverName value.">
  <cfreturn variables.instance.driverName />
</cffunction>

<cffunction name="getDriverVersion" access="public" output="false" returntype="string" hint="I return the driverVersion value.">
  <cfreturn variables.instance.driverVersion />
</cffunction>

<cffunction name="getJdbcMajorVersion" access="public" output="false" returntype="numeric" hint="I return the jdbcMajorVersion value.">
  <cfreturn variables.instance.jdbcMajorVersion />
</cffunction>

<cffunction name="getJdbcMinorVersion" access="public" output="false" returntype="string" hint="I return the jdbcMinorVersion value.">
  <cfreturn variables.instance.jdbcMinorVersion />
</cffunction>

<!--- UTILITY METHODS --->
<cffunction name="getMemento" access="public" output="false" hint="I return a struct of the variables.instance scope.">
  <cfreturn variables.instance />
</cffunction>
</cfcomponent>
