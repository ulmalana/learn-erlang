-module(dolphins).
-compile(export_all).

dolphin1() ->
    receive
        do_a_flip ->
            io:format("How about no?~n");
        fish ->
            io:format("thanks for the fish~n");
        _ ->
            io:format("we are smarter than you~n")
    end.

dolphin2() ->
    receive
        {From, do_a_flip} ->
            From ! "How about no?";
        {From, fish} ->
            From ! "thanks for the fish";
        _ -> 
            io:format("damn you fool~n")
    end.

dolphin3() ->
    receive
        {From, do_a_flip} ->
            From ! "how about no?",
            dolphin3();
        {From, fish} ->
            From ! "thanks for the fish";
        _ ->
            io:format("damn you fool"),
            dolphin3()
    end.
