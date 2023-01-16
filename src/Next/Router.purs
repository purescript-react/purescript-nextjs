module Next.Router
  ( NextRouter
  , RouteChangeStartHandler
  , UseRouter
  , addOnRouteChangeStartHandler
  , asPath
  , event
  , historyPushState
  , mkOnRouteChangeStartHandler
  , onRouteChangeStart
  , pathname
  , push
  , pushAs
  , pushAs_
  , push_
  , replace
  , routeChangeComplete
  , routeChangeError
  , useRouter
  ) where

import Prelude

import Control.Promise (Promise)
import Control.Promise as Promise
import Data.Maybe (Maybe)
import Data.Nullable (Nullable)
import Data.Nullable as Nullable
import Data.Options (Options, options)
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Uncurried (EffectFn1, mkEffectFn1, runEffectFn1)
import Foreign (Foreign)
import Next.Router.PushOptions (PushOptions)
import React.Basic.Hooks (Hook, unsafeHook)

foreign import onImpl ∷ ∀ a. String → a → Effect Unit

foreign import offImpl ∷ ∀ a. String → a → Effect Unit

event ∷ ∀ a. String → a → Effect (Effect Unit)
event name cb = onImpl name cb $> offImpl name cb

onRouteChangeStart ∷ (String → Effect Unit) → Effect (Effect Unit)
onRouteChangeStart = event "routeChangeStart" <<< mkEffectFn1

routeChangeComplete ∷ (String → Effect Unit) → Effect (Effect Unit)
routeChangeComplete = event "routeChangeComplete" <<< mkEffectFn1

routeChangeError
  ∷ ∀ r. ({ cancelled ∷ Boolean | r } → Effect Unit) → Effect (Effect Unit)
routeChangeError = event "routeChangeError" <<< mkEffectFn1

foreign import data NextRouter ∷ Type

foreign import useRouterImpl ∷ Effect NextRouter
foreign import queryImpl ∷ NextRouter → Foreign

foreign import data UseRouter ∷ Type → Type

useRouter ∷ Hook UseRouter NextRouter
useRouter = unsafeHook useRouterImpl

foreign import pathnameImpl ∷ NextRouter → Effect String

pathname :: NextRouter -> Effect String
pathname = pathnameImpl

foreign import pushImpl
  ∷ String → String → Options PushOptions → NextRouter → Effect Unit

foreign import pushImplNoAs
  ∷ String → Foreign → NextRouter → Effect Unit

push_ ∷ String → NextRouter → Effect Unit
push_ href = push href mempty

push ∷ String → Options PushOptions → NextRouter → Effect Unit
push href = options >>> pushImplNoAs href

pushAs_ ∷ String → String → NextRouter → Effect Unit
pushAs_ href as = pushAs href as (mempty)

pushAs ∷ String → String → Options PushOptions → NextRouter → Effect Unit
pushAs href as = pushImpl href as

foreign import historyPushState ∷ String → String → Effect Unit

foreign import asPathImpl ∷ EffectFn1 NextRouter String

asPath ∷ NextRouter → Effect String
asPath = runEffectFn1 asPathImpl

foreign import data RouteChangeStartHandler ∷ Type

foreign import mkOnRouteChangeStartHandler
  ∷ (String → { shallow ∷ Boolean } → Effect Unit)
  → Effect RouteChangeStartHandler

-- | Returns the unregister function for easy use in hooks
foreign import addOnRouteChangeStartHandler
  ∷ RouteChangeStartHandler → NextRouter → Effect (Effect Unit)

foreign import replaceImpl :: NextRouter -> String -> Nullable String -> Options PushOptions -> Effect (Promise Boolean)

replace :: NextRouter -> String -> Maybe String -> Options PushOptions -> Aff Boolean
replace router url asUrl options = replaceImpl router url (Nullable.toNullable asUrl) options # Promise.toAffE
