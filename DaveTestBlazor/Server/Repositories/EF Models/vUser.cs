using System.ComponentModel.DataAnnotations;

namespace DaveTestBlazor.Server.Repositories.EF_Models
{
    /// <summary>
    /// Overall, nothing to change here. This is just used to grab information from the database.
    /// </summary>
    public class vUser
    {
        [Key]
        public int userID { get; set; }
        public string firstName { get; set; }
        public string lastName { get; set; }
        public string address { get; set; }
        public string phoneNumber { get; set; }
        public int age { get; set; }
    }
}
