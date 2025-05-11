<cfscript>
	router = new core.Router();
	output =router.begin();
	cfcontent(reset="true", type="application/json");
	cfheader(statuscode="#output.code#", statustext="#output.message#");
	writeOutput(serializeJson(output));
</cfscript>

