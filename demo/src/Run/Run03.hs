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

fooDict :: Dict (FooConstraint Args)
fooDict = let ?getFoo = foo in Dict

barDict :: Dict (BarConstraint Args)
barDict = let ?getBar = bar in Dict

fooDict2 :: Dict (FooConstraint Args2)
fooDict2 = let ?getFoo = foo2 in Dict

barDict2 :: Dict (BarConstraint Args2)
barDict2 = let ?getBar = bar2 in Dict

bazDict :: Dict (BazConstraint Args2)
bazDict = let ?getBaz = baz in Dict

fooBarBazDict :: Dict (FooBarBazConstraint Args2)
fooBarBazDict = fooDict2 &-& barDict2 &-& bazDict <-> (cast Dict)

-- If we setBaz on Args, it becomes an Args2.
setBaz :: Args -> String -> Args2
setBaz (Args foo bar) value = Args2 { foo2 = foo, bar2 = bar, baz = value}

setBazDict :: Dict (SetBazConstraint Args Args2)
setBazDict = let ?setBaz = setBaz in Dict

setFooBarDict :: Dict (SetFooBarConstraint Args Args2)
setFooBarDict = (fooDict &-& barDict) &-& setBazDict

-- We can partially apply bazFilter with fooBarBazHandler
-- without settling on a concrete type yet.

-- makeFilteredHandler :: forall p a b
--   . Dict (FooBarBazConstraint b)
--   -> Handler (SetBazConstraint a b, BarConstraint a) a
makeFilteredHandler dict = applyFilter bazFilter dict fooBarBazHandler

-- Specialize the filtered handler to require the result of set baz
-- to be an Args2.

-- filteredHandler :: forall a.
--   Handler (SetBazConstraint a Args2, BarConstraint a) a
filteredHandler = makeFilteredHandler fooBarBazDict

-- We can call filteredHandler with both args and args2.

args = Args { foo = "foo", bar = "bar" }

-- filteredResult = "((foo: foo) (bar: bar) (baz: baz with bar))"
filteredResult = callHandler filteredHandler (setFooBarDict <-> (cast Dict)) args
