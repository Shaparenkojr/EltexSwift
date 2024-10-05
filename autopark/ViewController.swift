import UIKit


enum CargoType {
    case fragile(description: String)  // Хрупкий
    case perishable(description: String, temperature: Double)  // Скоропортящийся
    case bulk(description: String)  // Сыпучий
    
    func description() -> String {
        switch self {
        case .fragile:
            return "fragile"
        case .perishable:
            return "perishable, \temperature"
        case .bulk:
            return "bulk"
        }
    }
}

// Структура для груза
struct Cargo {
    let description: String
    let weight: Int
    let type: CargoType
    
    init?(description: String, weight: Int, type: CargoType) {
        guard weight > 0 else {
            print("Груз не может иметь отрицательный вес.")
            return nil
        }
        self.description = description
        self.weight = weight
        self.type = type
    }
}

// Базовый класс для транспортного средства
class Vehicle {
    let make: String
    let model: String
    let year: Int
    let capacity: Int
    var types: [CargoType]?
    var currentLoad: Int  // Изменено с опционала на обычный Int
    let fuelTankCapacity: Int  // Объем бака
    var fuelLevel: Int  // Текущий уровень топлива
    
    init(make: String, model: String, year: Int, capacity: Int, fuelTankCapacity: Int, types: [CargoType]? = nil) {
        self.make = make
        self.model = model
        self.year = year
        self.capacity = capacity
        self.types = types
        self.currentLoad = 0  // Инициализируем как 0
        self.fuelTankCapacity = fuelTankCapacity
        self.fuelLevel = fuelTankCapacity  // Бак полный при создании
    }
    
    // Метод загрузки груза
    func loadCargo(cargo: Cargo) {
        // Проверка на превышение грузоподъемности
        if currentLoad + cargo.weight > capacity {
            print("Превышена грузоподъемность транспортного средства \(make). ")
            return
        }
        else {
            currentLoad += cargo.weight
            print("Груз успешно загружен. в \(make), \(model)")
        }
    }
    
    // Метод разгрузки
    func unloadCargo() {
        currentLoad = 0
        print("Транспортное средство разгружено.")
    }
    
    // Метод для проверки возможности проезда с грузом на указанное расстояние
    func canGo(cargo: [Cargo], path: Int) -> Bool {
        let totalWeight = cargo.reduce(0) { $0 + $1.weight }
        let halfTank = fuelTankCapacity / 2
        
        // Проверяем, можно ли загрузить все грузы
        if totalWeight > capacity {
            print("Общий вес груза превышает грузоподъемность транспортного средства.")
            return false
        }
        
        // Проверяем, хватает ли топлива на поездку туда и обратно
        if path * 2 > halfTank {
            print("Недостаточно топлива для совершения поездки.")
            return false
        }
        print("Топлива достаточно для совершения поездки")
        return true
    }
}

// Класс для грузовиков (Truck)
class Truck: Vehicle {
    var trailerAttached: Bool
    var trailerCapacity: Int?
    var trailerTypes: [CargoType]?
    
    init(make: String, model: String, year: Int, capacity: Int, fuelTankCapacity: Int, trailerAttached: Bool, trailerCapacity: Int? = nil, trailerTypes: [CargoType]? = nil, types: [CargoType]? = nil) {
        self.trailerAttached = trailerAttached
        self.trailerCapacity = trailerCapacity
        self.trailerTypes = trailerTypes
        super.init(make: make, model: model, year: year, capacity: capacity, fuelTankCapacity: fuelTankCapacity, types: types)
    }
    
    override func loadCargo(cargo: Cargo) {
        if currentLoad + cargo.weight <= capacity {
            super.loadCargo(cargo: cargo)
        } else if trailerAttached, let trailerCapacity = trailerCapacity, currentLoad + cargo.weight <= trailerCapacity {
            currentLoad += cargo.weight
            print("Груз загружен в прицеп грузовика \(make).")
        } else {
            print("Превышена грузоподъемность как транспортного средства, так и прицепа.")
        }
    }
}

// Класс автопарка (Fleet)
class Fleet {
    var vehicles: [Vehicle] = []
    
    // Добавление транспортного средства в автопарк
    func addVehicle(_ vehicle: Vehicle) {
        vehicles.append(vehicle)
    }
    
    // Общая грузоподъемность автопарка
    func totalCapacity() -> Int {
        return vehicles.reduce(0) { $0 + $1.capacity }
    }
    
    // Текущая суммарная нагрузка автопарка
    func totalCurrentLoad() -> Int {
        return vehicles.reduce(0) { $0 + $1.currentLoad }
    }
    
    // Информация об автопарке
    func info() {
        print("Автопарк содержит \(vehicles.count) транспортных средств.")
        print("Общая грузоподъемность автопарка: \(totalCapacity()) кг.")
        print("Текущая нагрузка автопарка: \(totalCurrentLoad()) кг.")
    }
}

// ViewController
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fragileCargo = Cargo(description: "Хрупкий груз", weight: 600, type: .fragile(description: "Стекло"))!
        let bulkCargo = Cargo(description: "Сыпучий груз", weight: 200, type: .bulk(description: "Песок"))!

        let vehicle1 = Vehicle(make: "Mercedes", model: "Sprinter", year: 2018, capacity: 800, fuelTankCapacity: 5000)
        
        let truck1 = Truck(make: "Volvo", model: "FH16", year: 2020, capacity: 600, fuelTankCapacity: 5000, trailerAttached: true, trailerCapacity: 300)


        let fleet = Fleet()
        fleet.addVehicle(vehicle1)

        fleet.addVehicle(truck1)

        
        
//        fleet.info()

        vehicle1.loadCargo(cargo: fragileCargo)
        truck1.loadCargo(cargo: bulkCargo)
        

        fleet.info()

        let canGo = vehicle1.canGo(cargo: [fragileCargo], path: 100)
        print(canGo ? "Можем отправить груз." : "Не можем отправить груз.")
    }
}
