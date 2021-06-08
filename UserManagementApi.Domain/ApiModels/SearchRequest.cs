using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ApiModels
{
    public class SearchRequest
    {
        public string SearchKey { get; set; }
        public int PageCount { get; set; }
        public int PageNumber { get; set; }
        public string OrderBy { get; set; }
        public bool OrderByAsc { get; set; }
    }
}
