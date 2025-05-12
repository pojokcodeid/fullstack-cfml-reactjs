component {
    
    public function init() {
        return this;
    }

    public function authenticateAcess(){
		var requestData = GetHttpRequestData();
		if (StructKeyExists(requestData.Headers, "authorization")) {
			var token = requestData.Headers.authorization;
			token = replace(token, "Bearer ", "", "all");
			token = replace(token, " ", "", "all");
			try {
				var jwt = new core.helpers.Jwt();
				return jwt.decodeAccess(token);
			} catch (any e) {
				return {
                    message= "Anauthorized",
                    data= false
                };
			}
		} else {
			return {
                message= "Anauthorized",
                data= false
            };
		}
    }

    public function authenticateRefresh(){
		var requestData = GetHttpRequestData();
		if (StructKeyExists(requestData.Headers, "authorization")) {
			var token = requestData.Headers.authorization;
			token = replace(token, "Bearer ", "", "all");
			token = replace(token, " ", "", "all");
			try {
				var jwt = new core.helpers.Jwt();
				return jwt.decodeRefresh(token);
			} catch (any e) {
				return {
                    message= "Anauthorized",
                    data= false
                };
			}
		} else {
			return {
                message= "Anauthorized",
                data= false
            };
		}
    }
}