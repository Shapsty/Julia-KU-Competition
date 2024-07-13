include("weather_codes.jl")

function prompt_path(prompt::String)
    println(prompt)
    value = readline()
    #normalize path to use forward slash, trust me things get crazy elsewise
    value = replace(value, "\\" => "/")
    return value
end

# Make this more advanced for more functionality
function prompt_boolean(prompt::String)::Bool
    println(prompt)
    value = readline()
    
    if value == "y"
        return true
    end
    return false
end

function iter_mess_function_find_better_name_later(first_date, last_date, list)
    # probably a better way to do this
    listy = copy(list[1])
     # since julia uses 1 based query instead of 0 based query, adjust
    if first_date == 0
        first_date = 2
        last_date = last_date + 1
    end
    # in order not to return "date:"
    if first_date == 1
        first_date = 2
    end

    new_list = Vector{String}([])
    for (j,item) in enumerate(list[1])
        # if is before first date, remove it
        if j < first_date
            splice!(list[1], 1)
        end
        push!(new_list, list[1][j])
        # if on last date end
        if j == last_date
            break
        end
    end
    # reset list[1] because julia is weird with lists
    list[1] = Vector{SubString{String}}(listy)
    return new_list
end

# TODO: need to make it so that an indivdual day can be represented as day_x and also so that multiple days can be represented as 2024-04-24 to 2024-04-25
function prompt_date(prompt::String, list)
    println(prompt)
    value = readline()
     # check if single date, day format (and convert)
     if startswith(value, "day") && !occursin(" to ", value)
        first_date = parse(Int64, string(split(value, " ")[2]))
        last_date = first_date

        value = iter_mess_function_find_better_name_later(first_date, last_date, list)
        return value
    end
    # check if single date regular date  format
    if !occursin(" to ", value)
        return [value]
    end
    # formatting variables to only get number of day
    value = split(value, " to ")
    first_date = value[1]
    last_date = value[2]

    first_date = split(first_date, " ")
    last_date = split(last_date, " ")

    # turn days from string to integer
    first_date = parse(Int64, string(first_date[2]))
    last_date = parse(Int64, string(last_date[2]))

    value = iter_mess_function_find_better_name_later(first_date, last_date, list)
end

function return_index_of_property(list, sub_string)
    for line in list
        if occursin(sub_string, line) 
            index = findfirst(x -> x == line, list)
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
        if string_to_check != "weather_code" return list_manipulated[index_of_property][index_of_date] end

        # if looking for weather codes translate them
        weather_code_translated = convert_weather_code_to_words(list_manipulated[index_of_property][index_of_date])
        return weather_code_translated
    end
end

function main(file_path::String)
    file_path = prompt_path("Paste the file path:")
    check_for_weather_code = prompt_boolean("Do you want to check for the weather code?")
    check_for_temperature_max = prompt_boolean("Do you want to check for the temperature max?")
    check_for_temperature_min = prompt_boolean("Do you want to check for the temperature min?")
    check_for_precipitation_sum = prompt_boolean("Do you want to check for the precipitation sum?")
    check_for_wind_speed_max = prompt_boolean("Do you want to check for the wind speed max?")
    check_for_precipitation_probability_max = prompt_boolean("Do you want to check for the precipitation probability max?")
    
    open(file_path, "r") do input_file
        total_lines = [line for line in eachline(input_file)]
        # probably can do this variable better
        total_lines_manipulated = total_lines

        index_of_date = 0

        # get sub vectors of each orginal values
        for item in total_lines_manipulated
            total_lines_manipulated = replace(total_lines_manipulated, item=>split(item, " "))
        end
        dates = prompt_date("Enter the date you want to enter in format of year-month-day(Example: 2024-04-24)", total_lines_manipulated)
        # check if date in weather file and if so return index to access other infomation
        for date in dates
            if date in total_lines_manipulated[1]
                index_of_date = findfirst(x -> x == date, total_lines_manipulated[1])
            end
    
            println(return_properties(total_lines_manipulated, total_lines, check_for_weather_code,"weather_code" ,index_of_date))
            println(return_properties(total_lines_manipulated, total_lines, check_for_temperature_max, "temperature_max", index_of_date))
            println(return_properties(total_lines_manipulated, total_lines, check_for_temperature_min, "temperature_min", index_of_date))
            println(return_properties(total_lines_manipulated, total_lines, check_for_precipitation_sum, "precipitation_sum", index_of_date))
            println(return_properties(total_lines_manipulated, total_lines, check_for_wind_speed_max, "wind_speed_max", index_of_date))
            println(return_properties(total_lines_manipulated, total_lines, check_for_precipitation_probability_max, "precipitation_probability_max", index_of_date))
        end
    end
end

main("Example weather file.txt")