{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE ImplicitParams #-}
{-# LANGUAGE ConstraintKinds #-}

module App.Lens where

import Control.Lens

import Core.Handler

-- We have to wrap the lens inside a newtype/data container
-- as otherwise it cannot be passed through implicit parameters
-- due to restriction on impredicative polymorphism in Haskell
newtype Lenses s a = Lenses { getLens :: Lens' s a }

type FooLensConstraint a = (?fooLens :: Lenses a String)
type BarLensConstraint a = (?barLens :: Lenses a String)

type FooBarLensConstraint a = (FooLensConstraint a, BarLensConstraint a)

fooBarLensHandler :: forall a. Handler (FooBarLensConstraint a) a
fooBarLensHandler = makeHandler $ \x ->
  "((view-foo " ++ (view (getLens ?fooLens) x) ++ ") " ++
  "(view-bar " ++ (view (getLens ?barLens) x) ++ "))"
