enum Env {
  prod,
  test,
  demo,
  dev,
  debugLocally;

  bool get isAnalyticsEnabled => true;

  bool get isDebug => this != Env.debugLocally;

  static Env getEnv(String envString) {
    if (envString == Env.test.name) {
      return Env.test;
    }
    if (envString == Env.demo.name) {
      return Env.demo;
    }
    if (envString == Env.dev.name) {
      return Env.dev;
    }
    if (envString == Env.debugLocally.name) {
      return Env.debugLocally;
    }
    return Env.prod;
  }
}
