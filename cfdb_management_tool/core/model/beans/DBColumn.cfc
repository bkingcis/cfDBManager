<!--- COMPONENT --->
<cfcomponent displayname="DBColumn" output="false" hint="I am the DBColumn class.">
<cfproperty name="columnName" type="string" default="" />
<cfproperty name="columnType" type="string" default="" />
<cfproperty name="columnSize" type="numeric" default="0" />
<cfproperty name="defaultValue" type="string" default="" />
<cfproperty name="isNullable" type="boolean" default="0" />
<cfproperty name="isPrimary" type="boolean" default="0" />
<cfproperty name="isForeign" type="boolean" default="0" />
<cfproperty name="charOctLen" type="numeric" default="0" />
<cfproperty name="decimalDigits" type="numeric" default="0" />
<cfproperty name="displayOrder" type="numeric" default="0" />
<cfproperty name="refPrimary" type="string" default="" />
<cfproperty name="refPrimaryTable" type="string" default="" />
<cfproperty name="remarks" type="string" default="" />

<!--- PSEUDO-CONSTRUCTOR --->
<cfset variables.instance = {
	columnName = '',
	columnType = '',
	columnSize = '0',
	defaultValue = '',
	isNullable = '0',
	isPrimary = '0',
	isForeign = '0',
	charOctLen = '0',
	decimalDigits = '0',
	displayOrder = '0',
	refPrimary = '',
	refPrimaryTable = '',
	remarks = ''
} />

<!--- INIT --->
<cffunction name="init" access="public" output="false" returntype="any" hint="I am the constructor method for the DBColumn class.">
  <cfargument name="columnName" type="string" required="true" default="" hint="" />
  <cfargument name="columnType" type="string" required="false" default="" hint="" />
  <cfargument name="columnSize" type="numeric" required="false" default="0" hint="" />
  <cfargument name="defaultValue" type="string" required="false" default="" hint="" />
  <cfargument name="isNullable" type="boolean" required="false" default="0" hint="" />
  <cfargument name="isPrimary" type="boolean" required="false" default="0" hint="" />
  <cfargument name="isForeign" type="boolean" required="false" default="0" hint="" />
  <cfargument name="charOctLen" type="numeric" required="false" default="0" hint="" />
  <cfargument name="decimalDigits" type="numeric" required="false" default="0" hint="" />
  <cfargument name="displayOrder" type="numeric" required="false" default="0" hint="" />
  <cfargument name="refPrimary" type="string" required="false" default="" hint="" />
  <cfargument name="refPrimaryTable" type="string" required="false" default="" hint="" />
  <cfargument name="remarks" type="string" required="false" default="" hint="" />
  <!--- set the initial values of the bean --->
  <cfscript>
	setColumnName(ARGUMENTS.columnName);
	setColumnType(ARGUMENTS.columnType);
	setColumnSize(ARGUMENTS.columnSize);
	setDefaultValue(ARGUMENTS.defaultValue);
	setIsNullable(ARGUMENTS.isNullable);
	setIsPrimary(ARGUMENTS.isPrimary);
	setIsForeign(ARGUMENTS.isForeign);
	setCharOctLen(ARGUMENTS.charOctLen);
	setDecimalDigits(ARGUMENTS.decimalDigits);
	setDisplayOrder(ARGUMENTS.displayOrder);
	setRefPrimary(ARGUMENTS.refPrimary);
	setRefPrimaryTable(ARGUMENTS.refPrimaryTable);
	setRemarks(ARGUMENTS.remarks);
  </cfscript>
  <cfreturn this>
</cffunction>

<!--- SETTERS --->
<cffunction name="setColumnName" access="public" output="false" hint="I set the columnName value into the variables.instance scope.">
  <cfargument name="columnName" type="string" required="true" default="" hint="I am the columnName value." />
  <cfset variables.instance.columnName = ARGUMENTS.columnName />
</cffunction>

<cffunction name="setColumnType" access="public" output="false" hint="I set the columnType value into the variables.instance scope.">
  <cfargument name="columnType" type="string" required="true" default="" hint="I am the columnType value." />
  <cfset variables.instance.columnType = ARGUMENTS.columnType />
</cffunction>

<cffunction name="setColumnSize" access="public" output="false" hint="I set the columnSize value into the variables.instance scope.">
  <cfargument name="columnSize" type="numeric" required="true" default="0" hint="I am the columnSize value." />
  <cfset variables.instance.columnSize = ARGUMENTS.columnSize />
</cffunction>

<cffunction name="setDefaultValue" access="public" output="false" hint="I set the defaultValue value into the variables.instance scope.">
  <cfargument name="defaultValue" type="string" required="true" default="" hint="I am the defaultValue value." />
  <cfset variables.instance.defaultValue = ARGUMENTS.defaultValue />
</cffunction>

<cffunction name="setIsNullable" access="public" output="false" hint="I set the isNullable value into the variables.instance scope.">
  <cfargument name="isNullable" type="boolean" required="true" default="0" hint="I am the isNullable value." />
  <cfset variables.instance.isNullable = ARGUMENTS.isNullable />
</cffunction>

