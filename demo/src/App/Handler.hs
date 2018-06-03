{-# LANGUAGE ExplicitForAll #-}
{-# LANGUAGE ImplicitParams #-}

module App.Handler where

import Data.Constraint

import Core.Handler
import App.Constraint

-- fooHandler only requires a foo field to be present
fooHandler :: forall a. Handler (FooConstraint a) a
fooHandler = makeHandler $ \x -> "(foo: " ++ (?getFoo x) ++ ")"

-- barHandler only requries a barField to be present
barHandler :: forall a. Handler (BarConstraint a) a
barHandler = makeHandler $ \x -> "(bar: " ++ (?getBar x) ++ ")"

-- Define a handler that requires all 3 foo bar baz fields
-- and print out their values.
fooBarBazHandler :: forall a. Handler (FooBarBazConstraint a) a
fooBarBazHandler = makeHandler $ \x ->
  "((foo: " ++ (?getFoo x) ++
  ") (bar: " ++ (?getBar x) ++
  ") (baz: " ++ (?getBaz x) ++ "))"
