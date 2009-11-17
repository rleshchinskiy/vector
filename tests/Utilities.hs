module Utilities where

import Test.QuickCheck

import qualified Data.Vector as DV
import qualified Data.Vector.Generic as DVG
import qualified Data.Vector.Primitive as DVP
import qualified Data.Vector.Fusion.Stream as S


instance Show a => Show (S.Stream a) where
    show s = "Data.Vector.Fusion.Stream.fromList " ++ show (S.toList s)


instance Arbitrary a => Arbitrary (DV.Vector a) where
    arbitrary = fmap DV.fromList arbitrary
    coarbitrary = coarbitrary . DV.toList

instance (Arbitrary a, DVP.Prim a) => Arbitrary (DVP.Vector a) where
    arbitrary = fmap DVP.fromList arbitrary
    coarbitrary = coarbitrary . DVP.toList

instance Arbitrary a => Arbitrary (S.Stream a) where
    arbitrary = fmap S.fromList arbitrary
    coarbitrary = coarbitrary . S.toList


class Model a b | a -> b where
  -- | Convert a concrete value into an abstract model
  model :: a -> b

-- The meat of the models
instance               Model (DV.Vector a)  [a] where model = DV.toList
instance DVP.Prim a => Model (DVP.Vector a) [a] where model = DVP.toList

-- Identity models
instance Model Bool     Bool     where model = id
instance Model Int      Int      where model = id
instance Model Float    Float    where model = id
instance Model Double   Double   where model = id
instance Model Ordering Ordering where model = id

-- Functorish models
-- All of these need UndecidableInstances although they are actually well founded. Oh well.
instance Model a b                            => Model (Maybe a) (Maybe b)    where model           = fmap model
instance (Model a a', Model b b')             => Model (a, b) (a', b')        where model (a, b)    = (model a, model b)
instance (Model a a', Model b b', Model c c') => Model (a, b, c) (a', b', c') where model (a, b, c) = (model a, model b, model c)
instance (Model c a, Model b d)               => Model (a -> b) (c -> d)      where model f         = model . f . model


eq0 f g =             model f           == g
eq1 f g = \a       -> model (f a)       == g (model a)
eq2 f g = \a b     -> model (f a b)     == g (model a) (model b)
eq3 f g = \a b c   -> model (f a b c)   == g (model a) (model b) (model c)
eq4 f g = \a b c d -> model (f a b c d) == g (model a) (model b) (model c) (model d)

eqNotNull1 f g = \a       -> (not (DVG.null a)) ==> eq1 f g a
eqNotNull2 f g = \a b     -> (not (DVG.null b)) ==> eq2 f g a b
eqNotNull3 f g = \a b c   -> (not (DVG.null c)) ==> eq3 f g a b c
eqNotNull4 f g = \a b c d -> (not (DVG.null d)) ==> eq4 f g a b c d