<cffunction name="setIsPrimary" access="public" output="false" hint="I set the isPrimary value into the variables.instance scope.">
  <cfargument name="isPrimary" type="boolean" required="true" default="0" hint="I am the isPrimary value." />
  <cfset variables.instance.isPrimary = ARGUMENTS.isPrimary />
</cffunction>

<cffunction name="setIsForeign" access="public" output="false" hint="I set the isForeign value into the variables.instance scope.">
  <cfargument name="isForeign" type="boolean" required="true" default="0" hint="I am the isForeign value." />
  <cfset variables.instance.isForeign = ARGUMENTS.isForeign />
</cffunction>

<cffunction name="setCharOctLen" access="public" output="false" hint="I set the charOctLen value into the variables.instance scope.">
  <cfargument name="charOctLen" type="numeric" required="true" default="0" hint="I am the charOctLen value." />
  <cfset variables.instance.charOctLen = ARGUMENTS.charOctLen />
</cffunction>

<cffunction name="setDecimalDigits" access="public" output="false" hint="I set the decimalDigits value into the variables.instance scope.">
  <cfargument name="decimalDigits" type="numeric" required="true" default="0" hint="I am the decimalDigits value." />
  <cfset variables.instance.decimalDigits = ARGUMENTS.decimalDigits />
</cffunction>

<cffunction name="setDisplayOrder" access="public" output="false" hint="I set the displayOrder value into the variables.instance scope.">
  <cfargument name="displayOrder" type="numeric" required="true" default="0" hint="I am the displayOrder value." />
  <cfset variables.instance.displayOrder = ARGUMENTS.displayOrder />
</cffunction>

<cffunction name="setRefPrimary" access="public" output="false" hint="I set the refPrimary value into the variables.instance scope.">
  <cfargument name="refPrimary" type="string" required="true" default="" hint="I am the refPrimary value." />
  <cfset variables.instance.refPrimary = ARGUMENTS.refPrimary />
</cffunction>

<cffunction name="setRefPrimaryTable" access="public" output="false" hint="I set the refPrimaryTable value into the variables.instance scope.">
  <cfargument name="refPrimaryTable" type="string" required="true" default="" hint="I am the refPrimaryTable value." />
  <cfset variables.instance.refPrimaryTable = ARGUMENTS.refPrimaryTable />
</cffunction>

<cffunction name="setRemarks" access="public" output="false" hint="I set the remarks value into the variables.instance scope.">
  <cfargument name="remarks" type="string" required="true" default="" hint="I am the remarks value." />
  <cfset variables.instance.remarks = ARGUMENTS.remarks />
</cffunction>

<!--- GETTERS --->
<cffunction name="getColumnName" access="public" output="false" returntype="string" hint="I return the columnName value.">
  <cfreturn variables.instance.columnName />
</cffunction>

<cffunction name="getColumnType" access="public" output="false" returntype="string" hint="I return the columnType value.">
  <cfreturn variables.instance.columnType />
</cffunction>

<cffunction name="getColumnSize" access="public" output="false" returntype="numeric" hint="I return the columnSize value.">
  <cfreturn variables.instance.columnSize />
</cffunction>

<cffunction name="getDefaultValue" access="public" output="false" returntype="string" hint="I return the defaultValue value.">
  <cfreturn variables.instance.defaultValue />
</cffunction>

<cffunction name="getIsNullable" access="public" output="false" returntype="boolean" hint="I return the isNullable value.">
  <cfreturn variables.instance.isNullable />
</cffunction>

<cffunction name="getIsPrimary" access="public" output="false" returntype="boolean" hint="I return the isPrimary value.">
  <cfreturn variables.instance.isPrimary />
</cffunction>

<cffunction name="getIsForeign" access="public" output="false" returntype="boolean" hint="I return the isForeign value.">
  <cfreturn variables.instance.isForeign />
</cffunction>

<cffunction name="getCharOctLen" access="public" output="false" returntype="numeric" hint="I return the charOctLen value.">
  <cfreturn variables.instance.charOctLen />
</cffunction>

<cffunction name="getDecimalDigits" access="public" output="false" returntype="numeric" hint="I return the decimalDigits value.">
  <cfreturn variables.instance.decimalDigits />
</cffunction>

<cffunction name="getDisplayOrder" access="public" output="false" returntype="numeric" hint="I return the displayOrder value.">
  <cfreturn variables.instance.displayOrder />
</cffunction>

<cffunction name="getRefPrimary" access="public" output="false" returntype="string" hint="I return the refPrimary value.">
  <cfreturn variables.instance.refPrimary />
</cffunction>

<cffunction name="getRefPrimaryTable" access="public" output="false" returntype="string" hint="I return the refPrimaryTable value.">
  <cfreturn variables.instance.refPrimaryTable />
</cffunction>

<cffunction name="getRemarks" access="public" output="false" returntype="string" hint="I return the remarks value.">
  <cfreturn variables.instance.remarks />
</cffunction>

<!--- UTILITY METHODS --->
<cffunction name="getMemento" access="public" output="false" hint="I return a struct of the variables.instance scope.">
  <cfreturn variables.instance />
</cffunction>
</cfcomponent>
