$(document).ready(function() {
    swapables = $(".swapable-stat-input");

    console.log(swapables);

    if (swapables.length() > 0) {
        // capture starting values
        // Watch for dragable mouse down
            // move dragable input field with mouse
            // watch for  mouse up
                // return input value to original position
                // if mouse over another swapable
                    // switch the input values
                    // compare the current values to the capture starting values
                        // all the same: no swaps, 50 bps
                        // two different: one swap, 25 bps
                        // more than two different: more than one swap, 0 bps
                    // update sub nav bonus bps and bp message according to the above determination
                    // update the hidden bp input field
    }

});
