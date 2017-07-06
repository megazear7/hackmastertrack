(function() {
    window.HackAPI = { };

    // Max age is given in seconds
    var cache = { maxAge: 5 };

    var HackRequest = function(category, id) {
        var self = this;
        var path = jsonPath(category, id);

        var isCached = cache[category] && cache[category][id] && cache[category][id].expire > new Date();
        var cachedResponse;

        if (cache[category] && cache[category][id] && cache[category][id].expire > new Date()) {
            cachedResponse = cache[category][id].cachedResponse;
        } else {
            $.get(path)
            .done(function(result) {

                if (typeof cache[category] === "undefined") {
                    cache[category] = { };
                }

                var expire = new Date();
                expire.setSeconds(expire.getSeconds() + cache.maxAge);
                cache[category][id] = {expire: expire, cachedResponse: result};

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
        }

        self.done = function(callback) {
            self.doneCallback = callback;

            if (isCached) {
                self.doneCallback(cachedResponse);
            }

            return self;
        };

        self.fail = function(callback) {
            self.failCallback = callback;

            return self;
        };

        self.always = function(callback) {
            self.alwaysCallback = callback;

            if (isCached) {
                self.alwaysCallback();
            }

            return self;
        };

        self.each = function(callback) {
            self.doneCallback = callback;

            if (isCached) {
                $.each(cachedResponse, function(result) {
                    if (typeof self.doneCallback === "function") {
                        self.doneCallback(result);
                    }
                });
            }

            return self;
        };

        self.andThen = function(callback) {
            self.andThenCallback = callback;

            if (isCached) {
                self.andThenCallback();
            }

            return self;
        };
    };
    
    window.HackAPI.characters = {
        find: function(ids) {
            return new HackRequest("characters", ids);
        },
        findOne: function(id) {
            return new HackRequest("characters", id);
        }
    };
    
    function jsonPath() {
        return "/" + Array.from(arguments).join("/") + ".json"
    }
})()
