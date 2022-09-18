using DaveTestBlazor.Shared;

namespace DaveTestBlazor.Server.Services.Interfaces
{
    public interface IUserService
    {
        /// <summary>
        /// delete the user specified based on the ID sent through.
        /// </summary>
        /// <param name="userID"></param>
        /// <returns>true if successful delete</returns>
        public string DeleteUser(int userID);

        /// <summary>
        /// Update the user based on the information sent in
        /// </summary>
        /// <param name="FirstName">user's first name</param>
        /// <param name="LastName">user's last name</param>
        /// <param name="address">address of the user</param>
        /// <param name="phoneNumber">phone number for the user</param>
        /// <param name="age">user's age</param>
        /// <param name="userID">ID of the user record</param>
        /// <returns>true if edit is successful</returns>
        public string UpsertUser(string FirstName, string LastName, string address, string phoneNumber, int age, int userID);

        /// <summary>
        /// gets all users and their information
        /// </summary>
        /// <returns>A list of all currently active users.</returns>
        public List<User> GetAllUsers();
    }
}
