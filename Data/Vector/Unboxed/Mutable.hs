-- |
-- Module      : Data.Vector.Unboxed.Mutable
-- Copyright   : (c) Roman Leshchinskiy 2009-2010
-- License     : BSD-style
--
-- Maintainer  : Roman Leshchinskiy <rl@cse.unsw.edu.au>
-- Stability   : experimental
-- Portability : non-portable
--
-- Mutable adaptive unboxed vectors
--

module Data.Vector.Unboxed.Mutable (
  -- * Mutable vectors of primitive types
  MVector(..), IOVector, STVector, Unbox,

  -- * Accessors

  -- ** Length information
  length, null,

  -- ** Extracting subvectors
  slice, init, tail, take, drop,
  unsafeSlice, unsafeInit, unsafeTail, unsafeTake, unsafeDrop,

  -- ** Overlapping
  overlaps,

  -- * Construction

  -- ** Initialisation
  new, unsafeNew, replicate, clone,

  -- ** Growing
  grow, unsafeGrow,

  -- ** Restricting memory usage
  clear,

  -- * Zipping and unzipping
  zip, zip3, zip4, zip5, zip6,
  unzip, unzip3, unzip4, unzip5, unzip6,

  -- * Accessing individual elements
  read, write, swap,
  unsafeRead, unsafeWrite, unsafeSwap,

  -- * Modifying vectors

  -- ** Filling and copying
  set, copy, unsafeCopy,

  -- * Deprecated operations
  newWith, unsafeNewWith

) where

import Data.Vector.Unboxed.Base
import qualified Data.Vector.Generic.Mutable as G
import Control.Monad.Primitive

import Prelude hiding ( length, null, replicate, reverse, map, read,
                        take, drop, init, tail,
                        zip, zip3, unzip, unzip3 )

#include "vector.h"

-- Length information
-- ------------------

