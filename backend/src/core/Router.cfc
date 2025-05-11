component {

    function begin() {
        app = new core.App();
        app.setDefaultController("Default");
        app.setDefaultControllerMethod("index");
        app.post("/user/register", { controller: "em.UserController", method: "register"});
        return app.run();
    }
}
