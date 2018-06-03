{-# LANGUAGE ExplicitForAll #-}

module Core.Filter where

import Data.Constraint

import Core.Dict
import Core.Handler

-- A filter takes in a handler and its required dict, and return a new
-- handler that takes in a different type and constraints.
data Filter p a q b = Filter (Dict q -> (Handler q b) -> (Handler p a))

applyFilter :: forall p q a b. Filter p a q b -> Dict q -> Handler q b -> Handler p a
applyFilter (Filter f) inDict h = f inDict h

-- If we expect the filter to not change the type of its argument,
-- we can use applyFilter' which applies a filter on handler accepting
-- the same argument type.
applyFilter' :: forall p q a. Filter p a q a -> Handler q a -> Handler (p, q) a
applyFilter' (Filter f) h = Handler $ \dict ->
  callHandler (f (dict <-> (cast Dict)) h) (dict <-> (cast Dict))
