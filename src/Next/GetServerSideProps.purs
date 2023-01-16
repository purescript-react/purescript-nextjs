module Next.GetServerSideProps where

import Prelude hiding (top)

import Control.Promise (Promise)
import Control.Promise as Promise
import Data.Either (Either(..))
import Data.Maybe (Maybe)
import Data.Semigroup.Foldable (intercalateMap)
import Effect.Aff (Aff)
import Effect.Uncurried (EffectFn1, mkEffectFn1)
import Foreign (Foreign, renderForeignError)
import Foreign.Object (Object)
import Next.SerialisedProps (SerialisedProps)
import Partial.Unsafe (unsafeCrashWith)
import Prim.Row (class Union)
import Unsafe.Coerce (unsafeCoerce)
import Yoga.JSON (class ReadForeign, class WriteForeign, read, write, writeJSON)

type ServerSidePropsContext params =
  { params ∷ Maybe { | params }
  , req ∷ Foreign -- IncomingMessage
  , res ∷ Foreign -- HTTP response object
  , query ∷ Object String
  , preview ∷ Maybe Boolean
  , resolvedUrl ∷ String
  , locale ∷ Maybe Locale
  , locales ∷ Maybe (Array Locale)
  , defaultLocale ∷ Maybe Locale
  }

-- [TODO]: Move to a separate file
newtype Locale = Locale String

derive newtype instance ReadForeign Locale
derive newtype instance WriteForeign Locale

type ServerSideProps props =
  ( props ∷ props
  , redirect ∷ { destination ∷ String, permanent ∷ Boolean }
  , notFound ∷ Boolean
  )

foreign import data GetServerSideProps ∷ Type → Type → Type

toGetServerSideProps
  ∷ ∀ partialProps componentProps params
  . (EffectFn1 Foreign (Promise partialProps))
  → GetServerSideProps params componentProps
toGetServerSideProps = unsafeCoerce

decodeContextOrCrash ∷ ∀ a. ReadForeign a ⇒ Foreign → a
decodeContextOrCrash fgn =
  case read fgn of
    Right value → value
    Left errors →
      unsafeCrashWith
        $ "Invalid context received in getServerSideProps:\n"
            <> intercalateMap "\n" renderForeignError errors

mkGetServerSideProps
  ∷ ∀ props p p_ params
  . Union p p_ (ServerSideProps props)
  ⇒ ReadForeign { | params }
  ⇒ ReadForeign { | p }
  ⇒ WriteForeign props
  ⇒ WriteForeign { props ∷ { serialisedProps ∷ String } | p }
  ⇒ (ServerSidePropsContext params → Aff { props ∷ props | p })
  → GetServerSideProps { | params } (SerialisedProps props)
mkGetServerSideProps constructProps =
  toGetServerSideProps
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
