<!--- COMPONENT --->
<cfcomponent displayname="DBView" output="false" hint="I am the DBView class." bean="true">
<cfproperty name="viewName" type="string" default="" />
<cfproperty name="viewType" type="string" default="" />
<cfproperty name="remarks" type="string" default="" />

<!--- PSEUDO-CONSTRUCTOR --->
<cfset variables.instance = {
	viewName = '',
	viewType = '',
	remarks = '',
} />

<!--- INIT --->
<cffunction name="init" access="public" output="false" returntype="any" hint="I am the constructor method for the DBView class.">
  <cfargument name="viewName" type="string" required="true" default="" hint="" />
  <cfargument name="viewType" type="string" required="false" default="" hint="" />
  <cfargument name="remarks" type="string" required="false" default="" hint="" />
  <!--- set the initial values of the bean --->
  <cfscript>
	setViewName(ARGUMENTS.viewName);
	setViewType(ARGUMENTS.viewType);
	setRemarks(ARGUMENTS.remarks);
  </cfscript>
  <cfreturn this>
</cffunction>

<!--- SETTERS --->
<cffunction name="setViewName" access="public" output="false" hint="I set the viewName value into the variables.instance scope.">
  <cfargument name="viewName" type="string" required="true" default="" hint="I am the viewName value." />
  <cfset variables.instance.viewName = ARGUMENTS.viewName />
</cffunction>

<cffunction name="setViewType" access="public" output="false" hint="I set the viewType value into the variables.instance scope.">
  <cfargument name="viewType" type="string" required="false" default="" hint="I am the viewType value." />
  <cfset variables.instance.viewType = ARGUMENTS.viewType />
</cffunction>

<cffunction name="setRemarks" access="public" output="false" hint="I set the remarks value into the variables.instance scope.">
  <cfargument name="remarks" type="string" required="false" default="" hint="I am the remarks value." />
  <cfset variables.instance.remarks = ARGUMENTS.remarks />
</cffunction>

<!--- GETTERS --->
<cffunction name="getViewName" access="public" output="false" returntype="numeric" hint="I return the viewName value.">
  <cfreturn variables.instance.viewName />
</cffunction>

<cffunction name="getViewType" access="public" output="false" returntype="numeric" hint="I return the viewType value.">
  <cfreturn variables.instance.viewType />
</cffunction>

<cffunction name="getRemarks" access="public" output="false" returntype="numeric" hint="I return the remarks value.">
  <cfreturn variables.instance.remarks />
</cffunction>

<!--- UTILITY METHODS --->
<cffunction name="getMemento" access="public" output="false" hint="I return a struct of the variables.instance scope.">
  <cfreturn variables.instance />
</cffunction>
</cfcomponent>
