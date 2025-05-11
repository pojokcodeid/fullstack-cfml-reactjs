component {
	this.name = "MyApplication"; // Nama aplikasi
	this.applicationTimeout = createTimeSpan(0, 2, 0, 0); // Waktu kedaluwarsa aplikasi

    globalConfig = expandPath("/configs/global.json");
    if (fileExists(globalConfig)) {
        datasourceConfig = deserializeJSON(fileRead(globalConfig));
        this.datasource = structKeyArray(datasourceConfig.datasource)[1];
        this.datasources = datasourceConfig.datasource;
    } else {
        writeDump("Datasource config file not found: #globalConfig#");
        abort;
    }

	function onApplicationStart() {
        application.baseURL = datasourceConfig.baseURL;
		return true;
	}

	function onRequestStart(string targetPage) {
	}

	this.onError = function(exception, eventname){
        var uuid = createUUID();
		var strSpt = "/";
		if (findNoCase("Windows", server.OS.Name)) strSpt = "\";
        var targetPath = getDirectoryFromPath(getCurrentTemplatePath()) & "../logs";
        if (not directoryExists(targetPath)) {
            directoryCreate(targetPath);
        }
		targetPath = targetPath & strSpt & uuid & ".html";
        savecontent variable="strDump" {
            writeDump(var=exception, label="Exception", format="html");
        }
		try {
			fileWrite(targetPath, strDump);
		} catch (any writeErr) {
			if (isDefined("strDump")) {
				log text="Error while writing error file: #writeErr.message# - Dump: #strDump#" file="SFErrorHandler";
			}
		}
        cfheader(statuscode="500", statustext="Error Internal Server");
        cfheader(name="Content-Type", value="application/json");
        writeOutput(serializeJSON({
            success=false,
            code=500,
            message="Something went wrong",
            data={},
            errorcode=uuid
        },true));
        return false;
    }
}
