module type Config = {
  type state
  type action
  let initialState: state
  let reducer: (state, action) => state
}

module Make = (Config: Config) => {
  let make: option<Config.state> => (Config.state, Config.action => unit) = initialState =>
    Config.reducer->React.useReducer(
      switch initialState {
      | Some(initialState) => initialState
      | None => Config.initialState
      },
    )

  module State = {
    let t = React.createContext(Config.initialState)

    module Provider = {
      let provider = React.Context.provider(t)

      @react.component
      let make = (~state, ~children) => {
        React.createElement(
          provider,
          {
            "value": state,
            "children": children,
          },
        )
      }
    }

    let use = () => React.useContext(t)
  }

  module Dispatch = {
    let t = React.createContext((None: option<Config.action => unit>))

    module Provider = {
      let provider = React.Context.provider(t)

      @react.component
      let make = (~dispatch, ~children) => {
        React.createElement(
          provider,
          {
            "value": Some(dispatch),
            "children": children,
          },
        )
      }
    }

    let use = () => React.useContext(t)->Belt.Option.getExn
  }

  module Provider = {
    @react.component
    let make = (~initialState=?, ~children) => {
      let (state, dispatch) = make(initialState)
      <State.Provider state={state}>
        <Dispatch.Provider dispatch={dispatch}> children </Dispatch.Provider>
      </State.Provider>
    }
  }
}
