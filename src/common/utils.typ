#import "@preview/nth:1.0.1": *
#import "@preview/oxifmt:0.2.1": *

#let call-or-value(a, args) = if type(a) == function {
  a(..args)
} else {
  a
}

#let ternary(bool, a, b) = if bool { a } else { b }
#let ternary-fn(bool, a-fn, b-fn) = if bool { a-fn() } else { b-fn() }
#let coalesce(a, b) = if a != none { a } else { b }

#let course-topics(course, indices) = list(
  ..course
    .topics
    .enumerate()
    .filter(((w, topic)) => indices.contains(w))
    .map(((w, topic)) => [
      \[W#strfmt("{:02}", w + 1)\] #topic
    ]),
)
