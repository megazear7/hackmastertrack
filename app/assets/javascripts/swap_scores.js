$(document).ready(function() {
    swapables = $(".swapable");

    startingValues = { };

    if (swapables.length > 0) {
        // capture starting values
        swapables.each(function(index, swapable) {
            startingValues[$(swapable).find("input").attr("name")] = $(swapable).find("input").val();
        });

        // Watch for dragable mouse down
        $(".swapable").mousedown(function(e) {
            // move dragable input field with mouse
            var container = $(e.target).closest(".swapable-form");
            container.addClass("swapping");
            var group = $(e.target).closest(".input-group");
            var width = group.outerWidth();
            var height = group.outerHeight();
            var hoverGroup = group.clone();
            var hoverVal = hoverGroup.find("input").val();
            group.hide();
            $("body").append(hoverGroup);
            hoverGroup.width(width + "px");
            hoverGroup.css("position", "absolute");
            hoverGroup.css("z-index", "999");
            $(document).mousemove(function(event) {
                hoverGroup.css("left", (event.pageX + 5) + "px");
                hoverGroup.css("top", (event.pageY + 5) + "px");
            });
            // watch for  mouse up
            $(document).mouseup(function(e) {
                group.show();
                hoverGroup.remove();
                $(document).unbind("mouseup");
                container.removeClass("swapping");
            });

            // if mouse over another swapable
            $(".swapable").mouseup(function(e) {
                $(".swapable").unbind("mouseup");

                // switch the input values
                var dropInput = $(e.target).closest(".input-group").find("input");
                var dropVal = dropInput.val();
                dropInput.val(hoverVal);
                group.find("input").val(dropVal);

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
            });
        });
    }

});
