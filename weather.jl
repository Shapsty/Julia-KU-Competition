# Make this more advanced for more functionality
function prompt_boolean(prompt::String)::Bool
    println(prompt)
    value = readline()
    
    if value == "y"
        return true
    end
    return false
end

# make this more advanced to check for multiple dates
function prompt_date(prompt::String)
    println(prompt)
    value = readline()

    return value
end

function convert_weather_code_to_words(weather_code)
    # dict containing all weather codes
    # return value using weather_code as key    
end

function return_index_of_property(list, sub_string)
    for line in list
        if occursin(sub_string, line) 
            index = findfirst(x -> x == line, list)
            return index
        end
    end
    # use this to check for if weather data to get not in file. Priority = low
    return false
end

function main(file_path::String)
    date = prompt_date("Enter the date you want to enter in format of year-month-day(Example: 2024-04-24)")
    check_for_weather_code = prompt_boolean("Do you want to check for the weather code?")
    check_for_temperature_max = prompt_boolean("Do you want to check for the temperature max?")
    check_for_temperature_min = prompt_boolean("Do you want to check for the temperature min?")
    check_for_precipitation_sum = prompt_boolean("Do you want to check for the precipitation sum?")
    check_for_wind_speed_max = prompt_boolean("Do you want to check for the wind speed_max?")
    check_for_precipitation_probability_max = prompt_boolean("Do you want to check for the precipitation probability max?")

    open(file_path, "r") do input_file
        total_lines = [line for line in eachline(input_file)]
        # probably can do this variable better
        total_lines_manipulated = total_lines
        println(total_lines)

        index_of_date = 0

        # get sub vectors of each orginal values
        for item in total_lines_manipulated
            total_lines_manipulated = replace(total_lines_manipulated, item=>split(item, " "))
        end
        println("\n\n\n$total_lines_manipulated")
        # check if date in weather file and if so return index to access other infomation
        if date in total_lines_manipulated[1]
            index_of_date = findfirst(x -> x == date, total_lines_manipulated[1])
        end

        # giant logic block, I feel as though there is a way to write more concisely
        if check_for_weather_code
            index_of_weather_code = return_index_of_property(total_lines, "weather_code")
            println(total_lines_manipulated[index_of_weather_code][index_of_date])
        end
        if check_for_temperature_max
            index_of_temp_max = return_index_of_property(total_lines, "temperature_max")
            println(total_lines_manipulated[index_of_temp_max][index_of_date])
        end
        if check_for_temperature_min
            index_of_temp_min = return_index_of_property(total_lines, "temperature_min")
            println(total_lines_manipulated[index_of_temp_min][index_of_date])
        end
        if check_for_precipitation_sum
            index_of_precipitation_sum = return_index_of_property(total_lines, "precipitation_sum")
            println(total_lines_manipulated[index_of_precipitation_sum][index_of_date])
        end
        if check_for_wind_speed_max
            index_of_wind_speed_max = return_index_of_property(total_lines, "wind_speed_max")
            println(total_lines_manipulated[index_of_wind_speed_max][index_of_date])
        end
        if check_for_precipitation_probability_max
            index_of_precipitation_probability_max = return_index_of_property(total_lines, "precipitation_probability_max")
            println(total_lines_manipulated[index_of_precipitation_probability_max][index_of_date])
        end
    end
end

main("Example weather file.txt")