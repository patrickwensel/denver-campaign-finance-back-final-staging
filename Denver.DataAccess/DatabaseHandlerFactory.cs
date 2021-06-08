using System;
using System.Collections.Generic;
using System.Configuration;
using System.Text;

namespace Denver.DataAccess
{
    public class DatabaseHandlerFactory
    {
        private string _connectionString;
        private DataProvider _provider;

        public DatabaseHandlerFactory(String connectionString, DataProvider provider)
        {
            _connectionString = connectionString;
            _provider = provider;
            //connectionStringSettings = ConfigurationManager.ConnectionStrings[connectionStringName];
        }

        public IDatabaseHandler CreateDatabase()
        {
            IDatabaseHandler database = null;

            switch (_provider)
            {
                case DataProvider.MsSQL:
                    database = new SqlDataAccess(_connectionString);
                    break;                
                case DataProvider.PostgreSQL:
                    database = new PostgreSqlDataAccess(_connectionString);
                    break;               
                default:
                    break;
            }           
            return database;
        }

        public DataProvider GetProviderName()
        {
            return _provider;
        }

    }
}
