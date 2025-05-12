component {
    variables.jwt = new modules.jwtcfml.models.jwt();

    function init() {
        globalConfig = expandPath("/configs/global.json");
        if (fileExists(globalConfig)) {
            config = deserializeJSON(fileRead(globalConfig));
            variables.acessKey = config.acessTokenKey;
            variables.refreshKey = config.refreshTokenKey;
            variables.expiedMinute = config.expiedMinute;
            variables.refreshExpiredMinute = config.refreshExpiredMinute;
        } else {
            writeDump("config file not found: #globalConfig#");
            abort;
        }
        return this;
    }

    public function encode(content={}){
        var expdt = dateAdd("n", expiedMinute , now());
		var expdtRefresh = dateAdd("n", refreshExpiredMinute , now());
		var utcDate = dateDiff("s", dateConvert("utc2Local", createDateTime(1970, 1, 1, 0, 0, 0)), expdt);
		var utcDateRefresh = dateDiff("s", dateConvert("utc2Local", createDateTime(1970, 1, 1, 0, 0, 0)), expdtRefresh);
        var payload = {'content': content, 'iat': now(), 'exp':utcDate}
        var payloadRefresh = {'content': content, 'iat': now(), 'exp': utcDateRefresh}
        return {
            accessToken: jwt.encode(payload, acessKey, 'HS256'),
            refreshToken: jwt.encode(payloadRefresh, refreshKey, 'HS256')
        }
    }

    public function decodeAccess(token){
        try{
            return {
                data :jwt.decode(token, acessKey, 'HS256'),
                message : 'success'
            };
        }catch (any e) {
            return {
                data : false,
                message : e.message
            }
        }
    }

    public function decodeRefresh(token){
        try{
            return {
                data :jwt.decode(token, refreshKey, 'HS256'),
                message : 'success'
            };
        }catch (any e) {
            return {
                data : false,
                message : e.message
            }
        }
    }
}

// cara acess
// var jwt = new core.helpers.Jwt();
// var token = jwt.encode({username: content.username});
// registeredUser.accessToken = token.accessToken;
// registeredUser.refreshToken = token.refreshToken;