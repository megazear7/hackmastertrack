(function(){
    window.HackTrack = {};

    HackTrack.open = function($card) {
      HackTrack.closeAll();

      var data = $card.data();
      $card.addClass("open-details-card");

      var $container;
      if (data.category1 === "item" || data.category1 === "spell" || data.category1 === "proficiency") { 
        $container = $(".details-view-template-small").clone();
        $container.removeClass("details-view-template-small");
      } else {
        $container = $(".details-view-template-large").clone();
        $container.removeClass("details-view-template-large");
      }

      $container.removeClass("details-view-template");
      $container.addClass("details-view-actual");

      $container.find(".details-title").text(data.title.titleize());
      $container.find(".details-category1").text(data.category1.titleize());
      $container.hide();
      
      $card.closest(".mdl-cell").after($container);
      $card.closest(".mdl-cell").slideUp({done: function() {
          $container.slideDown({done: function() {
            //$('html, body').animate({scrollTop:$container.find(".mdl-layout-title").offset().top},500)
          }});
      }});

      $container.find(".closer").click(function() {
          HackTrack.close($card);
      });
    };

    HackTrack.close = function($card) {
      $card.removeClass("open-details-card");
      $container = $card.closest(".details-view-actual");

      $container.slideUp({done: function() {
          $container.remove();
          $card.closest(".mdl-cell").slideDown();
      }});
    };

    HackTrack.closeAll = function($card) {
      $(".details-view-actual").remove();
      $(".open-details-card").closest(".mdl-cell").show();
      $(".open-details-card").removeClass("open-details-card");
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
