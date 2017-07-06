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

                        var andThenItem;

                        if (typeof self.firstCallback === "function" && index === 0) {
                            andThenItem = self.firstCallback(result);
                        } else if (typeof self.lastCallback === "function" && index === response.length-1) {
                            andThenItem = self.lastCallback(result);
                        } else if (typeof self.eachCallback === "function") {
                            andThenItem = self.eachCallback(result, index === 0, index === response.length-1);
                        }

                        if (typeof andThenItem !== "undefined") {
                            andThenParam.push(andThenItem);
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

        /* This first callback functions just like the each callback except
         * this will only be called on the first item of the list if the
         * response is a list. If a first callback is provided then the each
         * method will not be called on that first item. */
        self.first = function(callback) {
            self.firstCallback = callback;

            return self;
        }

        /* This last callback functions just like the each callback except
         * this will only be called on the last item of the list if the
         * response is a list. If a last callback is provided then the each
         * method will not be called on that last item. */
        self.last = function(callback) {
            self.lastCallback = callback;

            return self;
        }

        /* If the response has an array of values then the each callback will
         * be called on each individual value. If something is returned by the
         * each callback, an array of the returned values will be passed into
         * the andThen callback. The second parameter indicated whether or not
         * this item is the first item in the list, the third parameter
         * indicates whether or not this item is the last item. */
        self.each = function(callback) {
            self.eachCallback = callback;

            if (isCached && Array.isArray(cachedResponse)) {
                $.each(cachedResponse, function(index, result) {
                    var andThenItem;

                    if (typeof self.firstCallback === "function" && index === 0) {
                        andThenItem = self.firstCallback(result);
                    } else if (typeof self.lastCallback === "function" && index === cachedResponse.length-1) {
                        andThenItem = self.lastCallback(result);
                    } else if (typeof self.eachCallback === "function") {
                        andThenItem = self.eachCallback(result, index === 0, index === cachedResponse.length-1);
                    }

                    if (typeof andThenItem !== "undefined") {
                        andThenParam.push(andThenItem);
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
