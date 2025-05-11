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
                    email,
                    password,
                    personal_id,
                    uuid
                )VALUES(
                    :email,
                    :password,
                    :personal_id,
                    :uuid
                )",
                {
                    email = {value=content.email, sqltype="CF_SQL_VARCHAR"},
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
            email = content.email,
            password = "xxxxxxxxxxxxxxxxxxxx",
            uuid=uuid
        };
    }

    public any function activate(uuid){
        var qUpdate = queryExecute(
            "UPDATE user SET status=1 WHERE uuid=:uuid",
            {
                uuid = {value=uuid, sqltype="CF_SQL_VARCHAR"}
            },
            {
                result: "updateUser" // penting untuk dapatkan generatedKey
            }
        );
        return true;
    }

    public boolean function activateStatus(uuid){
        var data = queryExecute(
            "SELECT * FROM user WHERE uuid=:uuid",
            {
                uuid = {value=uuid, sqltype="CF_SQL_VARCHAR"}
            }
        );
        if(data.recordCount > 0 && data.status == 0){
            return true;
        }
        return false;
    }
}