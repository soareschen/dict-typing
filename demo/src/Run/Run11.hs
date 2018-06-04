{-# LANGUAGE ImplicitParams #-}
{-# LANGUAGE ConstraintKinds #-}

module Run.Run11 where

import Data.Constraint

import Core.Dict
import Core.Handler
import Core.Prototype

import App.Data
import App.Filter
import App.Handler
import App.Constraint
import App.Prototype

-- chainedProto :: forall a. Prototype
--   (FooBarConstraint a, (FooConstraint a, BazConstraint a))
--   (Env, Env2)
--   a
chainedProto = fooBarProto =&= fooBazProto

-- fooBarBazDict3 :: Dict
--   (FooBarConstraint (Env, Env2),
--   (FooConstraint (Env, Env2), BazConstraint (Env, Env2)))
fooBarBazDict3 = runProto chainedProto

env = Env { foo = "foo", bar = "bar" }
env2 = Env2 { foo2 = "foo2", bar2 = "bar2", baz = "baz2" }

-- protoResult1 = "((foo: foo) (bar: bar) (baz: baz2))"
protoResult1 = callHandler fooBarBazHandler (fooBarBazDict3 <-> Dict) (env, env2)
