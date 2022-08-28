module NextUI.SWR where

import Prelude

import Control.Promise (Promise)
import Data.Function.Uncurried (Fn2)
import Data.Nullable (Nullable)
import Effect (Effect)
import Effect.Uncurried (EffectFn1, EffectFn2, mkEffectFn1, runEffectFn2)
import React.Basic.Hooks (Hook, ReactComponent, unsafeHook)

type SWR d err = { "data" :: d, error :: err }

-- const fetcher = (...args) => fetch(...args).then((res) => res.json())

-- function Profile() {
--   const { data, error } = useSWR('/api/profile-data', fetcher)

--   if (error) return <div>Failed to load</div>
--   if (!data) return <div>Loading...</div>

--   return (
--     <div>
--       <h1>{data.name}</h1>
--       <p>{data.bio}</p>
--     </div>
--   )

foreign import useSWR_
  :: forall d err
   . EffectFn2
       String
       (EffectFn1 String (Promise d))
       (SWR d err)

useSWR :: forall d err. String -> (String -> Effect (Promise d)) -> Hook (UseSWR d) (SWR d err)
useSWR url fetch = unsafeHook do
  runEffectFn2 useSWR_ url (mkEffectFn1 fetch)

foreign import data UseSWR :: Type -> Type -> Type

foreign import swrConfig :: forall props. ReactComponent { | props }
