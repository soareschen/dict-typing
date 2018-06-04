{-# LANGUAGE ExplicitForAll #-}
{-# LANGUAGE ImplicitParams #-}
{-# LANGUAGE ConstraintKinds #-}

module Run.Run07 where

import Data.Monoid
import Data.Constraint

import Core.Dict
import Core.Handler

import App.Data
import App.Constraint

fooDict :: Dict (FooConstraint Args)
fooDict = let ?getFoo = foo in Dict

barDict :: Dict (BarConstraint Args)
barDict = let ?getBar = bar in Dict

-- Using the merge operator, we can merge multiple dicts
-- into a larger dict containing all implicit parameters.
fooBarDict :: Dict (FooBarConstraint Args)
fooBarDict = fooDict &-& barDict

-- With the handler abstraction, we can easily compose them
-- without too much trouble fighting with Haskell's automatic
-- constraint resolution.

-- The demo compose handler takes in two handlers and return a
-- handler that requires a dict that satisfy constraints from both
-- inner handlers. Note that we have to cast the dicts before
-- passing to the inner handlers.
composeHandler :: forall p q r a
  . Monoid r
  => (Dict p -> a -> r)
  -> (Dict q -> a -> r)
  -> Dict (p, q)
  -> a
  -> r
composeHandler f g dict =
  let
    f' = f (dict <-> Dict)
    g' = g (dict <-> Dict)
  in
    \x -> (f' x) <> (g' x)

fooHandler :: forall a. Dict (FooConstraint a) -> a -> String
fooHandler Dict x = "(foo: " ++ (?getFoo x) ++ ")"

-- barHandler only requries a barField to be present
barHandler :: forall a. Dict (BarConstraint a) -> a -> String
barHandler Dict x = "(bar: " ++ (?getBar x) ++ ")"

fooBarHandler = composeHandler fooHandler barHandler

args = Args { foo = "foo", bar = "bar" }

monoidResult = fooBarHandler fooBarDict args
