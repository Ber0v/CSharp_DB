using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;
using ProductShop.Data;
using ProductShop.DTOs.Export;
using ProductShop.Models;

namespace ProductShop
{
    public class StartUp
    {
        public static void Main()
        {
            ProductShopContext context = new ProductShopContext();

            //string userTest = File.ReadAllText("../../../Datasets/users.json");
            //Console.WriteLine(ImportUsers(context, userTest));

            //string productsTest = File.ReadAllText("../../../Datasets/products.json");
            //Console.WriteLine(ImportProducts(context, productsTest));

            //string categoriesTest = File.ReadAllText("../../../Datasets/categories.json");
            //Console.WriteLine(ImportCategories(context, categoriesTest));

            //string categoryProductsTest = File.ReadAllText("../../../Datasets/categories-products.json");
            //Console.WriteLine(ImportCategoryProducts(context, categoryProductsTest));

            //Console.WriteLine(GetProductsInRange(context));

            //Console.WriteLine(GetSoldProducts(context));

            //Console.WriteLine(GetCategoriesByProductsCount(context));

            //Console.WriteLine(GetUsersWithProducts(context));
        }

        public static string GetUsersWithProducts(ProductShopContext context)
        {
            var users = context.Users
                .Where(u => u.ProductsSold.Any(p => p.BuyerId != null))
                .Select(u => new
                {
                    u.FirstName,
                    u.LastName,
                    u.Age,
                    SoldProducts = u.ProductsSold
                    .Where(p => p.BuyerId != null)
                    .Select(p => new
                    {
                        p.Name,
                        p.Price
                    })
                    .ToArray()
                })
                .OrderByDescending(u => u.SoldProducts.Length)
                .ToArray();

            var output = new
            {
                usersCount = users.Length,
                users = users.Select(u => new
                {
                    u.FirstName,
                    u.LastName,
                    u.Age,
                    SoldProducts = new
                    {
                        count = u.SoldProducts.Length,
                        products = u.SoldProducts
                    }
                })
            };

            var settings = new JsonSerializerSettings()
            {
                NullValueHandling = NullValueHandling.Ignore,
                ContractResolver = new CamelCasePropertyNamesContractResolver(),
                Formatting = Formatting.Indented,
            };

            return JsonConvert.SerializeObject(output, settings);
        }

        public static string GetCategoriesByProductsCount(ProductShopContext context)
        {
            var Categories = context.Categories
               .Select(c => new
               {
                   Category = c.Name,
                   ProductsCount = c.CategoriesProducts.Count,
                   AveragePrice = c.CategoriesProducts
                   .Average(cp => cp.Product.Price)
                   .ToString("F2"),
                   TotalRevenue = c.CategoriesProducts
                   .Sum(cp => cp.Product.Price)
                   .ToString("F2")
               })
               .OrderByDescending(x => x.ProductsCount)
               .ToList();

            var settings = new JsonSerializerSettings()
            {
                //NullValueHandling = NullValueHandling.Ignore,
                ContractResolver = new CamelCasePropertyNamesContractResolver(),
                Formatting = Formatting.Indented,
            };

            return JsonConvert.SerializeObject(Categories, settings);
        }

        public static string GetSoldProducts(ProductShopContext context)
        {
            var soldProducts = context.Users
                .Where(u => u.ProductsSold.Any(p => p.BuyerId != null))
                .Select(p => new SellerWithProductsDto()
                {
                    FirstName = p.FirstName,
                    LastName = p.LastName,
                    SoldProducts = p.ProductsSold.Select(u => new SoldProductsDto
                    {
                        Name = u.Name,
                        Price = u.Price,
                        BuyerFirstName = u.Buyer.FirstName,
                        BuyerLastName = u.Buyer.LastName,
                    })
                })
                .OrderBy(p => p.LastName)
                .ThenBy(p => p.FirstName)
                .ToList();

            var settings = new JsonSerializerSettings()
            {
                //NullValueHandling = NullValueHandling.Ignore,
                ContractResolver = new CamelCasePropertyNamesContractResolver(),
                Formatting = Formatting.Indented,
            };

            return JsonConvert.SerializeObject(soldProducts, settings);
        }

        public static string GetProductsInRange(ProductShopContext context)
        {
            var productsInRange = context.Products
                .Where(p => p.Price >= 500 && p.Price <= 1000)
                .OrderBy(p => p.Price)
                .Select(p => new
                {
                    Name = p.Name,
                    Price = p.Price,
                    Seller = $"{p.Seller.FirstName} {p.Seller.LastName}"
                })
                .ToList();

            var settings = new JsonSerializerSettings()
            {
                NullValueHandling = NullValueHandling.Ignore,
                ContractResolver = new CamelCasePropertyNamesContractResolver(),
                Formatting = Formatting.Indented,
            };

            return JsonConvert.SerializeObject(productsInRange, settings);
        }

        public static string ImportCategoryProducts(ProductShopContext context, string inputJson)
        {
            var categoryProducts = JsonConvert.DeserializeObject<List<CategoryProduct>>(inputJson);

            context.AddRange(categoryProducts);
            context.SaveChanges();

            return $"Successfully imported {categoryProducts.Count}";
        }

        public static string ImportCategories(ProductShopContext context, string inputJson)
        {
            var categories = JsonConvert.DeserializeObject<List<Category>>(inputJson);

            categories.RemoveAll(c => c.Name == null);

            context.Categories.AddRange(categories);
            context.SaveChanges();

            return $"Successfully imported {categories.Count}";
        }

        public static string ImportProducts(ProductShopContext context, string inputJson)
        {
            var products = JsonConvert.DeserializeObject<List<Product>>(inputJson);

            context.Products.AddRange(products);
            context.SaveChanges();

            return $"Successfully imported {products.Count}";
        }

        public static string ImportUsers(ProductShopContext context, string inputJson)
        {
            var users = JsonConvert.DeserializeObject<List<User>>(inputJson);

            context.Users.AddRange(users);
            context.SaveChanges();

            return $"Successfully imported {users.Count}";
        }
    }
}