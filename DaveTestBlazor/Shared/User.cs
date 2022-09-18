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
            this.UserID = userID;
            this.FirstName = firstName;
            this.LastName = lastName;
            this.Address = address;
            this.PhoneNumber = phoneNumber;
            this.Age = age;
        }

        public User()
        {
            this.UserID = 0;
            this.FirstName = String.Empty;
            this.LastName = String.Empty;
            this.Address = String.Empty;
            this.PhoneNumber = String.Empty;
            this.Age = 0;
        }

        public int UserID { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Address { get; set; }
        public string PhoneNumber { get; set; }
        public int Age { get; set; }
    }
}
