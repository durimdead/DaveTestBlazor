using DaveTestBlazor.Server.Repositories;
using DaveTestBlazor.Server.Services;
using DaveTestBlazor.Server.Services.Interfaces;
using DaveTestBlazor.Shared;
using Microsoft.AspNetCore.Mvc;

// For more information on enabling Web API for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace DaveTestBlazor.Server.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UserController : ControllerBase
    {

        private IUserService _userService;
        private readonly ILogger<UserController> _logger;

        public UserController(DaveTestContext context, ILogger<UserController> logger)
        {
            _userService = new UserService(context);
            _logger = logger;
        }

        // GET: api/<UserListingController>
        [HttpGet]
        public IEnumerable<User> Get()
        {
            return _userService.GetAllUsers();
        }

        // GET api/<UserListingController>/5
        [HttpGet("{userID}")]
        public User Get(int userID)
        {
            // in the case that we are getting a "new" user to add.
            User returnValue = new User(0, "", "", "", "", 0);

            // if this is an existing user
            if (userID > 0)
            {
                returnValue = _userService.GetUserByID(userID);
            }
            return returnValue;
        }

        // POST api/<UserListingController>
        [HttpPost]
        public void Post([FromBody]User userToSave)
        {
            _userService.UpsertUser(userToSave.FirstName, userToSave.LastName, userToSave.Address, userToSave.PhoneNumber, userToSave.Age, userToSave.UserID);
        }

        // PUT api/<UserListingController>/5
        [HttpPut("{id}")]
        public void Put(int id, [FromBody] string value)
        {
        }

        // DELETE api/<UserListingController>/5
        [HttpDelete("{userid}")]
        public void Delete(int userid)
        {
            _userService.DeleteUser(userid);
        }
    }
}
