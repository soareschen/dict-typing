{-# LANGUAGE ImplicitParams #-}
{-# LANGUAGE ConstraintKinds #-}

module Run.Run12 where

import Data.Constraint

import Core.Dict
import Core.Handler
import Core.Prototype

import App.Data
import App.Filter
import App.Handler
import App.Prototype
import App.Constraint

-- chainedProto2 :: forall a. Prototype
--   (BazConstraint a, FooBarConstraint a)
--   (String, Args)
--   a
chainedProto2 = chainProto bazProto fooBarProto

-- fooBarBazDict4 :: Dict
--   (BazConstraint (String, Args), FooBarConstraint (String, Args))
fooBarBazDict4 = runProto chainedProto2

args = Args { foo = "foo", bar = "bar" }

-- protoResult2 = "((foo: foo) (bar: bar) (baz: injected-baz))"
protoResult2 = callHandler fooBarBazHandler (fooBarBazDict4 <-> Dict) ("injected-baz", args)
