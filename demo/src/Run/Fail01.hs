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

fooBarDict :: Dict (FooBarConstraint Args)
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
    ?getBar = \_ -> "default-foo"
    ?getBaz = \_ -> "default-baz"
  in
    Dict

combinedDict :: Dict (FooBarBazConstraint Args)
combinedDict = fooBarDict &-& (defaultDict @Args) <-> (cast Dict)

args = Args { foo = "foo", bar = "bar" }

-- Correct: "((foo: foo) (bar: bar) (baz: default-baz))"
-- Wrong: "((foo: default-foo) (bar: default-foo) (baz: default-baz))"
defaultResult = callHandler fooBarBazHandler combinedDict args
