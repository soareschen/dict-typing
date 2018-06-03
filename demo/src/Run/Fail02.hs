{-# LANGUAGE ExplicitForAll #-}
{-# LANGUAGE ImplicitParams #-}
{-# LANGUAGE ConstraintKinds #-}

module Run.Fail02 where

import Data.Constraint

import Core.Dict
import Core.Handler

-- This demo demonstrates what happen when a dictionary
-- constains multiple implicit parameters of the same name
-- but with different type signatures. With the merge
-- operator (&-&) for dictionaries, it is possible
-- to construct such dictionary. However the right most
-- appearance of the implicit parameter of a given name
-- would lock in the type signature, and disallow usage
-- of other implicit parameters of the same name but
-- with different type signatures.

-- The result shows that the merge / union of implicit
-- parameters is somehow safe, as it statically enforce
-- that each "record field" must have only one unique
-- definition.

type Foo1Constraint a = (?getFoo :: a -> String)

-- Foo2Constraint defines implicit parameter of the same
-- name but with different type signature.
type Foo2Constraint a = (?getFoo :: a -> Int -> Int)

data Args = Args { foo :: String }

fooDict1 :: Dict (Foo1Constraint Args)
fooDict1 =
  let
    ?getFoo = foo
  in
    Dict

fooDict2 :: Dict (Foo2Constraint Args)
fooDict2 =
  let
    ?getFoo = \_ x -> x + 1
  in
    Dict

-- When merging fooDict1 and fooDict2, we get a dictionary
-- containing both ?getFoo definitions, seemingly violating
-- the uniqueness constraint of record fields.
fooDict3 :: Dict (Foo1Constraint Args, Foo2Constraint Args)
fooDict3 = fooDict1 &-& fooDict2

foo1Handler :: forall a. Handler (Foo1Constraint a) a
foo1Handler = makeHandler $ \x ->
  "(foo1 " ++ (?getFoo x) ++ ")"

foo2Handler :: forall a. Handler (Foo2Constraint a) a
foo2Handler = makeHandler $ \x ->
  "(foo2 " ++ (show (?getFoo x 8)) ++ ")"

args = Args { foo = "foo" }

-- However we'd fail to cast fooDict3 back to fooDict1, as
-- fooDict2 appears on the right side and locks in the
-- type signature for ?getFoo.
-- foo1Result = callHandler foo1Handler (fooDict3 <-> (cast Dict)) args

-- We can cast fooDict3 back to fooDict2 to be called with foo2Handler.
-- This is because fooDict2 has the right most definition of ?getFoo. 
foo2Result = callHandler foo2Handler (fooDict3 <-> (cast Dict)) args

-- We can still call foo1Handler with fooDict1, showing that
-- ?getFoo can still have multiple definitions as long as
-- not appearing locally at the same time.
foo1Result2 = callHandler foo1Handler fooDict1 args
