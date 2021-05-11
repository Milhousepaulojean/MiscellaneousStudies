using System.Threading.Tasks;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.TestHost;
using Microsoft.Extensions.DependencyInjection.Extensions;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;
using TestIntegration;
using TestIntegration.Interfaces;

namespace LayerUnitTestIntegrationExample2
{
    [TestClass]
    public class UnitTest1
    {
        [TestMethod]
        public async Task TestMethod1AsyncWithControllers()
        {
            var webHostBuilder =
              new WebHostBuilder()
                    .UseEnvironment("Test") // You can set the environment you want (development, staging, production)
                    .UseStartup<Startup>(); // Startup class of your web app project

            using (var server = new TestServer(webHostBuilder))
            using (var client = server.CreateClient())
            {
                string result = await client.GetStringAsync("/helloworld");
                Assert.AreEqual("Hello World", result);
            }
        }

        [TestMethod]
        public async Task TestMethod2AsyncWithRoute()
        {
            var webHostBuilder =
              new WebHostBuilder()
                    .UseEnvironment("Test") // You can set the environment you want (development, staging, production)
                    .UseStartup<Startup>(); // Startup class of your web app project

            using (var server = new TestServer(webHostBuilder))
            using (var client = server.CreateClient())
            {
                string result = await client.GetStringAsync("/helloworld/routetest");
                Assert.AreEqual("Hello World with Route", result);
            }
        }

        [TestMethod]
        public async Task TestMethod3AsyncWithMoq()
        {
            var mymock = Mock.Of<IBusinessClass>();
            Mock.Get(mymock)
                .Setup(m => m.example())
                .Returns("Teste com Mock");

            var webHostBuilder =
              new WebHostBuilder()
                    .UseEnvironment("Test") // You can set the environment you want (development, staging, production)

                    .ConfigureTestServices(
                  services =>
                  {
                      services.RemoveAll<IBusinessClass>();//Remove previous registration(s) of this service
                      services.TryAddTransient<IBusinessClass>(sp => mymock);
                  }) // Startup class of your web app project
                  .UseStartup<Startup>();

            using (var server = new TestServer(webHostBuilder))
            using (var client = server.CreateClient())
            {
                string result = await client.GetStringAsync("/helloworld/routetestfromMoq");
                Assert.AreEqual("Teste com Mock", result);
            }
        }
    }
}
