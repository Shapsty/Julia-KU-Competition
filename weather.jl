include("weather_codes.jl")

using Dates
using Statistics

function parse_weather_file(file_path::String)
    lines = readlines(file_path)
    data = Dict()
    for line in lines
        key, values = split(line, ": ")
        data[key] = split(values)
    end
    return data
end

function filter_data_by_date_range(data::Dict, start_date::Date, end_date::Date)
    dates = [Date(d) for d in data["date"]]
    start_index = findfirst(d -> d >= start_date, dates)
    end_index = findlast(d -> d <= end_date, dates)
    
    if isnothing(start_index) || isnothing(end_index)
        error("Date range not found in the data")
    end
    
    filtered_data = Dict()
    for (key, values) in data
        filtered_data[key] = values[start_index:end_index]
    end
    return filtered_data
end


function weather_data_analysis(file_path::String, start_date_str::String, end_date_str::String, selected_amount::String, selected_value::String)
    if isempty(file_path) || !isfile(file_path)
        return "Invalid file path"
    end

    start_date = Date(start_date_str)
    end_date = Date(end_date_str)

    data = parse_weather_file(file_path)
    filtered_data = filter_data_by_date_range(data, start_date, end_date)

    if !haskey(filtered_data, selected_value)
        return "Selected value not found in data"
    end

    values = if selected_value != "weather_code"
        parsed_values = Float64[]
        for v in filtered_data[selected_value]
            try
                # Remove any non-numeric characters except for decimal point, minus sign, and comma
                cleaned = replace(v, r"[^0-9.,-]" => "")
                # Replace comma with period for locales that use comma as decimal separator
                cleaned = replace(cleaned, "," => ".")
                push!(parsed_values, parse(Float64, cleaned))
            catch e
                println("Error parsing value: $v")
                println("Error: $e")
            end
        end
        parsed_values
    else
        [convert_weather_code_to_words(v) for v in filtered_data[selected_value]]
    end

    if isempty(values)
        return "No valid data found for the selected date range and value"
    end

    result = if selected_value != "weather_code"
        if selected_amount == "Minimum"
            minimum(values)
        elseif selected_amount == "Maximum"
            maximum(values)
        elseif selected_amount == "Average"
            mean(values)
        elseif selected_amount == "Single Point"
            # Return all values for the date range
            dates = start_date:Day(1):end_date
            daily_values = ["$date: $(values[i])" for (i, date) in enumerate(dates) if i <= length(values)]
            daily_values_without_dates = [(values[i]) for (i, date) in enumerate(dates) if i <= length(values)]
            join(daily_values, "\n")
        else
            nothing
        end
    else
        if selected_amount == "Single Point"
            # Return all values for the date range
            dates = start_date:Day(1):end_date
            daily_values = ["$date: $(values[i])" for (i, date) in enumerate(dates) if i <= length(values)]
            join(daily_values, "\n")
        else
            join(values, ", ")
        end
    end

    if isnothing(result)
        return "Unable to calculate $selected_amount for $selected_value"
    else
        if selected_amount == "Single Point"
            if selected_value == "weather_code"
                return "Daily $selected_value values:\n$result", 0
            end
            return "Daily $selected_value values:\n$result", daily_values_without_dates
        else
            return "$selected_amount $selected_value: $result", [result]
        end
    end
end

function weather_data_analysis_2(file_path::String, start_date_str::String, end_date_str::String, selected_amount::String, selected_value::String, second_date_start_str::String, second_date_end_str::String)
    if isempty(file_path) || !isfile(file_path)
        return "Invalid file path"
    end

    start_date = Date(start_date_str)
    end_date = Date(end_date_str)
    second_date_start = Date(second_date_start_str)
    second_date_end = Date(second_date_end_str)

    data = parse_weather_file(file_path)
    first_filtered_data = filter_data_by_date_range(data, start_date, second_date_start)
    second_filtered_data = filter_data_by_date_range(data, end_date, second_date_end)

    if !haskey(first_filtered_data, selected_value)
        return "First Selected value not found in data"
    end

    if !haskey(second_filtered_data, selected_value)
        return "Second Selected value not found in data"
    end

    values_1 = if selected_value != "weather_code"
        parsed_values = Float64[]
        for v in first_filtered_data[selected_value]
            try
                # Remove any non-numeric characters except for decimal point, minus sign, and comma
                cleaned = replace(v, r"[^0-9.,-]" => "")
                # Replace comma with period for locales that use comma as decimal separator
                cleaned = replace(cleaned, "," => ".")
                push!(parsed_values, parse(Float64, cleaned))
            catch e
                println("Error parsing value: $v")
                println("Error: $e")
            end
        end
        parsed_values
    else
        [convert_weather_code_to_words(v) for v in filtered_data[selected_value]]
    end

    values_2 = if selected_value != "weather_code"
        parsed_values = Float64[]
        for v in second_filtered_data[selected_value]
            try
                # Remove any non-numeric characters except for decimal point, minus sign, and comma
                cleaned = replace(v, r"[^0-9.,-]" => "")
                # Replace comma with period for locales that use comma as decimal separator
                cleaned = replace(cleaned, "," => ".")
                push!(parsed_values, parse(Float64, cleaned))
            catch e
                println("Error parsing value: $v")
                println("Error: $e")
            end
        end
        parsed_values
    else
        [convert_weather_code_to_words(v) for v in filtered_data[selected_value]]
    end

    if isempty(values_1) || isempty(values_2)
        return "No valid data found for the selected date range and value"
    end

    result_1 = if first_selected_value != "weather_code"
        if selected_amount == "Minimum"
            minimum(values_1)
        elseif selected_amount == "Maximum"
            maximum(values_1)
        elseif selected_amount == "Average"
            mean(values_1)
        elseif selected_amount == "Single Point"
            # Return all values for the date range
            dates = start_date:Day(1):end_date
            daily_values = ["$date: $(values_1[i])" for (i, date) in enumerate(dates) if i <= length(values_1)]
            daily_values_without_dates = [(values_1[i]) for (i, date) in enumerate(dates) if i <= length(values_1)]
            join(daily_values, "\n")
        else
            nothing
        end
    end

    result_2 = if first_selected_value != "weather_code"
        if selected_amount == "Minimum"
            minimum(values_2)
        elseif selected_amount == "Maximum"
            maximum(values_2)
        elseif selected_amount == "Average"
            mean(values_2)
        else
            nothing
        end
  
    end


    if isnothing(result_1) || isnothing(result_2)
        return "Unable to calculate $selected_amount for $selected_value"
    else
        if selected_amount == "Single Point"
            if selected_value == "weather_code"
                return "Daily $selected_value values:\n$result", 0
            end
            return "Daily $selected_value values:\n$result", daily_values_without_dates
        elseif result_1 == result_2
            return "Range 1 $selected_amount $selected_value is the same as Range 2 $selected_amount $selected_valu", [result_1]
        elseif result_1 > result_2
            return "Range 1 $selected_amount $selected_value is greater than Range 2 $selected_amount $selected_valu", [result_1]
        elseif result_1 < result_2
            return "Range 1 $selected_amount $selected_valu is less than Range 2 $selected_amount $selected_valu", [result_1]
        end
    end

end
