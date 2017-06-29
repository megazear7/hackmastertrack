(function() {
    var findOne = function (haystack, arr) {
        return arr.some(function (v) {
            return haystack.indexOf(v) >= 0;
        });
    };

    var queryPath = "/query";
    var suggestPath = "/suggest";

    HackSolr = function(url) {
        var self = this;

        self.search = function(phrase, config, success, failure) {
          var rows = config.rows || 100;

          var fq = "false";
          
          if (config.owners) {
              if (config.owners.length > 0) {
                  fq += " | owners:(" + config.owners.join(" ") + ")";
              }
          }
          
          if (config.groups) {
              if (config.groups.length > 0) {
                  fq += " | groups:(" + config.groups.join(" ") + ")";
              }
          }

          $.get(url+queryPath,
            { q: phrase, rows: rows, fq: fq})
          .done(function(data) {
              if (typeof success === "function") {
                  success(data.response.docs)
              }
          })
          .fail(function(xhr, textStatus, error) {
              if (typeof failure === "function") {
                  failure(error)
              }
          });
        };

        self.suggest = function(phrase, success, failure) {
          $.get(url+suggestPath,
            { "suggest.q": phrase })
          .done(function(data) {
              if (typeof success === "function") {
                  success(data.suggest.hackSuggester[phrase].suggestions);
              }
          })
          .fail(function(xhr, textStatus, error) {
              if (typeof failure === "function") {
                  failure(error)
              }
          });
        };
    }
    $(document).ready(function() {
        window.HackSolr = new HackSolr($(document.body).data().solrUrl);
    });
})()
