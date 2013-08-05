%%%-------------------------------------------------------------------
%%% @author Mahesh Paolini-Subramanya <mahesh@dieswaytoofast.com>
%%% @copyright (C) 2013 Mahesh Paolini-Subramanya
%%% @doc cassandra tests
%%% @end
%%%
%%% This source file is subject to the New BSD License. You should have received
%%% a copy of the New BSD license with this software. If not, it can be
%%% retrieved from: http://www.opensource.org/licenses/bsd-license.php
%%%-------------------------------------------------------------------
-module(erlang_cassandra_SUITE).
-author('Mahesh Paolini-Subramanya <mahesh@dieswaytoofast.com>').

-include_lib("proper/include/proper.hrl").
-include_lib("common_test/include/ct.hrl").
-include_lib("erlang_cassandra/include/cassandra_types.hrl").

-compile(export_all).

-define(CHECKSPEC(M,F,N), true = proper:check_spec({M,F,N})).
-define(PROPTEST(A), true = proper:quickcheck(A())).

-define(NUMTESTS, 500).


suite() ->
    [{ct_hooks,[cth_surefire]}, {timetrap,{seconds,320}}].

init_per_suite(Config) ->
%    setup_lager(),
    setup_environment(),
    Config.

end_per_suite(_Config) ->
    ok.

connection_options() ->
    [{thrift_host, "localhost"},
     {thrift_port, 9160},
     {thrift_options, [{framed, true}]}].

pool_options(1) ->
    [];
pool_options(2) ->
    [{size, 7}];
pool_options(_) ->
    [{size, 7},
     {max_overflow, 14}].

update_config(Config) ->
    Version = cassandra_test_version(Config),
    Config1 = lists:foldl(fun(X, Acc) -> 
                    proplists:delete(X, Acc)
            end, Config, [cassandra_test_version,
                          pool_options,
                          keyspace]),
    [{cassandra_test_version, Version + 1} | Config1].

cassandra_test_version(Config) ->
    case proplists:get_value(cassandra_test_version, Config) of
        undefined -> 1;
        Val -> Val
    end.


init_per_group(_GroupName, Config) ->
    Keyspace = random_name(<<"keyspace_">>),

    Config1 = 
    case ?config(saved_config, Config) of
        {_, Config0} -> Config0;
        undefined -> Config
    end,
    Version = cassandra_test_version(Config1),
    PoolOptions = pool_options(Version),
    ConnectionOptions = connection_options(),

    Config2 = [{keyspace, Keyspace},
               {pool_options, PoolOptions},
               {connection_options, ConnectionOptions} | Config1],
    start(Config2),
    create_keyspace(Config2),
    Config2.

end_per_group(_GroupName, Config) ->
    delete_keyspace(Config),
    stop(Config),
    Config1 = update_config(Config),
    {save_config, Config1}.


init_per_testcase(_TestCase, Config) ->
    Config.

end_per_testcase(_TestCase, _Config) ->
    ok.

groups() ->
    [
     {test, [{repeat, 5}],
      [
        t_describe_keyspace
      ]}
    ].

all() ->
    [
        {group, test}
    ].

t_describe_keyspace(Config) ->
    Keyspace = ?config(keyspace, Config),
    {ok, KeyspaceDefinition} = erlang_cassandra:describe_keyspace(Keyspace),
    Keyspace = KeyspaceDefinition#ksDef.name.

random_name(Name) ->
    random:seed(erlang:now()),
    Id = list_to_binary(integer_to_list(random:uniform(999999999))),
    <<Name/binary, Id/binary>>.

create_keyspace(Config) ->
    Keyspace = ?config(keyspace, Config),
    KeyspaceDefinition = #ksDef{name=Keyspace, 
                                strategy_class="org.apache.cassandra.locator.SimpleStrategy",
                                strategy_options = dict:store("replication_factor", "1", dict:new())},
    erlang_cassandra:system_add_keyspace(KeyspaceDefinition).

delete_keyspace(Config) ->
    Keyspace = ?config(keyspace, Config),
    erlang_cassandra:system_drop_keyspace(Keyspace).


setup_environment() ->
    random:seed(erlang:now()).

setup_lager() ->
    reltool_util:application_start(lager),
    lager:set_loglevel(lager_console_backend, debug),
    lager:set_loglevel(lager_file_backend, "console.log", debug).

start(Config) ->
    ct:pal("Config:~p~n", [Config]),
    ConnectionOptions = ?config(connection_options, Config),
    PoolOptions = ?config(pool_options, Config),
    reltool_util:application_start(erlang_cassandra),
    application:set_env(erlang_cassandra, pool_options, PoolOptions),
    application:set_env(erlang_cassandra, connection_options, ConnectionOptions)
    .

stop(_Config) ->
    reltool_util:application_stop(erlang_cassandra),
    ok.
