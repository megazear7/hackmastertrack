$(document).ready(function() {
    swapables = $(".swapable");

    startingValues = { };

    if (swapables.length > 0) {
        // capture starting values
        swapables.each(function(index, swapable) {
            startingValues[$(swapable).find("input").attr("name")] = $(swapable).find("input").val();
        });

        var swapping = false;

        // Watch for dragable mouse down
        $(".swapable").click(function(e) {
            if (! swapping) {
                e.preventDefault();
                swapping = true;
                // move dragable input field with mouse
                var container = $(e.target).closest(".swapable-form");
                var group = $(e.target).closest(".input-group");
                var width = group.outerWidth();
                var height = group.outerHeight();
                var hoverGroup = group.clone();
                var hoverVal = hoverGroup.find("input").val();

                container.addClass("swapping");
                group.find(".attr-val").hide();

                $("body").append(hoverGroup);
                hoverGroup.width(width + "px");
                hoverGroup.css("position", "absolute");
                hoverGroup.css("z-index", "999");

                $(document).mousemove(function(event) {
                    hoverGroup.css("left", (event.pageX + 5) + "px");
                    hoverGroup.css("top", (event.pageY + 5) + "px");
                });

                var endSwapping = function(e) {
                    group.find(".attr-val").show();
                    hoverGroup.remove();
                    $(document).unbind("click.swap");
                    container.removeClass("swapping");
                    swapping = false;
                }

                // watch for  mouse up
                $(document).bind("click.swap", endSwapping);

                var swapValues = function(e) {
                    $(".swapable").unbind("click.swap");

                    // switch the input values
                    var dropGroup = $(e.target).closest(".input-group");
                    var dropVal = dropGroup.find("input").val();
                    dropGroup.find("input").val(hoverVal);
                    dropGroup.find(".attr-val").text(hoverVal);
                    group.find("input").val(dropVal);
                    group.find(".attr-val").text(dropVal);

                    var numChanged = 0;
                    swapables.each(function(index, swapable) {
                        if (startingValues[$(swapable).find("input").attr("name")] != $(swapable).find("input").val()) {
                            numChanged++;
                            container.find("input[name='"+$(swapable).find("input").attr("name")+"']").closest(".input-group").addClass("changed");
                        } else {
                            container.find("input[name='"+$(swapable).find("input").attr("name")+"']").closest(".input-group").removeClass("changed");
                        }
                    });

                    if (numChanged >= 3) {
                        $("#bonus-bps").text("0");
                        $("#bonus-bp-message").text("Swapped more than two ability scores.");
                        $("#character_building_points").val(0);
                    } else if (numChanged >= 1) {
                        $("#bonus-bps").text("25");
                        $("#bonus-bp-message").text("Swapped two ability scores.");
                        $("#character_building_points").val(25);
                    } else {
                        $("#bonus-bps").text("50");
                        $("#bonus-bp-message").text("Swapped no ability scores.");
                        $("#character_building_points").val(50);
                    }
                }

                // if mouse over another swapable
                $(".swapable").bind("click.swap", swapValues);

                return false;
            }
        });
    }

});
