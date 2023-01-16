module Next.Image where

import Prim.Row (class Union)
import React.Basic.Hooks (ReactComponent)

foreign import data StaticallyImportedImage ∷ Type

-- | Components
type Props_static_image =
  ( src ∷ StaticallyImportedImage
  , alt ∷ String
  , layout ∷ String
  , objectFit ∷ String
  , objectPosition ∷ String
  , quality ∷ Int
  , placeholder ∷ String
  , className ∷ String
  )

staticImage
  ∷ ∀ attrs attrs_
  . Union attrs attrs_ Props_static_image
  ⇒ ReactComponent { src ∷ StaticallyImportedImage | attrs }
staticImage = imageImpl

foreign import imageImpl ∷ ∀ attrs. ReactComponent attrs
