

// ---- TODO ----- Make this interface happen!!!
/*
AbcAPI.category1()
.first(function(record) {
    return // Do something unique with the first record
})
.each(function(record) {
    return // Some UI Element based on the record, or whatever else
           // Because how we have the find(recordIds).each(...) format we need
           // to update the implementation to not actually perform the search
           // until either the each, first, last, or all method has been called,
           // and then we need to make sure we only do it once!
})
.last(function() {
    return // Do something unique with the last record
})
.andThen(function(things) {
    // "things" is an array of the things returned by the each, first, and last methods
    // whatever is returned in this method will be given to the collect method
})
.all(function(records) {
    // "records" is an array of all the records
    // whatever is returned in this method will be given to the collect method
})
.fail(functon(error) {
    // Something to do in case there was a problem
});
.pipe()
.and() // Starts a new request with the same category
.find(singleRecordID, function(record) {
    // Notice that if a function is provided to the second argument
    // then we assume that the first argument is a single recordId
    
    // If an id (an integer) is returned, the andThen, all or find methods 
    // can be used in conjunction with the take method.
    return record.category3Id;
})
.take() // This method is used in conjunction with the find method. It will take
        // whatever was returned by the previous andThen, all, or find method
        // and pass it will be passed into the callback provided in the next find method
        // This is essentially implementing a "join" of sorts
.fromCategory3(function(category3Record) {
    // This record will correspond to the id that was "taken" via the take method.
})
.pipe()
.and() 
.find(recordIDs) // recordIDs can be an array or a list of arguments.
                 // Notice that if a function is NOT provided to the second argument
                 // then we assume that there is either a single array argument
                 // or multiple arguments each representing a single id.

.each(function(record) {
    // Each record that corresponds to the provided record ids.

    return // something based off the record. (Maybe a react element?)
}
.pipe()
.each(function(record) {
    // The same records that were just referenced in the previous each method
    // using this to show an example of doing a take and a pipe

    return record.category4Id;
})
.take()
.fromCategory4()
.each(function(category4Record) {
    // category4Record will correspond to each of the ids taken from the previous take method.

    return // ...
})
.pipe() // When used in conjunction with the each method, the pipe method will pass
        // a single argument to the collect method which is an array of each item
        // that the each method iterated over.
.error(function(error) {
    // Something to do in case there was a problem with the findAll method
})
.category2() // Switches context to a different category
.each(function(record) {
    return // ...
})
.andThen(function(things) {
    // do something
    return things;
})
.pipe()
.collect(function(pipedValue1, pipedValue2, pipedValue3, pipeValue4, pipeValue5) {
    // There will be a number of provided parameters based on how many 
    // times you called the pipe method. Each param will correspond to the 
    // the value that was piped
    
    // pipeValue1: An array of things created from the andThen method based on category1 records
    // pipeValue2: A single record created from the find method based on a category3 record
    // pipeValue3: An array of objects created from the each method based on category3 records
    // pipeValue4: An array of objects created from the each method category3 records
    // pipeValue5: An array of objects created from the andThen method category2 records
})
.category1()
.find(4)
.ifChanges(function(record) {
    // record corresponds to the category1 record given by the find method
})
.and()
.categoory2()
.ifCreated(function(record) {
    // If a new record is created in category2 then this method will be called
    // and the newly created record provided.
})
.ifDeleted(function(record) {
    // If a record in deleted in category2 then this method will be called
    // and the old deleted record provided for reference.
});
*/


// Also all of the "category" methods will need auto created from a list of string names */

/* --- END OF as of yet fictional API --- */



(function() {
    window.HackAPI = { };

    // Max age is given in seconds. Records in the cache will be used for the
    // given amount of time before a request is sent to the server to update the record.
    var cache = {neverExpire: true, maxAge: 60 };

    var HackRequest = function(category, id) {
        var self = this;
        var path;
        var andThenParam = [];

        if (typeof cache[category] === "undefined") {
            cache[category] = { records: [] };
        }

        if (typeof id !== "undefined") {
            path = jsonPath(category, id);
        } else {
            path = jsonPath(category);
        }

        var isCached = false;
        var cachedResponse;
        if (id) {
            isCached = cache[category] && cache[category].records[id] && (cache.neverExpire || cache[category].records[id].expire > new Date());
        } else {
            isCached = cache[category].expire > new Date();
        }

        if (isCached && id) {
            cachedResponse = cache[category].records[id].cachedResponse;
        } else if (isCached) {
            cachedResponse = cache[category].records;
        } else {
            $.get(path)
            .done(function(response) {
                var expire = new Date();
                expire.setSeconds(expire.getSeconds() + cache.maxAge);

                if (Array.isArray(response)) {
                    cache[category].expire = expire;

                    $.each(response, function(index, result) {
                        cache[category].records[result.id] = {expire: expire, cachedResponse: result};

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

                    if (typeof self.allCallback === "function") {
                        self.allCallback(response);
                    }
                } else {
                    cache[category].records[id] = {expire: expire, cachedResponse: response};

                    if (typeof self.doneCallback === "function") {
                        self.doneCallback(response);
                    }

                    if (typeof self.allCallback === "function") {
                        self.allCallback([response]);
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

        /* This will provide the all callback with an array of results. If the
         * response is a single item an array of length 1 with the item will
         * be provided to the all callack. */
        self.all = function(callback) {
            self.allCallback = callback;

            if (isCached && Array.isArray(cachedResponse)) {
                self.allCallback(cachedResponse);
            } else if (isCached) {
                self.allCallback([cachedResponse]);
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