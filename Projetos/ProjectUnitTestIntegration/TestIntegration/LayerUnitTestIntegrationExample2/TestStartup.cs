using System;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using TestIntegration;
using TestIntegration.Business;
using TestIntegration.Interfaces;

namespace LayerUnitTestIntegrationExample2
{
    public class TestStartup : Startup
    {
        public TestStartup(IConfiguration configuration) : base(configuration)
        {
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServicess(IServiceCollection services)
        {
            services.AddControllers();
            services.AddScoped<IBusinessClass, BusinessClass>();

        }

        
    }
}
