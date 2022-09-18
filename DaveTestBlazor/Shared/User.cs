using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DaveTestBlazor.Shared
{
    public class User
    {
        public User(int userID, string firstName, string lastName, string address, string phoneNumber, int age)
        {
            this.userID = userID;
            this.firstName = firstName;
            this.lastName = lastName;
            this.address = address;
            this.phoneNumber = phoneNumber;
            this.age = age;
        }

        public int userID { get; set; }
        public string firstName { get; set; }
        public string lastName { get; set; }
        public string address { get; set; }
        public string phoneNumber { get; set; }
        public int age { get; set; }
    }
}
