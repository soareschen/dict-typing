{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE ConstraintKinds #-}

module Core.Dict where

import Data.Constraint

type Cast p q = p :- q

cast :: forall p q. (p => Dict q) -> p :- q
cast dict = Sub dict

-- Merge two dicts together and product a new dict with witness
-- for both constraints
mergeDict :: forall p q. Dict p -> Dict q -> Dict (p, q)
mergeDict Dict Dict = Dict

-- Given an entailment from p to q, we can cast a dict from
-- Dict p to Dict q. This is the same as mapDict in Data.Constraint.
castDict :: forall p q. Dict p -> p :- q -> Dict q
castDict = flip mapDict

-- We are using castDict mainly to cast between different subsets and
-- permutations of the constraints in a dict. This is required because
-- for example Dict (Foo a, Bar a), Dict (Bar a, Foo a),
-- Dict (Foo a), and Dict (Bar a) are all recognized by Haskell as
-- distinct types.

infixr 8 &-&
(&-&) = mergeDict

infixr 7 <->
(<->) = castDict
