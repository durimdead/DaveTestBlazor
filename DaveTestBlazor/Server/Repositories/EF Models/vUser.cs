﻿using System.ComponentModel.DataAnnotations;

namespace DaveTestBlazor.Server.Repositories.EF_Models
{
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
