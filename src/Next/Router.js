export { useRouter as useRouter_ } from "next/router";
import router from "next/router";

export function _on(event) {
  return function (cb) {
    return function () {
      router.events.on(event, cb);
    };
  };
}

export function _off(event) {
  return function (cb) {
    return function () {
      router.events.off(event, cb);
    };
  };
}

export const query = (router) => router.query;

export const push = (router) => (route) => () => router.push(route);

export const route = (router) => router.route;

export const replaceImpl = (router) => (route) => (as) => (options) => () =>
  router.replace(route, as, options);
