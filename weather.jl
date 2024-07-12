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
function prompt_date(prompt::String, list)
    println(prompt)
    value = readline()

    if !occursin(" to ", value)
        return value
    end

    value = split(value, " to ")

    first_date = value[1]
    last_date = value[2]

    first_date = split(first_date, " ")
    last_date = split(last_date, " ")

    first_date = parse(Int64, string(first_date[2]))
    last_date = parse(Int64, string(last_date[2]))

    if first_date == 0 || first_date == 1
        first_date = 2
    end

    println(first_date)
    println(last_date)
    new_list = []
    for (j,item) in enumerate(list[1])
        if j < first_date
            splice!(list[1], 1)
        end
        push!(new_list,list[1][j])
        if j == last_date
            break
        end
    end
    print(new_list)
    # convert days into dates using for loop which gets all dates and their position. 
    # Then uses the day number from value to specify start and end positions: returns list of converted dates
    # run main code for each date from list

    return value
end

function convert_weather_code_to_words(weather_code)
    # dict containing all weather codes
    weather_codes = Dict(
        "0.0" => "Cloud development not observed or not observable (Characteristic change of the state of sky during the past hour)",
        "1.0" => "Clouds generally dissolving or becoming less developed (Characteristic change of the state of sky during the past hour)",
        "2.0" => "State of sky on the whole unchanged (Characteristic change of the state of sky during the past hour)",
        "3.0" => "Clouds generally forming or developing (Characteristic change of the state of sky during the past hour)",
        "4.0" => "Visibility reduced by smoke, e.g. veldt or forest fires, industrial smoke or volcanic ashes",
        "5.0" => "Haze",
        "6.0" => "Widespread dust in suspension in the air, not raised by wind at or near the station at the time of observation",
        "7.0" => "Dust or sand raised by wind at or near the station at the time of observation, but no well developed dust whirl(s) or sand whirl(s), and no duststorm or sandstorm seen",
        "8.0" => "Well developed dust whirl(s) or sand whirl(s) seen at or near the station during the preceding hour or at the time ot observation, but no duststorm or sandstorm",
        "9.0" => "Duststorm or sandstorm within sight at the time of observation, or at the station during the preceding hour",
        "10.0" => "Mist",
        "11.0" => "shallow fog or ice fog at the station, whether on land or sea, not deeper than about 2 metres on land or 10 metres at sea (Patches)",
        "12.0" => "shallow fog or ice fog at the station, whether on land or sea, not deeper than about 2 metres on land or 10 metres at sea (More or less continuous)",
        "13.0" => "Lightning visible, no thunder heard",
        "14.0" => "Precipitation within sight, not reaching the ground or the surface of the sea",
        "15.0" => "Precipitation within sight, reaching the ground or the surface of the sea, but distant, i.e. estimated to be more than 5 km from the station",
        "16.0" => "Precipitation within sight, reaching the ground or the surface of the sea, near to, but not at the station",
        "17.0" => "Thunderstorm, but no precipitation at the time of observation",
        "18.0" => "Squalls (at or within sight of the station during the preceding hour or at the time of observation)",
        "19.0" => "Funnel cloud(s) (Tornado cloud or water-spout.) at or within sight of the station during the preceding hour or at the time of observation",
        "20.0" => "Drizzle (not freezing) or snow grains (not falling as shower(s))",
        "21.0" => "Rain (not freezing) (not falling as shower(s))",
        "22.0" => "Snow (not falling as shower(s))",
        "23.0" => "Rain and snow or ice pellets (not falling as shower(s))",
        "24.0" => "Freezing drizzle or freezing rain (not falling as shower(s))",
        "25.0" => "Shower(s) of rain",
        "26.0" => "Shower(s) of snow, or of rain and snow",
        "27.0" => "Shower(s) of hail, or of rain and hail",
        "28.0" => "Fog or ice fog,",
        "29.0" => "Thunderstorm (with or without precipitation)",
        "30.0" => "Slight or moderate duststorm or sandstorm	(has decreased during the preceding hour)",
        "31.0" => "Slight or moderate duststorm or sandstorm	(no appreciable change during the preceding hour)",
        "32.0" => "Slight or moderate duststorm or sandstorm	(has begun or has increased during the preceding hour)",
        "33.0" =>  "Severe duststorm or sandstorm	(has decreased during the preceding hour)",
        "34.0" => "Severe duststorm or sandstorm	(no appreciable change during the preceding hour)",
        "35.0" => "Severe duststorm or sandstorm	(has begun or has increased during the preceding hour)",
        "36.0" => "Slight or moderate blowing snow(generally low (below eye level))",
        "37.0" => "Heavy drifting snow (generally low (below eye level))",
        "38.0" => "Slight or moderate blowing snow(generally high (above eye level))",
        "39.0" => "Heavy drifting snow(generally high (above eye level))",
        "40.0" => "Fog or ice fog at a distance at the time of observation, but not at the station during the preceding hour, the fog or ice fog extending to a level above that of the observer",
        "41.0" => "Fog or ice fog in patches",
        "42.0" => "Fog or ice fog, sky visible (has become thinner during the preceding hour)",
        "43.0" => "Fog or ice fog, sky invisible (has become thinner during the preceding hour)",
        "44.0" => "Fog or ice fog, sky visible (no appreciable change during the preceding hour)",
        "45.0" => "Fog or ice fog, sky invisible (no appreciable change during the preceding hour)",
        "46.0" => "Fog or ice fog, sky visible (has begun or has become thicker during the preceding hour)",
        "47.0" => "Fog or ice fog, sky invisible (has begun or has become thicker during the preceding hour)",
        "48.0" => "Fog, depositing rime, sky visible",
        "49.0" => "Fog, depositing rime, sky invisible",
        "50.0" => "Drizzle, not freezing, intermittent (slight at time of observation)",
        "51.0" => "Drizzle, not freezing, continuous (slight at time of observation)",
        "52.0" => "Drizzle, not freezing, intermittent (moderate at time of observation)",
        "53.0" => "Drizzle, not freezing, continuous (moderate at time of observation)",
        "54.0" => "Drizzle, not freezing, intermittent (heavy (dense) at time of observation)",
        "55.0" => "Drizzle, not freezing, continuous (heavy (dense) at time of observation)",
        "56.0" => "Drizzle, freezing, slight",
        "57.0" => "Drizzle, freezing, moderate or heavy (dence)",
        "58.0" => "Drizzle and rain, slight",
        "59.0" => "Drizzle and rain, moderate or heavy",
        "60.0" => "Rain, not freezing, intermittent (slight at time of observation)",
        "61.0" => "Rain, not freezing, continuous (slight at time of observation)",
        "62.0" => "Rain, not freezing, intermittent (moderate at time of observation)",
        "63.0" => "Rain, not freezing, continuous (moderate at time of observation)",
        "64.0" => "Rain, not freezing, intermittent (heavy at time of observation)",
        "65.0" => "Rain, not freezing, continuous (heavy at time of observation)",
        "66.0" => "Rain, freezing, slight",
        "67.0" => "Rain, freezing, moderate or heavy (dence)",
        "68.0" => "Rain or drizzle and snow, slight",
        "69.0" => "Rain or drizzle and snow, moderate or heavy",
        "70.0" => "Intermittent fall of snowflakes (slight at time of observation)",
        "71.0" => "Continuous fall of snowflakes (slight at time of observation)",
        "72.0" => "Intermittent fall of snowflakes (moderate at time of observation)",
        "73.0" => "Continuous fall of snowflakes (moderate at time of observation)",
        "74.0" => "Intermittent fall of snowflakes (heavy at time of observation)",
        "75.0" => "Continuous fall of snowflakes (heavy at time of observation)",
        "76.0" => "Diamond dust (with or without fog)",
        "77.0" => "Snow grains (with or without fog)",
        "78.0" => "Isolated star-like snow crystals (with or without fog)",
        "79.0" => "Ice pellets",
        "80.0" => "Rain shower(s), slight",
        "81.0" => "Rain shower(s), moderate or heavy",
        "82.0" => "Rain shower(s), violent",
        "83.0" => "Shower(s) of rain and snow mixed, slight",
        "84.0" => "Shower(s) of rain and snow mixed, moderate or heavy",
        "85.0" => "Snow shower(s), slight",
        "86.0" => "Snow shower(s), moderate or heavy",
        "87.0" => "Shower(s) of snow pellets or small hail, with or without rain or rain and snow mixed (slight)",
        "88.0" => "Shower(s) of snow pellets or small hail, with or without rain or rain and snow mixed (moderate or heavy)",
        "89.0" => "Shower(s) of hail, with or without rain or rain and snow mixed, not associated with thunder (slight)",
        "90.0" => "Shower(s) of hail, with or without rain or rain and snow mixed, not associated with thunder (moderate or heavy)",
        "91.0" => "Slight rain at time of observation	(Thunderstorm during the preceding hour but not at time of observation)",
        "92.0" => "Moderate or heavy rain at time of observation (Thunderstorm during the preceding hour but not at time of observation)",
        "93.0" => "Slight snow, or rain and snow mixed or hail at time of observation (Thunderstorm during the preceding hour but not at time of observation)",
        "94.0" => "Moderate or heavy snow, or rain and snow mixed or hail at time of observation (Thunderstorm during the preceding hour but not at time of observation)",
        "95.0" => "Thunderstorm, slight or moderate, without hail but with rain and/or snow at time of observation (Thunderstorm at time of observation)",
        "96.0" => "Thunderstorm, slight or moderate, with hail at time of observation (Thunderstorm at time of observation)",
        "97.0" => "Thunderstorm, heavy, without hail but with rain and/or snow at time of observation (Thunderstorm at time of observation)",
        "98.0" => "Thunderstorm combined with duststorm or sandstorm at time of observation (Thunderstorm at time of observation)",
        "99.0" => "Thunderstorm, heavy, with hail at time of observation (Thunderstorm at time of observation)"
    )

    return weather_codes[weather_code]
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
        date = prompt_date("Enter the date you want to enter in format of year-month-day(Example: 2024-04-24)", total_lines_manipulated)
        # check if date in weather file and if so return index to access other infomation
        if date in total_lines_manipulated[1]
            index_of_date = findfirst(x -> x == date, total_lines_manipulated[1])
        end

        # giant logic block, I feel as though there is a way to write more concisely -> aha, use function with parameters of the boolean, sub_string, and list to check
        if check_for_weather_code
            index_of_weather_code = return_index_of_property(total_lines, "weather_code")
            weather_code_translated = convert_weather_code_to_words(total_lines_manipulated[index_of_weather_code][index_of_date])
            println(weather_code_translated)
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