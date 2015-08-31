{-# LANGUAGE TemplateHaskell, Rank2Types #-}
module Ling.Proto
  -- Types
  ( Proto
  , ConstraintFlag (WithConstraint, WithoutConstraints)
  -- Lenses
  , chans
  , constraints
  , orders
  -- Operations
  , prettyProto
  , prettyChanDecs
  , isEmptyProto
  , emptyProto
  , addChanWithOrder
  , rmChan
  , rmChans
  , substChans
  , chanSession
  , chanSessions
  , mkProto
  , protoAx
  , replProtoWhen
  , parallelProtos)
  where

import Prelude hiding (log)
import Ling.Utils
import Ling.Constraint
import Ling.Session
import Ling.Norm
import Ling.Print.Instances ()

import qualified Data.Map as Map
import Data.Map (Map)

import Control.Lens

data Proto = MkProto { _chans       :: Map Channel RSession
                     , _constraints :: Constraints
                     , _orders      :: [[Channel]]
                     }

$(makeLenses ''Proto)

prettyProto :: Proto -> [String]
prettyProto p =
  [" channels:"] ++ prettyChanDecs p
  ++
  if p ^. constraints . to noConstraints then [] else
  " constraints:"
  : map ("  " ++) (prettyConstraints (p ^. constraints))
  ++
  if p ^. orders . to null then [] else
  " orders:"
  : map (("  " ++) . show . map unName) (p ^. orders)

-- toListOf chanDecs :: Proto -> [Arg Session]
chanDecs :: Fold Proto (Arg RSession)
chanDecs = chans . to m2l . each . to (uncurry Arg)

prettyChanDecs :: Proto -> [String]
prettyChanDecs = prettyList . toListOf chanDecs

emptyProto :: Proto
emptyProto = MkProto Map.empty emptyConstraints []

-- Not used
chanPresent :: Channel -> Getter Proto Bool
chanPresent c = chans . hasKey c

isEmptyProto :: Getter Proto Bool
isEmptyProto = chans . to Map.null

addChanOnly :: (Channel,RSession) -> Endom Proto
addChanOnly (c,s) = chans %~ at c .~ Just s

data ConstraintFlag = WithConstraint | WithoutConstraints

addChanConstraint :: ConstraintFlag -> Channel -> Endom Proto
addChanConstraint WithoutConstraints _ = id
addChanConstraint WithConstraint     c = constraints %~ constrainChan c

addChan :: ConstraintFlag -> (Channel,RSession) -> Endom Proto
addChan flag (c,s) = addChanOnly (c,s) . addChanConstraint flag c

addChanWithOrder :: (Channel,RSession) -> Endom Proto
addChanWithOrder (c,s) p = p & addChan WithConstraint (c,s)
                             & orders %~ addOrder
  where addOrder []  = [[c]]
        addOrder css = map (c:) css

rmChanAndConstraint :: Channel -> Endom Proto
rmChanAndConstraint c p =
  p & chans . at c .~ Nothing
    & constraints %~ unconstrainChan c

rmChansAndConstraints :: [Channel] -> Endom Proto
rmChansAndConstraints = flip (foldr rmChanAndConstraint)

rmChan :: Channel -> Endom Proto
rmChan c p =
  p & rmChanAndConstraint c
    & orders . mapped %~ filter (/= c)

rmChans :: [Channel] -> Endom Proto
rmChans = flip (foldr rmChan)

substChans :: ConstraintFlag -> ([Channel], (Channel,RSession)) -> Endom Proto
substChans flag (cs, cs') p =
  p & orders . each %~ substList (l2s cs) (fst cs')
    & rmChansAndConstraints cs
    & addChan flag cs'

chanSession :: Channel -> Lens' Proto (Maybe RSession)
chanSession c = chans . at c

chanSessions :: [Channel] -> Proto -> [Maybe RSession]
chanSessions cs p = [ p ^. chanSession c | c <- cs ]

mkProto :: [(Channel,RSession)] -> Proto
mkProto css = MkProto (l2m css) (singleConstraint (l2s cs))
                      (map return cs)
  where cs = map fst css

protoAx :: RSession -> Channel -> Channel -> [Channel] -> Proto
protoAx s c d es = mkProto ((c,s):(d,dual s):map (\e -> (e, log s)) es)

replProtoWhen :: (Channel -> Bool) -> Term -> Endom Proto
replProtoWhen cond n = chans . imapped %@~ replRSessionWhen where
  replRSessionWhen c s | cond c    = replRSession n s
                       | otherwise = s

parallelProtos :: Verbosity -> Proto -> Proto -> Proto
parallelProtos v proto0 proto1 =
  debugTraceWhen (v && noConstraints ks0 && noConstraints ks1)
    (concat
      [["Merge constraints:"]
      ,prettyConstraints ks0
      ,["******************"]
      ,prettyConstraints ks1
      ]) $
    MkProto mchans ks (proto0 ^. orders ++ proto1 ^. orders)
  where
    ks0    = proto0 ^. constraints
    ks1    = proto1 ^. constraints
    ks     = mergeConstraints ks0 ks1
    mchans = Map.mergeWithKey (error "mergeSession") id id
                              (proto0 ^. chans) (proto1 ^. chans)
-- -}
