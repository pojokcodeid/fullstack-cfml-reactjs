component {
  
    variables.jarPaths = [
        expandPath("/lib/password4j-1.8.2.jar"),
    ];
  
    function init() {
        return this;
    }

    function bcryptHashGet(required string input) {
        var Password = createObject("java", "com.password4j.Password", variables.jarPaths);
        var hash = Password.hash(input).withBcrypt().getResult();
        return hash;
    }

    function bcryptHashVerify(required string input, required string hashedInput) {
        var Password = createObject("java", "com.password4j.Password", variables.jarPaths);
        var result = Password.check(input, hashedInput).withBcrypt();
        return result;
    }
  
}