# purescript-nextjs

Purescript FFI bindings to [Next.js](https://nextjs.org).

In order to bootstrap a Next.js project with Purescript you can use our [`purescript-nextjs-template`](https://github.com/rowtype-yoga/purescript-nextjs-template). You can find the information on how to get started in that repo.

## Usage

Once you have set up a Next.js project, you can use the FFI bindings here. This library provides bindings for many of the features described in the [Next.js documentation](https://nextjs.org/docs). We don't have FFI for everything yet, if you are missing something feel free to create an issue or even better: create a PR! 


### Router
Here is an example how to use the router.

```purescript
import React.Basic.DOM.Simplified.Generated as R
import React.Basic.Hooks as React

...

React.component "MyComponent" \props -> React.do
    router <- NextRouter.useRouter
    let
        q :: { myQueryParam :: String }
        q = query router

        dispatchRoute = Router.push Router
    pure $ R.button { onClick: handler_ $ dispatchRoute "/about" } "Click me"
```
