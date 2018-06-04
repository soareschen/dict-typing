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

fooDict :: Dict (FooConstraint Env2)
fooDict = let ?getFoo = foo2 in Dict

barDict :: Dict (BarConstraint Env2)
barDict = let ?getBar = bar2 in Dict

bazDict :: Dict (BazConstraint Env2)
bazDict = let ?getBaz = baz in Dict

setBaz :: Env2 -> String -> Env2
setBaz (Env2 foo bar _) value = Env2 { foo2 = foo, bar2 = bar, baz = value}

setBazDict :: Dict (SetBazConstraint Env2 Env2)
setBazDict = let ?setBaz = setBaz in Dict

fooBarBazDict :: Dict (FooBarBazConstraint Env2)
fooBarBazDict = fooDict &-& barDict &-& bazDict <-> Dict

setFooBarBazDict :: Dict (SetFooBarBazConstraint Env2)
setFooBarBazDict = fooBarBazDict &-& setBazDict

-- Notice that by explicitly passing dictionaries around, we can
-- have two definitions of implicits for Env and Env2 isolated
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
-- to env, as env do not implements a SetBazConstraint that
-- returns Env.

env = Env2 { foo2 = "foo2", bar2 = "bar2", baz = "baz2" }

-- filteredResult2 = "((foo: foo2) (bar: bar2) (baz: baz with bar2))"
filteredResult2 = callHandler filteredHandler2 (setFooBarBazDict <-> Dict) env
