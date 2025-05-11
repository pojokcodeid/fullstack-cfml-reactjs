
component extends="core.BaseController" {
    variables.UserModel = model("em.UserModel");
    variables.rules = {
        name  : "required",
        username: "required",
        password: "required|strong_password"
    }

    public function init() {
        return this;
    }

    public struct function register(content={}){
        try{

            var result = validate(content, rules);
            if(not result.success){
                return {
                    success = false,
                    code = 400,
                    message = result.errors[1],
                    data = {}
                }
            }
    
            var Bcript = new core.helpers.Password();
            content.password = Bcript.bcryptHashGet(content.password);
            var jwt = new core.helpers.Jwt();
            var token = jwt.encode({username: content.username});
            var registeredUser = UserModel.register(content);
            registeredUser.accessToken = token.accessToken;
            registeredUser.refreshToken = token.refreshToken;
            return {
                success = true,
                code = 201,
                message = "success",
                data = registeredUser
            }
        }catch (any e) {
            return {
                success = false,
                code = 422,
                message = e.message,
                data = {}
            }           
        }
    }
    
}