export { Html as _html, Head as _head, Main as _main, NextScript as _nextScript } from "next/document"

export function unsafeDocumentImpl(component) {
    component.getInitialProps = nextDoc.getInitialProps
    return component
}
