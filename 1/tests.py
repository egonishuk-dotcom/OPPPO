import unittest
from vehicles import Vehicle, Truck, Bus, Car, CommandProcessor

class TestVehicles(unittest.TestCase):

    # ----------------------- Тесты создания объектов -----------------------
    def test_truck_creation(self):
        """Проверка создания грузовика с корректными параметрами"""
        truck = Truck(200, "Germany", 5000)
        self.assertEqual(truck.engine_power, 200)
        self.assertEqual(truck.country, "Germany")
        self.assertEqual(truck.load_capacity, 5000)
    
    def test_bus_creation(self):
        """Проверка создания автобуса с корректными параметрами"""
        bus = Bus(150, "USA", 50)
        self.assertEqual(bus.passenger_capacity, 50)
        self.assertEqual(bus.country, "USA")

    def test_car_creation(self):
        """Проверка создания легкового автомобиля с корректными параметрами"""
        car = Car(120, "Japan", 4, 180)
        self.assertEqual(car.doors, 4)
        self.assertEqual(car.max_speed, 180)
        self.assertEqual(car.country, "Japan")

    # ----------------------- Тесты метода matches_condition -----------------------
    def test_matches_condition(self):
        """Проверка метода matches_condition с различными операторами"""
        car = Car(120, "Japan", 4, 180)
        self.assertTrue(car.matches_condition("enginePower", ">", 100))
        self.assertFalse(car.matches_condition("enginePower", "<", 100))
        self.assertTrue(car.matches_condition("country", "==", "Japan"))
        self.assertFalse(car.matches_condition("country", "==", "USA"))
        self.assertFalse(car.matches_condition("nonexistentField", "==", 0))  # несуществующее поле

    # ----------------------- Тесты CommandProcessor -----------------------
    def test_command_processor_add_rem(self):
        """Проверка добавления и удаления объектов через CommandProcessor"""
        processor = CommandProcessor()
        processor.process_add(["ADD", "Truck", "enginePower=200", "country=Germany", "loadCapacity=5000"])
        self.assertEqual(len(processor.container), 1)
        processor.process_rem(["REM", "enginePower", ">", "100"])
        self.assertEqual(len(processor.container), 0)

    def test_invalid_vehicle_type(self):
        """Проверка добавления неизвестного типа транспорта"""
        processor = CommandProcessor()
        processor.process_add(["ADD", "Plane", "enginePower=1000", "country=USA"])
        self.assertEqual(len(processor.container), 0)  # Plane не добавляется

    def test_rem_invalid_field(self):
        """Проверка удаления по несуществующему полю"""
        processor = CommandProcessor()
        processor.process_add(["ADD", "Car", "enginePower=120", "country=Japan", "doors=4", "maxSpeed=180"])
        processor.process_rem(["REM", "color", "==", "red"])  # поле color не существует
        self.assertEqual(len(processor.container), 1)  # контейнер остаётся

    def test_add_invalid_parameter_type(self):
        """Проверка добавления объекта с некорректным форматом параметра"""
        processor = CommandProcessor()
        with self.assertRaises(ValueError):
            processor.process_add(["ADD", "Truck", "enginePower=twohundred", "country=Germany", "loadCapacity=5000"])


if __name__ == "__main__":
    unittest.main()
