{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE ImplicitParams #-}
{-# LANGUAGE ExplicitForAll #-}
{-# LANGUAGE ConstraintKinds #-}

module Run.Run06 where

import Data.Constraint
import Control.Monad.Reader

import Core.Dict
import Core.Handler

import App.Constraint

data Env = Env { foo :: String, bar :: String }

fooHandler :: forall a m. MonadReader a m => Dict (FooConstraint a) -> m String
fooHandler Dict = do
  x <- ask
  return $ ?getFoo x

barHandler :: forall a m. MonadReader a m => Dict (BarConstraint a) -> m String
barHandler Dict = do
  x <- ask
  return $ ?getBar x

composeHandler :: forall a m p q
  . MonadReader a m
  => (Dict p -> m String)
  -> (Dict q -> m String)
  -> Dict (p, q)
  -> m String
composeHandler f g dict = do
  x1 <- f (dict <-> Dict)
  x2 <- g (dict <-> Dict)
  return $
    "(composed " ++ x1 ++ " " ++ x2 ++ ")"

fooBarHandler :: forall a m. MonadReader a m => Dict (FooBarConstraint a) -> m String
fooBarHandler = composeHandler fooHandler barHandler

fooBarDict :: Dict (FooBarConstraint Env)
fooBarDict =
  let
    ?getFoo = foo
    ?getBar = bar
  in
    Dict

env = Env { foo = "foo", bar = "bar" }

monadResult = runReader (fooBarHandler fooBarDict) env
