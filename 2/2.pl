% ==============================
% Практическая работа 1.1
% Обработка команд ADD / REM / PRINT
% Язык: Prolog
% ==============================
:- encoding(utf8).
:- dynamic vehicle/4.


% ==============================
% ADD
% ==============================

add_vehicle(truck, Params) :-
    member(enginePower=Power, Params),
    member(country=Country, Params),
    member(loadCapacity=Load, Params),
    assertz(vehicle(truck, Power, Country,
            [loadCapacity=Load])), !.

add_vehicle(bus, Params) :-
    member(enginePower=Power, Params),
    member(country=Country, Params),
    member(passengerCapacity=Passengers, Params),
    assertz(vehicle(bus, Power, Country,
            [passengerCapacity=Passengers])), !.

add_vehicle(car, Params) :-
    member(enginePower=Power, Params),
    member(country=Country, Params),
    member(doors=Doors, Params),
    member(maxSpeed=Speed, Params),
    assertz(vehicle(car, Power, Country,
            [doors=Doors, maxSpeed=Speed])), !.

% ==============================
% REM (условия)
% ==============================

matches(enginePower, '>', V, vehicle(_, Power, _, _)) :- Power > V.
matches(enginePower, '<', V, vehicle(_, Power, _, _)) :- Power < V.
matches(enginePower, '==', V, vehicle(_, Power, _, _)) :- Power =:= V.

matches(country, '==', V, vehicle(_, _, V, _)).

matches(loadCapacity, Op, V, vehicle(truck, _, _, Params)) :-
    member(loadCapacity=LC, Params),
    compare_val(Op, LC, V).

matches(passengerCapacity, Op, V, vehicle(bus, _, _, Params)) :-
    member(passengerCapacity=P, Params),
    compare_val(Op, P, V).

matches(doors, Op, V, vehicle(car, _, _, Params)) :-
    member(doors=D, Params),
    compare_val(Op, D, V).

matches(maxSpeed, Op, V, vehicle(car, _, _, Params)) :-
    member(maxSpeed=S, Params),
    compare_val(Op, S, V).

compare_val(Op, A, B) :-
    member(Op, ['>', '<', '==']),
    Goal =.. [Op, A, B],
    call(Goal).

remove_by_condition(Field, Op, Value) :-
    forall(
        ( vehicle(T, P, C, Params),
          matches(Field, Op, Value, vehicle(T, P, C, Params)) ),
        retract(vehicle(T, P, C, Params))
    ).

% ==============================
% PRINT
% ==============================

print_container :-
    findall(vehicle(T,P,C,Params), vehicle(T,P,C,Params), List),
    ( List = [] ->
        writeln('Контейнер пуст')
    ;
        writeln('Содержимое контейнера:'),
        forall(member(vehicle(T,P,C,Params), List),
               print_vehicle(T,P,C,Params))
    ).


print_vehicle(truck, P, C, [loadCapacity=L]) :-
    format('Truck(power=~w, country=~w, load_capacity=~w)~n',
           [P, C, L]).

print_vehicle(bus, P, C, [passengerCapacity=PC]) :-
    format('Bus(power=~w, country=~w, passengers=~w)~n',
           [P, C, PC]).

print_vehicle(car, P, C, [doors=D, maxSpeed=S]) :-
    format('Car(power=~w, country=~w, doors=~w, max_speed=~w)~n',
           [P, C, D, S]), !.

% ==============================
% Обработка файла
% ==============================

execute_file(File) :-
    retractall(vehicle(_,_,_,_)),
    open(File, read, Stream),
    repeat,
        read_line_to_string(Stream, Line),
        ( Line == end_of_file ->
            close(Stream), !
        ; process_line(Line),
          fail
        ).

process_line(Line) :-
    normalize_space(string(Trimmed), Line),
    ( Trimmed = "" ->
        true
    ; split_string(Trimmed, " ", "", Parts),
      command(Parts)
    ).


command(["ADD", TypeStr | ParamsStr]) :-
    string_lower(TypeStr, LowerStr),
    atom_string(Type, LowerStr),
    parse_params(ParamsStr, Params),
    add_vehicle(Type, Params), !.


command(["REM", FieldStr, OpStr, ValueStr]) :-
    atom_string(Field, FieldStr),
    atom_string(Op, OpStr),
    ( number_string(Value, ValueStr) -> true ; atom_string(Value, ValueStr) ),
    remove_by_condition(Field, Op, Value), !.

command(["PRINT"]) :-
    print_container, !.

command(_) :-
    writeln('Ошибка: неизвестная команда').
% ==============================
% Парсинг параметров
% ==============================

parse_params([], []).
parse_params([H|T], [Key=Value|Rest]) :-
    split_string(H, "=", "", [K,V]),
    atom_string(Key, K),
    ( number_string(Value, V) -> true ; atom_string(Value, V) ),
    parse_params(T, Rest).
