{-# LANGUAGE ExplicitForAll #-}
{-# LANGUAGE ImplicitParams #-}
{-# LANGUAGE ConstraintKinds #-}

module Run.Run02 (
  fooBarResult
) where

import Data.Constraint

import Core.Dict
import Core.Handler

import App.Data
import App.Handler
import App.Constraint

fooDict :: Dict (FooConstraint Args2)
fooDict = let ?getFoo = foo2 in Dict

barDict :: Dict (BarConstraint Args2)
barDict = let ?getBar = bar2 in Dict

bazDict :: Dict (BazConstraint Args2)
bazDict = let ?getBaz = baz in Dict

-- To merge 3 dicts, we have to use cast to "flatten"
-- the structure of the dict, because otherwise we get
-- Dict (FooConstraint Args2, (BarConstraint Args2, BazConstraint Args2))
-- which is not the same as
-- Dict (FooConstraint Args2, BarConstraint Args2, BazConstraint Args2)
-- (note the parenthesis)
fooBarBazDict :: Dict (FooBarBazConstraint Args2)
fooBarBazDict = fooDict &-& barDict &-& bazDict <-> (cast Dict)

args = Args2 { foo2 = "foo2", bar2 = "bar2", baz = "baz2" }

-- With the handler abstraction, we can easily compose them
-- without too much trouble fighting with Haskell's automatic
-- constraint resolution.

-- The demo compose handler takes in two handlers and return a
-- handler that requires a dict that satisfy constraints from both
-- inner handlers. Note that we have to cast the dicts before
-- passing to the inner handlers.
composeHandler :: forall p q r a. Handler p a -> Handler q a -> Handler (p, q) a
composeHandler f g = Handler $ \dict x ->
  let Dict = dict in
    "(composed: " ++ (callHandler f (dict <-> (cast Dict)) x) ++
    " " ++ (callHandler g (dict <-> (cast Dict)) x) ++ ")"

-- fooBarHandler is a composition of fooHandler and barHandler
-- fooBarHandler :: Handler (FooConstraint a, BarConstraint a) a
fooBarHandler = composeHandler fooHandler barHandler

-- We can also pass args2 to any of the handlers as they also have both fields

-- fooBarResult = "(composed: (foo: foo2) (bar: bar2))"
fooBarResult = callHandler fooBarHandler (fooBarBazDict <-> (cast Dict)) args
