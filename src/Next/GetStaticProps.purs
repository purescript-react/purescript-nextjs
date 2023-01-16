module Next.GetStaticProps where

import Prelude hiding (top)

import Control.Promise (Promise)
import Control.Promise as Promise
import Data.Either (Either(..))
import Data.Maybe (Maybe)
import Data.Semigroup.Foldable (intercalateMap)
import Data.Time.Duration (Seconds)
import Effect.Aff (Aff)
import Effect.Uncurried (EffectFn1, mkEffectFn1)
import Foreign (Foreign, renderForeignError)
import Next.SerialisedProps (SerialisedProps)
import Partial.Unsafe (unsafeCrashWith)
import Prim.Row (class Union)
import Unsafe.Coerce (unsafeCoerce)
import Yoga.JSON (class ReadForeign, class WriteForeign, read, write, writeJSON)

type StaticPropsContext params props =
  { params ∷ Maybe { | params }
  , preview ∷ Maybe Boolean
  , previewData ∷ Maybe { | props }
  , locale ∷ Maybe Locale
  , locales ∷ Maybe (Array Locale)
  , defaultLocale ∷ Maybe Locale
  }

-- [TODO]: Move to a separate file
newtype Locale = Locale String

derive newtype instance ReadForeign Locale
derive newtype instance WriteForeign Locale

type StaticProps props =
  ( props ∷ props
  , revalidate ∷ Seconds
  , notFound ∷ Boolean
  )

foreign import data GetStaticProps ∷ Type → Type → Type

toGetStaticProps
  ∷ ∀ partialProps componentProps params
  . (EffectFn1 Foreign (Promise partialProps))
  → GetStaticProps params componentProps
toGetStaticProps = unsafeCoerce

decodeContextOrCrash ∷ ∀ a. ReadForeign a ⇒ Foreign → a
decodeContextOrCrash fgn =
  case read fgn of
    Right value → value
    Left errors →
      unsafeCrashWith
        $ "Invalid context received in getStaticProps:\n"
            <> intercalateMap "\n" renderForeignError errors

mkGetStaticProps
  ∷ ∀ props p p_ params
  . Union p p_ (StaticProps props)
  ⇒ ReadForeign { | params }
  ⇒ ReadForeign { | p }
  ⇒ WriteForeign props
  ⇒ WriteForeign { props ∷ { serialisedProps ∷ String } | p }
  ⇒ (StaticPropsContext params p → Aff { props ∷ props | p })
  → GetStaticProps { | params } (SerialisedProps props)
mkGetStaticProps constructProps =
  toGetStaticProps
    $ mkEffectFn1
        ( Promise.fromAff
            <<< (map write)
            <<<
              ( map \x →
                  (x { props = { serialisedProps: writeJSON x.props } ∷ SerialisedProps props })
              )
            <<< constructProps
            <<< decodeContextOrCrash
        )
