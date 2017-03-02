abstract Maybe<T>(Null<T>) {
    public inline function may(fn:T->Void) if (this != null) fn(this);
}

typedef Project = {
    var classPaths:Maybe<Array<String>>;
    var entryPoints:Maybe<Array<String>>;
    var mainClass:Maybe<String>;
    var libraries:Maybe<Array<String>>;
    var debug:Maybe<Bool>;
    var defines:Maybe<Array<String>>;
    var output:Maybe<Output>;
    var deadCodeElimination:Maybe<DceMode>;
}

@:enum abstract DceMode(String) to String {
    var No = "no";
    var Std = "std";
    var Full = "full";
}

@:enum abstract Target(String) to String {
    var Js = "js";
}

typedef Output = {
    var target:Target;
    var path:String;
}

class Main {
    static function main() {
        var args = Sys.args();
        var projectFile = if (args.length == 0) "hxproject.json" else args[1];
        var project:Project = haxe.Json.parse(sys.io.File.getContent(projectFile));
        var args = generateArgs(project);
        trace("Executing haxe " + args.join(" "));
        Sys.command("haxe", args);
    }

    static function generateArgs(p:Project):Array<String> {
        var args = [];

        p.classPaths.may(function(classPaths) {
            for (path in classPaths) {
                args.push("-cp");
                args.push(path);
            }
        });

        p.libraries.may(function(libraries) {
            for (library in libraries) {
                args.push("-lib");
                args.push(library);
            }
        });

        p.defines.may(function(defines) {
            for (define in defines) {
                args.push("-D");
                args.push(define);
            }
        });

        p.debug.may(function(debug) if (debug) args.push("-debug"));

        p.entryPoints.may(function(entryPoints) {
            for (cls in entryPoints)
                args.push(cls);
        });

        p.mainClass.may(function(mainClass) {
            args.push("-main");
            args.push(mainClass);
        });

        p.output.may(function(output) {
            args.push("-" + output.target);
            args.push(output.path);
        });

        p.deadCodeElimination.may(function(dce) {
            args.push("-dce");
            args.push(dce);
        });

        return args;
    }
}
