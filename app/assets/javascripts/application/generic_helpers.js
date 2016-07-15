var getUrlParameter = function getUrlParameter(sParam) {
    var sPageURL = decodeURIComponent(window.location.search.substring(1)),
        sURLVariables = sPageURL.split('&'),
        sParameterName,
        i;

    for (i = 0; i < sURLVariables.length; i++) {
        sParameterName = sURLVariables[i].split('=');

        if (sParameterName[0] === sParam) {
            return sParameterName[1] === undefined ? true : sParameterName[1];
        }
    }
};

function random(min,max) {
        return Math.floor(Math.random()*(max-min+1)+min);
}

$(document).ready(function() {
  $(".show-on-hover").each(function(index, element) {
    var show = $(element).data("show");
    $("."+show).hide();
    $(element).mouseenter(function(e) {
      $("."+show).show();
    });
    $(element).mouseleave(function(e) {
      $("."+show).hide();
    });
  });

  var subNav = $(".sub-nav");
  var active = document.body.scrollTop > 50
  var first = true
  $(window).scroll(function(e){
    if ($(window).width() > 992) { 
        if ((! active && document.body.scrollTop > 50) || first) {
          first = false;
          active = true;
          var placeholder = subNav.clone().empty().css("height", subNav.height()+"px").addClass("subnav-placeholder");
          subNav.after(placeholder);
          subNav.addClass("active");
        } else if ((active && document.body.scrollTop < 50) || first) {
          first = false;
          active = false;
          $(".subnav-placeholder").remove();
          subNav.removeClass("active");
        }
    }
  });

  $(".click-link").click(function(e) {
    var clickableElement = $(e.target).closest(".click-link");
    if (clickableElement.length == 0) {
      clickableElement = $(e.target)
    }
    var clickId = clickableElement.data("click")
    document.location = $("#"+clickId).attr("href");
  });

  $(".selectable").click(function(e) {
    var group = $(e.target).data("selectable-group");
    $("."+group).removeClass("selected");
    $(e.target).addClass("selected");
  });

  $(".random").click(function(e) {
    e.preventDefault;
    var button = $(e.target).closest(".click-link");
    if (button.length == 0) {
      button = $(e.target)
    }
    

    var format = button.data("format");
    if (!format) {
      format = "roll"
    }
    rolls = format.match(/\w+/g); 

    if (parseInt(button.data("count")) < parseInt(button.data("limit"))) {
      count = button.data("count");
      button.data("count", count+1);
      var id = button.data("target");

      var value = format;
      $.each(rolls, function(index, roll) {
        dice = button.data(roll);
        rollInfo = dice.split(/d|\+|\-/g);
        count = rollInfo[0];
        size = rollInfo[1];
        total = rollInfo[2];

        if (count == "" || ! count) {
          count = "1";
        }

        if (total == "" || ! total) {
          total = "0";
        }

        count = parseInt(count);
        size = parseInt(size);
        total = parseInt(total);

        for (var i = 0; i < count; i++) {
          total += random(1, size);
        }

        value = value.replace(roll, total.toString());
      });

      $("#"+id).val(value);
    } else {
      limit = parseInt(button.data("limit"));
      if (limit == 1) {
        alert("Only one roll allowed");
      } else {
        alert("Only "+limit+" rolls allowed");
      }
    }
    return false;
  });

  $(".tile").each(function(index, tile) {
    $(tile).attr("data-base-height", $(tile).outerHeight());

    $(tile).css("height", "auto");
    $(tile).attr("data-auto-height", $(tile).outerHeight());
    $(tile).css("height", $(tile).data("base-height"));

    $(tile).attr("data-status", "closed");
  });

  function openTile(tile) {
    tile.find(".expander").removeClass("glyphicon-fullscreen");
    tile.find(".expander").addClass("glyphicon-resize-small");
    tile.data("status", "open");
    tile.css("position", "absolute");
    setTimeout(function() {
      tile.css("position", "absolute");
      tile.css("height", tile.data("auto-height")+"px");
    }, 250);
  }

  function closeTile(tile) {
    tile.find(".expander").removeClass("glyphicon-resize-small");
    tile.find(".expander").addClass("glyphicon-fullscreen");
    tile.data("status", "closed");
    tile.css("height", tile.data("base-height")+"px");
    setTimeout(function() {
      tile.css("position", "relative");
    }, 250);
  }

  $(".tile .buttons .expander").click(function(e) {
    e.preventDefault();
    var tile = $(e.target).closest(".tile");
    if (tile.data("status") == "closed") {
      $("."+tile.data("tile-group")).each(function(index, otherTile) {
        closeTile($(otherTile));
      });
      openTile(tile);
    } else {
      closeTile(tile);
    }
    return false;
  });
});
