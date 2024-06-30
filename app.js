function toCelsius()
{
    let fahrenheit = prompt("Fahrenheit : ")
    let value = (fahrenheit - 32)*5/9
    document.getElementById("toCelsius").innerHTML = value.toFixed(2) +" "+"Celsius";
}   

function toFahrenheit()
{
    let Celsius = prompt("Celsius : ")
    let value = (Celsius * 9) / 5 +32
    document.getElementById("toFahrenheit").innerHTML = value.toFixed(2) +" "+"Fahrenheit";
}   

//toFixed() เลขข้างในคือทศนิยม 
toCelsius()
toFahrenheit()