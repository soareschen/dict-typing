{-# LANGUAGE GADTs #-}
{-# LANGUAGE ExplicitForAll #-}
{-# LANGUAGE KindSignatures #-}

module Core.Prototype where

import Data.Constraint

import Core.Dict

-- Prototype Inheritence using Dict Typing
-- Work In Progress

data Prototype (p :: Constraint) e a where
  Prototype :: ((a -> e) -> Dict p) -> Prototype p e a

chainProto :: forall p1 p2 e1 e2 a.
  Prototype p1 e1 a
  -> Prototype p2 e2 a
  -> Prototype (p1, p2) (e1, e2) a
chainProto (Prototype makeDict1) (Prototype makeDict2) =
  Prototype $ \getElement ->
    (makeDict1 (fst . getElement)) &-&
    (makeDict2 (snd . getElement))

infixr 8 =&=
(=&=) = chainProto

runProto :: forall p e. Prototype p e e -> Dict p
runProto (Prototype makeDict) = makeDict id
