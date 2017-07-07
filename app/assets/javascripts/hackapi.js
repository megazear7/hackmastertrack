

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
    var cache = {neverExpire: true, maxAge: -1 };

    var HackRequest = function(category, pipablesParam) {
        var self = this;
        var andThenParam = [];
        var cachedResponse;
        var response;
        self.useEachAsPipable = true;
        self.isCached = false;
        self.initialized = false;

        self.pipeFinished = $.Deferred();

        self.pipableSet = $.Deferred();
        self.pipableDeferreds = [ self.pipableSet ];

        self.takableSet = $.Deferred();
        self.takableDeferreds = [ self.takableSet ];

        var doEach = function(records, callback) {
            if (self.useEachAsPipable) {
                self.pipable = [];
            }

            if (typeof self.beforeCallback === "function") {
                self.beforeCallback(record);
            }

            $.each(records, function(index, record) {
                if (typeof callback === "function") {
                    callback(record);
                }

                var andThenItem;

                if (typeof self.firstCallback === "function" && index === 0) {
                    andThenItem = self.firstCallback(record);
                } else if (typeof self.lastCallback === "function" && index === records.length-1) {
                    andThenItem = self.lastCallback(record);
                } else if (typeof self.eachCallback === "function") {
                    andThenItem = self.eachCallback(record, index === 0, index === records.length-1);
                }

                if (typeof andThenItem !== "undefined") {
                    if (self.useEachAsPipable) {
                        self.pipable.push(andThenItem);
                    }

                    andThenParam.push(andThenItem);
                }
            });

            if (self.useEachAsPipable) {
                self.pipableSet.resolve();
            }

            if (typeof self.afterCallback === "function") {
                self.afterCallback(record);
            }
        };

        var init = function() {
            self.initialized = true;

            if (Array.isArray(self.idOrIds)) {
                self.ids = self.idOrIds;
                self.singleRequest = false;
                self.multiRequest = true;
                self.indexRequest = false;
                self.path = jsonPath(category);
                self.data = { ids: self.ids };
            } else if (typeof self.idOrIds != "undefined") {
                self.id = self.idOrIds;
                self.singleRequest = true;
                self.multiRequest = false;
                self.indexRequest = false;
                self.path = jsonPath(category, self.id);
                self.data = { };
            } else {
                self.singleRequest = false;
                self.multiRequest = false;
                self.indexRequest = true;
                self.path = jsonPath(category);
                self.data = { };
            }

            if (typeof pipablesParam === "undefined") {
                self.pipables = [ ];
            } else {
                self.pipables = pipablesParam;
            }

            if (typeof cache[category] === "undefined") {
                cache[category] = { records: [] };
            }

            if (self.singleRequest) {
                self.isCached = cache[category] && cache[category].records[self.id] && (cache.neverExpire || cache[category].records[self.id].expire > new Date());
            } else if (self.multiRequest) {
                self.isCached = true;
                $.each(self.ids, function(index, id) {
                    thisIdCached = cache[category] && cache[category].records[id] && (cache.neverExpire || cache[category].records[id].expire > new Date());

                    if (! thisIdCached) {
                        self.isCached = false;
                    }
                });
            } else {
                self.isCached = cache[category] && cache[category].hasBeenRequested && (cache.neverExpire || cache[category].expire > new Date());
            }

            if (self.isCached && self.singleRequest) {
                cachedResponse = cache[category].records[self.id].cachedResponse;
            } else if (self.isCached && self.multiRequest) {
                cachedResponse = [ ];
                $.each(self.ids, function(index, id) {
                    cachedResponse.push(cache[category].records[id].cachedResponse);
                });
            } else if (self.isCached && self.indexRequest) {
                cachedResponse = Object.values(cache[category].records).map(function(record) { return record.cachedResponse; });;
            } else {
                $.get(self.path, self.data)
                .done(function(response) {
                    var expire = new Date();
                    expire.setSeconds(expire.getSeconds() + cache.maxAge);

                    if (Array.isArray(response)) {
                        cache[category].expire = expire;
                        cache[category].hasBeenRequested = true;

                        doEach(response, function(record) {
                            cache[category].records[record.id] = {expire: expire, cachedResponse: record};
                        });

                        if (typeof self.andThenCallback === "function") {
                            self.pipable = self.andThenCallback(andThenParam);
                            self.pipableSet.resolve();
                        }

                        if (typeof self.allCallback === "function") {
                            self.pipable = self.allCallback(response);
                            self.pipableSet.resolve();
                        }
                    } else {
                        cache[category].records[self.id] = {expire: expire, cachedResponse: response};

                        if (typeof self.findCallback === "function") {
                            self.pipable = self.findCallback(response);
                            self.pipableSet.resolve();
                        }

                        if (typeof self.allCallback === "function") {
                            self.pipable = self.allCallback([response]);
                            self.pipableSet.resolve();
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
        }

        self.find = function(idOrIdsParam, callback) {
            if (typeof callback === "function") {
                // Expect the id param to be a single id
                self.idOrIds = idOrIdsParam;
            } else {
                // Expect there to be 1 or more parameters, all ids, or one parameter that is an array of ids
                if (Array.isArray(idOrIdsParam)) {
                    self.idOrIds = idOrIdsParam;
                } else {
                    self.idOrIds = Array.from(arguments);
                }
            }

            self.findCallback = callback;

            if (! self.initialized) {
                init();
            }

            if (self.isCached && typeof self.findCallback === "function") {
                self.pipable = self.findCallback(cachedResponse);
                self.pipableSet.resolve();
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

        self.before = function(callback) {
            self.beforeCallback = callback;

            return self;
        };

        self.after = function(callback) {
            self.afterCallback = callback;

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
            if (! self.initialized) {
                init();
            }

            self.eachCallback = callback;

            if (self.isCached && Array.isArray(cachedResponse)) {
                doEach(cachedResponse);
                self.pipableSet.resolve();
            }

            return self;
        };

        /* This will provide the all callback with an array of results. If the
         * response is a single item an array of length 1 with the item will
         * be provided to the all callack. */
        self.all = function(callback) {
            if (! self.initialized) {
                init();
            }

            self.useEachAsPipable = false;
            self.allCallback = callback;

            if (self.isCached && Array.isArray(cachedResponse)) {
                self.pipable = self.allCallback(cachedResponse);
                self.pipableSet.resolve();
            } else if (self.isCached) {
                self.pipable = self.allCallback([cachedResponse]);
                self.pipableSet.resolve();
            }

            return self;
        };

        /* Used in conjunction with the each method. The items returned by the
         * each callback will be provided to the andThen callback as an array. */
        self.andThen = function(callback) {
            self.useEachAsPipable = false;
            self.andThenCallback = callback;

            if (self.isCached) {
                self.pipable = self.andThenCallback(andThenParam);
                self.pipableSet.resolve();
            }

            return self;
        };

        self.and = function() {
            return new HackRequest(category, self.pipables);
        };

        self.pipe = function() {
            $.when.apply($, self.pipableDeferreds).then(function() {
                self.pipables.push(self.pipable);

                self.pipeFinished.resolve();
            });

            return self;
        };

        self.collect = function(callback) {
            self.pipeFinished.done(function() {
                callback.apply(self, self.pipables);
            });

            return self;
        };

        self.take = function() {
            $.when.apply($, self.pipableDeferreds).then(function() {
                self.takable = self.pipable;
                self.taken = true;
                self.takableSet.resolve();
            });

            return self;
        };

        self.from = function(hackapi, callback) {
            var fromDeferred = $.Deferred();
            self.pipableDeferreds.push(fromDeferred);

            $.when.apply($, self.takableDeferreds).then(function() {
                if (Array.isArray(self.takable)) {
                    hackapi()
                    .find(self.takable)
                    .before(function() {
                        self.pipable = [ ];
                    })
                    .each(function(fromable, isFirst) {
                        if (typeof callback === "function") {
                            callback(fromable);
                        }

                        self.pipable.push(fromable);
                    })
                    .after(function() {
                        self.pipableSet.resolve();
                        fromDeferred.resolve();
                    });
                } else {
                    hackapi()
                    .find(self.takable, function(fromable) {
                        if (typeof callback === "function") {
                            callback(fromable);
                        }
                        self.pipable = fromable;
                        self.pipableSet.resolve();
                        fromDeferred.resolve();
                    });
                }
            });

            return self;
        };
    };
    
    window.HackAPI.characters = function() {
        return new HackRequest("characters");
    };

    window.HackAPI.races = function() {
        return new HackRequest("races");
    };

    window.HackAPI.characterClasses = function() {
        return new HackRequest("character_classes");
    };

    function jsonPath() {
        return "/" + Array.from(arguments).join("/") + ".json"
    }

    /* ------------------------------------------------------------------------
     * Examples for testing and documentation purposes. This might be easier to
     * document with examples than with a full description of how it all works.
     * ------------------------------------------------------------------------ */

    window.HackAPI.examples = { };

    window.HackAPI.examples.first = function() {
        HackAPI.characters()
        .each(function(character) {
            return character.name;
        })
        .andThen(function(characterNames) {
            return characterNames;
        })
        .pipe()
        .and()
        .each(function(character) {
            return character.id;
        })
        .andThen(function(characterIds) {
            return characterIds;
        })
        .pipe()
        .collect(function(characterNames, characterIds) {
            console.log(characterNames);
            console.log(characterIds);
        });
    };

    window.HackAPI.examples.second = function() {
        HackAPI.characters()
        .find(104, function(character) {
            console.log(character);
        });
    };

    window.HackAPI.examples.third = function() {
        HackAPI.characters()
        .find(104, 91)
        .each(function(character) {
            return character.name + " has a strength of " + character.strength;
        })
        .pipe()
        .collect(function(strengths) {
            console.log(strengths);
        });
    };

    window.HackAPI.examples.fourth = function() {
        HackAPI.characters()
        .find(104, function(character) {
            return character.race_id
        })
        .take()
        .from(HackAPI.races, function(race) {
            console.log(race.name);
        });
    };

    window.HackAPI.examples.fifth = function() {
        HackAPI.characters()
        .find(104, function(character) {
            return character;
        })
        .pipe()
        .and()
        .find(104, function(character) {
            return character.race_id;
        })
        .take()
        .from(HackAPI.races)
        .pipe()
        .and()
        .find(104, function(character) {
            return character.character_class_id;
        })
        .take()
        .from(HackAPI.characterClasses)
        .pipe()
        .collect(function(character, race, characterClass) {
            console.log(character.name + " is a " + race.name + " " + characterClass.name);
        });
    };

})()