-- | Length of the mutable vector.
length :: Unbox a => MVector s a -> Int
{-# INLINE length #-}
length = G.length

-- | Check whether the vector is empty
null :: Unbox a => MVector s a -> Bool
{-# INLINE null #-}
null = G.null

-- Extracting subvectors
-- ---------------------

-- | Yield a part of the mutable vector without copying it.
slice :: Unbox a => Int -> Int -> MVector s a -> MVector s a
{-# INLINE slice #-}
slice = G.slice

take :: Unbox a => Int -> MVector s a -> MVector s a
{-# INLINE take #-}
take = G.take

drop :: Unbox a => Int -> MVector s a -> MVector s a
{-# INLINE drop #-}
drop = G.drop

init :: Unbox a => MVector s a -> MVector s a
{-# INLINE init #-}
init = G.init

tail :: Unbox a => MVector s a -> MVector s a
{-# INLINE tail #-}
tail = G.tail

-- | Yield a part of the mutable vector without copying it. No bounds checks
-- are performed.
unsafeSlice :: Unbox a
            => Int  -- ^ starting index
            -> Int  -- ^ length of the slice
            -> MVector s a
            -> MVector s a
{-# INLINE unsafeSlice #-}
unsafeSlice = G.unsafeSlice

unsafeTake :: Unbox a => Int -> MVector s a -> MVector s a
{-# INLINE unsafeTake #-}
unsafeTake = G.unsafeTake

unsafeDrop :: Unbox a => Int -> MVector s a -> MVector s a
{-# INLINE unsafeDrop #-}
unsafeDrop = G.unsafeDrop

unsafeInit :: Unbox a => MVector s a -> MVector s a
{-# INLINE unsafeInit #-}
unsafeInit = G.unsafeInit

unsafeTail :: Unbox a => MVector s a -> MVector s a
{-# INLINE unsafeTail #-}
unsafeTail = G.unsafeTail

-- Overlapping
-- -----------

-- Check whether two vectors overlap.
overlaps :: Unbox a => MVector s a -> MVector s a -> Bool
{-# INLINE overlaps #-}
overlaps = G.overlaps

-- Initialisation
-- --------------

-- | Create a mutable vector of the given length.
new :: (PrimMonad m, Unbox a) => Int -> m (MVector (PrimState m) a)
{-# INLINE new #-}
new = G.new

-- | Create a mutable vector of the given length. The length is not checked.
unsafeNew :: (PrimMonad m, Unbox a) => Int -> m (MVector (PrimState m) a)
{-# INLINE unsafeNew #-}
unsafeNew = G.unsafeNew

-- | Create a mutable vector of the given length (0 if the length is negative)
-- and fill it with an initial value.
replicate :: (PrimMonad m, Unbox a) => Int -> a -> m (MVector (PrimState m) a)
{-# INLINE replicate #-}
replicate = G.replicate

-- | Create a copy of a mutable vector.
clone :: (PrimMonad m, Unbox a)
      => MVector (PrimState m) a -> m (MVector (PrimState m) a)
{-# INLINE clone #-}
clone = G.clone

-- Growing
-- -------

-- | Grow a vector by the given number of elements. The number must be
-- positive.
grow :: (PrimMonad m, Unbox a)  
              => MVector (PrimState m) a -> Int -> m (MVector (PrimState m) a)
{-# INLINE grow #-}
grow = G.grow

-- | Grow a vector by the given number of elements. The number must be
-- positive but this is not checked.
unsafeGrow :: (PrimMonad m, Unbox a)
               => MVector (PrimState m) a -> Int -> m (MVector (PrimState m) a)
{-# INLINE unsafeGrow #-}
unsafeGrow = G.unsafeGrow

-- Restricting memory usage
-- ------------------------

-- | Reset all elements of the vector to some undefined value, clearing all
-- references to external objects. This is usually a noop for unboxed vectors. 
clear :: (PrimMonad m, Unbox a) => MVector (PrimState m) a -> m ()
{-# INLINE clear #-}
clear = G.clear

-- Accessing individual elements
-- -----------------------------

-- | Yield the element at the given position.
read :: (PrimMonad m, Unbox a) => MVector (PrimState m) a -> Int -> m a
{-# INLINE read #-}
read = G.read

-- | Replace the element at the given position.
write :: (PrimMonad m, Unbox a) => MVector (PrimState m) a -> Int -> a -> m ()
{-# INLINE write #-}
write = G.write

-- | Swap the elements at the given positions.
swap :: (PrimMonad m, Unbox a) => MVector (PrimState m) a -> Int -> Int -> m ()
{-# INLINE swap #-}
swap = G.swap


-- | Yield the element at the given position. No bounds checks are performed.
unsafeRead :: (PrimMonad m, Unbox a) => MVector (PrimState m) a -> Int -> m a
{-# INLINE unsafeRead #-}
unsafeRead = G.unsafeRead

-- | Replace the element at the given position. No bounds checks are performed.
unsafeWrite
    :: (PrimMonad m, Unbox a) =>  MVector (PrimState m) a -> Int -> a -> m ()
{-# INLINE unsafeWrite #-}
unsafeWrite = G.unsafeWrite

-- | Swap the elements at the given positions. No bounds checks are performed.
unsafeSwap
    :: (PrimMonad m, Unbox a) => MVector (PrimState m) a -> Int -> Int -> m ()
{-# INLINE unsafeSwap #-}
unsafeSwap = G.unsafeSwap

-- Filling and copying
-- -------------------

-- | Set all elements of the vector to the given value.
set :: (PrimMonad m, Unbox a) => MVector (PrimState m) a -> a -> m ()
{-# INLINE set #-}
set = G.set

-- | Copy a vector. The two vectors must have the same length and may not
-- overlap.
copy :: (PrimMonad m, Unbox a) 
                 => MVector (PrimState m) a -> MVector (PrimState m) a -> m ()
{-# INLINE copy #-}
copy = G.copy

-- | Copy a vector. The two vectors must have the same length and may not
-- overlap. This is not checked.
unsafeCopy :: (PrimMonad m, Unbox a)
           => MVector (PrimState m) a   -- ^ target
           -> MVector (PrimState m) a   -- ^ source
           -> m ()
{-# INLINE unsafeCopy #-}
unsafeCopy = G.unsafeCopy

-- Deprecated functions
-- --------------------

-- | /DEPRECATED/ Use 'replicate' instead
newWith :: (PrimMonad m, Unbox a) => Int -> a -> m (MVector (PrimState m) a)
{-# INLINE newWith #-}
newWith = G.replicate

-- | /DEPRECATED/ Use 'replicate' instead
unsafeNewWith :: (PrimMonad m, Unbox a) => Int -> a -> m (MVector (PrimState m) a)
{-# INLINE unsafeNewWith #-}
unsafeNewWith = G.replicate

{-# DEPRECATED newWith, unsafeNewWith "Use replicate instead" #-}

#define DEFINE_MUTABLE
#include "unbox-tuple-instances"

