# Greenfinity utilities for React Context

## Scope

Context utilities

## Contents

### GlobalContext

A helper for creating contexts.

Definition:

```res
module Context = GreenfinityContextUtils.GlobalContext.Make({
  type value = string
  let defaultValue = 'anything'
})
```

Usage:

```res
let value = "Something completely different"
<Context.Provider value={value}>
{
  let value = Context.use()
}
</Context.Provider>
```

### OptionalContext

A helper for creating contexts that can be optional.

Definition:

```res
module Context = GreenfinityContextUtils.OptionalContext.Make({
  type value = string
  let defaultValue = 'anything'
})
```

Usage:

```res
let value = Some("Something completely different")
<Context.Provider value={value}>
{
  let value = Context.use()
  // value is a string here
}
</Context.Provider>


let value = None
<Context.Provider value={value}>
{
  let value = Context.use()
  // value is the defaultValue here
}
</Context.Provider>

```

### ReducerContext

Definition:

```res
type action = SetValue(string)

let initialState = "anything"

let reducer = (_, action) =>
  switch action {
  | SetValue(txt) => txt
  }

module Context = GreenfinityContextUtils.ReducerContext.Make({
  type state = string
  type action = action
  let initialState = initialState
  let reducer = reducer
})
```

Usage:

```res
let value = "Something completely different"
<Context.Provider>
{
  let state = Context.State.use()
  let dispatch = Context.Dispatch.use()
}
</Context.Provider>
```

With an initial state to be used instead of `Config.initialState`.

```res
let value = "Something completely different"
<Context.Provider initialState={initialState}>
{
  let state = Context.State.use()
  let dispatch = Context.Dispatch.use()
}
</Context.Provider>
```

Note that `Config.initialState` still needs to be defined and have the correct type, as it will still be used to create the initial value of the React context.
