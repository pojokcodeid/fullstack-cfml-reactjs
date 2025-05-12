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

    public struct function login(content={}){
        var data = queryExecute(
            "SELECT 
                u.user_id,
                u.personal_id, 
                u.email, 
                u.password,
                p.name,
                p.phone, 
                p.address
            FROM user u inner join personal p on u.personal_id=p.personal_id
            WHERE u.email=:email and u.status=1",
            {
                email = {value=content.email, sqltype="CF_SQL_VARCHAR"}
            }
        );
        if(data.recordCount){
            return {
                userId = data.user_id, 
                personalId = data.personal_id, 
                name = data.name,
                phone = data.phone,
                address = data.address,
                email = data.email,
                password = data.password
            };
        }
        return {};
    }

    public struct function update(content={}){
        transaction action="begin" {
            var sqlPersonal="UPDATE PERSONAL SET ";
            if(structKeyExists(content, "name")){
                sqlPersonal &= "name=:name ";
            }
            if(structKeyExists(content, "phone")){
                sqlPersonal &= ",phone=:phone ";
            }
            if(structKeyExists(content, "address")){
                sqlPersonal &= ",address=:address ";
            }
            sqlPersonal &= " WHERE personal_id=:personal_id";
            var qUpdate = queryExecute(
                sqlPersonal,
                {
                    name = {value=content.name, sqltype="CF_SQL_VARCHAR"},
                    phone = structKeyExists(content, "phone") ? {value=content.phone, sqltype="CF_SQL_VARCHAR"} : {value="", sqltype="CF_SQL_VARCHAR"},
                    address = structKeyExists(content, "address") ? {value=content.address, sqltype="CF_SQL_VARCHAR"} : {value="", sqltype="CF_SQL_VARCHAR"},
                    personal_id = {value=content.personal_id, sqltype="CF_SQL_INTEGER"}
                }
            );
            if(structKeyExists(content, "password") && len(trim(content.password)) > 0){
                var qUpdate = queryExecute(
                    "UPDATE USER SET email=:email, password=:password WHERE user_id=:user_id",
                    {
                        email = {value=content.email, sqltype="CF_SQL_VARCHAR"},
                        password ={value=content.password, sqltype="CF_SQL_VARCHAR"},
                        user_id = {value=content.user_id, sqltype="CF_SQL_INTEGER"}
                    }
                );
            }else{
                var qUpdate = queryExecute(
                    "UPDATE USER SET email=:email WHERE user_id=:user_id",
                    {
                        email = {value=content.email, sqltype="CF_SQL_VARCHAR"},
                        user_id = {value=content.user_id, sqltype="CF_SQL_INTEGER"}
                    }
                );
            }
        }
        return content;
    }
}