(function() {
    window.HackSolr = { }

    var url = "http://ec2-52-33-82-145.us-west-2.compute.amazonaws.com:8983";
    var queryPath = "/solr/hacksolr/query";

    window.HackSolr.search = function(phrase, config, success, failure) {
      var rows = config.rows || 100;

      $.get(url+queryPath,
        { q: phrase, rows: rows})
      .done(function(data) { success(data.response.docs) })
      .fail(function(xhr, textStatus, error) { failure(error) });
    };
})()
