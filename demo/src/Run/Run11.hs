{-# LANGUAGE ImplicitParams #-}
{-# LANGUAGE ConstraintKinds #-}

module Run.Run11 (
  result3
) where

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
--   (Args, Args2)
--   a
chainedProto = fooBarProto =&= fooBazProto

-- fooBarBazDict3 :: Dict
--   (FooBarConstraint (Args, Args2),
--   (FooConstraint (Args, Args2), BazConstraint (Args, Args2)))
fooBarBazDict3 = runProto chainedProto

args = Args { foo = "foo", bar = "bar" }
args2 = Args2 { foo2 = "foo2", bar2 = "bar2", baz = "baz2" }

-- result3 = "((foo: foo) (bar: bar) (baz: baz2))"
result3 = callHandler fooBarBazHandler (fooBarBazDict3 <-> (cast Dict)) (args, args2)
