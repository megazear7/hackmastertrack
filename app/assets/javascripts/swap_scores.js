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
                var dropInput = $(e.target).closest(".input-group").find("input");
                var dropVal = dropInput.val();

                dropInput.val(hoverVal);
                group.find("input").val(dropVal);

                $(".swapable").unbind("mouseup");
                // switch the input values
                // compare the current values to the capture starting values
                    // all the same: no swaps, 50 bps
                    // two different: one swap, 25 bps
                    // more than two different: more than one swap, 0 bps
                // update sub nav bonus bps and bp message according to the above determination
                // update the hidden bp input field
            });
        });
    }

});
