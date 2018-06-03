{-# LANGUAGE ImplicitParams #-}
{-# LANGUAGE ConstraintKinds #-}
{-# LANGUAGE TemplateHaskell #-}

module Run.Run05 where

import Control.Lens
import Data.Constraint

import Core.Dict
import Core.Handler

import App.Lens

data Args = Args { _foo :: String, _bar :: String }
makeLenses ''Args

fooBarLensDict :: Dict (FooBarLensConstraint Args)
fooBarLensDict =
  let
    ?fooLens = Lenses foo
    ?barLens = Lenses bar
  in
    Dict

args = Args { _foo = "foo", _bar = "bar" }

-- "((view-foo foo) (view-bar bar))"
lensResult = callHandler fooBarLensHandler fooBarLensDict args
