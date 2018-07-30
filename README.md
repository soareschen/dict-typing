# Dict Typing

### Solving the Haskell record problem with Data.Constraint.Dict and implicit parameters

## Overview

Dict typing is a programming technique I come out to solve the extensible record problem in Haskell. It makes use of the ConstraintKinds and ImplicitParams GHC extensions to reify implicit parameter constraints into dictionary values using Data.Constraint.Dict.

The reified constraint dictionary acts like dynamic typed object which can be safely casted in different field orders. Dict typing allows functions to accept accessor dictionaries to access particular fields of a concrete record. It also enables techniques such as prototype inheritance in Haskell by making use of first class dictionaries.

The project is currently in early development with blog posts and library publishing soon. Research is also being done on implementing algebraic effects in Haskell using similar technique.

## Presentations

  - [Haskell SG meetup, June 2018](https://slides.com/soareschen/dict-typing-haskellsg)
  - [OPLSS Participant Talk, July 2018](https://slides.com/soareschen/dict-typing-oplss)

## Related Topics

  - Row Polymorphism
  - Implicit Parameters
  - Duck Typing
  - ML Modules

## References

  - [Overcoming the Record Problem](https://www.parsonsmatt.org/overcoming-records/) - Matt Parsons
  - [Haskell record variant comparison](https://www.reddit.com/r/haskell/comments/8g8ojm/lets_create_a_comparison_table_of_all_the_haskell/)
  - [The ReaderT Design Pattern](https://www.fpcomplete.com/blog/2017/06/readert-design-pattern)
  - [The Has Constraints](https://github.com/input-output-hk/cardano-sl/blob/develop/docs/monads.md#the-has-constraints)
  - [Type Classes vs. the World](https://www.youtube.com/watch?v=hIZxTQP1ifo) - Edward Kmett
  - [Magic classes for overloaded record fields](https://ghc.haskell.org/trac/ghc/wiki/Records/OverloadedRecordFields/MagicClasses)
  - [SuperRecord: Practical Anonymous Records for Haskell](https://www.youtube.com/watch?v=Nh0XD2hPV8w)
