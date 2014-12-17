port0 <- hardware.uart57;
port0.configure(9600, 8, PARITY_NONE, 1, NO_CTSRTS);

class Screen {
    port = null;
    constructor(_port) {
        port = _port;
    }
    function set_size(_columns, _rows) {
        port.write(0xFE);
        port.write(0xD1);
        port.write(_columns);
        port.write(_rows);
        server.log("Set LCD: " + _columns + "x" + _rows);
    }
    function set_contrast(_value) {
        port.write(0xFE);
        port.write(0x50);
        port.write(_value);
        server.log("Contrast: " + _value);
    }
    function set_brightness(_value) {
        port.write(0xFE);
        port.write(0x99);
        port.write(_value);
        server.log("Brightness: " + _value);
    }
    function set_color(_red, _green, _blue) {
        port.write(0xFE);
        port.write(0xD0);
        port.write(_red);
        port.write(_green);
        port.write(_blue);
    }
    function cursor_off() {
        port.write(0xFE);
        port.write(0x4B);
        port.write(0xFE);
        port.write(0x54);
    }
    function clear_screen() {
        port.write(0xFE);
        port.write(0x58);
        server.log("Clear Screen");
    }
    function autoscroll_on() {
        port.write(0xFE);
        port.write(0x51);
    }
    function autoscroll_off() {
        port.write(0xFE);
        port.write(0x52);
    }
    function startup_message() {
        port.write(0xFE);
        port.write(0x40);
        port.write("**Your Startup*******Message****");
    }
    function cursor_at_line0() {
        port.write(0xFE);
        port.write(0x48);
    }
    function cursor_at_line1() {
        port.write(0xFE);
        port.write(0x47); 
        port.write(1);
        port.write(2);
    }
    function write_string(string) {
        foreach(i, char in string) {
            port.write(char);
        }
    }
}
imp.configure("Adafruit Serial LCD Class", [],[]);
    screen <- Screen(port0);
    screen.set_size(16, 2);
    screen.set_contrast(200);
    screen.set_brightness(255);
    screen.set_color(20, 20, 200); //Blue
    screen.cursor_off();

    
    local dataNull;

//Round function
function round(val, decimalPoints) {
    local f = math.pow(10, decimalPoints) * 1.0;
    local newVal = val * f;
    newVal = math.floor(newVal + 0.5)
    newVal = (newVal * 1.0) / f;
 
   return newVal;
}
////


function return_from_imp(data)
{
    screen.clear_screen();
    screen.cursor_at_line0();
    screen.write_string("Boston forecast");
    imp.sleep(2.0);
    
    //Write Temp and Humidity
    screen.clear_screen();
    screen.cursor_at_line0();
    local temp = data.main.temp - 273.15;
    temp = round(temp, 2);
    server.log(temp);
    local humidity = round(data.main.humidity, 2);
    screen.write_string("Temp   " + temp.tostring() +" C");
    screen.cursor_at_line1();
    screen.write_string("Humidity: " + humidity.tostring() +"%");
    imp.sleep(2.0);
    
    //Write TempMax and Min
    screen.clear_screen();
    screen.cursor_at_line0();
    local tempMax = data.main.temp_max - 273.15;
    local tempMin = data.main.temp_min - 273.15;
    tempMax = round(tempMax, 1);
    tempMin = round(tempMin, 1);
    screen.write_string("Temp. Max " + tempMax.tostring() +" C");
    screen.cursor_at_line1();
    screen.write_string("Temp. Min " + tempMin.tostring() +" C");
    imp.sleep(2.0);
    
    //Sunrise and sunset
    screen.clear_screen();
    screen.cursor_at_line0();
    local tempMax = data.main.temp_max - 273.15;
    local tempMin = data.main.temp_min - 273.15;
    tempMax = round(tempMax, 1);
    tempMin = round(tempMin, 1);
    screen.write_string("Temp. Max " + tempMax.tostring() +" C");
    screen.cursor_at_line1();
    screen.write_string("Temp. Min " + tempMin.tostring() +" C");
    imp.sleep(2.0);
    
    //Write TempMax and Min
    screen.clear_screen();
    screen.cursor_at_line0();
    screen.write_string("Description:");
    screen.cursor_at_line1();
    screen.write_string(data.weather[0].description);
    imp.sleep(2.0);
    
    screen.clear_screen();
    screen.cursor_at_line0();
    screen.write_string("Data from: openweathermap.org");
    imp.sleep(1.0);
    
    agent.send("getCurrentWeather", dataNull);
  
    
}

agent.send("getCurrentWeather", dataNull);

agent.on("CurrentWeather", return_from_imp);

    
    