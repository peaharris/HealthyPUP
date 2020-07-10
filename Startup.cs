using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using HealthyPUP.Models;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.HttpsPolicy;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;

namespace HealthyPUP
{
    public class Startup
    {
        // F i e l d s  &  P r o p e r t i e s
        private IConfiguration configuration { get; }

        // C o n s t r u c t o r s
        public Startup(IConfiguration configuration)
        {
            this.configuration = configuration;
        }

        // M e t h o d s
        public void ConfigureServices(IServiceCollection services) //gets called by the runtime. Use this method to add services to the container.
        {
            services.AddDbContext<AppDogDbContext>(options => options.UseSqlServer
                (configuration.GetConnectionString("DefaultConnection")));
            services.AddDefaultIdentity<IdentityUser>().AddEntityFrameworkStores<AppDogDbContext>();

            services.AddScoped<IDogRepository, EfDogRepository>();
            services.AddScoped<IWalkRepository, EfWalkRepository>();
            services.AddScoped<IVetVisitRepository, EfVetVisitRepository>();
            services.AddScoped<IDailyRoutineRepository, EfDailyRoutineRepository>();
            services.AddControllersWithViews();
            services.AddRazorPages();
            services.AddHttpContextAccessor();
            services.AddMemoryCache();
            services.AddSession();
            services.AddCloudscribePagination();
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }

            app.UseStatusCodePages();
            app.UseStaticFiles();
            app.UseSession();
            app.UseRouting();

            app.UseAuthentication();
            app.UseAuthorization();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllerRoute(
                    name: "default",
                    pattern: "{controller=Home}/{action=Index}/{id?}");
                endpoints.MapRazorPages();
            });
        }
    }
}
