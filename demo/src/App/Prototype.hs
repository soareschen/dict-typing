{-# LANGUAGE ExplicitForAll #-}
{-# LANGUAGE ImplicitParams #-}

module App.Prototype where

import Data.Constraint

import App.Data
import App.Constraint
import Core.Prototype

fooBarProto :: forall a. Prototype (FooBarConstraint a) Args a
fooBarProto = Prototype $ \getArg ->
  let
    ?getFoo = foo . getArg
    ?getBar = bar . getArg
  in
    Dict

fooBazProto :: forall a. Prototype (FooConstraint a, BazConstraint a) Args2 a
fooBazProto = Prototype $ \getArg ->
  let
    ?getFoo = foo2 . getArg
    ?getBaz = baz . getArg
  in
    Dict

bazProto :: forall a. Prototype (BazConstraint a) String a
bazProto = Prototype $ \getBaz ->
  let ?getBaz = getBaz in Dict
