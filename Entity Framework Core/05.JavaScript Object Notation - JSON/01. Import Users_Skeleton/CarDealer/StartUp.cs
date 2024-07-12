using CarDealer.Data;
using CarDealer.DTOs.Import;
using CarDealer.Models;
using Newtonsoft.Json;

namespace CarDealer
{
    public class StartUp
    {
        public static void Main()
        {
            CarDealerContext context = new CarDealerContext();

            //string suppliersString = File.ReadAllText("../../../Datasets/suppliers.json");
            //Console.WriteLine(ImportSuppliers(context, suppliersString));

            //string partsString = File.ReadAllText("../../../Datasets/parts.json");
            //Console.WriteLine(ImportParts(context, partsString));

            //string carsString = File.ReadAllText("../../../Datasets/cars.json");
            //Console.WriteLine(ImportCars(context, carsString));

            //string customersString = File.ReadAllText("../../../Datasets/customers.json");
            //Console.WriteLine(ImportCustomers(context, customersString));

            //string salesString = File.ReadAllText("../../../Datasets/sales.json");
            //Console.WriteLine(ImportSales(context, salesString));

            //Console.WriteLine(GetOrderedCustomers(context));

            //Console.WriteLine(GetCarsFromMakeToyota(context));

            //Console.WriteLine(GetLocalSuppliers(context));

            //Console.WriteLine(GetCarsWithTheirListOfParts(context));

            //Console.WriteLine(GetTotalSalesByCustomer(context));

            Console.WriteLine(GetSalesWithAppliedDiscount(context));

        }

        public static string GetSalesWithAppliedDiscount(CarDealerContext context)
        {
            var sales = context.Sales
                .Take(10)
                .Select(s => new
                {
                    car = new
                    {
                        s.Car.Make,
                        s.Car.Model,
                        s.Car.TraveledDistance
                    },
                    customerName = s.Customer.Name,
                    discount = s.Discount.ToString("F2"),
                    price = s.Car.PartsCars.Sum(pc => pc.Part.Price).ToString("F2"),
                    priceWithDiscount = (s.Car.PartsCars.Sum(pc => pc.Part.Price) * (1 - s.Discount / 100)).ToString("F2")
                })
                .ToList();
            return JsonConvert.SerializeObject(sales, Formatting.Indented);
        }

        public static string GetTotalSalesByCustomer(CarDealerContext context)
        {
            var customers = context.Customers
                .Where(c => c.Sales.Any())
                .Select(c => new
                {
                    fullName = c.Name,
                    boughtCars = c.Sales.Count,
                    spentMoney = c.Sales.Sum(s => s.Car.PartsCars.Sum(pc => pc.Part.Price))
                })
                .OrderByDescending(c => c.spentMoney)
                .ThenByDescending(c => c.boughtCars)
                .ToList();
            return JsonConvert.SerializeObject(customers, Formatting.Indented);
        }

        public static string GetCarsWithTheirListOfParts(CarDealerContext context)
        {
            var cars = context.Cars
                .Select(c => new
                {
                    car = new
                    {
                        c.Make,
                        c.Model,
                        c.TraveledDistance
                    },
                    parts = c.PartsCars.Select(pc => new
                    {
                        pc.Part.Name,
                        Price = pc.Part.Price.ToString("F2")
                    })
                    .ToList()
                })
                .ToList();
            return JsonConvert.SerializeObject(cars, Formatting.Indented);
        }

        public static string GetLocalSuppliers(CarDealerContext context)
        {
            var suppliers = context.Suppliers
                .Where(s => !s.IsImporter)
                .Select(s => new
                {
                    s.Id,
                    s.Name,
                    PartsCount = s.Parts.Count
                })
                .ToList();
            return JsonConvert.SerializeObject(suppliers, Formatting.Indented);
        }

        public static string GetCarsFromMakeToyota(CarDealerContext context)
        {
            var cars = context.Cars
                .Where(c => c.Make == "Toyota")
                .OrderBy(c => c.Model)
                .ThenByDescending(c => c.TraveledDistance)
                .Select(c => new
                {
                    c.Id,
                    c.Make,
                    c.Model,
                    c.TraveledDistance
                })
                .ToList();
            return JsonConvert.SerializeObject(cars, Formatting.Indented);
        }

        public static string GetOrderedCustomers(CarDealerContext context)
        {
            var customers = context.Customers
                .OrderBy(c => c.BirthDate)
                .ThenBy(c => c.IsYoungDriver)
                .Select(c => new
                {
                    Name = c.Name,
                    BirthDate = c.BirthDate.ToString("dd/MM/yyyy"),
                    IsYoungDriver = c.IsYoungDriver
                })
                .ToList();
            return JsonConvert.SerializeObject(customers, Formatting.Indented);
        }

        public static string ImportSales(CarDealerContext context, string inputJson)
        {
            var sales = JsonConvert.DeserializeObject<List<Sale>>(inputJson);

            context.Sales.AddRange(sales);
            context.SaveChanges();

            return $"Successfully imported {sales.Count}.";
        }

        public static string ImportCustomers(CarDealerContext context, string inputJson)
        {
            var customers = JsonConvert.DeserializeObject<List<Customer>>(inputJson);

            context.Customers.AddRange(customers);
            context.SaveChanges();

            return $"Successfully imported {customers.Count}.";
        }

        public static string ImportCars(CarDealerContext context, string inputJson)
        {
            var CarsDtos = JsonConvert.DeserializeObject<List<ImportCarDto>>(inputJson);

            var cars = new HashSet<Car>();
            var partsCars = new HashSet<PartCar>();

            foreach (var carDto in CarsDtos)
            {
                var newCar = new Car()
                {
                    Make = carDto.Make,
                    Model = carDto.Model,
                    TraveledDistance = carDto.TraveledDistance
                };

                cars.Add(newCar);
                foreach (var partId in carDto.PartsId.Distinct())
                {
                    partsCars.Add(new PartCar()
                    {
                        Car = newCar,
                        PartId = partId
                    });
                }

            }

            context.Cars.AddRange(cars);
            context.PartsCars.AddRange(partsCars);
            context.SaveChanges();

            return $"Successfully imported {cars.Count}.";
        }

        public static string ImportParts(CarDealerContext context, string inputJson)
        {
            List<Part> parts = JsonConvert.DeserializeObject<List<Part>>(inputJson)
            .Where(p => context.Suppliers.Any(s => s.Id == p.SupplierId)).ToList();

            context.Parts.AddRange(parts);
            context.SaveChanges();

            return $"Successfully imported {parts.Count}.";
        }

        public static string ImportSuppliers(CarDealerContext context, string inputJson)
        {
            List<Supplier> suppliers = JsonConvert.DeserializeObject<List<Supplier>>(inputJson);

            context.Suppliers.AddRange(suppliers);
            context.SaveChanges();

            return $"Successfully imported {suppliers.Count}.";
        }
    }
}