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

fooDict :: Dict (FooConstraint Args)
fooDict = let ?getFoo = foo in Dict

barDict :: Dict (BarConstraint Args)
barDict = let ?getBar = bar in Dict

-- Using the merge operator, we can merge multiple dicts
-- into a larger dict containing all implicit parameters.
fooBarDict :: Dict (FooBarConstraint Args)
fooBarDict = fooDict &-& barDict

args = Args { foo = "foo", bar = "bar" }

-- We can pass args to fooHandler and barHandler, with some verbose
-- casting if we are passing the combined dict.

-- fooResult = "(foo: foo)"
fooResult = callHandler fooHandler (fooBarDict <-> (cast Dict)) args

-- barResult = "(bar: bar)"
barResult = callHandler barHandler (fooBarDict <-> (cast Dict)) args
