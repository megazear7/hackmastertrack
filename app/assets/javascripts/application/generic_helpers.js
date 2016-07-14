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
    if (parseInt(button.data("count")) < parseInt(button.data("limit"))) {
      count = button.data("count");
      button.data("count", count+1);
      var id = button.data("target");
      var whole = random(1, 6) + random(1, 6) + random(1, 6)
      var value = whole + "." + random(0,99)
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
});
