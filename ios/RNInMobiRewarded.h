#if __has_include(<React/RCTBridgeModule.h>)
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
#else
#import "RCTBridgeModule.h"
#import "RCTEventEmitter.h"
#endif

@import InMobiSDK;

@interface RNInMobiRewarded : RCTEventEmitter <RCTBridgeModule, IMInterstitialDelegate>

@end
  
