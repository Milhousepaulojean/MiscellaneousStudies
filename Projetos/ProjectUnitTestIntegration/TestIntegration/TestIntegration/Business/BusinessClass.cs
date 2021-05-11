using System;
using TestIntegration.Interfaces;

namespace TestIntegration.Business
{
    public class BusinessClass : IBusinessClass
    {
        public string example()
        {
            return "Using class Bussiness.";
        }
    }
}
