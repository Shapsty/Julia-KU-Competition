using Plots, Images, ImageView

function create_histogram(values)
    h = histogram(values)
    ylabel!(h, "Occurrences")
    xlabel!(h, "Values")
    png(h, "histogram")
    # Now you can load the PNG if needed:

end
function create_bargraph(values)
    gr()
    how_many = []

    for (i,j) in enumerate(values)
        append!(how_many, i)
    end

    bar_plot = plot(bar(how_many, values))
    xlabel!(bar_plot, "Days")
    ylabel!(bar_plot, "Values")
    title!(bar_plot, "Bar Plot")
    png(bar_plot, "bar")
end
