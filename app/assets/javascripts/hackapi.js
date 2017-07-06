(function() {
    window.HackAPI = { };

    // Max age is given in seconds. Records in the cache will be used for the
    // given amount of time before a request is sent to the server to update the record.
    var cache = { maxAge: 30 };

    var HackRequest = function(category, id) {
        var self = this;
        var path;

        if (typeof id !== "undefined") {
            path = jsonPath(category, id);
        } else {
            path = jsonPath(category);
        }

        var isCached = cache[category] && cache[category][id] && cache[category][id].expire > new Date();
        var cachedResponse;

        if (cache[category] && cache[category][id] && cache[category][id].expire > new Date()) {
            cachedResponse = cache[category][id].cachedResponse;
        } else {
            $.get(path)
            .done(function(response) {
                if (typeof cache[category] === "undefined") {
                    cache[category] = { };
                }

                var expire = new Date();
                expire.setSeconds(expire.getSeconds() + cache.maxAge);

                if (Array.isArray(response)) {
                    $.each(response, function(index, result) {
                        cache[category][result.id] = {expire: expire, cachedResponse: result};

                        if (typeof self.doneCallback === "function") {
                            self.doneCallback(result);
                        }
                    });
                } else {
                    cache[category][id] = {expire: expire, cachedResponse: response};

                    if (typeof self.doneCallback === "function") {
                        self.doneCallback(response);
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

            if (isCached && typeof self.doneCallback === "function") {
                if (Array.isArray(cachedResponse)) {
                    $.each(cachedResponse, function(index, result) {
                        self.doneCallback(result);
                    });
                } else {
                    self.doneCallback(cachedResponse);
                }
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

            if (isCached && Array.isArray(cachedResponse)) {
                $.each(cachedResponse, function(index, result) {
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
    
    window.HackAPI.characters = function() {
        return new HackRequest("characters");
    };

    window.HackAPI.characters.find = function(id) {
        return new HackRequest("characters", id);
    };
    
    function jsonPath() {
        return "/" + Array.from(arguments).join("/") + ".json"
    }
})()
