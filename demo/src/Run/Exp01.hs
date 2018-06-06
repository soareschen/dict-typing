{-# LANGUAGE ExplicitForAll #-}
{-# LANGUAGE ImplicitParams #-}
{-# LANGUAGE ConstraintKinds #-}

module Run.Exp01 where

import Data.Constraint

import Core.Dict
import Core.Handler

-- Consider merging the two dictionaries
-- with the same parameters but with different orders and values.
-- Since dict1 appears on the left, it should have overridden
-- all values of dict2.

dict1 :: Dict (?a :: String, ?b :: String, ?c :: String)
dict1 = let ?a = "a1"; ?b = "b1"; ?c = "c1" in Dict

dict2 :: Dict (?c :: String, ?b :: String, ?a :: String)
dict2 = let ?a = "a2"; ?b = "b2"; ?c = "c2" in Dict

dict3 = dict1 &-& dict2

showParam :: (?a :: String, ?b :: String, ?c :: String) => String
showParam = ?a ++ " " ++ ?b ++ " " ++ ?c

showDict :: Dict (?a :: String, ?b :: String, ?c :: String) -> String
showDict Dict = showParam

-- castResult1 = "a1 b1 c1"
castResult1 = showDict $ ((dict3 <-> Dict)
  :: Dict (?a :: String, ?b :: String, ?c :: String)) <-> Dict

-- However when we cast the merged dict3 into the target dict
-- with exact same order as dict2, it returns dict2 instead.

-- castResult2 = "a2 b2 c2"
castResult2 = showDict $ ((dict3 <-> Dict)
  :: Dict (?c :: String, ?b :: String, ?a :: String)) <-> Dict

-- All the other casting show only values from dict1, which
-- should be the expected behavior.

-- castResult3 = "a1 b1 c1"
castResult3 = showDict $ ((dict3 <-> Dict)
  :: Dict (?c :: String, ?a :: String, ?b :: String)) <-> Dict

-- castResult4 = "a1 b1 c1"
castResult4 = showDict $ ((dict3 <-> Dict)
  :: Dict (?b :: String, ?a :: String, ?c :: String)) <-> Dict

-- Note that when using implicit parameters as regular constraints,
-- the bug doesn't show up and we always get values of dict1.

showParam2 :: (?c :: String, ?b :: String, ?a :: String) => String
showParam2 = ?a ++ " " ++ ?b ++ " " ++ ?c

showDict2 :: Dict (?c :: String, ?b :: String, ?a :: String) -> String
showDict2 Dict = showParam2

-- Calling showParam2 directly casts properly
-- castResult5 = "a1 b1 c1"
castResult5 = case dict3 of Dict -> showParam2

-- Calling showDict2 after explicit cast still produce wrong result
-- castResult6 = "a2 b2 c2"
castResult6 = case dict3 of Dict -> showDict2 Dict

properCast :: (?c :: String, ?b :: String, ?a :: String) => Dict (?c :: String, ?b :: String, ?a :: String)
properCast = Dict

-- Explicitly providing a full cast proof work
-- castResult7 = "a1 b1 c1"
castResult7 = case dict3 of Dict -> showDict2 properCast

-- Creating a generic cast produces wrong result
improperCast :: forall p. p => Dict p
improperCast = Dict

-- castResult8 = "a2 b2 c2"
castResult8 = case dict3 of Dict -> showDict2 improperCast

-- Expanding the automatic entailment, we can see that dict4 also have
-- the bug with castResult6 showing the wrong result

dict4 :: ((?a :: String, ?b :: String, ?c :: String),
          (?c :: String, ?b :: String, ?a :: String))
         => Dict (?c :: String, ?b :: String, ?a :: String)
dict4 = Dict

-- castResult10 = "a2 b2 c2"
castResult10 = showDict $ (dict3 <-> dict4) <-> Dict
