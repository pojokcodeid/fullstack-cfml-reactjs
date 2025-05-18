component {

    function begin() {
        app = new core.App();
        app.setDefaultController("Default");
        app.setDefaultControllerMethod("index");
        app.post("/user/register", { controller: "em.UserController", method: "register"});
        app.get("/user/activate/:uuid", { controller: "em.UserController", method: "activate"});
        app.post("/user/login", { controller: "em.UserController", method: "login"});
        app.get("/user/refresh", { controller: "em.UserController", method: "refreshToken"});
        app.put("/user/update", { controller: "em.UserController", method: "update"});
        return app.run();
    }
}
