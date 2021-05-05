using ConsoleTest;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace ConsoleUnitTest
{
    [TestClass]
    public class UnitTest1
    {
        [TestMethod]
        public void TestMethod1()
        {
            ProgramTest programTest = new ProgramTest();

            Assert.IsNotNull(programTest.classTest());
        }
    }
}
