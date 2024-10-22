using Plots

b_range = range(-5, 5, length=21)

function histo(values)
    h = histogram(values)
    ylabel!(h, "Occurances")
    xlabel!(h, "Values")
    display(h)
end
histo([54.9464, 52.6064, 61.9664, 52.2464, 52.6064, 48.4664])
sleep(500)