using DaveTestBlazor.Server.Repositories;
using DaveTestBlazor.Server.Services.Interfaces;
using DaveTestBlazor.Shared;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Net;

namespace DaveTestBlazor.Server.Services
{
    /// <summary>
    /// Better error handling would have made this a better class
    /// </summary>
    public class UserService : IUserService
    {
        private readonly DaveTestContext _context;

        public UserService(DaveTestContext context)
        {
            _context = context;
        }

        public string DeleteUser(int userID)
        {
            string returnValue = string.Empty;
            try
            {
                this._context.usp_UserDelete(userID);
            }
            catch (Exception e)
            {
                returnValue = e.Message;
            }
            return returnValue;
        }

        public string UpsertUser(string firstName, string lastName, string address, string phoneNumber, int age, int userID = 0)
        {
            string returnValue = string.Empty;
            try
            {
                this._context.usp_UserUpsert(firstName, lastName, address, phoneNumber, age, userID);
            }
            catch (Exception e)
            {
                returnValue = e.Message;
            }
            return returnValue;
        }

        
        public IEnumerable<User> GetAllUsers()
        {
            List<User> returnValue = new List<User>();
            try
            {
                returnValue = _context.vUser.Select(x => new User(x.userID, x.firstName, x.lastName, x.address, x.phoneNumber, x.age)).ToList();
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
            }
            return returnValue;
        }


        public User GetUserByID(int userID) {
            User returnValue = new User();
            try
            {
                var user = _context.vUser.Where(x => x.userID == userID).Select(x => new User(x.userID, x.firstName, x.lastName, x.address, x.phoneNumber, x.age)).Single();
                if (user != null)
                {
                    returnValue = user;
                }
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
            }
            return returnValue;
        }
    }
}
