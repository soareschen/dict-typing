{-# LANGUAGE ImplicitParams #-}
{-# LANGUAGE ConstraintKinds #-}

module Run.Run04 (
  filteredResult2
) where

import Data.Constraint

import Core.Dict
import Core.Handler
import Core.Filter

import App.Data
import App.Filter
import App.Handler
import App.Constraint

fooDict :: Dict (FooConstraint Args2)
fooDict = let ?getFoo = foo2 in Dict

barDict :: Dict (BarConstraint Args2)
barDict = let ?getBar = bar2 in Dict

bazDict :: Dict (BazConstraint Args2)
bazDict = let ?getBaz = baz in Dict

setBaz :: Args2 -> String -> Args2
setBaz (Args2 foo bar _) value = Args2 { foo2 = foo, bar2 = bar, baz = value}

setBazDict :: Dict (SetBazConstraint Args2 Args2)
setBazDict = let ?setBaz = setBaz in Dict

fooBarBazDict :: Dict (FooBarBazConstraint Args2)
fooBarBazDict = fooDict &-& barDict &-& bazDict <-> (cast Dict)

setFooBarBazDict :: Dict (SetFooBarBazConstraint Args2)
setFooBarBazDict = fooBarBazDict &-& setBazDict

-- Notice that by explicitly passing dictionaries around, we can
-- have two definitions of implicits for Args and Args2 isolated
-- in separate dictionaries. When calling the inner handler,
-- fooBarBazDict is used to reference implicits such as ?getFoo.
-- This wouldn't have been possible when using implicits in normal
-- context, as we can't define two implicits of the same name
-- for different types.

-- We can also use applyFilter' to require the filter and handler
-- both accepts the same argument type.

-- filteredHandler2 :: Handler
--   ((SetBazConstraint a a, BarConstraint a),
--    FooBarBazConstraint a)
--   a
filteredHandler2 = applyFilter' bazFilter fooBarBazHandler

-- In this case it would not be possible to apply filteredHandler2
-- to args, as args do not implements a SetBazConstraint that
-- returns Args.

args = Args2 { foo2 = "foo2", bar2 = "bar2", baz = "baz2" }

-- filteredResult2 = "((foo: foo2) (bar: bar2) (baz: baz with bar2))"
filteredResult2 = callHandler filteredHandler2 (setFooBarBazDict <-> (cast Dict)) args
