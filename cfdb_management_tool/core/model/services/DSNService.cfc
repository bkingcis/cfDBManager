<cfcomponent displayname="DSNService" output="false" hint="I am the DSNService class. I provide utility methods and facades to interface with the datasources.">

<!--- PUBLIC METHODS --->

<!--- GET DATASOURCE LIST --->
<cffunction name="getDatasourceList" access="public" returntype="string" hint="I return a sorted list of datasources, or an error if access is not permitted or credentials are incorrect.">
	<cfargument name="password" type="string" required="true" default="" hint="I am the administrative user's password to login to the adminapi. Required." />
	<cfargument name="username" type="string" required="false" default="admin" hint="I am an administrative user to login to the adminapi. Default user is 'admin'." />
	<cfargument name="sortType" type="string" required="false" default="textnocase" hint="I am the sort type for the datasource list, 'numeric', 'textnocase' (default) or 'text'." />
	<cfargument name="sortOrder" type="string" required="false" default="asc" hint="I am the sort order for the datasource list, 'asc' (default) or 'desc'." />
	
	<!--- var scope --->
	<cfset var admin = '' />
	<cfset var DataSourceObj = '' />
	<cfset var DataSourceList = '' />
	
	<!--- try --->
	<cftry>
		<!--- create a new interface into the CF adminapi --->
		<cfset admin = new cfide.adminapi.Administrator() />
		<!--- login to the adminapi with passed credentials --->
		<cfset admin.login(ARGUMENTS.password,ARGUMENTS.username) />
		<!--- get the datasource struct from the service factory --->
		<cfset DataSourceObj = CreateObject('java','coldfusion.server.ServiceFactory').getDatasourceService().getDatasources() />
		<!--- log out of the adminapi --->
		<cfset admin.logout() />
		<!--- convert the struct into a list of available datasources --->
		<cfset DataSourceList = ListSort(StructKeyList(DataSourceObj),ARGUMENTS.sortType,ARGUMENTS.sortOrder) />
		<!--- catch any errors --->
		<cfcatch type="any">
			<!--- set the datasource list to an error message --->
			<cfset DataSourceList = "[UNAVAILABLE]" />
			<!--- end catching --->
		</cfcatch>
	<!--- end trying --->
	</cftry>
	
	<!--- Return the list of datasources --->
	<cfreturn DataSourceList />
	
</cffunction>

</cfcomponent>