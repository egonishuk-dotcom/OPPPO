from typing import List
import operator
# Базовый класс
""" Модуль для работы с транспортными средствами.
Содержит классы Vehicle, Truck, Bus, Car и обработчик команд CommandProcessor. """
class Vehicle:
    """Базовый класс транспортного средства с общими характеристиками."""

    def __init__(self, engine_power: int, country: str):
        self.engine_power = engine_power
        self.country = country

    def matches_condition(self, field, operator, value):
        """Проверяет, соответствует ли атрибут заданному условию."""
        field_map = {
        "enginePower": "engine_power",
        "country": "country",
        "loadCapacity": "load_capacity",
        "passengerCapacity": "passenger_capacity",
        "doors": "doors",
        "maxSpeed": "max_speed"
        }
        attr = getattr(self, field_map.get(field, ""), None)
        if attr is None:
            return False

        if operator == ">":
            return attr > value
        elif operator == "<":
            return attr < value
        elif operator == "==":
            return attr == value
        return False

    def __str__(self):
        return f"Vehicle(power={self.engine_power}, country={self.country})"


# Грузовик
class Truck(Vehicle):
    """Класс грузового автомобиля с характеристикой грузоподъёмности."""
    def __init__(self, engine_power, country, load_capacity):
        super().__init__(engine_power, country)
        self.load_capacity = load_capacity

    def __str__(self):
        return (
            f"Truck(power={self.engine_power}, "
            f"country={self.country}, "
            f"load_capacity={self.load_capacity})"
        )


# Автобус
class Bus(Vehicle):
    """Класс автобуса с характеристикой пассажировместимости."""
    def __init__(self, engine_power, country, passenger_capacity):
        super().__init__(engine_power, country)
        self.passenger_capacity = passenger_capacity

    def __str__(self):
        return (
            f"Bus(power={self.engine_power}, "
            f"country={self.country}, "
            f"passengers={self.passenger_capacity})"
        )


# Легковой автомобиль
class Car(Vehicle):
    """Класс легкового автомобиля с количеством дверей и максимальной скоростью."""
    def __init__(self, engine_power, country, doors, max_speed):
        super().__init__(engine_power, country)
        self.doors = doors
        self.max_speed = max_speed

    def __str__(self):
        return (
            f"Car(power={self.engine_power}, "
            f"country={self.country}, "
            f"doors={self.doors}, "
            f"max_speed={self.max_speed})"
        )


# Обработчик команд
class CommandProcessor:
    """Класс для обработки команд ADD, REM и PRINT с контейнером транспортных средств."""
    def __init__(self):
        self.container = []

    def process_add(self, parts):
        """Обрабатывает команду ADD, создаёт объект транспортного средства и добавляет в контейнер."""
    
        vehicle_type = parts[1]
        params = {}

        for p in parts[2:]:
            key, value = p.split("=")
            params[key] = value

    # Приведение типов параметров
        param_types = {
            "enginePower": int,
            "loadCapacity": int,
            "passengerCapacity": int,
            "doors": int,
            "maxSpeed": int,
            "country": str
        }

        for k, v in params.items():
            if k in param_types:
                params[k] = param_types[k](v)

        # Создание объекта в зависимости от типа
        if vehicle_type == "Truck":
            obj = Truck(params["enginePower"], params["country"], params["loadCapacity"])
        elif vehicle_type == "Bus":
            obj = Bus(params["enginePower"], params["country"], params["passengerCapacity"])
        elif vehicle_type == "Car":
            obj = Car(params["enginePower"], params["country"], params["doors"], params["maxSpeed"])
        else:
            print(f"Неизвестный тип объекта: {vehicle_type}")
            return

        self.container.append(obj)


    def process_rem(self, parts):
        """Обрабатывает команду REM, удаляет объекты из контейнера по условию."""
        field = parts[1]
        operator = parts[2]
        value = parts[3]

        if value.isdigit():
            value = int(value)

        self.container = [
            obj for obj in self.container
            if not obj.matches_condition(field, operator, value)
        ]

    def process_print(self):
        """Выводит содержимое контейнера транспортных средств."""
        print("Содержимое контейнера:")
        if not self.container:
            print("Контейнер пуст")

        for obj in self.container:
            print(obj)

    def execute_file(self, filename):
        """Считывает команды из файла и выполняет их построчно."""
        with open(filename, encoding="utf-8") as file:
            for line in file:
                line = line.strip()
                if not line:
                    continue

                parts = line.split()
                command = parts[0]

                if command == "ADD":
                    self.process_add(parts)
                elif command == "REM":
                    self.process_rem(parts)
                elif command == "PRINT":
                    self.process_print()


# Точка входа
if __name__ == "__main__":
    processor = CommandProcessor()
    processor.execute_file("commands.txt")
