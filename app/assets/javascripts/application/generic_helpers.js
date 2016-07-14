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
});

$(document).ready(function() {
  subNav = $(".sub-nav");
  active = document.body.scrollTop > 50
  first = true
  $(window).scroll(function(e){
    if ($(window).width() > 992) { 
        if ((! active && document.body.scrollTop > 50) || first) {
          first = false;
          active = true;
          placeholder = subNav.clone().empty().css("height", subNav.height()+"px").addClass("subnav-placeholder");
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
    clickableElement = $(e.target).closest(".click-link");
    if (clickableElement.length == 0) {
      clickableElement = $(e.target)
    }
    clickId = clickableElement.data("click")
    document.location = $("#"+clickId).attr("href");
  });
});
