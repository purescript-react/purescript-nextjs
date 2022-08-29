module Next.Router where

import Prelude
import Effect (Effect)
import Effect.Uncurried (mkEffectFn1)
import React.Basic.Hooks (Hook, unsafeHook)

foreign import data Router :: Type

foreign import useRouter_ :: Effect Router

useRouter :: Hook (UseRouter) Router
useRouter = unsafeHook useRouter_

foreign import data UseRouter :: Type -> Type

foreign import query :: forall q. Router -> q

foreign import push :: Router -> String -> Effect Unit

foreign import route :: Router -> String

foreign import _on :: forall a. String -> a -> Effect Unit

foreign import _off :: forall a. String -> a -> Effect Unit

event :: forall a. String -> a -> Effect (Effect Unit)
event name cb = _on name cb $> _off name cb

onRouteChangeStart :: (String -> Effect Unit) -> Effect (Effect Unit)
onRouteChangeStart = event "routeChangeStart" <<< mkEffectFn1

routeChangeComplete :: (String -> Effect Unit) -> Effect (Effect Unit)
routeChangeComplete = event "routeChangeComplete" <<< mkEffectFn1

routeChangeError :: forall r. ({ cancelled :: Boolean | r } -> Effect Unit) -> Effect (Effect Unit)
routeChangeError = event "routeChangeError" <<< mkEffectFn1
