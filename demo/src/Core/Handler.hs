{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE ExplicitForAll #-}
{-# LANGUAGE ConstraintKinds #-}

module Core.Handler where

import Data.Constraint

import Core.Dict

-- A handler is a polymorphic function accepts a duck type a,
-- with a dict that contains implicit parameters that give
-- access to the required fields. For simplicity we use
-- String as the return type as we want to focus on
-- duck typing the argument for now.
data Handler p a = Handler (Dict p -> a -> String)

makeHandler :: forall p a. (p => a -> String) -> Handler p a
makeHandler f = Handler $ \Dict -> f

-- Given an a and the accompanying dict, we can call a
-- handler and get back the result.
callHandler :: forall p a. Handler p a -> Dict p -> a -> String
callHandler (Handler h) dict = h dict

-- Similar to casting dicts, we can cast handlers into
-- different permutations of its constraints.
castHandler :: forall p q a. Handler q a -> Cast p q -> Handler p a
castHandler h casted = Handler $ \dict ->
  callHandler h (castDict dict casted)
