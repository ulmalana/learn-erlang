-module(functions).
-compile(export_all).


head([H|_]) ->
    H.
second([_,X|_]) ->
    X.

same(X,X) ->
    true;
same(_,_) ->
    false.

valid_time({Date = {Y,M,D}, Time = {H,Min,S}}) ->
    io:format("The Date tuple (~p) says today is: ~p/~p/~p,~n", [Date,Y,M,D]),
    io:format("The Time tuple (~p) indicates: ~p:~p:~p.~n", [Time, H, Min, S]);
valid_time(_) ->
    io:format("Stop feeding me wrong data!~n").

%% guards
old_enough(X) when X >= 16 ->
    true;
old_enough(_) -> false.

right_age(X) when X >= 16, X =< 104 ->
    true;
right_age(_) -> false.

wrong_age(X) when X < 16;
                  X > 104 ->
    true;
wrong_age(_) -> false.


insert(X,[]) ->
    [X];
insert(X,Set) ->
    case lists:member(X,Set) of
        true -> Set;
        false -> [X|Set]
    end.

beach(Temperature) ->
    case Temperature of
        {celsius, N} when N >= 20,
                          N =< 45 ->
            'favorable';
        {kelvin, N} when N >= 293,
                         N =< 318 ->
            'scientifically favorable';
        {fahrenheit, N} when N >= 68, N =< 113 ->
            'favorable in the US';
        _ -> 'avoid beach'
    end.
