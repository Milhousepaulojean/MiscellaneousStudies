using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;

namespace appTeste.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class WeatherForecastController : ControllerBase
    {
        private static readonly string[] Summaries = new[]
        {
            "Freezing", "Bracing", "Chilly", "Cool", "Mild", "Warm", "Balmy", "Hot", "Sweltering", "Scorching"
        };

        private readonly ILogger<WeatherForecastController> _logger;

        public WeatherForecastController(ILogger<WeatherForecastController> logger)
        {
            _logger = logger;
        }

        [HttpGet]
        public IEnumerable<WeatherForecast> Get()
        {
            var rng = new Random();
            IEnumerable<WeatherForecast> weatherForecasts = Enumerable.Range(1, 5).Select(index => new WeatherForecast
            {
                Date = DateTime.Now.AddDays(index),
                TemperatureC = rng.Next(-20, 55),
                Summary = Summaries[rng.Next(Summaries.Length)]
            })
           .ToArray();
            LogInternal(weatherForecasts, 
                        this.ControllerContext.RouteData.Values["action"].ToString(), 
                        this.ControllerContext.RouteData.Values["controller"].ToString());

            return weatherForecasts;
        }

        private void LogInternal(IEnumerable<WeatherForecast> weatherForecasts, string action, string controller)
        {
          _logger.Log(LogLevel.Information, string.Format("action = {1} , controller = {2} , Retorno da do array: {0}", JsonConvert.SerializeObject(string.Format("Date={0}, TemperatureC={1}, Summary={2}" , weatherForecasts.ToList()[0].Date , weatherForecasts.ToList()[0].TemperatureC, weatherForecasts.ToList()[0].Summary)) , action , controller));
        }

    }
}

