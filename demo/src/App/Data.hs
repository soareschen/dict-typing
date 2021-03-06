module App.Data where

-- If we want to pass for example an instance of Dict (Foo a, Bar a)
-- to a function that accepts a Dict (Bar a), we can cast it as follow:
-- barDict = (fooBarDict <-> Dict)
--
-- The casting operation is a bit verbose, but Haskell does most of the
-- work for us recognizing that it is always safe to cast different
-- subsets and permutations of the same set of constraints.

-- Here we have two example types that we are going to use for duck typing.
-- Both Env and Env2 have the foo and bar fields. Note that we are
-- naming the fields in Env as foo2 and bar2 to avoid ambiguous field
-- accessor errors.
data Env = Env { foo :: String, bar :: String }

data Env2 = Env2 { foo2 :: String, bar2 :: String, baz :: String }
