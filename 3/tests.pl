% ==============================
% Практическая работа 4
% Модульные тесты для транспортной системы
% Язык: Prolog (SWI-Prolog)
% Используется PLUnit
% ==============================

:- encoding(utf8).

:- begin_tests(transport).

% Подключаем тестируемый код
:- consult('../2/2.pl').

% ==============================
% Вспомогательные предикаты
% ==============================

clear_container :-
    retractall(vehicle(_, _, _, _)).

% ==============================
% УСПЕШНЫЕ ТЕСТЫ
% ==============================

test(add_car_success, [nondet]) :-
    clear_container,
    add_vehicle(car, [
        enginePower=150,
        country=japan,
        doors=4,
        maxSpeed=210
    ]),
    vehicle(car, 150, japan, Params),
    member(doors=4, Params),
    member(maxSpeed=210, Params).

test(add_truck_success) :-
    clear_container,
    add_vehicle(truck, [
        enginePower=400,
        country=germany,
        loadCapacity=12000
    ]),
    vehicle(truck, 400, germany, Params),
    member(loadCapacity=12000, Params).

test(add_bus_success) :-
    clear_container,
    add_vehicle(bus, [
        enginePower=250,
        country=russia,
        passengerCapacity=45
    ]),
    vehicle(bus, 250, russia, Params),
    member(passengerCapacity=45, Params).

test(remove_by_engine_power) :-
    clear_container,
    add_vehicle(car, [
        enginePower=320,
        country=germany,
        doors=2,
        maxSpeed=280
    ]),
    add_vehicle(car, [
        enginePower=180,
        country=japan,
        doors=4,
        maxSpeed=220
    ]),
    remove_by_condition(enginePower, '>', 300),
    vehicle(car, 180, japan, _),
    \+ vehicle(car, 320, _, _).

test(remove_does_not_affect_other_types) :-
    clear_container,
    add_vehicle(bus, [
        enginePower=200,
        country=poland,
        passengerCapacity=40
    ]),
    remove_by_condition(enginePower, '>', 300),
    vehicle(bus, 200, poland, _).

test(print_container_non_empty) :-
    clear_container,
    add_vehicle(car, [
        enginePower=120,
        country=japan,
        doors=4,
        maxSpeed=180
    ]),
    print_container.

% ==============================
% ТЕСТЫ ИСКЛЮЧИТЕЛЬНЫХ СИТУАЦИЙ
% ==============================

test(add_unknown_vehicle_type, [fail]) :-
    clear_container,
    add_vehicle(plane, [
        enginePower=500,
        country=usa
    ]).

test(remove_unknown_field_does_nothing) :-
    clear_container,
    add_vehicle(car, [
        enginePower=140,
        country=japan,
        doors=4,
        maxSpeed=190
    ]),
    remove_by_condition(weight, '>', 100),
    vehicle(_, _, _, _).

test(remove_from_empty_container) :-
    clear_container,
    remove_by_condition(enginePower, '>', 100),
    \+ vehicle(_, _, _, _).

test(print_empty_container) :-
    clear_container,
    print_container.

test(compare_invalid_operator, [fail]) :-
    compare_val('!=', 10, 20).

% ==============================
% Завершение набора тестов
% ==============================

:- end_tests(transport).
