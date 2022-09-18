using DaveTestBlazor.Server.Repositories;
using DaveTestBlazor.Server.Services.Interfaces;
using DaveTestBlazor.Shared;
using Microsoft.AspNetCore.Mvc.RazorPages;
using System.Net;

namespace DaveTestBlazor.Server.Services
{
    public class UserService : IUserService
    {
        private readonly DaveTestContext _context;

        /// <summary>
        /// initilaizes appropriate db context for connections
        /// </summary>
        /// <param name="context">database context</param>
        public UserService(DaveTestContext context)
        {
            _context = context;
        }


        /// <summary>
        /// delete the user specified based on the ID sent through.
        /// </summary>
        /// <param name="userID"></param>
        /// <returns>true if successful delete</returns>
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

        /// <summary>
        /// Update the user based on the information sent in
        /// </summary>
        /// <param name="firstName">user's first name</param>
        /// <param name="lastName">user's last name</param>
        /// <param name="address">address of the user</param>
        /// <param name="phoneNumber">phone number for the user</param>
        /// <param name="age">user's age</param>
        /// <param name="userID">ID of the user record - if none is passed in, we use "0" to indicate new user</param>
        /// <returns>true if edit is successful</returns>
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

        /// <summary>
        /// gets all users and their information
        /// </summary>
        /// <returns>A list of all users.</returns>
        public IEnumerable<User> GetAllUsers()
        {
            List<User> returnValue = new List<User>();
            try
            {
                returnValue = _context.vUser.Select(x => new User(x.userID, x.firstName, x.lastName, x.address, x.phoneNumber, x.age)).ToList();
            }
            catch (Exception e)
            {
                //TODO: add logging to db table
                Console.WriteLine(e.Message);
            }
            return returnValue;
        }


        /// <summary>
        /// Gets a user based on their ID
        /// </summary>
        /// <param name="userID">the ID of the user</param>
        /// <returns>the user for the given ID - default user object if the user is not found</returns>
        public User GetUserByID(int userID) {
            User returnValue = new User();
            try
            {
                // getting "single" instead of "first" because we should only ever get 1 for the given argument. If we get more than 1, we have big problems!
                var user = _context.vUser.Where(x => x.userID == userID).Select(x => new User(x.userID, x.firstName, x.lastName, x.address, x.phoneNumber, x.age)).Single();
                if (user != null)
                {
                    returnValue = user;
                }
            }
            catch (Exception e)
            {
                //TODO: add logging to db table
                Console.WriteLine(e.Message);
            }
            return returnValue;
        }
    }
}
