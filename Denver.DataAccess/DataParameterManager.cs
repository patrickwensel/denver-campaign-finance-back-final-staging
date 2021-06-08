using Npgsql;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Text;

namespace Denver.DataAccess
{
    public class DataParameterManager
    {
        public static IDbDataParameter CreateParameter(DataProvider providerName, string name, object value, DbType dbType, ParameterDirection direction = ParameterDirection.Input)
        {
            IDbDataParameter parameter = null;
            switch (providerName)
            {
                case DataProvider.MsSQL:
                    return CreateSqlParameter(name, value, dbType, direction);
                case DataProvider.PostgreSQL:
                    return CreatePostgreSqlParameter(name, value, dbType, direction);                
            }

            return parameter;
        }

        public static IDbDataParameter CreateParameter(DataProvider providerName, string name, int size, object value, DbType dbType, ParameterDirection direction = ParameterDirection.Input)
        {
            IDbDataParameter parameter = null;
            switch (providerName)
            {
                case DataProvider.MsSQL:
                    return CreateSqlParameter(name, size, value, dbType, direction);
                case DataProvider.PostgreSQL:
                    return CreatePostgreSqlParameter(name, size, value, dbType, direction);               
            }
            return parameter;
        }

        private static IDbDataParameter CreateSqlParameter(string name, object value, DbType dbType, ParameterDirection direction)
        {
            return new SqlParameter
            {
                DbType = dbType,
                ParameterName = name,
                Direction = direction,
                Value = value
            };
        }

        private static IDbDataParameter CreatePostgreSqlParameter(string name, object value, DbType dbType, ParameterDirection direction)
        {
            return new NpgsqlParameter
            {
                DbType = dbType,
                ParameterName = name,
                Direction = direction,
                Value = value
            };
        }

        private static IDbDataParameter CreateSqlParameter(string name, int size, object value, DbType dbType, ParameterDirection direction)
        {
            return new SqlParameter
            {
                DbType = dbType,
                Size = size,
                ParameterName = name,
                Direction = direction,
                Value = value
            };
        }

        private static IDbDataParameter CreatePostgreSqlParameter(string name, int size, object value, DbType dbType, ParameterDirection direction)
        {
            return new NpgsqlParameter
            {
                DbType = dbType,
                Size = size,
                ParameterName = name,
                Direction = direction,
                Value = value
            };
        }

    }
}
