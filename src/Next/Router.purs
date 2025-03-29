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
  , query
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
import Effect.Uncurried (EffectFn1, EffectFn2, EffectFn3, EffectFn4, mkEffectFn1, mkEffectFn2, runEffectFn1, runEffectFn2, runEffectFn3, runEffectFn4)
import Foreign (Foreign)
import Next.Router.PushOptions (PushOptions)
import React.Basic.Hooks (Hook, unsafeHook)

foreign import onImpl ∷ ∀ a. EffectFn2 String a Unit

foreign import offImpl ∷ ∀ a. EffectFn2 String a Unit

event ∷ ∀ a. String → a → Effect (Effect Unit)
event name cb = runEffectFn2 onImpl name cb $> runEffectFn2 offImpl name cb

onRouteChangeStart ∷ (String → Effect Unit) → Effect (Effect Unit)
onRouteChangeStart = event "routeChangeStart" <<< mkEffectFn1

routeChangeComplete ∷ (String → Effect Unit) → Effect (Effect Unit)
routeChangeComplete = event "routeChangeComplete" <<< mkEffectFn1

routeChangeError
  ∷ ∀ r. ({ cancelled ∷ Boolean | r } → Effect Unit) → Effect (Effect Unit)
routeChangeError = event "routeChangeError" <<< mkEffectFn1

foreign import data NextRouter ∷ Type

foreign import useRouterImpl ∷ Effect NextRouter
foreign import query ∷ NextRouter → Foreign

foreign import data UseRouter ∷ Type → Type

useRouter ∷ Hook UseRouter NextRouter
useRouter = unsafeHook useRouterImpl

foreign import pathnameImpl ∷ EffectFn1 NextRouter String

pathname :: NextRouter -> Effect String
pathname = runEffectFn1 pathnameImpl

foreign import pushImpl
  ∷ EffectFn4 String String (Options PushOptions) NextRouter Unit

foreign import pushImplNoAs
  ∷ EffectFn3 String Foreign NextRouter Unit

push_ ∷ String → NextRouter → Effect Unit
push_ href = push href mempty

push ∷ String → Options PushOptions → NextRouter → Effect Unit
push href = options >>> runEffectFn3 pushImplNoAs href

pushAs_ ∷ String → String → NextRouter → Effect Unit
pushAs_ href as = pushAs href as (mempty)

pushAs ∷ String → String → Options PushOptions → NextRouter → Effect Unit
pushAs href as opts router = runEffectFn4 pushImpl href as opts router

foreign import historyPushStateImpl ∷ EffectFn2 String String Unit

historyPushState :: String -> String -> Effect Unit
historyPushState href as = runEffectFn2 historyPushStateImpl href as

foreign import asPathImpl ∷ EffectFn1 NextRouter String

asPath ∷ NextRouter → Effect String
asPath = runEffectFn1 asPathImpl

newtype RouteChangeStartHandler = RouteChangeStartHandlerUnsafeCreate (EffectFn2 String { shallow ∷ Boolean } Unit)

mkOnRouteChangeStartHandler
  ∷ (String → { shallow ∷ Boolean } → Effect Unit)
  → Effect RouteChangeStartHandler -- TODO: why should be created only using Effect?
mkOnRouteChangeStartHandler fn = pure $ RouteChangeStartHandlerUnsafeCreate $ mkEffectFn2 fn

-- | Returns the unregister function for easy use in hooks
foreign import addOnRouteChangeStartHandlerImpl
  ∷ EffectFn2 RouteChangeStartHandler NextRouter Unit

addOnRouteChangeStartHandler :: RouteChangeStartHandler -> NextRouter -> Effect Unit
addOnRouteChangeStartHandler = runEffectFn2 addOnRouteChangeStartHandlerImpl

foreign import replaceImpl :: EffectFn4 NextRouter String (Nullable String) (Options PushOptions) (Promise Boolean)

replace :: NextRouter -> String -> Maybe String -> Options PushOptions -> Aff Boolean
replace router url asUrl options = runEffectFn4 replaceImpl router url (Nullable.toNullable asUrl) options # Promise.toAffE
