(function() {
    window.HackSolr = { }

    var findOne = function (haystack, arr) {
    return arr.some(function (v) {
        return haystack.indexOf(v) >= 0;
    });
    };

    var url = "http://ec2-52-33-82-145.us-west-2.compute.amazonaws.com:8983";
    var queryPath = "/solr/hacksolr/query";

    window.HackSolr.search = function(phrase, config, success, failure) {
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
})()
