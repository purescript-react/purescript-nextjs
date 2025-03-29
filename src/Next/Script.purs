module Next.Script where

import React.Basic (ReactComponent)

foreign import script :: forall props. ReactComponent { | props }
