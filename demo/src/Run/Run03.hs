{-# LANGUAGE ImplicitParams #-}
{-# LANGUAGE ConstraintKinds #-}

module Run.Run03 (
  filteredResult
) where

import Data.Constraint

import Core.Dict
import Core.Handler
import Core.Filter

import App.Data
import App.Filter
import App.Handler
import App.Constraint

fooDict :: Dict (FooConstraint Env)
fooDict = let ?getFoo = foo in Dict

barDict :: Dict (BarConstraint Env)
barDict = let ?getBar = bar in Dict

fooDict2 :: Dict (FooConstraint Env2)
fooDict2 = let ?getFoo = foo2 in Dict

barDict2 :: Dict (BarConstraint Env2)
barDict2 = let ?getBar = bar2 in Dict

bazDict :: Dict (BazConstraint Env2)
bazDict = let ?getBaz = baz in Dict

fooBarBazDict :: Dict (FooBarBazConstraint Env2)
fooBarBazDict = fooDict2 &-& barDict2 &-& bazDict <-> Dict

-- If we setBaz on Env, it becomes an Env2.
setBaz :: Env -> String -> Env2
setBaz (Env foo bar) value = Env2 { foo2 = foo, bar2 = bar, baz = value}

setBazDict :: Dict (SetBazConstraint Env Env2)
setBazDict = let ?setBaz = setBaz in Dict

setFooBarDict :: Dict (SetFooBarConstraint Env Env2)
setFooBarDict = (fooDict &-& barDict) &-& setBazDict

-- We can partially apply bazFilter with fooBarBazHandler
-- without settling on a concrete type yet.

-- makeFilteredHandler :: forall p a b
--   . Dict (FooBarBazConstraint b)
--   -> Handler (SetBazConstraint a b, BarConstraint a) a
makeFilteredHandler dict = applyFilter bazFilter dict fooBarBazHandler

-- Specialize the filtered handler to require the result of set baz
-- to be an Env2.

-- filteredHandler :: forall a.
--   Handler (SetBazConstraint a Env2, BarConstraint a) a
filteredHandler = makeFilteredHandler fooBarBazDict

-- We can call filteredHandler with both env and env2.

env = Env { foo = "foo", bar = "bar" }

-- filteredResult = "((foo: foo) (bar: bar) (baz: baz with bar))"
filteredResult = callHandler filteredHandler (setFooBarDict <-> Dict) env
