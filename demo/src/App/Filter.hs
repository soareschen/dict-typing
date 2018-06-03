{-# LANGUAGE ExplicitForAll #-}
{-# LANGUAGE ImplicitParams #-}

module App.Filter where

import Data.Constraint

import Core.Handler
import Core.Filter

import App.Handler
import App.Constraint

-- A baz filter injects a value to the baz field, overriding any
-- existing value. It only requires that baz is settable in a
-- and it can read bar from a.
bazFilter :: forall p a b. Filter
  (SetBazConstraint a b, BarConstraint a)
  a p b
bazFilter =
  Filter $ \inDict h ->
    makeHandler $ \x ->
      let
        y = ?setBaz x ("baz with " ++ (?getBar x))
      in
        callHandler h inDict y
