{-# LANGUAGE ImplicitParams #-}
{-# LANGUAGE ConstraintKinds #-}

module Run.Run01 (
  fooResult,
  barResult
) where

import Data.Constraint

import Core.Dict
import Core.Handler

import App.Data
import App.Handler
import App.Constraint

fooDict :: Dict (FooConstraint Env)
fooDict = let ?getFoo = foo in Dict

barDict :: Dict (BarConstraint Env)
barDict = let ?getBar = bar in Dict

-- Using the merge operator, we can merge multiple dicts
-- into a larger dict containing all implicit parameters.
fooBarDict :: Dict (FooBarConstraint Env)
fooBarDict = fooDict &-& barDict

env = Env { foo = "foo", bar = "bar" }

-- We can pass env to fooHandler and barHandler, with some verbose
-- casting if we are passing the combined dict.

-- fooResult = "(foo: foo)"
fooResult = callHandler fooHandler (fooBarDict <-> Dict) env

-- barResult = "(bar: bar)"
barResult = callHandler barHandler (fooBarDict <-> Dict) env
