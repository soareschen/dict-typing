{-# LANGUAGE ExplicitForAll #-}
{-# LANGUAGE ImplicitParams #-}
{-# LANGUAGE ConstraintKinds #-}
{-# LANGUAGE TypeApplications #-}

module Run.Fail01 where

import Data.Constraint

import Core.Dict
import Core.Handler

import App.Data
import App.Handler
import App.Constraint

-- We can construct default dictionary that is overridable when merging
-- with implementation dictionaries. The trick is when multiple implicit
-- parameters are present inside a dictionary, only the first implicit
-- parameter should be used.

type BazBarFooConstraint a = (BazConstraint a, BarConstraint a, FooConstraint a)

fooBarDict :: Dict (FooBarConstraint Env)
fooBarDict =
  let
    ?getFoo = foo
    ?getBar = bar
  in
    Dict

-- Curiously there might be a bug in GHC that prevents default dictionaries
-- from working. The problem is during casting, when the target constraint
-- set is an exact match of one of the source constraint subset, GHC will
-- pick the particular constraint subset regardless of its order.

-- Uncomment this type signature to produce the correct result.
defaultDict :: forall a. Dict (BazBarFooConstraint a)

-- defaultDict :: forall a. Dict (FooBarBazConstraint a)
defaultDict =
  let
    ?getFoo = \_ -> "default-foo"
    ?getBar = \_ -> "default-bar"
    ?getBaz = \_ -> "default-baz"
  in
    Dict

combinedDict :: Dict (FooBarBazConstraint Env)
combinedDict = fooBarDict &-& (defaultDict @Env) <-> Dict

env = Env { foo = "foo", bar = "bar" }

-- Correct: "((foo: foo) (bar: bar) (baz: default-baz))"
-- Wrong: "((foo: default-foo) (bar: default-foo) (baz: default-baz))"
defaultResult = callHandler fooBarBazHandler combinedDict env


-- As a demonstration, consider merging the two dictionaries
-- with the same parameters but with different orders and values.
-- Since dict1 appears on the left, it should have overridden
-- all values of dict2.

dict1 :: Dict (?a :: String, ?b :: String, ?c :: String)
dict1 = let ?a = "a1"; ?b = "b1"; ?c = "c1" in Dict

dict2 :: Dict (?c :: String, ?b :: String, ?a :: String)
dict2 = let ?a = "a2"; ?b = "b2"; ?c = "c2" in Dict

dict3 = dict1 &-& dict2

showDict :: Dict (?a :: String, ?b :: String, ?c :: String) -> String
showDict Dict = ?a ++ " " ++ ?b ++ " " ++ ?c

-- castResult1 = "a1 b1 c1"
castResult1 = showDict $ ((dict3 <-> Dict)
  :: Dict (?a :: String, ?b :: String, ?c :: String)) <-> Dict

-- However when we cast the merged dict3 into the target dict
-- with exact same order as dict2, it returns dict2 instead.

-- castResult2 = "a2 b2 c2"
castResult2 = showDict $ ((dict3 <-> Dict)
  :: Dict (?c :: String, ?b :: String, ?a :: String)) <-> Dict

-- All the other casting show only values from dict1, which
-- should be the expected behavior.

-- castResult3 = "a1 b1 c1"
castResult3 = showDict $ ((dict3 <-> Dict)
  :: Dict (?c :: String, ?a :: String, ?b :: String)) <-> Dict

-- castResult4 = "a1 b1 c1"
castResult4 = showDict $ ((dict3 <-> Dict)
  :: Dict (?b :: String, ?a :: String, ?c :: String)) <-> Dict

-- Note that when using implicit parameters as regular constraints,
-- the bug doesn't show up and we always get values of dict1.
showDict2 :: (?c :: String, ?b :: String, ?a :: String) => String
showDict2 = ?a ++ " " ++ ?b ++ " " ++ ?c

-- castResult5 = "a1 b1 c1"
castResult5 = case dict3 of
  Dict -> showDict2
