include("weather.jl")
include("weather_codes.jl")

using Mousetrap

# Initialize global variables
global file_path = nothing  
global start_date = nothing
global end_date = nothing
global selected_amount = nothing
global selected_value = nothing


 main() do app::Application
    window = Window(app)

    # Simple output Box, currently for testing, also works to show the user their inputs are valid
    output_main = Label()
    set_text!(output_main, "output_text")
    

    header_bar = get_header_bar(window)
    set_title!(window, "Mousetrap.jl")

    #light/darl mode swap
    swap_button = Button(Label("Swap Light/Dark"))
    set_tooltip_text!(swap_button, "Click to Swap Themes")
    connect_signal_clicked!(swap_button, app) do self::Button, app::Application

        # get currently used theme
        current = get_current_theme(app)

        # swap light with dark, preservng whether the theme is high contrast
        if current == THEME_DEFAULT_DARK
            next = THEME_DEFAULT_LIGHT
        elseif current == THEME_DEFAULT_LIGHT
            next = THEME_DEFAULT_DARK
        elseif current == THEME_HIGH_CONTRAST_DARK
            next = THEME_HIGH_CONTRAST_LIGHT
        elseif current == THEME_HIGH_CONTRAST_LIGHT
            next = THEME_HIGH_CONTRAST_DARK
        end

        # set new theme
        play!(swap_fadeout)
        set_current_theme!(app, next)
    end
    push_front!(header_bar, swap_button)
    #animation for clicking button  
    swap_fadeout = Animation(swap_button, seconds(1))
    on_tick!(swap_fadeout, swap_button) do self::Animation, value::Float64, target::Button
        set_opacity!(target, 1 - value)
    end
    
    # Button for future histogram creation
    hist_button = Button()
    set_child!(hist_button, Label("Hist"))
    connect_signal_clicked!(hist_button) do self::Button
        # Create histogram here
        gui()
        set_text!(output_main, "Hist")
        println("Hist")
    end
    #Submit Button
    submit = Button()
    set_child!(submit, Label("Submit"))
    connect_signal_clicked!(submit) do self::Button
        if isnothing(file_path)
            set_text!(output_main, "Please select a file first")
            println("No file selected")
        elseif isnothing(start_date) 
            set_text!(output_main, "Please enter both start and end dates")
            println("Dates not set")
        elseif isnothing(selected_amount) || isnothing(selected_value)
            set_text!(output_main, "Please select amount and value")
            println("Amount or value not selected")
        else

            if isnothing(end_date) || isempty(get_text(end_Date_Entry))
                global end_date = start_date
                set_text!(end_Date_Entry, start_date)
            end

            try
                result = weather_data_analysis(file_path, start_date, end_date, selected_amount, selected_value)
                set_text!(output_main, result[1])
                println("Result: $result")  # Print to console as well
            catch e
                error_msg = "Error processing file: $(sprint(showerror, e))"
                set_text!(output_main, error_msg)
                println(error_msg)
            end
        end
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
        chooser = FileChooser(FILE_CHOOSER_ACTION_OPEN_FILE)

        on_accept!(chooser) do self::FileChooser, files::Vector{FileDescriptor}
            if !isempty(files)
                file_desc_str = string(files[1])
                # Extract the path from the FileDescriptor string representation
                path_match = match(r"path\s*=\s*(.+?)\)", file_desc_str)
                if !isnothing(path_match)
                    file_location = strip(path_match.captures[1])
                    file_location = replace(file_location, "\"" => "")  # Remove quotes if present
                    println("Selected file: $file_location")
                    global file_path = file_location
                    set_text!(output_main, "File selected: $(basename(file_location))")
                else
                    set_text!(output_main, "Error: Couldn't extract file path")
                end
            else
                set_text!(output_main, "No file selected")
            end
        end
        present!(chooser)
    end

    # TODO find better way to enter date/date range, cause I don't love that I am just hardcoding in every possible output for days

    # Start Date Text Entry
    start_Date_Entry = Entry()
    set_text!(start_Date_Entry, "Start Date (Format year-mm-dd)")
    connect_signal_activate!(start_Date_Entry) do self::Entry
        global start_date = get_text(start_Date_Entry)
        println("Start date set to: $start_date")
    end

    # End Date Text Entry
    end_Date_Entry = Entry()
    set_text!(end_Date_Entry, "End Date (Format year-mm-dd)")
    connect_signal_activate!(end_Date_Entry) do self::Entry
        global end_date = get_text(end_Date_Entry)
        println("End date set to: $end_date")
    end
    
    amount_Drop_Down = DropDown()
    value_Drop_Down = DropDown()
   
    amount_Drop_Down = DropDown()
    push_back!(amount_Drop_Down, "Amount") do self::DropDown
        global selected_amount = "Amount"
        println("Selected amount: Amount")
    end
    push_back!(amount_Drop_Down, "Minimum") do self::DropDown
        global selected_amount = "Minimum"
        println("Selected amount: Minimum")
    end
    push_back!(amount_Drop_Down, "Maximum") do self::DropDown
        global selected_amount = "Maximum"
        println("Selected amount: Maximum")
    end
    push_back!(amount_Drop_Down, "Average") do self::DropDown
        global selected_amount = "Average"
        println("Selected amount: Average")
    end
    push_back!(amount_Drop_Down, "Single Point") do self::DropDown
        global selected_amount = "Single Point"
        println("Selected amount: Single Point")
    end

    value_Drop_Down = DropDown()
    push_back!(value_Drop_Down, "Value") do self::DropDown
        global selected_value = "Value"
        println("Selected value: Value")
    end
    push_back!(value_Drop_Down, "Day Max Temperature") do self::DropDown
        global selected_value = "temperature_max"
        println("Selected value: Day Max Temperature")
    end
    push_back!(value_Drop_Down, "Day Min Temperature") do self::DropDown
        global selected_value = "temperature_min"
        println("Selected value: Day Min Temperature")
    end
    push_back!(value_Drop_Down, "Wind") do self::DropDown
        global selected_value = "wind_speed_max"
        println("Selected value: Wind")
    end
    push_back!(value_Drop_Down, "Code") do self::DropDown
        global selected_value = "weather_code"
        println("Selected value: Code")
    end
    push_back!(value_Drop_Down, "Rain") do self::DropDown
        global selected_value = "precipitation_sum"
        println("Selected value: Rain")
    end
    push_back!(value_Drop_Down, "Rain Chance") do self::DropDown
        global selected_value = "precipitation_probability_max"
        println("Selected value: Rain Chance")
    end

    # Layout
    set_child!(window, vbox(
        start_Date_Entry, 
        end_Date_Entry, 
        amount_Drop_Down, 
        value_Drop_Down, 
        hist_button, 
        file_Explorer,
        submit, 
        unknown_Purpose_Button, 
        output_main
    ))
    present!(window)
end
