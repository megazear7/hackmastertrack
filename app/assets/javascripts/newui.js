(function(){
    window.HackTrack = {};

    HackTrack.open = function($card) {
        var data = $card.data();
        var category = data.category;
        var id = data.id;

        history.pushState({action: "details", category: category}, null, '/new#/details/'+category+"/"+id);

        $(".details-title h3").text(data.title.titleize());

        if (data.categoryReadable) {
            $(".details-category h5").text(data.categoryReadable);
        }

        $(".default-cell, .search-cell").slideUp({duration: 200}).promise().done(function() {
            $(".details-cell").slideDown(200);
        });
    };

    HackTrack.close = function() {
        history.back();
        $(".details-cell").slideUp({duration: 200}).promise().done(function() {
            $(".default-cell").slideDown(200);
        });
    };
})();

$(document).ready(function() {
    $(".card-opener").click(function() {
        HackTrack.open($(this.closest(".mdl-card")));
    });

    $(".details-back").click(function() {
        HackTrack.close();
    });

    $(".hack-search").submit(function(e) {
        e.preventDefault();

        $(".default-cell, .details-cell").slideUp({duration: 200}).promise().done(function() {
            $(".search-cell").slideDown(200);
        });

        terms = $(this).find("input").val();
        history.pushState({action: "search", terms: terms}, null, '/new#/search/'+terms);
    });
});

Array.prototype.remove = function() {
    var what, a = arguments, L = a.length, ax;
    while (L && this.length) {
        what = a[--L];
        while ((ax = this.indexOf(what)) !== -1) {
            this.splice(ax, 1);
        }
    }
    return this;
};

String.prototype.capitalize = function() {
    return this.charAt(0).toUpperCase() + this.slice(1);
}

String.prototype.titleize = function() {
    var string_array = this.split(' ');
    string_array = string_array.map(function(str) {
       return str.capitalize(); 
    });
    
    return string_array.join(' ');
}
