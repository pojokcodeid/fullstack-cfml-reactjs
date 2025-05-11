component {
    
    property array params;
    property array paramsVariables;
    property array handlers;
    property string controllerFile;
    property string controllerMethod;
    property string DEFAULT_GET;
    property string DEFAULT_POST;
    property string DEFAULT_PUT;
    property string DEFAULT_DELETE;

    public function init() {
        variables.controllerFile="Default";
        variables.controllerMethod="index";
        variables.params=[];
        variables.paramsVariables=[];
        variables.handlers=[];
        variables.DEFAULT_GET="GET";
        variables.DEFAULT_POST="POST";
        variables.DEFAULT_PUT="PUT";
        variables.DEFAULT_DELETE="DELETE";
        return this;
    }

    public function setDefaultController(string controllerFile){
        variables.controllerFile = controllerFile;
    }

    public function setDefaultControllerMethod(string controllerMethod){
        variables.controllerMethod = controllerMethod;
    }

    public function get(string uri, any callback) {
        setHandler(DEFAULT_GET, uri, callback);
    }

    public function post(string uri, any callback) {
        setHandler(DEFAULT_POST, uri, callback);
    }

    public function put(string uri, any callback) {
        setHandler(DEFAULT_PUT, uri, callback);
    }

    public function delete(string uri, any callback) {
        setHandler(DEFAULT_DELETE, uri, callback);
    }

    private function setHandler(string method, string path, any handler) {
        local.content={
            path = path,
            method = method,
            handler = handler
        };
        arrayAppend(variables.handlers, local.content);    
    }

    public function run() {
        // dapatkan data dari url
        var urlPage = trim(url.page);
        // ambil http method yang digunakan
        var httpMethod = ucase(cgi.request_method);
        // lakkan perulangan semua setting route
        for (var handler in variables.handlers) {
            // ambil setting url route
            var urlRoute= handler.path;
            // convert urlRoute menjadi array
            var urlRouteArray = listToArray(urlRoute, "/");
            // hitung panjang array urlRoute
            var urlRouteArrayLength = arrayLen(urlRouteArray);
            
            var urlArray=[];
            // cek apakah url tidak kosong
            if (len(urlPage) > 0) {
                var urlArray = listToArray(urlPage, "/");
                var urlArrayLength = arrayLen(urlArray);
            }else{
                var urlArrayLength = 0;
            }

            // cek apakah panjang array urlRoute sama dengan panjang array url
            if (urlRouteArrayLength == urlArrayLength) {
                // reset array params
                variables.paramsVariables = [];
                // lakukan pengecekan apakah ada param
                for ( var urlItem in urlRouteArray ) {
                    // check apakah urlItem mengandung carakter :
                    if (urlItem.find(":", 1) neq 0) {
                        // hapus dari urlRouteArray
                        arrayDeleteAt(urlRouteArray, arrayFind(urlRouteArray, urlItem));
                        // tambahkan ke array params dengan menghilangkan symbol :
                        arrayAppend(variables.paramsVariables, urlItem.replace(":", ""));
                    }
                }
                // convert array urlRouteArray item ke satu string
                var urlRouteString = "";
                for (var i=1; i <= arrayLen(urlRouteArray); i++) {
                    urlRouteString &= urlRouteArray[i];
                    if (i lt arrayLen(urlRouteArray)) {
                        urlRouteString &= "/";
                    }
                }
                // tambahkan tanda / untuk mencegah salah cek url
                urlRouteString &= "/";
                urlPage &= "/";
                // lakukan pengecekan apakah url mengandung urlRouteString
                if (urlPage.find(urlRouteString, 1) neq 0 and httpMethod == handler.method) {
                    // tentukan controller file dan methodnya
                    variables.controllerFile=handler.handler.controller;
                    variables.controllerMethod=handler.handler.method;
                    // replace urlPage dengan urlRouteString
                    urlPage = urlPage.replace(urlRouteString, "");
                    // convert urlPage menjadi array
                    variables.params = listToArray(urlPage, "/");
                    break;
                }
            }
        }

        // menangani kiriman json data atau post form
        local.content = {};
        if (len(trim(getHttpRequestData().content))) {
            try {
                local.content = deserializeJson(getHttpRequestData().content);
            } catch (any e) {
                local.content = form; // fallback to form data if JSON deserialization fails
            }
            arrayAppend(variables.paramsVariables, "content");
            arrayAppend(variables.params, local.content);
        }
        // return {
        //     success: false,
        //     code: 404,
        //     message: "Not Found",
        //     data: local.content,
        //     paramsVariables: variables.paramsVariables,
        //     params: variables.params
        // }
        
        var controllerPath = "/controllers/#replace(controllerFile, ".", "/", "all")#.cfc";
        if (fileExists(expandPath(controllerPath))) {
            var controller = createObject("component", "controllers.#controllerFile#");

            if (structKeyExists(controller, controllerMethod)) {
                return controller[controllerMethod](argumentCollection=paramsToStruct(params));
            } else {
                return {
                    success: false,
                    message: "Method `#controllerMethod#` not found in controller `#controllerFile#`."
                };
            }
        } else {
            return {
                success: false,
                message: "Controller `#controllerFile#` not found."
            }
        }
        // writeDump(var=controllerFile, label="controllerFile");
    }

    // Ubah array params menjadi struct dengan nama arg1, arg2, dst.
    private function paramsToStruct(array params) {
        var s = {};
        for (var i=1; i <= arrayLen(params); i++) {
            s[paramsVariables[i]] = params[i];
        }
        return s;
    }

}