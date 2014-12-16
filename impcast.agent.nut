function currentWeather(dataNull){
    
local url = "http://api.openweathermap.org/data/2.5/weather?id=4930956";
local headers = { "Content-Type": "application/json" };
local request = http.get(url, headers);
local response = request.sendsync();

server.log(response.statuscode + " - " + response.body);

local data = http.jsondecode(response.body);

device.send("CurrentWeather", data);
server.log("Sending data to the Imp");
server.log("Agent Data: ");
server.log("Humidity: " + data.weather[0].main);
    
}

device.on("getCurrentWeather", currentWeather);

//currentWeather();

