using System;
using System.Net.Http;
using Microsoft.AspNetCore.Mvc.Testing;
using Xunit;

namespace TestIntegrationMockServer
{
    public class UnitTest1
    {
        private readonly HttpClient httpClient;

        public UnitTest1()
        {

            var factory = new WebApplicationFactory<TestIntegrationMockServer.Program>();

            httpClient = server.CreateClient();
        }


        [Fact]
        public void Test1()
        {

        }
    }
}
