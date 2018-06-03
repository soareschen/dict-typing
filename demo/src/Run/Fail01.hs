{-# LANGUAGE ExplicitForAll #-}
{-# LANGUAGE ImplicitParams #-}
{-# LANGUAGE ConstraintKinds #-}

module Run.Fail01 where

import Data.Constraint

import Core.Dict
import Core.Handler

import App.Data
import App.Handler
import App.Constraint

type BazBarFooConstraint a = (BazConstraint a, BarConstraint a, FooConstraint a)

fooBarDict :: Dict (FooBarConstraint Args)
fooBarDict =
  let
    ?getFoo = foo
    ?getBar = bar
  in
    Dict

-- defaultDict :: forall a. Dict (BazBarFooConstraint a)
defaultDict :: forall a. Dict (FooBarBazConstraint a)
defaultDict =
  let
    ?getFoo = \_ -> "default-foo"
    ?getBar = \_ -> "default-foo"
    ?getBaz = \_ -> "default-baz"
  in
    Dict

-- combinedDict :: Dict (FooBarConstraint Args, (BazBarFooConstraint Args))
combinedDict :: Dict (FooBarConstraint Args, (FooBarBazConstraint Args))
combinedDict = fooBarDict &-& defaultDict

args = Args { foo = "foo", bar = "bar" }

defaultResult = callHandler fooBarBazHandler (combinedDict <-> (cast Dict)) args
