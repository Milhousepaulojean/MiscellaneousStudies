using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;

namespace HeaderAuthorization.Controllers
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

        [HttpPost]
        public IActionResult Post([FromHeader] string parentRequestId)
        {
            try
            {
                Console.WriteLine($"Got Header with parentRequestId: {parentRequestId} !");
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                //return StatusCode(StatusCodes.Status500InternalServerError);
            }
            return new AcceptedResult();
        }
    }
}
