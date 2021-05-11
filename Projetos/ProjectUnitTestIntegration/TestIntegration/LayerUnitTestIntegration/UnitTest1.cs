using Xunit;
using Microsoft.AspNetCore.TestHost;
using Microsoft.AspNetCore.Hosting;
using System.Net.Http;
using TestIntegration;
using System.Threading.Tasks;
using System.Net;
using System.Net.Http.Headers;

using TestIntegration.Interfaces;
using Moq;
using Microsoft.Extensions.Logging;
using TestIntegration.Controllers;
using TestIntegration.Business;

namespace LayerUnitTestIntegration
{
    public class UnitTest1
    {

        private readonly HttpClient httpClient;

        public UnitTest1()
        {
            var server = new TestServer(
                new WebHostBuilder()
                .UseEnvironment("Development")
                .UseStartup<Startup>());

            httpClient = server.CreateClient();
            
        }

        #region Unit Test Integration - Get
            [Theory]
            [InlineData("Get")]
            public async Task testGetSimpleController(string method)
            {
                var request = new HttpRequestMessage(new HttpMethod(method), "/helloworld");

                HttpResponseMessage response = await httpClient.SendAsync(request);

                string result = await response.Content.ReadAsStringAsync();
                response.EnsureSuccessStatusCode();

                Assert.Equal(HttpStatusCode.OK , response.StatusCode);
                Assert.Equal("Hello World", result);
            }

            [Theory]
            [InlineData("Get")]
            public async Task testGetWithRouteSimpleController(string method)
            {
                var request = new HttpRequestMessage(new HttpMethod(method), "/helloworld/routetest");

                var response = await httpClient.SendAsync(request);
                string result = await response.Content.ReadAsStringAsync();

                response.EnsureSuccessStatusCode();

                Assert.Equal(HttpStatusCode.OK, response.StatusCode);
                Assert.Equal("Hello World with Route", result);
            }

            [Theory]
            [InlineData("Get")]
            public async Task testGetWithRouteSimpleAndValuesHeaderController(string method)
            {
                HttpRequestMessage request = new HttpRequestMessage(new HttpMethod(method), "/helloworld/routetestfromquery");

                request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", "test");

                var response = await httpClient.SendAsync(request);
                string result = await response.Content.ReadAsStringAsync();

                response.EnsureSuccessStatusCode();

                Assert.Equal(HttpStatusCode.OK, response.StatusCode);
                Assert.Equal("test", result.Replace("Bearer ", string.Empty));
            }

            [Theory]
            [InlineData("Get")]
            public async Task testGetWithRouteSimpleAndValuesHeaderAndMoqBussinessController(string method)
            {
                HttpRequestMessage request = new HttpRequestMessage(new HttpMethod(method), "/helloworld/routetestfromMoq");
                request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", "test");
                Mock<IBusinessClass> objectMoq = new Mock<IBusinessClass>();
                var logMoq = new Mock<ILogger<HelloWorldController>>();

                objectMoq.Setup(x => x.example()).Returns("return method");
                HelloWorldController helloWorldController = new HelloWorldController(logMoq.Object , objectMoq.Object);
                
                var response = await this.httpClient.SendAsync(request);
                string result = await response.Content.ReadAsStringAsync();

                response.EnsureSuccessStatusCode();

                Assert.Equal(HttpStatusCode.OK, response.StatusCode);
                Assert.Equal("test", result.Replace("Bearer ", string.Empty));
            }

        

        #endregion

        #region Unit Test Integration - Post
        //[   Theory]
        //    [InlineData("Post")]
        //    public async Task testPostSimple(string method)
        //    {
        //        HttpRequestMessage request = new HttpRequestMessage(new HttpMethod(method), "/helloworld");
        //        string json = "{\"Name\":\"John Doe\",\"Age\":33}";

        //        request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", "test");
        //        request.Content = new StringContent(json, Encoding.UTF8, "application/json"); ;

        //        var response = await httpClient.SendAsync(request);
        //        string result = await response.Content.ReadAsStringAsync();

        //        response.EnsureSuccessStatusCode();

        //        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
        //        Assert.Equal(json, result);
        //    }

        //    //[Theory]
        //    //[InlineData("Post")]
        //    //public async Task testPostWithRouteSimple(string method)
        //    //{

        //    //}
        #endregion
    }
}
