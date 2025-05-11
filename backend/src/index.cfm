<cfscript>
	router = new core.Router();
	output =router.begin();
	if (isStruct(output) && structKeyExists(output, "code") && structKeyExists(output, "message")){
		cfcontent(reset="true", type="application/json");
		cfheader(statuscode="#output.code#", statustext="#output.message#");
		writeOutput(serializeJson(output));
	}
</cfscript>

