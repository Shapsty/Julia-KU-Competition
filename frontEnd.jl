using Mousetrap

 main() do app::Application
    window = Window(app)

    # Text Entry for future Rest API integration
    rest_API_Terminal = Entry()
    set_text!(rest_API_Terminal, "Write here")
    connect_signal_activate!(rest_API_Terminal) do self::Entry
        println("Text is now: $(get_text(rest_API_Terminal))")
    end

    # Simple output Box, currently for testing, also works to show the user their inputs are valid
    output_main = Label()
    set_text!(output_main, "output_text")

    # Button for future histogram creation
    hist_button = Button()
    set_child!(hist_button, Label("Hist"))
    connect_signal_clicked!(hist_button) do self::Button
        # Create histogram here
        set_text!(output_main, "Hist")
        println("Hist")
    end
    # Button to trigger REST API functionality, may be uneeded
    rest_API_Button = Button()
    set_child!(rest_API_Button, Label("Rest"))
    connect_signal_clicked!(rest_API_Button) do self::Button
        set_text!(output_main, "Rest")
        println("Rest")
    end
    # button to be used for mystery feature
    unknown_Purpose_Button = Button()
    set_child!(unknown_Purpose_Button, Label("?"))
    connect_signal_clicked!(unknown_Purpose_Button) do self::Button
        set_text!(output_main, "N/A")
        println("N/A")
    end
    # Opens file explorer for user to pick one file
    file_Explorer = Button()
    set_child!(file_Explorer, Label("File Explorer"))
    connect_signal_clicked!(file_Explorer) do self::Button
        set_text!(output_main, "File Explorer")
        println("File Explorer")

        chooser = FileChooser(FILE_CHOOSER_ACTION_OPEN_FILE)

        on_accept!(chooser) do self::FileChooser, files::Vector{FileDescriptor}
            println("$files")
            file_location = "$files"
            file_location = replace(file_location, "FileDescriptor[FileDescriptor(path = " => "")
            file_location = replace(file_location, ")]" => "")
            file_location = replace(file_location, "\"" => "")
            println(file_location)
        end
        present!(chooser)
    end

    # TODO find better way to enter date/date range, cause I don't love that I am just hardcoding in every possible output for days

    # Start Date Text Entry
    start_Date_Entry = Entry()
    set_text!(start_Date_Entry, "Start Date (Format year-mm-dd)")
    connect_signal_activate!(start_Date_Entry) do self::Entry
        println("Start date is: $(get_text(start_Date_Entry))")
    end

    # End Date Text Entry
    end_Date_Entry = Entry()
    set_text!(end_Date_Entry, "End Date") 
    connect_signal_activate!(end_Date_Entry) do self::Entry
        println("End date is: $(get_text(end_Date_Entry))")
    end
    
    amount_Drop_Down = DropDown()
    value_Drop_Down = DropDown()
   
    # Amount Drop Down
    push_back!(amount_Drop_Down, "Amount") do self::DropDown
        println("Amount")
        set_text!(output_main, "Amount")
    end
    push_back!(amount_Drop_Down, "Minimun") do self::DropDown
        println("Min")
        set_text!(output_main, "Min")
    end
    push_back!(amount_Drop_Down, "Maximum") do self::DropDown
        println("Max")
        set_text!(output_main, "Max")
    end
    push_back!(amount_Drop_Down, "Average") do self::DropDown
        println("Avg")
        set_text!(output_main, "Avg")
    end
    push_back!(amount_Drop_Down, "Single Point") do self::DropDown
        println("single_point")
        set_text!(output_main, "single_point")
    end
   
    # Value drop down
    push_back!(value_Drop_Down, "Value") do self::DropDown
        println("value")
        set_text!(output_main, "value")
    end
    push_back!(value_Drop_Down, "Day Max Temperature") do self::DropDown
        println("max_temp")
        set_text!(output_main, "max_temp")
        global check_for_weather_code = false
        global check_for_temperature_max = true
        global check_for_temperature_min = false
        global check_for_precipitation_sum = false
        global check_for_wind_speed_max = false
        global check_for_precipitation_probability_max = false
        return nothing
    end
    push_back!(value_Drop_Down, "Day Min Temperature") do self::DropDown
        println("min_temp")
        set_text!(output_main, "min_temp")
        global check_for_weather_code = false
        global check_for_temperature_max = false
        global check_for_temperature_min = true
        global check_for_precipitation_sum = false
        global check_for_wind_speed_max = false
        global check_for_precipitation_probability_max = false
        return nothing
    end
    push_back!(value_Drop_Down, "Wind") do self::DropDown
        println("wind")
        set_text!(output_main, "wind")
        global check_for_weather_code = false
        global check_for_temperature_max = false
        global check_for_temperature_min = false
        global check_for_precipitation_sum = false
        global check_for_wind_speed_max = true
        global check_for_precipitation_probability_max = false
        return nothing
    end
    push_back!(value_Drop_Down, "Code") do self::DropDown
        println("code")
        set_text!(output_main, "code")
        global check_for_weather_code = true
        global check_for_temperature_max = false
        global check_for_temperature_min = false
        global check_for_precipitation_sum = false
        global check_for_wind_speed_max = false
        global check_for_precipitation_probability_max = false
        return nothing
    end
    push_back!(value_Drop_Down, "Rain") do self::DropDown
        println("rain")
        set_text!(output_main, "rain")
        global check_for_weather_code = false
        global check_for_temperature_max = false
        global check_for_temperature_min = false
        global check_for_precipitation_sum = true
        global check_for_wind_speed_max = false
        global check_for_precipitation_probability_max = false
        return nothing
    end
    push_back!(value_Drop_Down, "Rain Chance") do self::DropDown
        println("rain_prob")
        set_text!(output_main, "rain_prob")
        global check_for_weather_code = false
        global check_for_temperature_max = false
        global check_for_temperature_min = false
        global check_for_precipitation_sum = false
        global check_for_wind_speed_max = false
        global check_for_precipitation_probability_max = true
        return nothing
    end

    set_child!(window, vbox(rest_API_Terminal, start_Date_Entry, end_Date_Entry, amount_Drop_Down, value_Drop_Down, hist_button, rest_API_Button, unknown_Purpose_Button, file_Explorer, output_main))
    present!(window)
end

