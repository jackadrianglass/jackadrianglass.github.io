---
type: project
status: active
title: Advent of Code in 12 languages
description: Trying out a bunch of programming languages by writing each challenge in the advent of code in a different one. We're looking for a potential hobby language
date: 2026-05-25 00:00:00
tags: ["OCaml", "Haskell",  "Nim", "Crystal", "Scala", "Clojure", "Gleam", "Idris"]
repo: https://github.com/jackadrianglass/side_projects/tree/master/challenges/aoc_2025
---

Some folks might ask me "why?". Well I ask myself the same question. Originally, the challenge was to do the [advent of code](https://adventofcode.com/) in Elixir. But as I did the first challenge, I really found myself missing a static type system. Right around that time, I encountered [devenv.sh](https://devenv.sh/) which makes spinning up new environments for 50 programming languages super easy. I thought to myself "well this is a perfect time to try them all!". And so, here we are. I'm planning on blogging about this experience once I finish it (eventually)

# Log

https://adventofcode.com/

Doing each day in a different language

- [x] Day 1: Haskell
- [x] Day 2: OCaml
- [x] Day 3: Nim
- [x] Day 4: Crystal
- [x] Day 5: Scala
- [x] Day 6: Clojure
- [x] Day 7: Gleam
- [x] Day 8: ~~Idris~~ OCaml
- [ ] Day 9: ~~Kotlin~~  OCaml
- [ ] Day 10: ~~Swift~~ OCaml
- [ ] Day 11: ~~Zig~~ OCaml
- [ ] Day 12: ~~Roc~~ OCaml

Languages to maybe switch out with
- https://vale.dev/
- https://hylo-lang.org/ (research language... maybe not?)
- https://www.ponylang.io/
- https://www.unison-lang.org/

Why you might ask? Honestly just to see if any of them seem like a fun hobby language or if any of them really spark joy. So far my favorite is Rust.

The more I work on this, the more I wonder why should I learn a new programming language. All the interesting things about a language seem to pop up when you're very competent with that language so long as the basics are nice. The less nice the basics, the harder the advance stuff become. Pure functional programming languages sound nice, but I don't think I'm willing to sift through the soup of symbols just to do the basics.

# Haskell

Fun once you learn the concepts. Very satisfying code to write. Very hard to learn (as in a huge up front cost)

Pros:
- Really cool type system
- Love how everything is a function
- Seems very elegant
- Hoogle is soooo cool!

Neutral:
- Finding "how do I do this in Haskell" is kind of hard

Cons:
- Very different to the style of programming that I'm used to
- Slow to compile
- Build story was challenging. Stack seems to download A LOT of things and cabal is just very foreign

# OCaml

Fun and pretty easy to get going. Much easier than Haskell just to get going. May try to make a project on this one to get used to thinking in functional terms and then move to Haskell.

Pros:
- Somewhat easier to understand than Haskell (despite being very similar. Probably fewer special symbols used)
- Docs are great. Website is great
- Pretty easy to find "how do I do this"

Neutral:
- Build & package management present and works. No other opinion beyond that

Cons:
- Single pass compiler so there's an order to declarations (not the worst thing)
- C-style printf (kind of annoying to print out lists. Probably a way to deal with this that I just don't know about)

# Nim

Also fun and easy to get going. Would be interested to try to make a project with it

Pros:
- Familiar enough that it's easy to get started
- Can do functional style computation even if it looks like the docs are geared towards OOP folks
- Test syntax is nice
- Feels like a scripting language. Haven't tried type inference though

Cons:
- `nimble` segfaults in devenv for some reason
- Compiler errors for macros look pretty terrible
- Compiler errors generally are kind of a miss. Probably would be fine once gotten used to
- Documentation isn't as nice as Haskell or OCaml

# Crystal

Didn't really find anything that sparked interest in the language, nor did I really find it all that enjoyable. Definitely not the language for me

Cons:
- No official treesitter grammar (though an unofficial one exists [here](https://github.com/crystal-lang-tools/tree-sitter-crystal))
- I don't like the testing framework so far
- Missed opportunity for piping or dot call syntax
- Lots of sugar that just doesn't seem important

# Scala

Definitely interesting as a language in a lot of respects. But the interesting bits are the same things that other functional programming languages have that interest me. Probably would just keep to the other ones

Pros:
- Has some pretty neat syntax
- Love the functional stuff

Cons:
- Still very object oriented. Not generally a fan of that style and it would be hard to get away from in Scala
- I found the documentation around libraries hard to navigate. Maybe I'm just dumb but it was difficult to find the thing that I wanted. More often ended up on the "walk through" page but that wasn't super enlightening.
- Error messages weren't easy to parse sometimes
- Build times were weirdly long for how simple of an application it was (just a cli)

# Clojure

It's fun! I find myself missing a type system very badly in this language

Pros:
- Cute little language
- Pretty easy to pickup given the small syntax
- Very satisfying to write once you get it

Cons:
- Hard to debug
- The repl isn't as featureful as I would like (and it's the thing that the language enthusiasts like about it)
- Docs are kind of meh. Probably just because I miss the type system
- No static type system

# Gleam

Honestly, I don't find myself enjoying much about this language. It's nice to have the pizza operators but seems needlessly small and few features. I don't really care about the beam VM or the language enough to want to use it more than for the projects that I've tried it out with. Not for me

Pros:
- Super easy to get started with. Nice starter docs
- Small language

Cons:
- Removes a whole wack of stuff in a language that I don't find annoying or bad. Needlessly small
- It seems like every type has to redefine the same functions (e.g. map, filter etc.)
- The base operators for primitives are all different (adding floats is a different operator than ints)

# Idris

It's like Haskell, except with a fancier type system. But I feel extremely stupid when trying to program in it. I think that I'll just skip this one. It's not hitting anything that I'm excited about and I feel like I would need to know way more about formal verification to appreciate what this language is trying to do.

Also, it doesn't really have stuff that I'd need to do my hobby projects and I'd to write everything myself

# OCaml (round 2)

My new job has a large code base written in OCaml so I'm extra incentivized to actually learn this language.

The more that I work with OCaml, the more little things that I find myself actually liking about this language
- It's really satisfying to solve a problem functionally (i.e. using map, filter, fold, persistent datastructures, etc.)
- I'm more and more intruiged by the type system (in particular how modules and functors are used)
- It's not so deep into category theory where I feel stupid when I read the compiler error (most of the time)
- The docs are really nice to read

Even the complaints that I had in the beginning seem to not matter anymore
- There's `@@derive show` for records which makes it pretty easy to print things
- I don't really even think about the single pass-ness of the compiler 99% of the time. It ends up just being like C (which I'm already used to)

And the community values seem in line with what I care about
- Good performance without extra ceremony
- Good usability of the tools (build times, getting packages, nice compiler errors, good docs)
- Functional by default until OOP solves the problem better
- [this course is awesome!](https://cs3110.github.io/textbook/cover.html). I think that more introduction language books should be written like this (video + text + exercises)
- For the love of learning!
- For the love of programming!
- For the love of making actual things!

So I'm going to use OCaml for the rest of this challenge since the other languages in my list aren't nearly as interesting to me as OCaml has become (with the exception of Zig and Unison but I'll do that another time)
