import nextRouter, { useRouter } from "next/navigation";

export const onImpl = function (event) {
  return function (cb) {
    return function () {
      nextRouter.events.on(event, cb);
    };
  };
};

export const offImpl = function (event) {
  return function (cb) {
    return function () {
      nextRouter.events.off(event, cb);
    };
  };
};

export const useRouterImpl = () => useRouter();

export const queryImpl = (nr) => nr.query;

export function pathnameImpl(nr) {
  return () => nr.pathname;
}

export const asPathImpl = (nr) => nr.asPath;

export const pushImpl = (path) => (as) => (options) => (routerInstance) => () =>
  routerInstance.push(path, as, options);

export function pushImplNoAs(path) {
  return (options) => (routerInstance) => () => {
    routerInstance.push(path, undefined, options);
  };
}

export const historyPushState = (href) => (as) => () => {
  window.history.pushState(
    _objectSpread(
      _objectSpread({}, window.history.state),
      {},
      {
        as: as,
        url: href,
      }
    ),
    "",
    href
  );
};

// Babel stuff
function ownKeys(object, enumerableOnly) {
  var keys = Object.keys(object);
  if (Object.getOwnPropertySymbols) {
    var symbols = Object.getOwnPropertySymbols(object);
    if (enumerableOnly) {
      symbols = symbols.filter(function (sym) {
        return Object.getOwnPropertyDescriptor(object, sym).enumerable;
      });
    }
    keys.push.apply(keys, symbols);
  }
  return keys;
}

function _objectSpread(target) {
  for (var i = 1; i < arguments.length; i++) {
    var source = arguments[i] != null ? arguments[i] : {};
    if (i % 2) {
      ownKeys(Object(source), true).forEach(function (key) {
        _defineProperty(target, key, source[key]);
      });
    } else if (Object.getOwnPropertyDescriptors) {
      Object.defineProperties(target, Object.getOwnPropertyDescriptors(source));
    } else {
      ownKeys(Object(source)).forEach(function (key) {
        Object.defineProperty(
          target,
          key,
          Object.getOwnPropertyDescriptor(source, key)
        );
      });
    }
  }
  return target;
}

function _defineProperty(obj, key, value) {
  if (key in obj) {
    Object.defineProperty(obj, key, {
      value: value,
      enumerable: true,
      configurable: true,
      writable: true,
    });
  } else {
    obj[key] = value;
  }
  return obj;
}

export const mkOnRouteChangeStartHandler = (fn) => () => (url, opts) =>
  fn(url)(opts)();
export const addOnRouteChangeStartHandler = (handler) => (router) => () => {
  router.events.on("routeChangeStart", handler);
  return () => router.events.off("routeChangeStart", handler);
};

export const replaceImpl = (router) => (route) => (as) => (options) => () =>
  router.replace(route, as, options);
