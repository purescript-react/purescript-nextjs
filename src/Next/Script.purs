module Next.Script where

import Prelude

import React.Basic (ReactComponent)

foreign import script :: forall props. ReactComponent { | props }
