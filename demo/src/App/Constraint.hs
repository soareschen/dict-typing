{-# LANGUAGE ImplicitParams #-}
{-# LANGUAGE ConstraintKinds #-}

module App.Constraint where

-- We define the duck-typable fields as implicit parameter constraints
-- In practice these fields can be lenses then we can get both
-- getter and setter together.
type FooConstraint a = (?getFoo :: a -> String)
type BarConstraint a = (?getBar :: a -> String)
type BazConstraint a = (?getBaz :: a -> String)

-- Constraint synomyms to help us specify that a function require
-- multiple fields to be present.
type FooBarConstraint a = (FooConstraint a, BarConstraint a)
type FooBarBazConstraint a = (FooConstraint a, BarConstraint a, BazConstraint a)

-- Going in a little more interesting, we introduce bazSetter, which either
-- modifies an existing baz field or adds a baz field to a type by returning
-- another type.
type SetBazConstraint a b = (?setBaz :: a -> String -> b)
type SetFooBarConstraint a b = (FooBarConstraint a, SetBazConstraint a b)
type SetFooBarBazConstraint a = (FooBarBazConstraint a, SetBazConstraint a a)
