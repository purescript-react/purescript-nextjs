module Next.Router.PushOptions
  ( PushOptions
  , locale
  , scroll
  , shallow
  ) where

import Data.Options (Option, opt)

foreign import data PushOptions ∷ Type

shallow ∷ Option PushOptions Boolean
shallow = opt "shallow"

locale ∷ Option PushOptions String
locale = opt "locale"

scroll ∷ Option PushOptions String
scroll = opt "scroll"
