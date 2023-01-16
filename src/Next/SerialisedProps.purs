module Next.SerialisedProps where

import Prelude

import Control.Monad.Except (runExcept)

import Data.Either (Either(..))
import Data.Semigroup.Foldable (intercalateMap)
import Foreign (renderForeignError, unsafeToForeign)
import Foreign.Index (readProp)
import Partial.Unsafe (unsafeCrashWith)
import Yoga.JSON (class ReadForeign, E, readJSON)
import Yoga.JSON as JSON

type SerialisedProps ∷ ∀ k. k → Type
type SerialisedProps a =
  { serialisedProps ∷ String
  }

deserialiseProps ∷ ∀ a. ReadForeign a ⇒ SerialisedProps a → E a
deserialiseProps sp = runExcept do
  value <- readProp "serialisedProps" (unsafeToForeign sp)
  str <- JSON.read' value
  JSON.readJSON' str

unsafeDeserialiseProps ∷ ∀ a. ReadForeign a ⇒ SerialisedProps a → a
unsafeDeserialiseProps props = do
  case readJSON props.serialisedProps of
    Right value → value
    Left errors →
      unsafeCrashWith
        $ "Invalid serialisedProps getServerSideProps:\n"
            <> intercalateMap "\n" renderForeignError errors
