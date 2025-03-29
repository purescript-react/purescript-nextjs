module Next.Image where

import Data.Nullable (Nullable)
import Data.Unit (Unit)
import Effect.Uncurried (EffectFn1)
import Foreign.Object (Object)
import Prim.Row (class Union)
import React.Basic (JSX, Ref)
import React.Basic.DOM.Internal (CSS)
import React.Basic.Events (EventHandler)
import React.Basic.Hooks (ReactComponent)
import Web.DOM (Node)

foreign import data StaticallyImportedImage :: Type

-- | Components
type Props_static_image_optional =
  ------- those are props which are mentioned in documentation
  -- , layout :: String -- removed
  -- , objectFit :: String -- removed
  -- , objectPosition :: String -- removed
  ( loader :: ({ src :: String, width :: Int, quality :: Int } → String)
  , fill :: Boolean
  , sizes :: String
  , quality :: Int
  , priority :: Boolean
  , placeholder :: String
  , style :: CSS
  , onLoadingComplete :: EffectFn1 { width ∷ Int, height ∷ Int } Unit
  , onLoad :: EventHandler
  , onError :: EventHandler
  , loading :: String
  , blurDataURL :: String
  , overrideSrc :: String
  ------- Other props, taken from Props_img, then removed duplicates
  , _aria :: Object String
  , _data :: Object String
  , about :: String
  , acceptCharset :: String
  , accessKey :: String
  , allowFullScreen :: Boolean
  , allowTransparency :: Boolean
  , alt :: String
  , autoFocus :: Boolean
  , autoPlay :: Boolean
  , capture :: Boolean
  , cellPadding :: String
  , cellSpacing :: String
  , charSet :: String
  , classID :: String
  , className :: String
  , colSpan :: Int
  , contentEditable :: Boolean
  , contextMenu :: String
  , crossOrigin :: String
  , dangerouslySetInnerHTML :: { __html :: String }
  , datatype :: String
  , dateTime :: String
  , dir :: String
  , draggable :: Boolean
  , encType :: String
  , formAction :: String
  , formEncType :: String
  , formMethod :: String
  , formNoValidate :: Boolean
  , formTarget :: String
  , frameBorder :: String
  , height :: String
  , hidden :: Boolean
  , hrefLang :: String
  , htmlFor :: String
  , httpEquiv :: String
  , icon :: String
  , id :: String
  , inlist :: String
  , inputMode :: String
  , is :: String
  , itemID :: String
  , itemProp :: String
  , itemRef :: String
  , itemScope :: Boolean
  , itemType :: String
  , key :: String
  , keyParams :: String
  , keyType :: String
  , lang :: String
  -- , loading :: String
  , marginHeight :: String
  , marginWidth :: String
  , maxLength :: Int
  , mediaGroup :: String
  , minLength :: Int
  , name :: String
  , noValidate :: Boolean
  , onAnimationEnd :: EventHandler
  , onAnimationIteration :: EventHandler
  , onAnimationStart :: EventHandler
  , onBlur :: EventHandler
  , onClick :: EventHandler
  , onCompositionEnd :: EventHandler
  , onCompositionStart :: EventHandler
  , onCompositionUpdate :: EventHandler
  , onContextMenu :: EventHandler
  , onCopy :: EventHandler
  , onCut :: EventHandler
  , onDoubleClick :: EventHandler
  , onDrag :: EventHandler
  , onDragEnd :: EventHandler
  , onDragEnter :: EventHandler
  , onDragExit :: EventHandler
  , onDragLeave :: EventHandler
  , onDragOver :: EventHandler
  , onDragStart :: EventHandler
  , onDrop :: EventHandler
  -- , onError :: EventHandler
  , onFocus :: EventHandler
  , onGotPointerCapture :: EventHandler
  , onInvalid :: EventHandler
  , onKeyDown :: EventHandler
  , onKeyPress :: EventHandler
  , onKeyUp :: EventHandler
  -- , onLoad :: EventHandler
  , onLostPointerCapture :: EventHandler
  , onMouseDown :: EventHandler
  , onMouseEnter :: EventHandler
  , onMouseLeave :: EventHandler
  , onMouseMove :: EventHandler
  , onMouseOut :: EventHandler
  , onMouseOver :: EventHandler
  , onMouseUp :: EventHandler
  , onPaste :: EventHandler
  , onPointerCancel :: EventHandler
  , onPointerDown :: EventHandler
  , onPointerEnter :: EventHandler
  , onPointerLeave :: EventHandler
  , onPointerMove :: EventHandler
  , onPointerOut :: EventHandler
  , onPointerOver :: EventHandler
  , onPointerUp :: EventHandler
  , onSelect :: EventHandler
  , onSubmit :: EventHandler
  , onTouchCancel :: EventHandler
  , onTouchEnd :: EventHandler
  , onTouchMove :: EventHandler
  , onTouchStart :: EventHandler
  , onTransitionEnd :: EventHandler
  , onWheel :: EventHandler
  , prefix :: String
  , property :: String
  , radioGroup :: String
  , readOnly :: Boolean
  , ref :: Ref (Nullable Node)
  , resource :: String
  , role :: String
  , rowSpan :: Int
  , scoped :: Boolean
  , seamless :: Boolean
  , security :: String
  -- , sizes :: String
  , slot :: String
  , spellCheck :: Boolean
  , src :: String
  , srcDoc :: JSX
  , srcLang :: String
  , srcSet :: String
  -- , style :: CSS
  , suppressContentEditableWarning :: Boolean
  , tabIndex :: Int
  , title :: String
  , typeof :: String
  , unselectable :: Boolean
  , useMap :: String
  , vocab :: String
  , width :: String
  , wmode :: String
  )

type Props_static_image_required other =
  ( src :: StaticallyImportedImage
  , alt :: String
  , width :: Int
  , height :: Int
  | other
  )

staticImage
  :: ∀ attrs attrs_
   . Union attrs attrs_ Props_static_image_optional
  => ReactComponent { | Props_static_image_required attrs }
staticImage = imageImpl

foreign import imageImpl :: ∀ attrs. ReactComponent attrs
