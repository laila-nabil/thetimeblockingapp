enum Env {
  prod,
  test,
  demo,
  dev;

  bool get isAnalyticsEnabled => this != dev;

  static Env getEnv(String envString){
    if(envString == Env.test.name){
      return Env.test;
    }
    if(envString == Env.demo.name){
      return Env.demo;
    }
    if(envString == Env.dev.name){
      return Env.dev;
    }
    return Env.prod;
  }
}
