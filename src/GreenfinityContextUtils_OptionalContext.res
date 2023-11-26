module type Config = {
  type value
  let defaultValue: value
}

module Make = (Config: Config) => {
  let t = React.createContext(None)

  module Provider = {
    let provider = React.Context.provider(t)

    @react.component
    let make = (~value, ~children) => {
      React.createElement(
        provider,
        {
          "value": value,
          "children": children,
        },
      )
    }
  }

  let use = () => React.useContext(t)->Belt.Option.getWithDefault(Config.defaultValue)
}
