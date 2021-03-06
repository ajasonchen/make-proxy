%%%-------------------------------------------------------------------
%%% @author wang <yueyoum@gmail.com>
%%% @copyright (C) 2014
%%% @doc
%%%
%%% @end
%%% Created : 2014-12-18 13:00
%%%-------------------------------------------------------------------
-module(mpc_sup).
-author("wang").

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%%===================================================================
%%% API functions
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%% Starts the supervisor
%%
%% @end
%%--------------------------------------------------------------------
-spec(start_link() ->
    {ok, Pid :: pid()} | ignore | {error, Reason :: term()}).
start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%%===================================================================
%%% Supervisor callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Whenever a supervisor is started using supervisor:start_link/[2,3],
%% this function is called by the new process to find out about
%% restart strategy, maximum restart frequency and child
%% specifications.
%%
%% @end
%%--------------------------------------------------------------------
-spec(init(Args :: term()) ->
    {ok, {SupFlags :: {RestartStrategy :: supervisor:strategy(),
        MaxR :: non_neg_integer(), MaxT :: non_neg_integer()},
        [ChildSpec :: supervisor:child_spec()]
    }} |
    ignore |
    {error, Reason :: term()}).
init([]) ->
    RestartStrategy = one_for_one,
    MaxRestarts = 10,
    MaxSecondsBetweenRestarts = 3600,

    SupFlags = {RestartStrategy, MaxRestarts, MaxSecondsBetweenRestarts},

    Restart = permanent,
    Shutdown = infinity,
    Type = supervisor,

    ChildAcceptorSup = {mpc_acceptor_sup, {mpc_acceptor_sup, start_link, []},
                        Restart, Shutdown, Type, [mpc_child_sup]},

    ChildChildSup = {mpc_child_sup, {mpc_child_sup, start_link, []},
                     Restart, Shutdown, Type, [mpc_child_sup]},

    {ok, {SupFlags, [ChildChildSup, ChildAcceptorSup]}}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
