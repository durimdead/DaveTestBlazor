using DaveTestBlazor.Server.Repositories;
using DaveTestBlazor.Server.Services;
using DaveTestBlazor.Server.Services.Interfaces;
using DaveTestBlazor.Shared;
using Microsoft.AspNetCore.Mvc;

/// <summary>
/// Overall, the controller methods have approximately what it is they should have (except error handling!).
/// That is the biggest thing I would change.
/// </summary>
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

        [HttpGet]
        public IEnumerable<User> Get()
        {
            return _userService.GetAllUsers();
        }

        [HttpGet("{userID}")]
        public User Get(int userID)
        {
            User returnValue = new User(0, "", "", "", "", 0);

            if (userID > 0)
            {
                returnValue = _userService.GetUserByID(userID);
            }
            return returnValue;
        }

        
        [HttpPost]
        public void Post([FromBody]User userToSave)
        {
            // I would ideally be validating the userToSave object here. Best way to do this would most likely be to add annotations for validation types/regex on the model's class
            _userService.UpsertUser(userToSave.FirstName, userToSave.LastName, userToSave.Address, userToSave.PhoneNumber, userToSave.Age, userToSave.UserID);
        }

        /// <summary>
        /// This should not have been here as I haven't used it. I thought I deleted this
        /// </summary>
        [HttpPut("{id}")]
        public void Put(int id, [FromBody] string value)
        {
        }

        [HttpDelete("{userid}")]
        public void Delete(int userid)
        {
            _userService.DeleteUser(userid);
        }
    }
}
