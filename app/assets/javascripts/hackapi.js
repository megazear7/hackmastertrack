(function() {
    window.HackAPI = { };

    // Max age is given in seconds. Records in the cache will be used for the
    // given amount of time before a request is sent to the server to update the record.
    var cache = {neverExpire: true, maxAge: -1 };

    var HackRequest = function(category, pipablesParam, otherPipableDeferreds) {
        var self = this;
        var andThenParam = [];
        var cachedResponse;
        var response;
        self.useEachAsPipable = true;
        self.isCached = false;
        self.initialized = false;

        self.pipeFinished = $.Deferred();

        self.pipableSet = $.Deferred();
        self.pipableDeferreds = [ ];
        self.pipableDeferreds.push(self.pipableSet);

        self.takableSet = $.Deferred();
        self.takableDeferreds = [ ];
        self.takableDeferreds.push(self.takableSet);

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
            self.pipe();

            return new HackRequest(category, self.pipables, self.pipableDeferreds, self.takableDeferreds);
        };

        // TODO make this a private method.
        self.pipe = function() {
            $.when.apply($, self.pipableDeferreds).then(function() {
                self.pipables.push(self.pipable);

                self.pipeFinished.resolve();
            });

            return self;
        };

        self.collect = function(callback) {
            self.pipe();

            var deferreds;
            if (otherPipableDeferreds) {
                deferreds = otherPipableDeferreds.concat(self.pipeFinished);
            } else {
                deferreds = [ self.pipeFinished ];
            }
            $.when.apply($, deferreds).then(function() {
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

    var tables = ["characters", "races", "character_classes"];

    $.each(tables, function(index, tableName) {
        window.HackAPI[tableName] = function() {
            return new HackRequest(tableName);
        };
    });

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
        .and()
        .each(function(character) {
            return character.id;
        })
        .andThen(function(characterIds) {
            return characterIds;
        })
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
        .and()
        .find(104, function(character) {
            return character.race_id;
        })
        .take()
        .from(HackAPI.races)
        .and()
        .find(104, function(character) {
            return character.character_class_id;
        })
        .take()
        .from(HackAPI.character_classes)
        .collect(function(character, race, characterClass) {
            console.log(character.name + " is a " + race.name + " " + characterClass.name);
        });
    };

    window.HackAPI.examples.sixth = function() {
        HackAPI.characters()
        .find(104, function(character) {
            return character;
        })
        .and()
        .find(104, function(character) {
            return character.race_id;
        })
        .take()
        .from(HackAPI.races)
        .and()
        .find(104, function(character) {
            return character.character_class_id;
        })
        .take()
        .from(HackAPI.character_classes)
        .collect(function(character, race, characterClass) {
            console.log(character.name + " is a " + race.name + " " + characterClass.name);
        });
    };

})()
