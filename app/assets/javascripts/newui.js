(function(){
    window.HackTrack = {};

    HackTrack.open = function($card) {
        $(".hack-cell").slideUp({
            duration: 200,
            done: function() {
                $(".details-cell").slideDown();
            }
        });
    };

    HackTrack.close = function($card) {
        $(".details-cell").slideUp({
            duration: 200,
            done: function() {
                $(".hack-cell").slideDown();
            }
        });
    };
})();

$(document).ready(function() {
    $(".card-opener").click(function() {
        HackTrack.open($(this.closest(".mdl-card")));
    });

    $(".card-closer").click(function() {
        HackTrack.close($(this.closest(".mdl-card")));
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
