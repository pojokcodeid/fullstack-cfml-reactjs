component {
    
    public function init(to, from, subject, type){
        variables.to=to;
        variables.from=from;
        variables.subject=subject;
        variables.type=type;
        return this;
    }

    public function send(content){
        mail subject=variables.subject from=variables.from to=variables.to type=variables.type {
            writeOutput(content);
        };
    }
}