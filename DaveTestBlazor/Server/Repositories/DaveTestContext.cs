using DaveTestBlazor.Server.Repositories.EF_Models;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;

namespace DaveTestBlazor.Server.Repositories
{
    public class DaveTestContext : DbContext
    {
        public DaveTestContext(DbContextOptions options) : base(options)
        {

        }

        public virtual DbSet<vUser> vUser { get; set; }

        public void usp_UserUpsert(string firstName, string lastName, string address, string phoneNumber, int age, int userID = 0)
        {
            // parameterize the data for executing the stored procedure
            var parameter = new List<SqlParameter>();
            parameter.Add(new SqlParameter("@userFirstName", firstName));
            parameter.Add(new SqlParameter("@userLastName", lastName));
            parameter.Add(new SqlParameter("@userAddress", address));
            parameter.Add(new SqlParameter("@userPhoneNumber", phoneNumber));
            parameter.Add(new SqlParameter("@userAge", age));
            parameter.Add(new SqlParameter("@userID", userID));

            // execute sproc
            this.Database.ExecuteSqlRaw("exec usp_UserUpsert @userID, @userFirstName, @userLastName, @userAddress, @userAge, @userPhoneNumber");
        }
    }
}