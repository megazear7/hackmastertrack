(function() {
    window.HackAPI = { };

    // Max age is given in seconds. Records in the cache will be used for the
    // given amount of time before a request is sent to the server to update the record.
    var cache = { maxAge: 30 };

    var HackRequest = function(category, id) {
        var self = this;
        var path;
        var andThenParam = [];

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

                        if (typeof self.eachCallback === "function") {
                            var andThenItem = self.eachCallback(result);
                            console.log(andThenItem);

                            if (typeof andThenItem !== "undefined") {
                                andThenParam.push(andThenItem);
                            }
                        }
                    });

                    if (typeof self.andThenCallback === "function") {
                        self.andThenCallback(andThenParam);
                    }
                } else {
                    cache[category][id] = {expire: expire, cachedResponse: response};

                    if (typeof self.doneCallback === "function") {
                        self.doneCallback(response);
                    }
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

        /* The done callback will be used if the response is an individual item
         * and not an array */
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

        /* The fail callback will be called if the item is not cached and the
         * response from the server fails. */
        self.fail = function(callback) {
            self.failCallback = callback;

            return self;
        };

        /* The always callback will be called after everything else is completed
         * and is given no parameters */
        self.always = function(callback) {
            self.alwaysCallback = callback;

            if (isCached) {
                self.alwaysCallback();
            }

            return self;
        };

        /* If the response has an array of values then the each callback will
         * be called on each individual value. If something is returned by the
         * each callback, an array of the returned values will be passed into
         * the andThen callback. */
        self.each = function(callback) {
            self.eachCallback = callback;

            if (isCached && Array.isArray(cachedResponse)) {
                $.each(cachedResponse, function(index, result) {
                    if (typeof self.eachCallback === "function") {
                        var andThenItem = self.eachCallback(result);

                        if (typeof andThenItem !== "undefined") {
                            andThenParam.push(andThenItem);
                        }
                    }
                });
            }

            return self;
        };

        /* Used in conjunction with the each method. The items returned by the
         * each callback will be provided to the andThen callback as an array. */
        self.andThen = function(callback) {
            self.andThenCallback = callback;

            if (isCached) {
                self.andThenCallback(andThenParam);
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
