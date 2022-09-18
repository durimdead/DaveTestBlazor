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
            var parameters = new List<SqlParameter>();
            parameters.Add(new SqlParameter("@userFirstName", firstName));
            parameters.Add(new SqlParameter("@userLastName", lastName));
            parameters.Add(new SqlParameter("@userAddress", address));
            parameters.Add(new SqlParameter("@userPhoneNumber", phoneNumber));
            parameters.Add(new SqlParameter("@userAge", age));
            parameters.Add(new SqlParameter("@userID", userID));

            // execute sproc
            this.Database.ExecuteSqlRaw("exec usp_UserUpsert @userID, @userFirstName, @userLastName, @userAddress, @userAge, @userPhoneNumber");
        }

        public void usp_UserDelete(int userID)
        {
            // parameterize the data for executing the stored procedure
            var parameters = new List<SqlParameter>();
            parameters.Add(new SqlParameter("@userID", userID));

            // execute sproc
            this.Database.ExecuteSqlRaw("exec usp_UserDelete @userID", parameters);
        }
    }
}