-module(linkmon).
-compile(export_all).

myproc() ->
    timer:sleep(5000),
    exit(reason).

chain(0) ->
    receive
        _ -> ok
    after 2000 ->
            exit("chain dies here")
    end;
chain(N) ->
    Pid = spawn(fun () -> chain(N-1) end),
    link(Pid),
    receive
        _ -> ok
    end.

start_critic() ->
    spawn(?MODULE, critic, []).

judge(Pid, Band, Album) ->
    Pid ! {self(), {Band, Album}},
    receive
        {Pid, Criticism} -> Criticism
    after 2000 -> timeout
    end.

critic() ->
    receive
        {From, {"RATM", "Unit Testify"}} ->
            From ! {self(), "They are great"};
        {From, {"SOAD", "Memoize"}} ->
            From ! {self(), "Not jhonny crash but good"};
        {From, {"Johnny Crash", "Ring of Fire"}} ->
            From ! {self(), "Simply incredible"};
        {From, {_Band, _Album}} ->
            From ! {self(), "terrible"}
    end,
    critic().

start_critic2() ->
    spawn(?MODULE, restarter, []).

restarter() ->
    process_flag(trap_exit, true),
    Pid = spawn_link(?MODULE, critic2, []),
    register(critic, Pid),
    receive
        {'EXIT', Pid, normal} -> % not a crash
            ok;
        {'EXIT', Pid, shutdown} -> % manual termination
            ok;
        {'EXIT', Pid, _} ->
            restarter()
    end.

judge2(Band, Album) ->
    Ref = make_ref(),
    critic ! {self(), Ref, {Band, Album}},
    receive
        {Ref, Criticism} ->
            Criticism
    after 2000 ->
            timeout
    end.

critic2() ->
    receive
        {From, Ref, {"RATM", "Unit Testify"}} ->
            From ! {Ref, "They are great"};
        {From, Ref, {"SOAD", "Memoize"}} ->
            From ! {Ref, "Not jhonny crash but good"};
        {From, Ref, {"Johnny Crash", "Ring of Fire"}} ->
            From ! {Ref, "Simply incredible"};
        {From, Ref, {_Band, _Album}} ->
            From ! {Ref, "terrible"}
    end,
    critic2().
