(function() {
    window.HackAPI = { };

    var HackRequest = function(path) {
        var self = this;

        $.get(path)
        .done(function(result) {
            if (Array.isArray(result)) {
                $.each(results, function(result) {
                    if (typeof self.doneCallback === "function") {
                        self.doneCallback(result);
                    }
                });
            } else {
                if (typeof self.doneCallback === "function") {
                    self.doneCallback(result);
                }
            }

            if (typeof self.andThenCallback === "function") {
                self.andThenCallback();
            }
        })
        .fail(function(error) {
            if (typeof self.failCallback === "function") {
                self.failCallback(error);
            }
        })
        .always(function() {
            if (typeof self.alwaysCallback === "function") {
                self.alwaysCallback();
            }
        });

        self.done = function(callback) {
            self.doneCallback = callback;

            return self;
        };

        self.fail = function(callback) {
            self.failCallback = callback;

            return self;
        };

        self.always = function(callback) {
            self.alwaysCallback = callback;

            return self;
        };

        self.each = function(callback) {
            self.doneCallback = callback;

            return self;
        };

        self.andThen = function(callback) {
            self.andThenCallback = callback;

            return self;
        };
    };
    
    window.HackAPI.characters = {
        find: function(ids) {
            return new HackRequest(path("characters", ids));
        },
        findOne: function(id) {
            return new HackRequest(path("characters", id));
        }
    };
    
    function path() {
        return "/" + Array.from(arguments).join("/") + ".json"
    }
})()
