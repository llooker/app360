project_name: "crashlytics-remote"

remote_dependency: marketplace_crashlytics {
  url: "https://github.com/llooker/crashlytics"
  ref: "master"
  override_constant: CONNECTION {
    value: "leigha-bq-dev"
  }
  override_constant: APP_NAME {
    value: "something"
  }
  override_constant: PLATFORM {
    value: "something"
  }
  override_constant: PROJECT {
    value: "something"
  }
  override_constant: SCHEMA_NAME {
    value: "something"
  }
}
