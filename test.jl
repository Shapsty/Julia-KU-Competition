using Plots

function create_histogram(values)
    h = histogram(values)
    ylabel!(h, "Occurances")
    xlabel!(h, "Values")
    display(h)
    savefig(h, "histogram.pdf")
end
sleep(300)