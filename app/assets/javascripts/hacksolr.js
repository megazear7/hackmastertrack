(function() {
    window.HackSolr = { }

    var url = "http://ec2-52-33-82-145.us-west-2.compute.amazonaws.com:8983";
    var queryPath = "/solr/hacksolr/query";

    window.HackSolr.search = function(phrase, filters, success, failure) {
      $.get(url+queryPath,
        { q: "en:" + phrase })
      .done(function(data) { success(data) })
      .fail(function(xhr, textStatus, error) { failure(error) });
    };
})()
