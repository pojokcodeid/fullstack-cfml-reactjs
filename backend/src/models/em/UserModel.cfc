component{
    
    public function init() {
        return this;
    }

    public any function register(content){
        if (!structKeyExists(content, "phone")) {
            content.phone = "";
        }
        if (!structKeyExists(content, "address")) {
            content.address = "";
        }
        var uuid = createUUID();
        transaction action="begin" {
            // insert personal
            var qInsert = queryExecute(
                "INSERT INTO personal(
                    name,
                    phone,
                    address
                )VALUES(
                    :name,
                    :phone,
                    :address
                )",
                {
                    name = {value=content.name, sqltype="CF_SQL_VARCHAR"},
                    phone = {value=content.phone, sqltype="CF_SQL_VARCHAR"},
                    address = {value=content.address, sqltype="CF_SQL_VARCHAR"}
                },
                {
                    result: "insertPersonal" // penting untuk dapatkan generatedKey
                }
            );
            // insert user
            var qInsert = queryExecute(
                "INSERT INTO user(
                    username,
                    password,
                    personal_id,
                    uuid
                )VALUES(
                    :username,
                    :password,
                    :personal_id,
                    :uuid
                )",
                {
                    username = {value=content.username, sqltype="CF_SQL_VARCHAR"},
                    password = {value=content.password, sqltype="CF_SQL_VARCHAR"},
                    personal_id = {value=insertPersonal.generatedKey, sqltype="CF_SQL_INTEGER"},
                    uuid = {value=uuid, sqltype="CF_SQL_VARCHAR"}
                },
                {
                    result: "insertUser" // penting untuk dapatkan generatedKey
                }
            );
        }
        return {
            userId = insertPersonal.generatedKey, 
            name = content.name,
            phone = content.phone,
            address = content.address,
            username = content.username,
            password = "xxxxxxxxxxxxxxxxxxxx",
            uuid=uuid
        };
    }
}