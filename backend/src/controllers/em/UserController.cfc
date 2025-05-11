
component extends="core.BaseController" {
    variables.UserModel = model("em.UserModel");
    variables.rules = {
        name  : "required",
        email: "required|is_email",
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
            var registeredUser = UserModel.register(content);
            registeredUser.activate = application.baseURL&"/user/activate/"&registeredUser.uuid;
            var mail = new core.helpers.Mail(
                registeredUser.email,
                application.emailFrom,
                "Email Activation",
                "html"
            );
            mail.send(
                '<p>Hi #registeredUser.name#</p>
                <p>Click the link below to activate your account</p>
                <a href="#registeredUser.activate#">Activate</a>'
            );
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

    public any function activate(uuid=""){
        try{
            if(!UserModel.activateStatus(uuid)){
                view("activation/index", { message:"Already Activated or Invalid UUID" });
                return false;
            }
            var result = UserModel.activate(uuid);       
            view("activation/index", { message:"Activation success" });
            return true;
        }catch (any e) {
            view("activation/index", { message:e.message });
            return false;          
        }
    }
    
}