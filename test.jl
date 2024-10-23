using Plots, Images, ImageView

function create_histogram(values)
    h = histogram(values)
    ylabel!(h, "Occurrences")
    xlabel!(h, "Values")
    png(h, "histogram")
    # Now you can load the PNG if needed:

end
