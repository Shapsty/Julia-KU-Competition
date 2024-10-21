include("weather_codes.jl")

# Returns file path in usable format
function prompt_path(prompt::String)
    println(prompt)
    value = readline()
    # normalize path to use forward slash, trust me things get crazy elsewise
    value = replace(value, "\\" => "/")
    return value
end

# Make this more advanced for more functionality
function prompt_boolean(prompt::String)::Bool
    println(prompt)
    value = readline()
    
    return lowercase(value) == "y"
end

function iterate_vector_get_specific_dates(first_date, last_date, list)
    changed_list = copy(list[1])
    # since julia uses 1 based query instead of 0 based query, adjust -- maybe make it standarized, like only use 0 based query or only use 1 based query.
    if first_date == 0
        first_date = 1
        last_date = last_date + 1
    end
    new_list = Vector{String}([])
    # get rid of "date:"
    filter!(e->e≠"date:", changed_list)
    for (counter,item) in enumerate(changed_list)
        # if before counter is before first date ignore
        if !(counter >= first_date) continue end

        push!(new_list, changed_list[counter])
        # if on last date then end
        if counter == last_date
            break
        end
    end
    return new_list
end

function prompt_date(prompt::String, list)
    println(prompt)
    value = readline()

    # can probably make next three if statements more effcient
    # check if single, day format (and convert)
    if startswith(value, "day") && !occursin(r"\s+to\s+", value)
        first_date = parse(Int64, split(value, " ")[2])

        return iterate_vector_get_specific_dates(first_date, first_date, list)
    end
    # check if in date format and has multiple dates
    if !startswith(value, "day") && occursin(r"\s+to\s+", value)
        start, stop  = split(value, r"\s+to\s+")

        first_date = findfirst(x -> x == start, list[1])-1
        last_date = findfirst(x -> x == stop, list[1])-1

        return iterate_vector_get_specific_dates(first_date, last_date, list)
    end
    # check if single date regular date  format
    if !occursin(" to ", value)
        return [value]
    end
    # formatting variables to only get number of day
    start, stop = split(value, r"\s+to\s+")
    first_date = start
    last_date = stop

    first_date = split(first_date, " ")
    last_date = split(last_date, " ")

    # turn days from string to integer
    first_date = parse(Int64, (first_date[2]))
    last_date = parse(Int64, (last_date[2]))

    value = iterate_vector_get_specific_dates(first_date, last_date, list)
end

function return_index_of_property(list, sub_string)
    for line in list
        if occursin(sub_string, line) 
            index = findfirst(==(line), list)
            return index
        end
    end
    # TODO use this boolean to check for if weather data to get is not in the file. A simple if function somewhere will make do
    return false
end

function return_properties(list_manipulated, list_unmaniplated, boolean, string_to_check, index_of_date)
    # check if boolean is true
    if boolean
        index_of_property = return_index_of_property(list_unmaniplated, string_to_check)

        # check if this is looking for weather codes
        string_to_check != "weather_code" &&  list_manipulated[index_of_property][index_of_date]

        # if looking for weather codes translate them
        weather_code_translated = WEATHER_CODES[list_manipulated[index_of_property][index_of_date]]
        return weather_code_translated
    end
end

function main()
    file_path = prompt_path("What path do you want to use?")
    check_for_weather_code = prompt_boolean("Do you want to check for the weather code?")
    check_for_temperature_max = prompt_boolean("Do you want to check for the temperature max?")
    check_for_temperature_min = prompt_boolean("Do you want to check for the temperature min?")
    check_for_precipitation_sum = prompt_boolean("Do you want to check for the precipitation sum?")
    check_for_wind_speed_max = prompt_boolean("Do you want to check for the wind speed max?")
    check_for_precipitation_probability_max = prompt_boolean("Do you want to check for the precipitation probability max?")
    
    total_lines = [line for line in eachline(open(file_path))]
    # probably can do this variable better
    total_lines_manipulated = total_lines

    index_of_date = 0

    # get sub vectors of each orginal values
    total_lines_manipulated = [split(item, " ") for item in total_lines]
    dates = prompt_date("Enter the date you want in format year-month-day (Example: 2024-04-24)", total_lines_manipulated)
    # check if date in weather file and if so return index to access other infomation
    for date in dates
        if date in total_lines_manipulated[1]
            index_of_date = findfirst(==(date), total_lines_manipulated[1])
        end
    
        println(return_properties(total_lines_manipulated, total_lines, check_for_weather_code,"weather_code" ,index_of_date))
        println(return_properties(total_lines_manipulated, total_lines, check_for_temperature_max, "temperature_max", index_of_date))
        println(return_properties(total_lines_manipulated, total_lines, check_for_temperature_min, "temperature_min", index_of_date))
        println(return_properties(total_lines_manipulated, total_lines, check_for_precipitation_sum, "precipitation_sum", index_of_date))
        println(return_properties(total_lines_manipulated, total_lines, check_for_wind_speed_max, "wind_speed_max", index_of_date))
        println(return_properties(total_lines_manipulated, total_lines, check_for_precipitation_probability_max, "precipitation_probability_max", index_of_date))
    end
end

main()