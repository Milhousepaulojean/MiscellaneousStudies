
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using TestIntegration.Interfaces;

namespace TestIntegration.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class HelloWorldController : ControllerBase
    {

        private readonly ILogger<HelloWorldController> _logger;
        private readonly IBusinessClass _businessClass;

        public HelloWorldController(ILogger<HelloWorldController> logger,
            IBusinessClass businessClass)
        {
            _logger = logger;
            _businessClass = businessClass;
        }

        [HttpGet]
        public IActionResult Get()
        {
            return Ok("Hello World");
            //return Ok(_businessClass.example());
        }

        [HttpGet]
        [Route("routetest")]
        public IActionResult OtherGet()
        {
            return Ok("Hello World with Route");
        }

        [HttpGet]
        [Route("routetestfrombody")]
        public IActionResult NewGet()
        {
            string value = Request.Headers["Authorization"];

            return Ok(value);
        }

        [HttpGet]
        [Route("routetestfromMoq")]
        public IActionResult MoqGet()
        {
            //string value = Request.Headers["Authorization"];

            return Ok(_businessClass.example());
        }

        
    }
}
