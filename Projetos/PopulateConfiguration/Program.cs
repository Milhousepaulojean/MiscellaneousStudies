using System;
using System.Collections.Generic;
using Microsoft.Extensions.Configuration;

namespace PopulateConfiguration
{
    class Program
    {
        static void Main(string[] args)
        {
            var myConfiguration = new Dictionary<string, string>
            {
                {"Key1", "Value1"},
                {"Nested:Key1", "NestedValue1"},
                {"Nested:Key2", "NestedValue2"}
            };

            var configuration = new ConfigurationBuilder()
            .AddInMemoryCollection(myConfiguration)
            .Build();

            Console.WriteLine(configuration.GetSection("Key1").Value);
            Console.WriteLine(configuration.GetSection("Nested").GetSection("Key1").Value);
            Console.WriteLine(configuration.GetSection("Nested").GetSection("key2").Value);
        }
    }
}
