using System;
using System.Collections.Generic;
using System.Text;

namespace UserManagementApi.Domain.ViewModels
{
    public class AppTenantRequestApiModel
    {
		public int AppId { get; set; }
		public string AppName { get; set; }
		public string ThemeName { get; set; }
		public string LogoUrl { get; set; }
		public string FavIcon { get; set; }
		public string BannerImageUrl { get; set; }
		public string SealImageUrl { get; set; }
		public string ClerkSealImageUrl { get; set; }
		public string HeaderImageUrl { get; set; }
		public string FooterImageUrl { get; set; }
		public string ClerkSignImageUrl { get; set; }
	}
}
