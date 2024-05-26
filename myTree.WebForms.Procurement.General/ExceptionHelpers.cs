using Serilog;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace myTree.WebForms.Procurement.General
{
    public static class ExceptionHelpers
    {
        private static string Generate(this Exception ex)
        {

            var st = new StackTrace(ex, true);
            var frames = st.GetFrames();
            var msg = ex.Message;
            var fileName = string.Empty;
            var fileLineNumber = string.Empty;
            var result = string.Empty;

            foreach (var frame in frames)
            {
                if (frame.GetFileLineNumber() < 1)
                    continue;

                fileName += frame.GetFileName();
                fileLineNumber += frame.GetFileLineNumber();

            }

            result = string.Format(@"Message: {0};Path: {1};line: {2}", msg, fileName, fileLineNumber);

            return result;
        }
        public static string Message(this Exception ex)
        {
            return Generate(ex);
        }

        public static void PrintError(this Exception ex)
        {
            Log.Error(Generate(ex));
        }

        public static void PrintInformation(this Exception ex)
        {
            Log.Information(Generate(ex));
        }
    }
}
